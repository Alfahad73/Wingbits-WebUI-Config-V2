#!/bin/bash
# backend-app.sh
# Writes the Flask backend application (app.py) for the Wingbits station web panel.

set -euo pipefail

echo "Writing backend files..."

INSTALL_DIR="/opt/wingbits-station-web"
BACKEND_DIR="$INSTALL_DIR/backend"
CONF_DIR="$INSTALL_DIR/conf"

mkdir -p "$BACKEND_DIR" "$CONF_DIR"

cat > "$BACKEND_DIR/app.py" << 'EOF'
import os
import subprocess
import re
import glob
import time
import json
import platform
import socket
import psutil
import functools
import uuid
import threading
import sys
import requests

# Redirect all stdout and stderr to /dev/null immediately for Flask app logs
sys.stdout = open(os.devnull, 'w')
sys.stderr = open(os.devnull, 'w')

from werkzeug.security import generate_password_hash, check_password_hash
from flask import jsonify, make_response
from datetime import datetime
from flask import Flask, request, jsonify, send_from_directory
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

AUTH_FILE_PATH = "/opt/wingbits-station-web/conf/auth.json"
CONFIG_FILE_PATH = "/opt/wingbits-station-web/conf/config.json"

CURRENT_SESSION_TOKEN = None
UPDATE_PROCESS = None
LAST_NET_STATS = {"time": 0, "iface": None, "rx_bytes": 0, "tx_bytes": 0}

WEB_PANEL_RUN_PORT = 5000
DISABLE_UPDATE_LOG = True
if os.path.exists(CONFIG_FILE_PATH):
    try:
        with open(CONFIG_FILE_PATH, 'r') as f:
            config = json.load(f)
            WEB_PANEL_RUN_PORT = config.get('port', 5000)
            DISABLE_UPDATE_LOG = True
    except (json.JSONDecodeError, IOError):
        DISABLE_UPDATE_LOG = True

DESCRIPTIONS = {
    "readsb_status": {"ar": "عرض حالة خدمة readsb.", "en": "Show the status of the readsb service."},
    "readsb_restart": {"ar": "إعادة تشغيل خدمة readsb.", "en": "Restart the readsb service."},
    "readsb_logs": {"ar": "عرض آخر 50 سطر من سجلات readsb.", "en": "Show last 50 lines of readsb logs."},
    "readsb_set_gain": {"ar": "ضبط كسب الاستقبال (Gain) للـ readsb.", "en": "Set gain value for readsb."},
    "readsb_toggle_verbose": {"ar": "تفعيل/تعطيل وضع الإسهاب (Verbose) لـ readsb.", "en": "Enable/Disable verbose mode for readsb."},
    "wingbits_status": {"ar": "عرض حالة خدمة wingbits.", "en": "Show the status of the wingbits service."},
    "wingbits_restart": {"ar": "إعادة تشغيل خدمة wingbits.", "en": "Restart the wingbits service."},
    "wingbits_logs": {"ar": "عرض آخر 2000 سطر من سجلات wingbits.", "en": "Show last 2000 lines of wingbits logs."},
    "wingbits_update_client": {"ar": "تحديث عميل Wingbits.", "en": "Update Wingbits client."},
    "wingbits_geosigner_info": {"ar": "عرض معلومات GeoSigner.", "en": "Show GeoSigner information."},
    "wingbits_version": {"ar": "عرض إصدار Wingbits.", "en": "Show Wingbits version."},
    "tar1090_restart": {"ar": "إعادة تشغيل خدمة tar1090.", "en": "Restart tar1090 service."},
    "tar1090_route_info": {"ar": "تفعيل أو تعطيل معلومات مسار الرحلة في tar1090.", "en": "Enable/Disable route info in tar1090."},
    "graphs1090_restart": {"ar": "إعادة تشغيل خدمة graphs1090.", "en": "Restart graphs1090 service."},
    "graphs1090_colorscheme": {"ar": "تغيير مخطط الألوان للـ graphs1090.", "en": "Set color scheme for graphs1090."},
    "pi_restart": {"ar": "إعادة تشغيل الجهاز بالكامل.", "en": "Reboot the device."},
    "pi_shutdown": {"ar": "إيقاف تشغيل الجهاز بالكامل.", "en": "Shutdown the device."},
    "wingbits_debug": {"ar": "عرض معلومات تصحيح أخطاء Wingbits.", "en": "Show Wingbits debug information."},
    "update_in_progress": {"ar": "تحديث قيد التقدم بالفعل.", "en": "An update is already in progress."},
    "update_started": {"ar": "بدأ تحديث عميل Wingbits في الخلفية.", "en": "Wingbits client update started in the background."},
    "wingbits_update_logs": {"ar": "سجلات تحديث عميل Wingbits.", "en": "Wingbits client update logs."},
    "diagnostics_wingbits_readsb_logs": {"ar": "إنشاء رابط لسجلات Wingbits و readsb.", "en": "Generate link for Wingbits & readsb logs."},
    "diagnostics_all_logs": {"ar": "إنشاء رابط لجميع السجلات الحديثة.", "en": "Generate link for all recent logs."},
    "diagnostics_os_release": {"ar": "عرض تفاصيل نظام التشغيل.", "en": "View OS release details."},
    "diagnostics_lsusb": {"ar": "عرض الأجهزة المتصلة عبر USB.", "en": "View USB devices."},
    "diagnostics_throttled": {"ar": "فحص انخفاض الجهد الكهربائي.", "en": "Check for voltage throttling."},
    "diagnostics_wingbits_status_verbose": {"ar": "عرض حالة Wingbits التفصيلية.", "en": "View detailed Wingbits status."},
    "diagnostics_geosigner_info": {"ar": "عرض معلومات GeoSigner.", "en": "View GeoSigner information."}
}

def lang_desc(key, lang='en'):
    return DESCRIPTIONS.get(key, {}).get(lang, '')

def run_shell(cmd):
    try:
        output = subprocess.check_output(cmd, shell=True, stderr=subprocess.STDOUT, encoding='utf-8', timeout=120)
        return output.strip()
    except subprocess.CalledProcessError as e:
        return f"Error executing command:\n{e.output.strip()}"
    except subprocess.TimeoutExpired:
        return "Error: Command timed out after 2 minutes."

def run_shell_async(cmd, _ignored):
    global UPDATE_PROCESS
    try:
        process = subprocess.Popen(cmd, shell=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, text=True)
        UPDATE_PROCESS = process
        process.wait()
    finally:
        UPDATE_PROCESS = None

def load_auth_credentials():
    if os.path.exists(AUTH_FILE_PATH):
        with open(AUTH_FILE_PATH, 'r') as f:
            try:
                return json.load(f)
            except json.JSONDecodeError:
                return None
    return None

def save_auth_credentials(username, password_hash):
    data = {"username": username, "password_hash": password_hash}
    with open(AUTH_FILE_PATH, 'w') as f:
        json.dump(data, f)
    os.chmod(AUTH_FILE_PATH, 0o600)

def login_required(f):
    @functools.wraps(f)
    def decorated_function(*args, **kwargs):
        global CURRENT_SESSION_TOKEN
        auth_token = request.headers.get('X-Auth-Token')
        if not auth_token or not auth_token == CURRENT_SESSION_TOKEN:
            return jsonify({'ok': False, 'msg': 'Unauthorized'}), 401
        return f(*args, **kwargs)
    return decorated_function

# ----------------- AUTH -----------------
@app.route('/api/login', methods=['POST'])
def login():
    global CURRENT_SESSION_TOKEN
    data = request.get_json()
    username = data.get('username')
    password = data.get('password')

    credentials = load_auth_credentials()
    if not credentials:
        return jsonify({'ok': False, 'msg': 'Authentication file not found. Please run the installer script to set up credentials.'}), 500

    if username == credentials.get('username') and check_password_hash(credentials.get('password_hash'), password):
        CURRENT_SESSION_TOKEN = str(uuid.uuid4())
        return jsonify({'ok': True, 'msg': 'Login successful', 'token': CURRENT_SESSION_TOKEN})
    else:
        return jsonify({'ok': False, 'msg': 'Invalid username or password'}), 401

@app.route('/api/logout', methods=['POST'])
@login_required
def logout():
    global CURRENT_SESSION_TOKEN
    CURRENT_SESSION_TOKEN = None
    return jsonify({'ok': True, 'msg': 'Logged out successfully'})

@app.route('/api/change_password', methods=['POST'])
@login_required
def change_password():
    data = request.get_json()
    old_password = data.get('old_password')
    new_password = data.get('new_password')

    if not old_password or not new_password:
        return jsonify({'ok': False, 'msg': 'Old and new passwords are required'}), 400
    if len(new_password) < 6:
        return jsonify({'ok': False, 'msg': 'New password must be at least 6 characters long'}), 400

    credentials = load_auth_credentials()
    if not credentials:
        return jsonify({'ok': False, 'msg': 'Authentication file not found or corrupted.'}), 500

    if not check_password_hash(credentials.get('password_hash'), old_password):
        return jsonify({'ok': False, 'msg': 'Incorrect old password'}), 401

    new_password_hash = generate_password_hash(new_password)
    save_auth_credentials(credentials.get('username'), new_password_hash)
    global CURRENT_SESSION_TOKEN
    CURRENT_SESSION_TOKEN = None
    return jsonify({'ok': True, 'msg': 'Password changed successfully. Please log in again.'})

# ----------------- LIVE STATS -----------------
@app.route('/api/stats/live', methods=['GET'])
@login_required
def live_stats():
    stats_path = '/run/readsb/stats.json'
    if not os.path.exists(stats_path):
        stats_path = '/var/run/readsb/stats.json'

    now = time.time()

    def get_main_iface_bytes():
        max_bytes = 0
        main_iface = None
        rx_bytes = tx_bytes = 0
        try:
            with open('/proc/net/dev') as f:
                lines = f.readlines()[2:]
                for line in lines:
                    parts = line.strip().split()
                    if len(parts) < 17: continue
                    iface = parts[0].strip(':')
                    if iface == "lo": continue
                    _rx = int(parts[1])
                    _tx = int(parts[9])
                    if _rx + _tx > max_bytes:
                        max_bytes = _rx + _tx
                        rx_bytes = _rx
                        tx_bytes = _tx
                        main_iface = iface
        except FileNotFoundError:
            pass
        return main_iface, rx_bytes, tx_bytes

    iface, rx_bytes, tx_bytes = get_main_iface_bytes()

    stats_data = {}
    if os.path.exists(stats_path):
        with open(stats_path) as f:
            stats_data = json.load(f)
    messages_per_sec = 0
    if "last1min" in stats_data:
        msgs_1min = stats_data["last1min"].get("messages_valid", 0)
        messages_per_sec = round(msgs_1min / 60, 1)
    aircraft_with_pos = stats_data.get("aircraft_with_pos", 0)
    aircraft_without_pos = stats_data.get("aircraft_without_pos", 0)
    total_aircraft = aircraft_with_pos + aircraft_without_pos
    max_range_m = stats_data.get("last1min", {}).get("max_distance", 0)
    max_range_km = round(max_range_m / 1000, 2) if max_range_m else 0
    avg_signal = stats_data.get("last1min", {}).get("local", {}).get("signal", 0)

    global LAST_NET_STATS
    net_usage_rx_kb = net_usage_tx_kb = 0
    if LAST_NET_STATS["iface"] == iface and LAST_NET_STATS["time"] and LAST_NET_STATS["rx_bytes"] and LAST_NET_STATS["tx_bytes"]:
        delta_time = now - LAST_NET_STATS["time"]
        delta_rx = rx_bytes - LAST_NET_STATS["rx_bytes"]
        delta_tx = tx_bytes - LAST_NET_STATS["tx_bytes"]
        if delta_time > 0:
            net_usage_rx_kb = round(delta_rx / 1024, 2)
            net_usage_tx_kb = round(delta_tx / 1024, 2)
    LAST_NET_STATS = {"time": now, "iface": iface, "rx_bytes": rx_bytes, "tx_bytes": tx_bytes}

    return jsonify({
        'ok': True,
        'live': {
            'messages_per_sec': messages_per_sec,
            'aircraft_now': total_aircraft,
            'aircraft_with_pos': aircraft_with_pos,
            'aircraft_without_pos': aircraft_without_pos,
            'max_range_km': max_range_km,
            'signal_avg_db': avg_signal,
            'data_usage_rx_kb': net_usage_rx_kb,
            'data_usage_tx_kb': net_usage_tx_kb,
            'rx_total': rx_bytes,
            'tx_total': tx_bytes,
            'network_iface': iface or ""
        }
    })

# ----------------- readsb -----------------
@app.route('/api/service/readsb/get-gain', methods=['GET'])
@login_required
def api_readsb_get_gain():
    gain = ""
    config_path = "/etc/default/readsb"
    if not os.path.exists(config_path):
        return jsonify({'ok': False, 'msg': 'readsb config not found!', 'gain': ''})
    try:
        with open(config_path, "r") as f:
            for line in f:
                if "GAIN=" in line:
                    gain = line.split("=")[-1].strip().replace('"','').replace("'","")
                elif "--gain" in line:
                    parts = line.replace('"','').replace("'","").split()
                    if "--gain" in parts:
                        idx = parts.index("--gain")
                        if idx+1 < len(parts):
                            gain = parts[idx+1]
    except Exception as e:
        return jsonify({'ok': False, 'msg': str(e), 'gain': ''})
    return jsonify({'ok': True, 'gain': gain or ''})

@app.route('/api/service/readsb/get-location', methods=['GET'])
@login_required
def api_readsb_get_location():
    lat, lon = None, None
    config_path = "/etc/default/readsb"
    if not os.path.exists(config_path):
        return jsonify({'ok': False, 'msg': 'readsb config not found!', 'lat': '', 'lon': ''})
    try:
        with open(config_path, "r") as f:
            lines = f.readlines()
        for line in lines:
            if '--lat' in line and '--lon' in line:
                line = line.replace('"','').replace("'","")
                parts = line.split()
                for i, p in enumerate(parts):
                    if p == '--lat' and (i+1) < len(parts):
                        lat = parts[i+1]
                    if p == '--lon' and (i+1) < len(parts):
                        lon = parts[i+1]
        if not lat or not lon:
            for line in lines:
                if line.strip().startswith("DECODER_OPTIONS="):
                    vals = line.split("=")[-1].replace('"','').replace("'","")
                    p = vals.split()
                    if '--lat' in p:
                        lat = p[p.index('--lat')+1]
                    if '--lon' in p:
                        lon = p[p.index('--lon')+1]
    except Exception as e:
        return jsonify({'ok': False, 'msg': str(e), 'lat': '', 'lon': ''})
    return jsonify({'ok': True, 'lat': lat or '', 'lon': lon or ''})

@app.route('/api/service/readsb/heatmap', methods=['POST'])
@login_required
def api_readsb_heatmap():
    data = request.get_json() or {}
    enable = data.get("enable", True)
    if isinstance(enable, str):
        enable = (enable.lower() == "true")
    config_path = "/etc/default/readsb"
    options_to_add = "--heatmap-dir /var/globe_history --heatmap 30"

    try:
        lines = []
        if os.path.exists(config_path):
            with open(config_path, "r") as f:
                lines = f.readlines()

        found_json_options = False
        for i, line in enumerate(lines):
            if line.strip().startswith("JSON_OPTIONS="):
                found_json_options = True
                current_options = line.split('=', 1)[1].strip().strip('"').strip("'")

                if enable:
                    if options_to_add not in current_options:
                        new_options = f'"{current_options.strip()} {options_to_add}"'
                        lines[i] = f"JSON_OPTIONS={new_options}\n"
                else:
                    if options_to_add in current_options:
                        new_options = current_options.replace(options_to_add, '').strip()
                        new_options = f'"{new_options}"' if new_options else '""'
                        lines[i] = f"JSON_OPTIONS={new_options}\n"
                break

        if not found_json_options:
            if enable:
                lines.append(f'JSON_OPTIONS="{options_to_add}"\n')

        with open(config_path, "w") as f:
            f.writelines(lines)

        if enable:
            if not os.path.exists("/var/globe_history"):
                subprocess.call(["sudo", "mkdir", "/var/globe_history"])
            subprocess.call(["sudo", "chown", "readsb", "/var/globe_history"])

        subprocess.call(["sudo", "systemctl", "restart", "readsb"])

        return jsonify({'ok': True,'result': f"Heatmap {'enabled' if enable else 'disabled'}.",'desc': "Experimental: Enable or disable heatmap in readsb"})
    except Exception as e:
        return jsonify({'ok': False, 'msg': str(e)})

@app.route('/api/service/readsb/toggle-verbose', methods=['POST'])
@login_required
def api_readsb_toggle_verbose():
    lang = request.args.get('lang', 'en')
    data = request.get_json() or {}
    enable_verbose = data.get("enable", True)
    config_path = "/etc/default/readsb"
    verbose_option = "--verbose"

    try:
        lines = []
        if os.path.exists(config_path):
            with open(config_path, "r") as f:
                lines = f.readlines()

        found_decoder_options = False
        for i, line in enumerate(lines):
            if line.strip().startswith("DECODER_OPTIONS="):
                found_decoder_options = True
                current_options = line.split('=', 1)[1].strip().strip('"').strip("'")
                if enable_verbose:
                    if verbose_option not in current_options:
                        new_options = f'"{current_options.strip()} {verbose_option}"'.strip()
                        lines[i] = f"DECODER_OPTIONS={new_options}\n"
                else:
                    if verbose_option in current_options:
                        new_options = current_options.replace(verbose_option, '').strip()
                        new_options = f'"{new_options}"' if new_options else '""'
                        lines[i] = f"DECODER_OPTIONS={new_options}\n"
                break

        if not found_decoder_options and enable_verbose:
            lines.append(f'DECODER_OPTIONS="{verbose_option}"\n')

        with open(config_path, "w") as f:
            f.writelines(lines)

        subprocess.call(["sudo", "systemctl", "restart", "readsb"])

        return jsonify({'ok': True,'result': f"readsb verbose mode {'enabled' if enable_verbose else 'disabled'}.",'desc': lang_desc("readsb_toggle_verbose", lang)})
    except Exception as e:
        return jsonify({'ok': False, 'msg': str(e)})

@app.route('/api/service/readsb/status', methods=['GET'])
@login_required
def api_readsb_status():
    lang = request.args.get('lang', 'en')
    return jsonify({'result': run_shell("systemctl status readsb"),'desc': lang_desc("readsb_status", lang)})

@app.route('/api/service/readsb/restart', methods=['POST'])
@login_required
def api_readsb_restart():
    lang = request.args.get('lang', 'en')
    result = run_shell("sudo systemctl restart readsb")
    return jsonify({'result': result, 'desc': lang_desc("readsb_restart", lang)})

@app.route('/api/service/readsb/logs', methods=['GET'])
@login_required
def api_readsb_logs():
    lang = request.args.get('lang', 'en')
    return jsonify({'result': run_shell("journalctl -n 50 -u readsb --no-pager"),'desc': lang_desc("readsb_logs", lang)})

@app.route('/api/service/readsb/set-gain', methods=['POST'])
@login_required
def api_readsb_set_gain():
    lang = request.args.get('lang', 'en')
    data = request.json
    gain = str(data.get("gain", ""))
    result = run_shell(f"sudo readsb-gain {gain}")
    return jsonify({'result': result,'desc': lang_desc("readsb_set_gain", lang)})

# ----------------- Wingbits -----------------
@app.route('/api/service/wingbits/status', methods=['GET'])
@login_required
def api_wingbits_status():
    lang = request.args.get('lang', 'en')
    return jsonify({'result': run_shell("systemctl status wingbits"),'desc': lang_desc("wingbits_status", lang)})

@app.route('/api/service/wingbits/last-install-log', methods=['GET'])
@login_required
def api_wingbits_last_install_log():
    return jsonify({'result': 'No install logs found as logging is disabled.','desc': 'last Wingbits install log'})

@app.route('/api/service/wingbits/debug', methods=['GET'])
@login_required
def api_wingbits_debug():
    lang = request.args.get('lang', 'en')
    result = run_shell("curl -sL \"https://gitlab.com/wingbits/config/-/raw/master/debug.sh\" | sudo bash 2>&1")
    result = re.sub(r'\x1B\[[0-9;]*[mGKF]', '', result)
    result = re.sub(r'tput: unknown terminal \"[^\"]+\"\n?', '', result)
    result = re.sub(r'\r', '', result)
    return jsonify({'result': result,'desc': lang_desc("wingbits_debug", lang)})

@app.route('/api/service/wingbits/restart', methods=['POST'])
@login_required
def api_wingbits_restart():
    lang = request.args.get('lang', 'en')
    result = run_shell("sudo systemctl restart wingbits")
    return jsonify({'result': result, 'desc': lang_desc("wingbits_restart", lang)})

@app.route('/api/service/wingbits/logs', methods=['GET'])
@login_required
def api_wingbits_logs():
    lang = request.args.get('lang', 'en')
    return jsonify({'result': run_shell("journalctl -n 2000 -u wingbits --no-pager"),'desc': lang_desc("wingbits_logs", lang)})

@app.route('/api/service/wingbits/update-client', methods=['POST'])
@login_required
def api_wingbits_update_client():
    lang = request.args.get('lang', 'en')
    global UPDATE_PROCESS
    if UPDATE_PROCESS is not None and UPDATE_PROCESS.poll() is None:
        return jsonify({'ok': False,'msg': lang_desc("update_in_progress", lang),'result': 'Update already running.'})
    threading.Thread(target=run_shell_async, args=(
        "curl -sL https://gitlab.com/wingbits/config/-/raw/master/install-client.sh | sudo bash", None
    )).start()
    return jsonify({'ok': True,'msg': lang_desc("update_started", lang),'result': 'Wingbits client update started in the background. Logging is disabled for updates.'})

@app.route('/api/service/wingbits/update-logs', methods=['GET'])
@login_required
def api_wingbits_update_logs():
    lang = request.args.get('lang', 'en')
    log_content = "Client update logging is disabled in configuration. No logs are saved."
    status = "disabled"
    if UPDATE_PROCESS is not None and UPDATE_PROCESS.poll() is None:
        status = "running"
    elif UPDATE_PROCESS is None:
        status = "finished"
    return jsonify({'ok': True,'status': status,'logs': log_content,'desc': lang_desc("wingbits_update_logs", lang)})

@app.route('/api/service/wingbits/geosigner-info', methods=['GET'])
@login_required
def api_wingbits_geosigner_info():
    lang = request.args.get('lang', 'en')
    result = run_shell("sudo wingbits geosigner info")
    return jsonify({'result': result,'desc': lang_desc("wingbits_geosigner_info", lang)})

@app.route('/api/service/wingbits/version', methods=['GET'])
@login_required
def api_wingbits_version():
    lang = request.args.get('lang', 'en')
    result = run_shell("wingbits -v")
    return jsonify({'result': result,'desc': lang_desc("wingbits_version", lang)})

# ----------------- tar1090 / graphs1090 -----------------
@app.route('/api/service/tar1090/restart', methods=['POST'])
@login_required
def api_tar1090_restart():
    lang = request.args.get('lang', 'en')
    result = run_shell("sudo systemctl restart tar1090")
    return jsonify({'result': result, 'desc': lang_desc("tar1090_restart", lang)})

@app.route('/api/service/tar1090/route-info', methods=['POST'])
@login_required
def api_tar1090_route_info():
    lang = request.args.get('lang', 'en')
    data = request.get_json() or {}
    enable = data.get("enable", True)
    if isinstance(enable, str):
        enable = (enable.lower() == "true")
    config_path = "/usr/local/share/tar1090/html/config.js"
    if not os.path.exists(config_path):
        result = "config.js not found!"
    else:
        with open(config_path, "r") as f:
            js = f.read()
        import re as _re
        if _re.search(r"useRouteAPI\s*[:=]\s*(true|false)", js):
            js = _re.sub(r"useRouteAPI\s*[:=]\s*(true|false)", f"useRouteAPI = {'true' if enable else 'false'}", js)
        else:
            if not js.endswith('\n'):
                js += '\n'
            js += f"useRouteAPI = {'true' if enable else 'false'};\n"
        with open(config_path, "w") as f:
            f.write(js)
        result = f"Route info {'enabled' if enable else 'disabled'}."
    return jsonify({'result': result,'desc': lang_desc("tar1090_route_info", lang)})

@app.route('/api/service/graphs1090/restart', methods=['POST'])
@login_required
def api_graphs1090_restart():
    lang = request.args.get('lang', 'en')
    return jsonify({'result': run_shell("sudo systemctl restart graphs1090"),'desc': lang_desc("graphs1090_restart", lang)})

@app.route('/api/service/graphs1090/colorscheme', methods=['POST'])
@login_required
def api_graphs1090_colorscheme():
    data = request.get_json()
    color = data.get('color', '')
    if color not in ['dark', 'default']:
        return jsonify({'ok': False, 'msg': 'Invalid color'})
    config_path = "/etc/default/graphs1090"
    try:
        lines = []
        if os.path.exists(config_path):
            with open(config_path, "r") as f:
                lines = f.readlines()
        found = False
        for i in range(len(lines)):
            if lines[i].strip().startswith("colorscheme="):
                lines[i] = f"colorscheme={color}\n"; found = True
        if not found:
            lines.append(f"colorscheme={color}\n")
        with open(config_path, "w") as f:
            f.writelines(lines)
        subprocess.call(["sudo", "systemctl", "restart", "graphs1090"])
        return jsonify({'ok': True, 'result': f"graphs1090 {color} mode enabled. Reload your graphs1090 page"})
    except Exception as e:
        return jsonify({'ok': False, 'msg': str(e)})

# ----------------- System Info / Alerts -----------------
@app.route('/api/system/info', methods=['GET'])
@login_required
def system_info():
    try:
        cpu_name = None
        if os.path.exists("/proc/cpuinfo"):
            cpu_name_output = os.popen('cat /proc/cpuinfo | grep "model name" | head -1').read()
            if cpu_name_output:
                cpu_name = cpu_name_output.split(":")[-1].strip()
        if not cpu_name:
            cpu_name = platform.processor()

        info = {
            "hostname": platform.node(),
            "os": platform.platform(),
            "cpu": cpu_name,
            "arch": platform.machine(),
            "cores": psutil.cpu_count(logical=True),
            "load_avg": os.getloadavg() if hasattr(os, "getloadavg") else [0, 0, 0],
            "ram_total_mb": round(psutil.virtual_memory().total/1024/1024,1),
            "ram_free_mb": round(psutil.virtual_memory().available/1024/1024,1),
            "disk_total_gb": round(psutil.disk_usage('/').total/1024/1024/1024,2),
            "disk_free_gb": round(psutil.disk_usage('/').free/1024/1024/1024,2),
            "uptime_hr": round((psutil.boot_time() and ((time.time()-psutil.boot_time())/3600)) or 0,1)
        }

        temp = None
        try:
            if os.path.exists('/sys/class/thermal/thermal_zone0/temp'):
                with open('/sys/class/thermal/thermal_zone0/temp') as f:
                    temp = round(int(f.read()) / 1000, 1)
            else:
                temp_out = os.popen("sensors | grep 'CPU' | grep '°C'").read()
                if temp_out:
                    temp = temp_out
        except:
            temp = None
        info["cpu_temp"] = temp

        sdr_status = "not_connected"
        try:
            sdr_keywords = ["RTL", "2832", "2838", "SDR", "R820T", "HackRF", "Airspy", "LimeSDR", "SDRplay", "Realtek", "Radabox", "DVB"]
            lsusb_output = run_shell("lsusb").lower()
            if any(keyword.lower() in lsusb_output for keyword in sdr_keywords):
                sdr_status = "connected"
        except Exception:
            sdr_status = "not_connected"

        info["sdr_status"] = sdr_status
        return jsonify({"ok": True, "info": info})
    except Exception as e:
        return jsonify({"ok": False, "msg": str(e)})

@app.route('/api/netstatus')
@login_required
def api_netstatus():
    try:
        r = requests.get("https://1.1.1.1", timeout=3)
        online = (r.status_code in (200,301,302))
    except requests.exceptions.RequestException:
        online = False

    try:
        r2 = requests.get("https://api.wingbits.com/ping", timeout=5)
        server_ok = (r2.status_code == 200)
    except requests.exceptions.RequestException:
        server_ok = False

    last_sync = ""
    return jsonify({"ok": True, "net": {"online": online, "server_ok": server_ok, "last_sync": last_sync}})

@app.route('/api/alerts', methods=['GET'])
@login_required
def api_alerts():
    alerts = []
    services = [("wingbits", "Wingbits"), ("readsb", "readsb"), ("tar1090", "tar1090")]
    for svc, label in services:
        try:
            out = subprocess.check_output(['systemctl', 'is-active', svc], stderr=subprocess.STDOUT).decode().strip()
            if out != "active":
                alerts.append(f"{label} service is NOT running!")
        except Exception as e:
            alerts.append(f"{label} service status unknown: {e}")

    try:
        sdr = subprocess.check_output("lsusb | grep -i RTL2832", shell=True).decode().strip()
        if not sdr:
            alerts.append("SDR dongle is NOT detected! (RTL2832)")
    except Exception as e:
        alerts.append("SDR check failed: " + str(e))

    try:
        st = os.statvfs("/")
        percent = 100 - (st.f_bavail / st.f_blocks * 100)
        if percent > 95:
            alerts.append(f"Disk is almost full: {percent:.1f}% used")
    except:
        pass

    logfiles = [
        ("/var/log/wingbits.log", "wingbits"),
        ("/var/log/readsb.log", "readsb"),
        ("/var/log/tar1090.log", "tar1090"),
    ]
    keywords = re.compile(r"(ERROR|FATAL|FAIL|WARNING|WARN)", re.IGNORECASE)
    for logfile, label in logfiles:
        if os.path.exists(logfile):
            try:
                lines = subprocess.check_output(["tail", "-n", "200", logfile]).decode(errors="ignore").splitlines()
                for line in lines:
                    if keywords.search(line):
                        if not any(line in a for a in alerts):
                            alerts.append(f"[{label}] {line.strip()[:400]}")
            except:
                pass

    return {"ok": True, "alerts": alerts}

@app.route('/api/status/check')
@login_required
def api_status_check():
    def svc_status(name):
        try:
            out = subprocess.check_output(['systemctl', 'is-active', name], stderr=subprocess.STDOUT).decode().strip()
            return out == "active"
        except:
            return False

    try:
        online = False
        try:
            socket.create_connection(("8.8.8.8", 53), timeout=2)
            online = True
        except:
            online = False

        try:
            wb_status = subprocess.check_output(['sudo', 'wingbits', 'status'], stderr=subprocess.STDOUT).decode().strip()
        except Exception as e:
            wb_status = "Error: " + str(e)

        return jsonify({"ok": True,"status": {"internet": online,"wingbits": svc_status("wingbits"),"readsb": svc_status("readsb"),"tar1090": svc_status("tar1090"),"wb_details": wb_status}})
    except Exception as e:
        return jsonify({"ok": False, "msg": str(e)})

@app.route('/api/update/reinstall', methods=['POST'])
@login_required
def api_update_reinstall():
    req = request.get_json(force=True)
    comps = req.get("components", [])
    steps = []
    try:
        if "deps" in comps:
            steps.append(("deps", subprocess.getoutput('sudo apt update && sudo apt install --reinstall -y python3 python3-pip rtl-sdr')))
        if "wingbits" in comps:
            steps.append(("wingbits", subprocess.getoutput('sudo systemctl stop wingbits ; wget -O /usr/local/bin/wingbits https://dl.wingbits.com/latest/wingbits-linux-arm64 ; chmod +x /usr/local/bin/wingbits ; sudo systemctl restart wingbits')))
        if "readsb" in comps:
            steps.append(("readsb", subprocess.getoutput('sudo systemctl stop readsb ; cd /tmp && wget https://github.com/wiedehopf/adsb-scripts/releases/latest/download/readsb.tar.xz ; tar -xJf readsb.tar.xz -C /usr/local/bin ; sudo systemctl restart readsb')))
        if "tar1090" in comps:
            steps.append(("tar1090", subprocess.getoutput('cd /usr/local/share/tar1090/html && sudo git pull')))
        if "panel" in comps:
            steps.append(("panel", subprocess.getoutput('cd /opt/wingbits-station-web && sudo git pull ; sudo systemctl restart wingbits-web-panel')))
        detail = "\n".join([f"[{name}]\n{out}" for name, out in steps])
        return jsonify({"ok": True, "msg": "All selected components updated!", "detail": detail})
    except Exception as e:
        return jsonify({"ok": False, "msg": str(e)})

@app.route("/api/feeder/versions")
@login_required
def feeder_versions():
    try:
        wingbits_ver = os.popen("wingbits --version 2>/dev/null").read().strip() or None
        readsb_ver = os.popen("readsb --version 2>/dev/null").read().strip() or None
        tar1090_ver = os.popen("tar1090 --version 2>/dev/null").read().strip() or None
        panel_ver = "1.0.0"
        return jsonify({"ok": True,"versions": {"wingbits": wingbits_ver,"readsb": readsb_ver,"tar1090": tar1090_ver,"panel": panel_ver},"checked_at": datetime.now().strftime('%Y-%m-%d %H:%M:%S')})
    except Exception as e:
        return jsonify({"ok": False, "msg": str(e)})

@app.route('/api/service/urls', methods=['GET'])
@login_required
def api_get_urls():
    def get_ip_address():
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        try:
            s.connect(("8.8.8.8", 80))
            ip = s.getsockname()[0]
        except Exception:
            ip = "127.0.0.1"
        finally:
            s.close()
        return ip

    ip_addr = get_ip_address()
    global WEB_PANEL_RUN_PORT
    urls = [
        {"title": "Live map (tar1090)", "url": f"http://{ip_addr}/tar1090"},
        {"title": "Statistics (graphs1090)", "url": f"http://{ip_addr}/graphs1090"},
        {"title": "Advanced Web Panel", "url": f"http://{ip_addr}:{WEB_PANEL_RUN_PORT}"},
        {"title": "Wingbits Dashboard", "url": "https://dash.wingbits.com/"},
    ]
    return jsonify({"ok": True, "urls": urls})

@app.route('/api/system/reboot', methods=['POST'])
@login_required
def api_reboot():
    lang = request.args.get('lang', 'en')
    run_shell("sudo reboot")
    return jsonify({'result': "Device is rebooting...", 'desc': lang_desc("pi_restart", lang)})

@app.route('/api/system/shutdown', methods=['POST'])
@login_required
def api_shutdown():
    lang = request.args.get('lang', 'en')
    run_shell("sudo shutdown -h now")
    return jsonify({'result': "Device is shutting down...", 'desc': lang_desc("pi_shutdown", lang)})

# ----------------- NEW: SMART TROUBLESHOOTER -----------------
def _svc_active(name):
    try:
        out = subprocess.check_output(['systemctl', 'is-active', name], stderr=subprocess.STDOUT).decode().strip()
        return out == "active"
    except Exception:
        return False

def _journal_tail(unit, n=200):
    return run_shell(f"journalctl -u {unit} -n {n} --no-pager")

def _status_head(unit, n=12):
    return run_shell(f"systemctl status {unit} | head -n {n}")

def _read_readsb_stats():
    path = '/run/readsb/stats.json'
    if not os.path.exists(path):
        path = '/var/run/readsb/stats.json'
    if os.path.exists(path):
        try:
            with open(path) as f:
                return json.load(f)
        except Exception:
            return {}
    return {}

def _readsb_flow_ok(stats):
    try:
        msgs = stats.get("last1min", {}).get("messages_valid", 0)
        return msgs and msgs > 0
    except Exception:
        return False

def _parse_readsb_hints(log_text):
    hints = []
    patterns = [
        (r'No supported devices found', "SDR not detected (driver/USB). تأكد من توصيل الدونغل وتعريفه."),
        (r'usb_open error|could not open', "لا يمكن فتح الدونجل (سماحية/تعريف). جرّب إعادة التشغيل أو تغيير المنفذ."),
        (r'rtlsdr_demod_write_reg failed', "مشكلة اتصال RTL-SDR. تحقق من الكابل والطاقة."),
        (r'usb_claim_interface error', "تعارض برنامج آخر مع الدونجل (dvb_usb_rtl28xxu). جرّب: sudo rmmod dvb_usb_rtl28xxu"),
        (r'gain.*invalid', "قيمة Gain غير صالحة."),
        (r'network.*error|connection.*refused', "مشكلة شبكة/منفذ لإخراج readsb.")
    ]
    for pat, msg in patterns:
        if re.search(pat, log_text, re.IGNORECASE):
            hints.append(f"- {msg}")
    return list(dict.fromkeys(hints))

def _ntp_synced():
    val = run_shell("timedatectl show -p NTPSynchronized --value").strip().lower()
    return val == "yes"

def _lsusb_sdr_lines():
    ls = run_shell("lsusb")
    lines = [ln for ln in ls.splitlines() if re.search(r'RTL|2832|SDR|R820T|Realtek', ln, re.IGNORECASE)]
    return lines, bool(lines)

def _geosigner_info():
    return run_shell("sudo wingbits geosigner info 2>&1")

def _wb_status_verbose():
    out = run_shell("sudo wingbits status --verbose 2>&1")
    return re.sub(r'\x1B\[[0-9;]*[mGKF]', '', out)

def _summarize_resources():
    vm = psutil.virtual_memory()
    du = psutil.disk_usage("/")
    return {
        "ram_total_mb": round(vm.total/1024/1024,1),
        "ram_free_mb": round(vm.available/1024/1024,1),
        "disk_total_gb": round(du.total/1024/1024/1024,2),
        "disk_free_gb": round(du.free/1024/1024/1024,2)
    }

def _status_label(ok_bool, warn=False):
    if ok_bool and not warn:
        return "OK"
    return "WARN" if warn else "FAIL"

# -------- Geo location helpers (NEW) --------
def _haversine_km(lat1, lon1, lat2, lon2):
    from math import radians, sin, cos, asin, sqrt
    R = 6371.0
    dlat = radians(lat2 - lat1)
    dlon = radians(lon2 - lon1)
    a = sin(dlat/2)**2 + cos(radians(lat1))*cos(radians(lat2))*sin(dlon/2)**2
    return 2 * R * asin(sqrt(a))

def _parse_geosigner_info_txt(txt):
    lat = lon = sats = None
    m = re.search(r'(?:gps_)?lat(?:itude)?\s*[:=]\s*(-?\d+\.\d+)', txt, re.I)
    if m: lat = float(m.group(1))
    m = re.search(r'(?:gps_)?lon(?:gitude)?\s*[:=]\s*(-?\d+\.\d+)', txt, re.I)
    if m: lon = float(m.group(1))
    m = re.search(r'(?:satellites|sats)\s*[:=]\s*(\d+)', txt, re.I)
    if m: sats = int(m.group(1))
    return lat, lon, sats

def _readsb_config_location():
    lat, lon = None, None
    config_path = "/etc/default/readsb"
    if not os.path.exists(config_path):
        return None, None
    try:
        with open(config_path, "r") as f:
            lines = f.readlines()
        for line in lines:
            if '--lat' in line and '--lon' in line:
                line = line.replace('"','').replace("'","")
                parts = line.split()
                for i, p in enumerate(parts):
                    if p == '--lat' and (i+1) < len(parts):
                        lat = parts[i+1]
                    if p == '--lon' and (i+1) < len(parts):
                        lon = parts[i+1]
        if not lat or not lon:
            for line in lines:
                if line.strip().startswith("DECODER_OPTIONS="):
                    vals = line.split("=",1)[-1].replace('"','').replace("'","")
                    p = vals.split()
                    if '--lat' in p: lat = p[p.index('--lat')+1]
                    if '--lon' in p: lon = p[p.index('--lon')+1]
        lat = float(lat) if lat else None
        lon = float(lon) if lon else None
    except Exception:
        lat = lon = None
    return lat, lon

def _set_readsb_location(lat, lon):
    cfg = "/etc/default/readsb"
    lines = []
    if os.path.exists(cfg):
        with open(cfg, "r") as f:
            lines = f.readlines()
    found = False
    for i, line in enumerate(lines):
        if line.strip().startswith("DECODER_OPTIONS="):
            found = True
            opts = line.split("=",1)[-1].strip().strip('"').strip("'")
            parts = opts.split()

            def _set(parts, key, val):
                if key in parts:
                    idx = parts.index(key)
                    if idx+1 < len(parts):
                        parts[idx+1] = f"{val}"
                else:
                    parts += [key, f"{val}"]
                return parts

            parts = _set(parts, "--lat", f"{lat:.8f}")
            parts = _set(parts, "--lon", f"{lon:.8f}")
            new_opts = " ".join(parts)
            lines[i] = f'DECODER_OPTIONS="{new_opts}"\n'
            break
    if not found:
        lines.append(f'DECODER_OPTIONS="--lat {lat:.8f} --lon {lon:.8f}"\n')
    with open(cfg, "w") as f:
        f.writelines(lines)
    subprocess.call(["sudo","systemctl","restart","readsb"])

# ---- auto-fix helpers (NEW) ----
def _run(cmd_list):
    env = os.environ.copy()
    env["LANG"] = "C"
    p = subprocess.run(cmd_list, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, env=env)
    return p.returncode, (p.stdout or "").strip(), (p.stderr or "").strip()

def _sysctl_state(unit="wingbits"):
    rc1, out1, _ = _run(["systemctl","is-enabled",unit])
    rc2, out2, _ = _run(["systemctl","is-active",unit])
    return (out1 or "unknown").strip(), (out2 or "unknown").strip()

def _autofix_wingbits():
    applied = []
    enabled, active = _sysctl_state("wingbits")

    if enabled == "masked":
        for cmd in [
            ["sudo","-n","systemctl","unmask","wingbits"],
            ["sudo","-n","systemctl","enable","--now","wingbits"],
        ]:
            rc, out, err = _run(cmd)
            applied.append({"action": " ".join(cmd), "result": (out or err or f"rc={rc}")})
        enabled, active = _sysctl_state("wingbits")
    elif active != "active":
        rc, out, err = _run(["sudo","-n","systemctl","restart","wingbits"])
        applied.append({"action": "sudo -n systemctl restart wingbits", "result": (out or err or f"rc={rc}")})
        enabled, active = _sysctl_state("wingbits")

    return applied, enabled, active

@app.route('/api/troubleshoot/run', methods=['POST'])
@login_required
def api_troubleshoot_run():
    req = request.get_json(silent=True) or {}
    apply_fix = bool(req.get("apply_fix", False))

    checks = []
    summary_warnings = 0
    summary_fail = 0
    safe_actions = []

    # 1) Internet
    try:
        r = requests.get("https://1.1.1.1", timeout=3)
        online = (r.status_code in (200,301,302))
    except requests.RequestException:
        online = False
    checks.append({
        "id":"internet","title":"Internet connectivity",
        "status": _status_label(online),
        "details": f"http(s) to 1.1.1.1 => {'OK' if online else 'UNREACHABLE'}"
    })
    if not online:
        summary_fail += 1

    # 2) Wingbits API
    try:
        r2 = requests.get("https://api.wingbits.com/ping", timeout=5)
        api_ok = (r2.status_code == 200)
    except requests.RequestException:
        api_ok = False
    checks.append({
        "id":"wingbits_api","title":"Wingbits API reachability",
        "status": _status_label(api_ok, warn=(online and not api_ok)),
        "details": f"GET /ping => {'200 OK' if api_ok else 'unreachable'}"
    })
    if not api_ok:
        if online: summary_warnings += 1
        else: summary_fail += 1

    # 3) Services basic
    readsb_active = _svc_active("readsb")
    wingbits_active = _svc_active("wingbits")
    tar1090_active = _svc_active("tar1090")

    checks += [
        {"id":"svc_readsb","title":"readsb service","status":_status_label(readsb_active),"details":_status_head('readsb')},
        {"id":"svc_wingbits","title":"wingbits service","status":_status_label(wingbits_active),"details":_status_head('wingbits')},
        {"id":"svc_tar1090","title":"tar1090 service","status":_status_label(tar1090_active, warn=False),"details":_status_head('tar1090')}
    ]
    if not readsb_active:
        summary_fail += 1
        safe_actions.append(("Restart readsb","sudo systemctl restart readsb"))
    if not wingbits_active:
        summary_fail += 1
        safe_actions.append(("Restart wingbits","sudo systemctl restart wingbits"))

    # 4) SDR dongle
    sdr_lines, sdr_found = _lsusb_sdr_lines()
    sdr_details = "No RTL/SDR device in lsusb."
    if sdr_found:
        sdr_details = "\n".join(sdr_lines)
    checks.append({"id":"sdr","title":"SDR dongle detected (lsusb)","status":_status_label(sdr_found),"details":sdr_details})
    if not sdr_found:
        summary_fail += 1

    # 5) readsb data flow
    stats = _read_readsb_stats()
    flow_ok = _readsb_flow_ok(stats) if readsb_active else False
    flow_details = "stats.json not found."
    if stats:
        msgs = stats.get("last1min",{}).get("messages_valid",0)
        ac_pos = stats.get("aircraft_with_pos",0)
        ac_nop = stats.get("aircraft_without_pos",0)
        flow_details = f"messages_valid(last1min): {msgs}\naircraft: {ac_pos+ac_nop} (pos:{ac_pos}, no_pos:{ac_nop})"
    checks.append({"id":"readsb_flow","title":"readsb data flow","status":_status_label(flow_ok, warn=(readsb_active and not flow_ok)),"details":flow_details})
    if readsb_active and not flow_ok:
        summary_warnings += 1
        safe_actions.append(("Restart readsb (no data)","sudo systemctl restart readsb"))

    # 6) readsb recent log hints
    readsb_log = _journal_tail("readsb", n=200)
    hints = _parse_readsb_hints(readsb_log)
    hint_status = "OK" if not hints else "WARN"
    checks.append({"id":"readsb_hints","title":"readsb recent log hints","status":hint_status,"details":("No obvious errors." if not hints else "\n".join(hints) + "\n\nSee Support → readsb logs for details")})
    if hints:
        summary_warnings += 1

    # 7) Wingbits verbose status
    wb_verbose = _wb_status_verbose()
    checks.append({"id":"wb_verbose","title":"wingbits detailed status","status":"OK","details":wb_verbose})

    # 8) GeoSigner info
    geo_txt = _geosigner_info()
    checks.append({"id":"geosigner","title":"GeoSigner","status":"OK","details":geo_txt})

    # 9) Time sync (NTP)
    ntp_ok = _ntp_synced()
    checks.append({"id":"ntp","title":"Time sync (NTP)","status":_status_label(ntp_ok),"details":f"NTPSynchronized={ntp_ok}"})
    if not ntp_ok:
        summary_warnings += 1
        safe_actions.append(("Enable NTP sync","sudo timedatectl set-ntp true ; sudo systemctl restart systemd-timesyncd || true"))

    # 10) Resources
    res = _summarize_resources()
    res_ok = (res["disk_free_gb"] > 1 and res["ram_free_mb"] > 64)
    checks.append({"id":"resources","title":"Resources (disk/memory)","status":_status_label(res_ok, warn=not res_ok),"details":f"Disk free: {res['disk_free_gb']} GB\nRAM free: {res['ram_free_mb']} MB"})
    if not res_ok:
        summary_warnings += 1

    # 11) Location consistency (NEW)
    gps_raw = _geosigner_info()
    gps_lat, gps_lon, sats = _parse_geosigner_info_txt(gps_raw)
    stated_lat, stated_lon = _readsb_config_location()
    loc_details = "GPS/stated location unavailable."
    loc_ok = True
    delta_km = None
    if gps_lat is not None and gps_lon is not None and stated_lat is not None and stated_lon is not None:
        try:
            delta_km = round(_haversine_km(gps_lat, gps_lon, stated_lat, stated_lon), 3)
            loc_ok = (delta_km <= 0.3)  # 300 m tolerance
            loc_details = (
                f"GPS: {gps_lat:.6f},{gps_lon:.6f} (sats={sats or 'n/a'})\n"
                f"Stated(readsb): {stated_lat:.6f},{stated_lon:.6f}\n"
                f"Δ = {delta_km} km"
            )
        except Exception as _e:
            loc_ok = False
            loc_details = f"Failed to compute distance: {_e}"
    else:
        loc_ok = False

    checks.append({
        "id": "location_consistency",
        "title": "GeoSigner vs stated location",
        "status": _status_label(loc_ok, warn=not loc_ok),
        "details": loc_details
    })
    if not loc_ok:
        summary_warnings += 1
        safe_actions.append((
            "Apply GPS → readsb location",
            f"curl -s -X POST http://127.0.0.1:{WEB_PANEL_RUN_PORT}/api/geosigner/apply-location "
            f"-H 'X-Auth-Token: {CURRENT_SESSION_TOKEN or ''}' -H 'Content-Type: application/json' -d '{{\"source\":\"gps\"}}'"
        ))

    # Summary
    overall = "OK"
    if summary_fail > 0:
        overall = "ERROR"
    elif summary_warnings > 0:
        overall = "WARN"

    # Execute planned safe actions (restart, etc.)
    applied_safe = []
    if apply_fix and safe_actions:
        for title, cmd in safe_actions:
            out = run_shell(cmd)
            applied_safe.append({"action": title, "result": out[:4000]})

    # Auto-fix masked/disabled wingbits
    autofix = {"applied": []}
    if apply_fix:
        actions, enabled, active = _autofix_wingbits()
        autofix["applied"].extend(actions)
        autofix["state"] = {"enabled": enabled, "active": active}

    return jsonify({
        "ok": True,
        "summary": {"overall": overall, "fails": summary_fail, "warnings": summary_warnings},
        "checks": checks,
        "autofix": {
            "applied": applied_safe + autofix["applied"],
            "planned": [{"title": a, "cmd": c} for a, c in safe_actions],
            "state": autofix.get("state", None)
        }
    })

# ----------------- NEW GeoSigner APIs -----------------
@app.route('/api/geosigner/location', methods=['GET'])
@login_required
def api_geosigner_location():
    raw = run_shell("sudo wingbits geosigner info 2>&1")
    gps_lat, gps_lon, sats = _parse_geosigner_info_txt(raw)

    # stated: from readsb
    stated_src = "readsb"
    stated_lat, stated_lon = _readsb_config_location()

    delta_km = None
    if gps_lat is not None and gps_lon is not None and stated_lat is not None and stated_lon is not None:
        try:
            delta_km = round(_haversine_km(gps_lat, gps_lon, stated_lat, stated_lon), 3)
        except Exception:
            delta_km = None

    return jsonify({
        "ok": True,
        "gps": {"lat": gps_lat, "lon": gps_lon, "satellites": sats},
        "stated": {"lat": stated_lat, "lon": stated_lon, "source": stated_src},
        "delta_km": delta_km
    })

@app.route('/api/geosigner/apply-location', methods=['POST'])
@login_required
def api_geosigner_apply_location():
    data = request.get_json() or {}
    source = (data.get("source") or "gps").lower()
    lat = data.get("lat"); lon = data.get("lon")

    if source == "gps" and (lat is None or lon is None):
        raw = run_shell("sudo wingbits geosigner info 2>&1")
        lat, lon, _ = _parse_geosigner_info_txt(raw)

    try:
        if lat is None or lon is None:
            return jsonify({"ok": False, "msg": "Latitude/Longitude not available"}), 400
        _set_readsb_location(float(lat), float(lon))
        return jsonify({"ok": True, "msg": "readsb location updated from GPS & service restarted"})
    except Exception as e:
        return jsonify({"ok": False, "msg": str(e)}), 500

# ----------- Frontend files -----------
@app.route('/', defaults={'path': ''})
@app.route('/<path:path>')
def serve_frontend(path):
    root = '/opt/wingbits-station-web/frontend'
    if path != "" and os.path.exists(os.path.join(root, path)):
        return send_from_directory(root, path)
    else:
        return send_from_directory(root, "index.html")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=WEB_PANEL_RUN_PORT)
EOF

echo "Backend Flask app written at: $BACKEND_DIR/app.py"

# Optional: hint for service restart (uncomment if you have a systemd unit named wingbits-web-panel)
# if systemctl list-units --type=service | grep -q "wingbits-web-panel.service"; then
#   echo "Restarting wingbits-web-panel service..."
#   sudo systemctl restart wingbits-web-panel
# fi

echo "Done."
