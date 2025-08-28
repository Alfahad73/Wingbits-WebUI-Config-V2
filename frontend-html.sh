#!/bin/bash

# Write the frontend (index.html)

set -e

echo "Writing frontend files..."

INSTALL_DIR="/opt/wingbits-station-web"
FRONTEND_DIR="$INSTALL_DIR/frontend"

# ========== index.html file ==========
cat > "$FRONTEND_DIR/index.html" << 'EOF'
<!DOCTYPE html>
<html lang="en" dir="ltr">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>Wingbits Station Web Config</title>
  <link rel="icon" type="image/png" href="https://wingbits.com/apple-icon.png?34e8dd62bf865c3e" />
  <style>
  .tabs-bar {
  display: flex;
  gap: 0px;
  border-bottom: 2px solid #e2e8f0;
  margin-bottom: 22px;
  margin-top: 18px;
}
.tab-btn {
  background: none;
  color: #202540;
  border: none;
  border-bottom: 3px solid transparent;
  padding: 11px 32px 10px 32px;
  margin: 0;
  font-size: 1.13em;
  font-weight: 600;
  cursor: pointer;
  transition: 0.13s;
  border-radius: 13px 13px 0 0;
  outline: none;
}
.tab-btn.active {
  background: #f4f7fd;
  color: #1976d2;
  border-bottom: 3px solid #2196f3;
  font-weight: bold;
}
.tab-content {
  display: none;
  min-height: 200px;
}
.tab-content.active {
  display: block;
  animation: fadein .4s;
}
@keyframes fadein {
  from {opacity:0;}
  to {opacity:1;}
}
  body {
    background: #f5f8fe;
    font-family: 'Segoe UI', 'system-ui', Arial, sans-serif;
    margin: 0;
    padding: 0;
    direction: ltr;
  }
  .container {
    display: flex;
    height: 100vh;
    width: 100vw;
  }
  .sidebar {
    background: #1a2940;
    color: #fff;
    width: 200px;
    min-width: unset;
    padding: 24px 4px 0 4px;
    display: flex;
    flex-direction: column;
    align-items: center;
    border-top-right-radius: 22px;
    border-bottom-right-radius: 22px;
    box-shadow: 2px 0 24px #0002;
	overflow-y: auto;
    max-height: 100vh;
    /* Hidden by default until authenticated */
    display: none; 
  }
  .logo {
    width: 38px;
    margin-bottom: 12px;
    border-radius: 12px;
    background: #fff;
    box-shadow: 0 2px 16px #0003;
  }
  .side-title {
    margin-bottom: 13px;
    font-size: 1.15rem;
    font-weight: 700;
    text-align: center;
    letter-spacing: 0.01em;
    white-space: pre-line;
  }
  .side-menu {
    width: 100%;
    margin-bottom: 18px;
  }
  .side-menu button {
    background: none;
    border: none;
    color: #fff;
    font-size: 1.03rem;
    width: 100%;
    padding: 10px 0 10px 7px;
    margin-bottom: 4px;
    text-align: left;
    cursor: pointer;
    border-radius: 8px;
    transition: background 0.16s;
    font-weight: 500;
  }
  .lang-switch {
    margin-top: auto;
    margin-bottom: 11px;
    width: 100%;
    display: flex;
    gap: 4px;
  }
  .lang-switch button {
    flex: 1;
    border-radius: 7px;
    border: none;
    background: #fff;
    color: #1a2940;
    font-weight: 600;
    font-size: 0.98rem;
    padding: 7px 0;
    cursor: pointer;
    transition: background 0.15s;
  }
  .lang-switch button.active {
    background: #1366f6;
    color: #fff;
    box-shadow: 0 2px 8px #1366f650;
  }
  .main {
    flex: 1;
    padding: 48px 7vw;
    display: flex;
    flex-direction: column;
    overflow-y: auto;
  }
  .form-group {
    margin-bottom: 26px;
  }
  .label {
    font-weight: 600;
    margin-bottom: 7px;
    display: block;
    font-size: 1.06em;
    color: #1a2940;
  }
  input, select, textarea, button.action {
    font-size: 1rem;
    padding: 10px 12px;
    border-radius: 9px;
    border: 1px solid #e3eaf4;
    background: #f6faff;
    margin-bottom: 9px;
    width: 100%;
    transition: border 0.16s;
    box-sizing: border-box;
  }
  input:focus, select:focus, textarea:focus {
    border-color: #1366f6;
    outline: none;
  }
  button.action {
    background: #1366f6;
    color: #fff;
    border: none;
    cursor: pointer;
    margin-top: 6px;
    transition: background 0.17s, box-shadow 0.18s;
    box-shadow: 0 1px 5px #1366f640;
    font-weight: 600;
    letter-spacing: 0.02em;
  }
  button.action:hover {
    background: #0956cb;
    box-shadow: 0 2px 12px #1366f655;
  }
  .result-block {
    background: #fff;
    border-radius: 18px;
    padding: 18px 18px;
    margin: 20px 0 10px 0;
    box-shadow: 0 2px 14px #0001;
    direction: ltr;
    font-family: monospace;
    font-size: 1.07em;
    overflow-x: auto;
    white-space: pre-wrap;
    color: #333;
  }
  .desc-block {
    font-size: 1.07em;
    color: #1366f6;
    margin-top: 9px;
    margin-bottom: 19px;
  }
  hr {
    border: none;
    height: 2px;
    background: #e4eaf6;
    border-radius: 2px;
    margin: 18px 0 22px 0;
  }
  .diagnostics-section {
    background-color: #ffffff;
    padding: 24px;
    border-radius: 15px;
    margin-bottom: 25px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.05);
  }
  .diagnostics-section h3 {
    margin-top: 0;
    margin-bottom: 8px;
    font-size: 1.4em;
    color: #1a2940;
  }
  .diagnostics-section p {
    margin-top: 0;
    margin-bottom: 20px;
    color: #555;
    font-size: 1.05em;
  }
  .diagnostics-section button.action {
    width: 100%;
    margin-bottom: 10px;
    padding: 12px;
    font-size: 1.1em;
  }
  .diag-command-item {
      margin-bottom: 20px;
  }
  .log-link-result {
    margin-top: 10px;
    padding: 10px;
    background-color: #e9f5ff;
    border: 1px solid #b3d7ff;
    border-radius: 8px;
    font-family: monospace;
    word-wrap: break-word;
  }
  @media (max-width: 700px) {
    .main { padding: 13px 1vw; }
    .sidebar { min-width: 66px; padding-left: 3px; padding-right: 3px;}
    .side-title { font-size: 1.06rem; }
    .logo { width: 38px; }
    .side-menu button { font-size: 0.98rem;}
    .lang-switch { font-size: 0.97rem;}
  }
  body.rtl .container {
  flex-direction: row-reverse;
}

body.rtl .sidebar {
  border-top-right-radius: 0;
  border-bottom-right-radius: 0;
  border-top-left-radius: 22px;
  border-bottom-left-radius: 22px;
  box-shadow: -2px 0 24px #0002;
}
body.rtl .sidebar {
  text-align: right;
}
body.rtl .side-menu button {
  text-align: right;
  padding-right: 12px;
}
body.rtl .main {
  text-align: right;
}

body.rtl .result-block,
body.rtl .desc-block,
body.rtl h2,
body.rtl h3,
body.rtl h4,
body.rtl .form-group,
body.rtl .tabs-bar,
body.rtl .tab-content,
body.rtl .tab-btn,
body.rtl input,
body.rtl select,
body.rtl textarea,
body.center button,
body.rtl table,
body.rtl #main-content,
body.rtl .diagnostics-section {
  direction: rtl;
  text-align: right;
}

/* Login Page Specific Styles */
.login-container {
    display: flex;
    justify-content: center; /* Center horizontally */
    align-items: center; /* Center vertically */
    height: 100vh;
    width: 100vw; /* Ensure it takes full width to center content */
    background: #f5f8fe;
}
.login-box {
    background: #fff;
    padding: 40px;
    border-radius: 15px;
    box-shadow: 0 5px 25px rgba(0,0,0,0.1);
    width: 100%;
    max-width: 400px;
    text-align: center;
    margin: auto; /* Center within flex container */
}
.login-box h2 {
    margin-bottom: 30px;
    color: #1a2940;
    font-size: 1.8em;
}
.login-box input[type="text"],
.login-box input[type="password"] {
    width: calc(100% - 24px);
    padding: 12px;
    margin-bottom: 20px;
    border: 1px solid #e3eaf4;
    border-radius: 8px;
    font-size: 1.1em;
}
.login-box button.action {
    width: 100%;
    padding: 12px;
    font-size: 1.1em;
    margin-top: 10px;
}
.login-message {
    margin-top: 20px;
    color: red;
    font-weight: bold;
}

  /* ===== Smart Troubleshooter (UI styles) ===== */
  .ts-top{display:flex;justify-content:space-between;align-items:center;margin:6px 0 14px}
  .ts-row{background:#fff;border:1px solid #eef2f8;border-left:6px solid #d0d7e1;border-radius:10px;padding:10px 12px;margin:8px 0}
  .ts-ok{border-left-color:#27ae60}
  .ts-warn{border-left-color:#f39c12}
  .ts-fail{border-left-color:#e74c3c}
  .ts-init{border-left-color:#f1c40f}
  .ts-title{font-weight:700;color:#1a2940;margin-bottom:6px}
  .ts-details{font-family:monospace;white-space:pre-wrap;color:#333}
  .ts-badge{padding:3px 8px;border-radius:8px;font-weight:700;font-size:.92em}
  .ok{background:#eaf9ee;color:#1c7c3c}
  .warn{background:#fff7e8;color:#a86a08}
  .fail{background:#ffecec;color:#b1332b}

</style>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
  <div class="container" id="container">
    <div class="sidebar" id="sidebar">
      <img class="logo" src="https://wingbits.com/apple-icon.png?34e8dd62bf865c3e" alt="Wingbits" />
      <div class="side-title" id="side-title">Wingbits Web Config</div>
      <div class="side-menu" id="side-menu">
        </div>
      <div class="lang-switch">
        <button id="en-btn" class="active" onclick="setLang('en')">EN</button>
        <button id="ar-btn" onclick="setLang('ar')">العربية</button>
      </div>
      <!-- Logout button is hidden by default and shown after login -->
      <button class="action" style="margin-top: auto; margin-bottom: 15px; width: 80%; display: none;" onclick="logoutUser()" id="logout-btn"></button>
    </div>
    <div class="main" id="main-content">
      </div>
  </div>

  <script>
    // --------- Interface text translation ----------
    const txt = {
      en: {
        main_title: "Wingbits Station Web Config",
        menu: [
          "Live Stats", "Set Gain", "QOL Options", "Support", "Wingbits Metrics", "Restart", "Change Password", "URLs", "Help"
        ],
        support_menu_title: "Support",
        readsb: "readsb Service",
        wingbits: "wingbits Service",
        tar1090: "tar1090 Service",
        graphs1090: "graphs1090 Service",
        btn_status: "Status",
        btn_restart: "Restart",
        btn_logs: "Logs",
        btn_update: "Update",
        btn_geosigner: "GeoSigner Info",
        btn_version: "Version",
        btn_set_gain: "Set Gain",
        btn_colorscheme: "Colorscheme",
        btn_routeinfo: "Route Info",
        btn_dark: "Dark",
        btn_light: "Light",
        btn_enable: "Enable",
        btn_disable: "Disable",
        btn_signalreport: "Signal Report",
        btn_debug: "Debug",
        logs_head: "View Logs",
        settings_head: "System Info & Tools",
        reboot: "Reboot",
        shutdown: "Shutdown",
        about: "About & Help",
        please_wait: "Please wait...",
        gain_value: "Gain value",
        apply: "Apply",
        service: "Service",
        select: "Select",
        colorscheme: "Colorscheme",
        pi_restart: "Reboot Device",
        pi_shutdown: "Shutdown Device",
        info_system: "System Info",
        yes: "Yes",
        no: "No",
        logout: "Logout",
        change_password: "Change Password",
        old_password: "Old Password",
        new_password: "New Password",
        confirm_new_password: "Confirm New Password",
        update_password: "Update Password",
        username: "Username",
        password: "Password",
        login: "Login",
        login_failed: "Login failed. Please check your username and password.",
        password_changed_success: "Password changed successfully. Please log in again.",
        password_change_fail: "Password change failed. Please check your old password and try again.",
        password_mismatch: "New passwords do not match.",
        password_too_short: "New password must be at least 6 characters long.",
        wingbits_install_needed: "Wingbits client not installed. Please install it from your 'My Stations' dashboard on wingbits.com.",
        wb_config_install_needed: "wb-config not installed. Please install it manually by running: curl -sL https://gitlab.com/wingbits/config/-/raw/master/wb-config/install.sh | sudo bash",
        return_to_normal_gain: "Return to Normal Gain Options",
        confirm_update_client: "Are you sure you want to update the Wingbits client?",
        update_in_progress: "An update is already in progress.",
        update_started: "Wingbits client update started. Checking progress...",
        update_finished: "Wingbits client update finished.",
        update_failed: "Wingbits client update failed.",
        fetching_logs: "Fetching update logs...",
        update_client_progress: "Wingbits Client Update Progress",
        update_log_placeholder: "Update logs will appear here...",
        wingbits_metrics: "Wingbits Metrics",
        diagnostics: "Diagnostics",
        diagnostics_title: "Diagnostics & Support Tools",
        generate_log_url_title: "Generate Log URL for Support",
        generate_log_url_desc: "Click a button to generate a temporary URL containing system logs. This is useful for sharing with the Wingbits support team.",
        generate_wingbits_readsb_link: "Generate Wingbits & readsb Logs Link",
        generate_all_logs_link: "Generate All Recent Logs Link",
        handy_commands_title: "Handy Diagnostic Commands",
        view_os_release: "View OS Release Details",
        view_usb_devices: "View USB Devices",
        check_voltage: "Check Voltage Throttling",
        view_wingbits_status_verbose: "View Wingbits Detailed Status",
        view_geosigner_info: "View GeoSigner Info",
        copy_link: "Copy Link",
        copied: "Copied!",

        /* Updates (new) */
        updates: "Updates",
        check_updates: "Check for Updates",
        updates_panel_title: "Panel & Wingbits Updates",
        current_version: "Current version",
        latest_version: "Latest available",
        update_available: "Update available",
        panel_up_to_date: "Panel is up-to-date.",
        wingbits_up_to_date: "Wingbits Client is up-to-date.",
        unknown: "Unknown",
        update_panel_now: "Update Panel",
        update_wingbits_now: "Update Wingbits Client",

        /* NEW i18n for Smart Troubleshooter INIT + hints */
        initializing: "Initializing",
        init_msg: "Recent boot/replug detected. For best diagnostic result wait 180–300 seconds, then run diagnostics again.",
        now: "Current time",
        boot_at: "Boot/replug time",
        run_again_60: "Run again in 300s",
        ts_readsb_hint_port_issue: "- readsb network/port output issue.",
        ts_readsb_hint_cleared: "[Cleared] readsb currently healthy; older log warning ignored."
      },
      ar: {
        main_title: "إعداد محطة Wingbits عبر الويب",
        menu: [
          "الحالة الحية", "ضبط الكسب", "خيارات الجودة", "الدعم", "مقاييس Wingbits", "إعادة/إيقاف التشغيل", "تغيير كلمة المرور", "روابط محلية", "حول"
        ],
        support_menu_title: "الدعم",
        readsb: "خدمة readsb",
        wingbits: "خدمة wingbits",
        tar1090: "خدمة tar1090",
        graphs1090: "خدمة graphs1090",
        btn_status: "الحالة",
        btn_restart: "إعادة تشغيل",
        btn_logs: "السجلات",
        btn_update: "تحديث",
        btn_geosigner: "معلومات GeoSigner",
        btn_version: "الإصدار",
        btn_set_gain: "ضبط الكسب",
        btn_colorscheme: "مخطط الألوان",
        btn_routeinfo: "معلومات المسار",
        btn_dark: "غامق",
        btn_light: "فاتح",
        btn_enable: "تفعيل",
        btn_disable: "تعطيل",
        btn_signalreport: "تقرير الإشارة",
        btn_debug: "تصحيح",
        logs_head: "عرض السجلات",
        settings_head: "معلومات النظام وأدواته",
        reboot: "إعادة تشغيل",
        shutdown: "إيقاف تشغيل",
        about: "حول & مساعدة",
        please_wait: "يرجى الانتظار...",
        gain_value: "قيمة الكسب",
        apply: "تطبيق",
        service: "الخدمة",
        select: "اختر",
        colorscheme: "مخطط الألوان",
        pi_restart: "إعادة تشغيل الجهاز",
        pi_shutdown: "إيقاف تشغيل الجهاز",
        info_system: "معلومات النظام",
        yes: "نعم",
        no: "لا",
        logout: "تسجيل الخروج",
        change_password: "تغيير كلمة المرور",
        old_password: "كلمة المرور القديمة",
        new_password: "كلمة المرور الجديدة",
        confirm_new_password: "تأكيد كلمة المرور الجديدة",
        update_password: "تحديث كلمة المرور",
        username: "اسم المستخدم",
        password: "كلمة المرور",
        login: "تسجيل الدخول",
        login_failed: "فشل تسجيل الدخول. يرجى التحقق من اسم المستخدم وكلمة المرور.",
        password_changed_success: "تم تغيير كلمة المرور بنجاح. يرجى تسجيل الدخول مرة أخرى.",
        password_change_fail: "فشل تغيير كلمة المرور. يرجى التحقق من كلمة المرور القديمة والمحاولة مرة أخرى.",
        password_mismatch: "كلمتا المرور الجديدتان غير متطابقتين.",
        password_too_short: "يجب أن تتكون كلمة المرور الجديدة من 6 أحرف على الأقل.",
        wingbits_install_needed: "عميل Wingbits غير مثبت. يرجى تثبيته من لوحة معلومات 'محطاتي' على wingbits.com.",
        wb_config_install_needed: "wb-config غير مثبت. يرجى تثبيته يدويًا عن طريق تشغيل: curl -sL https://gitlab.com/wingbits/config/-/raw/master/wb-config/install.sh | sudo bash",
        return_to_normal_gain: "العودة لخيارات Gain العادية",
        confirm_update_client: "هل أنت متأكد أنك تريد تحديث عميل Wingbits؟",
        update_in_progress: "تحديث قيد التقدم بالفعل.",
        update_started: "بدأ تحديث عميل Wingbits. جاري التحقق من التقدم...",
        update_finished: "اكتمل تحديث عميل Wingbits.",
        update_failed: "فشل تحديث عميل Wingbits.",
        fetching_logs: "جاري جلب سجلات التحديث...",
        update_client_progress: "تقدم تحديث عميل Wingbits",
        update_log_placeholder: "ستظهر سجلات التحديث هنا...",
        wingbits_metrics: "مقاييس Wingbits",
        diagnostics: "التشخيص",
        diagnostics_title: "أدوات التشخيص والدعم",
        generate_log_url_title: "إنشاء رابط للسجلات للدعم",
        generate_log_url_desc: "انقر فوق زر لإنشاء عنوان URL مؤقت يحتوي على سجلات النظام. هذا مفيد للمشاركة مع فريق دعم Wingbits.",
        generate_wingbits_readsb_link: "إنشاء رابط لسجلات Wingbits و readsb",
        generate_all_logs_link: "إنشاء رابط لجميع السجلات الحديثة",
        handy_commands_title: "أوامر تشخيص مفيدة",
        view_os_release: "عرض تفاصيل نظام التشغيل",
        view_usb_devices: "عرض أجهزة USB",
        check_voltage: "فحص انخفاض الجهد",
        view_wingbits_status_verbose: "عرض حالة Wingbits التفصيلية",
        view_geosigner_info: "عرض معلومات GeoSigner",
        copy_link: "نسخ الرابط",
        copied: "تم النسخ!",

        /* Updates (new) */
        updates: "التحديثات",
        check_updates: "فحص التحديثات",
        updates_panel_title: "تحديثات اللوحة وعميل Wingbits",
        current_version: "الإصدار الحالي",
        latest_version: "أحدث إصدار متاح",
        update_available: "يتوفر تحديث",
        panel_up_to_date: "سكربت اللوحة مُحدّث.",
        wingbits_up_to_date: "عميل Wingbits مُحدّث.",
        unknown: "غير معروف",
        update_panel_now: "تحديث اللوحة",
        update_wingbits_now: "تحديث عميل Wingbits",

        /* NEW i18n for Smart Troubleshooter INIT + hints */
        initializing: "Initializing",
        init_msg: "تم اكتشاف تشغيل/إعادة توصيل حديث. انتظر 180–300 ثانية ثم شغّل التشخيص مجددًا.",
        now: "الوقت الحالي",
        boot_at: "وقت التشغيل/إعادة التوصيل",
        run_again_60: "أعد التشغيل بعد 300ث",
        ts_readsb_hint_port_issue: "- مشكلة شبكة/منفذ لإخراج readsb.",
        ts_readsb_hint_cleared: "[تم التجاهل] readsb يعمل حاليًا بشكل سليم؛ تم تجاهل تحذير قديم."
      }
    };

    let LANG = localStorage.getItem("wb_lang") || "en";
    let AUTH_TOKEN = localStorage.getItem("auth_token");

    // --- Live Stats / Dashboard Variables (Defined Globally) ---
    let liveChart = null;
    let liveStatsHistory = [];
    let liveTimer = null;
    let updateLogTimer = null; // Global timer for update logs polling

    // --- Language Settings ---
    function setLang(l) {
      LANG = l;
      localStorage.setItem("wb_lang", l);
      document.body.dir = (l === "ar") ? "rtl" : "ltr";
	  document.body.classList.toggle("rtl", l === "ar");
      
      const enBtn = document.getElementById("en-btn");
      const arBtn = document.getElementById("ar-btn");
      if (enBtn) enBtn.classList.toggle("active", l === "en");
      if (arBtn) arBtn.classList.toggle("active", l === "ar");
      
      const sideTitle = document.getElementById("side-title");
      if (sideTitle) {
        sideTitle.innerText = txt[LANG].main_title;
      }
      
      const logoutBtn = document.getElementById("logout-btn");
      if (logoutBtn) {
        logoutBtn.innerText = txt[LANG].logout;
      }
      
      // Re-render the current page to apply new language
      const currentKey = document.querySelector('.side-menu button.active')?.dataset.key || 'live_stats';
      const currentSub = document.querySelector('.side-menu button.active')?.dataset.sub || '';
      const currentQolSub = document.querySelector('.side-menu button.active')?.dataset.qolSub || '';
      
      // Only re-render if not on the login page and main content elements exist
      if (document.getElementById('login-container') === null && document.getElementById('main-content')) {
        renderMenuPage(currentKey, currentSub, currentQolSub);
      }
    }

    // --- Sidebar Menu Control ---
    function renderMenu(activeKey = 'live_stats', supportSub = '', qolSub = '') {
      const mainMenu = [
        { key: 'live_stats', label: LANG === 'ar' ? 'الحالة الحية' : 'Live Stats' },
        { key: 'set_gain', label: LANG === 'ar' ? 'ضبط الكسب' : 'Set Gain' },
        { key: 'qol_options', label: LANG === 'ar' ? 'خيارات الجودة' : 'QOL Options' },
        { key: 'support_menu', label: txt[LANG].support_menu_title },
        { key: 'wingbits_metrics', label: LANG === 'ar' ? 'مقاييس Wingbits' : 'Wingbits Metrics', isExternalLink: true, url: 'http://192.168.100.5:8088/metrics' },
        { key: 'restart', label: LANG === 'ar' ? 'إعادة/إيقاف التشغيل' : 'Restart' },
        { key: 'change_password', label: LANG === 'ar' ? 'تغيير كلمة المرور' : 'Change Password' },
        { key: 'urls', label: LANG === 'ar' ? 'روابط محلية' : 'URLs' },
        { key: 'help', label: LANG === 'ar' ? 'مساعدة' : 'Help' }
      ];
      let menu = '';
      for (let i = 0; i < mainMenu.length; ++i) {
        let isActive = (mainMenu[i].key === activeKey) ? "active" : "";
        
        // External links
        if (mainMenu[i].isExternalLink) {
            menu += `<button class="${isActive}" data-key="${mainMenu[i].key}" onclick="window.open('${mainMenu[i].url}', '_blank')">${mainMenu[i].label}</button>`;
        } else {
            menu += `<button class="${isActive}" data-key="${mainMenu[i].key}" onclick="renderMenuPage('${mainMenu[i].key}')">${mainMenu[i].label}</button>`;
        }

        if (mainMenu[i].key === 'qol_options' && activeKey === 'qol_options') {
          menu += `
            <div style="margin-left:18px;">
              <button class="${qolSub==='graphs_colorscheme'?'active':''}" data-key="qol_options" data-qol-sub="graphs_colorscheme" onclick="renderMenuPage('qol_options', '', 'graphs_colorscheme')">${LANG === 'ar' ? 'مخطط ألوان graphs1090' : 'graphs1090 colorscheme'}</button>
              <button class="${qolSub==='tar_routes'?'active':''}" data-key="qol_options" data-qol-sub="tar_routes" onclick="renderMenuPage('qol_options', '', 'tar_routes')">${LANG === 'ar' ? 'مسارات tar1090' : 'tar1090 routes'}</button>
              <button class="${qolSub==='tar_heatmaps'?'active':''}" data-key="qol_options" data-qol-sub="tar_heatmaps" onclick="renderMenuPage('qol_options', '', 'tar_heatmaps')">${LANG === 'ar' ? 'خرائط الحرارة tar1090' : 'tar1090 heatmaps'}</button>
            </div>
          `;
        }
        if (mainMenu[i].key === 'support_menu' && activeKey === 'support_menu') {
          menu += `
            <div style="margin-left:18px;">
              <button class="${supportSub==='troubleshooter'?'active':''}" data-key="support_menu" data-sub="troubleshooter" onclick="renderMenuPage('support_menu','troubleshooter')">${(LANG === 'ar' ? 'أداة تشخيص ذكية' : 'Smart Troubleshooter')}</button>
              <button class="${supportSub==='debug'?'active':''}" data-key="support_menu" data-sub="debug" onclick="renderMenuPage('support_menu','debug')">${LANG === 'ar' ? 'تصحيح' : 'Debug'}</button>
              <button class="${supportSub==='diagnostics'?'active':''}" data-key="support_menu" data-sub="diagnostics" onclick="renderMenuPage('support_menu','diagnostics')">${txt[LANG].diagnostics}</button>
              <button class="${supportSub==='wingbits_status'?'active':''}" data-key="support_menu" data-sub="wingbits_status" onclick="renderMenuPage('support_menu','wingbits_status')">${LANG === 'ar' ? 'حالة wingbits' : 'wingbits status'}</button>
              <button class="${supportSub==='readsb_status'?'active':''}" data-key="support_menu" data-sub="readsb_status" onclick="renderMenuPage('support_menu','readsb_status')">${LANG === 'ar' ? 'حالة readsb' : 'readsb status'}</button>
              <button class="${supportSub==='wingbits_logs'?'active':''}" data-key="support_menu" data-sub="wingbits_logs" onclick="renderMenuPage('support_menu','wingbits_logs')">${LANG === 'ar' ? 'سجلات wingbits' : 'wingbits logs'}</button>
              <button class="${supportSub==='readsb_logs'?'active':''}" data-key="support_menu" data-sub="readsb_logs" onclick="renderMenuPage('support_menu','readsb_logs')">${LANG === 'ar' ? 'سجلات readsb' : 'readsb logs'}</button>
              <button class="${supportSub==='all_logs'?'active':''}" data-key="support_menu" data-sub="all_logs" onclick="renderMenuPage('support_menu','all_logs')">${LANG === 'ar' ? 'جميع السجلات الحديثة' : 'All recent logs'}</button>

              <!-- NEW: Updates (Check for Updates) -->
              <button class="${supportSub==='updates'?'active':''}" data-key="support_menu" data-sub="updates" onclick="renderMenuPage('support_menu','updates')">${txt[LANG].check_updates}</button>

              <!-- Existing: Update Client (logs modal/polling) -->
              <button class="${supportSub==='update_client'?'active':''}" data-key="support_menu" data-sub="update_client" onclick="confirmUpdateClient()">${LANG === 'ar' ? 'تحديث العميل' : 'Update Client'}</button>
            </div>
          `;
        }
      }
      const sideMenu = document.getElementById("side-menu");
      if (sideMenu) {
        sideMenu.innerHTML = menu;
      }
    }

    function renderMenuPage(key, sub = '', qolSub = '') {
      // Clear any existing intervals before rendering a new page
      if (liveTimer) {
        clearInterval(liveTimer);
        liveTimer = null;
      }
      if (updateLogTimer) { // Clear update log timer
        clearInterval(updateLogTimer);
        updateLogTimer = null;
      }

      const mainContent = document.getElementById("main-content");
      if (!mainContent) {
        console.error("Main content element not found.");
        return;
      }

      // External link info
      if (key === 'wingbits_metrics') {
          mainContent.innerHTML = `<h2>${LANG === "ar" ? "مقاييس Wingbits" : "Wingbits Metrics"}</h2>
                                   <p>${LANG === "ar" ? "سيتم فتح صفحة المقاييس في تبويب جديد." : "The metrics page will open in a new tab."}</p>`;
          renderMenu(key); // highlight the menu item
          return;
      }

      if (key === 'support_menu') {
        renderMenu('support_menu', sub, qolSub);
        if (sub === 'updates') return renderUpdatesPage();     // NEW
        if (sub === 'debug') return renderDebug();
        if (sub === 'diagnostics') return renderDiagnosticsPage();
        if (sub === 'wingbits_status') return callAPI('/api/service/wingbits/status', 'GET', null, 'main-content');
        if (sub === 'readsb_status') return callAPI('/api/service/readsb/status', 'GET', null, 'main-content');
        if (sub === 'wingbits_logs') return callAPI('/api/service/wingbits/logs', 'GET', null, 'main-content');
        if (sub === 'readsb_logs') return callAPI('/api/service/readsb/logs', 'GET', null, 'main-content');
        if (sub === 'all_logs') return renderAllLogs();
        if (sub === 'last_install_log') return renderLastInstallLog();
        mainContent.innerHTML = `<h2>${LANG === "ar" ? "يرجى اختيار خيار فرعي..." : "Please select a Support sub-option..."}</h2>`;
        return;
      }
      renderMenu(key, '', qolSub);
      if (key === 'live_stats') return renderLiveStats();
      if (key === 'set_gain') return renderSetGain();
      if (key === 'qol_options') {
        if (qolSub === 'graphs_colorscheme') return renderGraphsColorscheme();
        if (qolSub === 'tar_routes') return renderTarRoutes();
        if (qolSub === 'tar_heatmaps') return renderTarHeatmaps();
        mainContent.innerHTML = `<h2>Please select sub-option</h2>`;
        return;
      }
      if (key === 'urls') return renderURLs();
      if (key === 'restart') return renderPower();
      if (key === 'change_password') return renderChangePasswordPage();
      if (key === 'help') return renderHelp();
      mainContent.innerHTML = `<h2>Please select sub-option</h2>`;
    }

    // --- Live Stats / Dashboard Functions ---
    function renderLiveStats() {
      const mainContent = document.getElementById("main-content");
      if (!mainContent) return;

      mainContent.innerHTML = `
        <h2>${LANG === "ar" ? "لوحة مراقبة المحطة" : "Station Dashboard"}</h2>
        <div class="tabs-bar">
          <button class="tab-btn active" id="tabbtn_live" onclick="switchTab('live')">${LANG==="ar"?"الحالة الحية":"Live Stats"}</button>
          <button class="tab-btn" id="tabbtn_tools" onclick="switchTab('tools')">${LANG==="ar"?"أدوات":"Tools"}</button>
          <button class="tab-btn" id="tabbtn_alerts" onclick="switchTab('alerts')">${LANG==="ar"?"تنبيهات":"Alerts"}</button>
        </div>
        <div id="tabcontent_live" class="tab-content active"></div>
        <div id="tabcontent_tools" class="tab-content"></div>
        <div id="tabcontent_alerts" class="tab-content"></div>
      `;
      switchTab('live');
    }

    function switchTab(tab) {
      const tabbtnLive = document.getElementById("tabbtn_live");
      const tabbtnTools = document.getElementById("tabbtn_tools");
      const tabbtnAlerts = document.getElementById("tabbtn_alerts");
      const tabcontentLive = document.getElementById("tabcontent_live");
      const tabcontentTools = document.getElementById("tabcontent_tools");
      const tabcontentAlerts = document.getElementById("tabcontent_alerts");

      if (tabbtnLive) tabbtnLive.classList.toggle("active", tab === "live");
      if (tabbtnTools) tabbtnTools.classList.toggle("active", tab === "tools");
      if (tabbtnAlerts) tabbtnAlerts.classList.toggle("active", tab === "alerts");
      
      if (tabcontentLive) tabcontentLive.classList.toggle("active", tab === "live");
      if (tabcontentTools) tabcontentTools.classList.toggle("active", tab === "tools");
      if (tabcontentAlerts) tabcontentAlerts.classList.toggle("active", tab === "alerts");

      if (liveChart) {
        liveChart.destroy();
        liveChart = null;
      }
      if (liveTimer) {
        clearInterval(liveTimer);
        liveTimer = null;
      }
      if (updateLogTimer) {
        clearInterval(updateLogTimer);
        updateLogTimer = null;
      }

      if (tab === "live") {
  if (tabcontentLive) {
    tabcontentLive.innerHTML = `
      <div>
        <canvas id="liveChart" style="width:100%;max-width:1000px;height:180px;display:block;margin:auto"></canvas>
      </div>
      <div id="live-values" style="padding:14px 0 0 0;margin:0;display:flex;flex-direction:column;align-items:center;gap:5px;"></div>
      <div style="display:flex;justify-content:center;gap:12px;margin-bottom:18px;">
        <button class="action" onclick="updateLiveStats(true)">${LANG === "ar" ? "تحديث الآن" : "Refresh Now"}</button>
      </div>
      <div id="netstatus-block" style="margin:9px 0 16px 0;text-align:center"></div>
      <div style="margin:30px 0 0 0">
        <h3 style="font-size:1.1em;margin-bottom:7px">
          ${LANG==="ar" ? "معلومات النظام والهاردوير" : "System & Hardware Info"}
        </h3>
        <div id="system-info-block" style="font-family:monospace;font-size:1em"></div>
      </div>
      <div style="margin-top:10px;color:#888;font-size:0.92em" id="live-chart-note"></div>
    `;
    liveStatsHistory = [];
    initLiveChart();
    liveTimer = setInterval(updateLiveStats, 60000);
    setTimeout(updateLiveStats, 120);
    setTimeout(updateSystemInfoBlock, 140);
    setTimeout(updateNetStatusBlock, 180);
  }
}

      else if(tab === "tools") {
        if (tabcontentTools) {
            tabcontentTools.innerHTML = `
            <div style="padding:24px;max-width:700px;margin:auto">
                <div style="margin-bottom:20px">
                <button class="action" onclick="copyDebugInfo()">
                    ${LANG === "ar" ? "نسخ بيانات التشخيص" : "Copy Debug Info"}
                </button>
                <span id="copy-debug-info-status" style="margin-left:12px;color:green"></span>
                </div>

                <div style="margin-bottom:20px">
                <button class="action" onclick="openUpdateModal()">
                  ${LANG === "ar" ? "تثبيت/تحديث المكونات" : "Update/Reinstall Components"}
                </button>
                <span id="reinstall-all-status" style="margin-left:12px;color:blue"></span>
                </div>

                <div style="margin-bottom:20px">
                  <h4 style="margin:8px 0 8px 0">${LANG === "ar" ? "إصدارات الخدمات" : "Client/Feeder Versions"}</h4>
                  <div id="feeder-versions-block" style="font-family:monospace"></div>
                  <button class="action" onclick="loadFeederVersions()" id="refresh-versions-btn">
                    ${LANG==="ar" ? "تحديث إصدارات الخدمات" : "Refresh Versions"}
                  </button>
                </div>

                <div style="margin-bottom:20px">
                  <h4 style="margin:8px 0 8px 0">${LANG==="ar"?"حالة النظام والخدمات":"System/Service Status"}</h4>
                  <div id="status-block" style="font-family:monospace"></div>
                  <button class="action" onclick="loadStatusBlock()">${LANG==="ar"?"تحديث الحالة":"Refresh Status"}</button>
                </div>
            </div>
            `;
            setTimeout(()=>{
              loadFeederVersions();
              loadStatusBlock();
            },200);
        }
      }
      else if(tab === "alerts") {
        if (tabcontentAlerts) {
            tabcontentAlerts.innerHTML = `
            <div style="padding:24px;">
                <h3>${LANG === "ar" ? "تنبيهات وتشخيص" : "Alerts & Diagnostics"}</h3>
                <div id="alerts-content"></div>
                <button class="action" onclick="loadAlerts()">${LANG === "ar" ? "تحديث" : "Refresh"}</button>
            </div>
            `;
            loadAlerts();
        }
      }
    }

    function initLiveChart() {
      const liveChartCanvas = document.getElementById('liveChart');
      if (!liveChartCanvas) {
        console.error("Canvas element 'liveChart' not found for chart initialization.");
        return;
      }
      const ctx = liveChartCanvas.getContext('2d');
      liveChart = new Chart(ctx, {
        type: 'line',
        data: {
          labels: [],
          datasets: [
            {
              label: LANG === "ar" ? "رسائل/ثانية" : "Messages/sec",
              data: [],
              borderWidth: 2,
              fill: false,
              borderColor: 'rgb(75, 192, 192)',
              tension: 0.1
            },
            {
              label: LANG === "ar" ? "عدد الطائرات" : "Aircraft",
              data: [],
              borderWidth: 2,
              fill: false,
              borderColor: 'rgb(255, 99, 132)',
              tension: 0.1
            },
            {
              label: LANG === "ar" ? "استهلاك البيانات (KB)" : "Data Usage (KB)",
              data: [],
              borderWidth: 2,
              fill: false,
              borderColor: 'rgb(54, 162, 235)',
              tension: 0.1
            },
          ]
        },
        options: {
          responsive: true,
          scales: {
            y: { beginAtZero: true },
            x: { title: { display: true, text: LANG === "ar" ? "الوقت" : "Time" } }
          }
        }
      });
    }

    function updateLiveStats(manual = false) {
      fetch('/api/stats/live', {
        headers: { 'X-Auth-Token': AUTH_TOKEN }
      }).then(res => res.json()).then(js => {
        const liveValuesEl = document.getElementById("live-values");
        if (js && js.ok) {
          const d = js.live;
          if (liveValuesEl) {
            liveValuesEl.innerHTML = `
      <div style="display:flex;flex-wrap:wrap;justify-content:center;align-items:center;gap:22px 14px;font-size:1.05em;margin:18px 0 0 0">
        <div>${LANG === "ar" ? "عدد الرسائل/ثانية" : "Messages/sec"}: <b>${d.messages_per_sec ?? "-"}</b></div>
        <div>${LANG === "ar" ? "عدد الطائرات الآن" : "Aircraft now"}: <b>${d.aircraft_now ?? "-"}</b></div>
        <div>${LANG === "ar" ? "طائرات مع موقع" : "Aircraft with pos"}: <b>${d.aircraft_with_pos ?? "-"}</b></div>
        <div>${LANG === "ar" ? "طائرات بدون موقع" : "Aircraft w/o pos"}: <b>${d.aircraft_without_pos ?? "-"}</b></div>
        <div>${LANG === "ar" ? "أقصى نطاق (كم)" : "Max range (km)"}: <b>${d.max_range_km ?? "-"}</b></div>
        <div>${LANG === "ar" ? "متوسط الإشارة (dB)" : "Avg signal (dB)"}: <b>${d.signal_avg_db ?? "-"}</b></div>
        <div>${LANG === "ar" ? "الإنترفيس الشبكي" : "Network Interface"}: <b>${d.network_iface || "-"}</b></div>
        <div>${LANG === "ar" ? "البيانات المستقبلة خلال 10 ثواني (KB)" : "Data Received/10s (KB)"}: <b>${d.data_usage_rx_kb ?? "-"}</b></div>
        <div>${LANG === "ar" ? "البيانات المرسلة خلال 10 ثواني (KB)" : "Data Sent/10s (KB)"}: <b>${d.data_usage_tx_kb ?? "-"}</b></div>
        <div>${LANG === "ar" ? "إجمالي المستلم (MB)" : "Total Received (MB)"}: <b>${(d.rx_total/1024/1024).toFixed(2)}</b></div>
        <div>${LANG === "ar" ? "إجمالي المرسل (MB)" : "Total Sent (MB)"}: <b>${(d.tx_total/1024/1024).toFixed(2)}</b></div>
      </div>
    `;
          }
          const timeLabel = new Date().toLocaleTimeString().slice(0, 8);
          liveStatsHistory.push({
            time: timeLabel,
            messages: d.messages_per_sec,
            aircraft: d.aircraft_now,
            data_kb: (Number(d.data_usage_rx_kb) || 0) + (Number(d.data_usage_tx_kb) || 0),
          });
          if (liveStatsHistory.length > 50) liveStatsHistory.shift();

          if (liveChart) {
            liveChart.data.labels = liveStatsHistory.map(x => x.time);
            liveChart.data.datasets[0].data = liveStatsHistory.map(x => x.messages);
            liveChart.data.datasets[1].data = liveStatsHistory.map(x => x.aircraft);
            liveChart.data.datasets[2].data = liveStatsHistory.map(x => x.data_kb);
            liveChart.update();
          }

          const liveChartNote = document.getElementById("live-chart-note");
          if (liveChartNote) {
            liveChartNote.innerText = manual ? "Data refreshed manually." : "";
          }
        } else {
          if (liveValuesEl) {
            liveValuesEl.innerHTML = `
              <div style="color:red;text-align:center;padding:20px;font-size:1.1em">
                ${LANG === "ar" ? "خطأ في جلب البيانات" : "Error:"} ${js.msg || "Unknown error"}
              </div>
            `;
          }
          if (liveChart) {
            liveChart.data.labels = [];
            liveChart.data.datasets.forEach(ds => ds.data = []);
            liveChart.update();
          }
        }
      }).catch(e => {
        const liveValuesEl = document.getElementById("live-values");
        if (liveValuesEl) {
          liveValuesEl.innerHTML = `
            <div style="color:red;text-align:center;padding:20px;font-size:1.1em">
              ${LANG === "ar" ? "خطأ في الاتصال بالشبكة." : "Network error."}
            </div>
          `;
        }
      });
    }

    // --- Set Gain Functions ---
    const GAIN_OPTIONS = [
        "auto", "58.0", "49.6", "48.0", "44.5", "43.4", "42.1", "40.2", "38.6", "37.2", "36.4",
        "33.8", "32.8", "29.7", "28.0", "25.4", "22.9", "20.7", "19.7", "16.6", "15.7",
        "14.4", "12.5", "8.7", "7.7", "3.7", "2.7", "1.4", "0.9", "0.0"
    ];

    function renderSetGain() {
      const mainContent = document.getElementById("main-content");
      if (!mainContent) return;

      mainContent.innerHTML = `
        <h2 style="color:#219150">${LANG === "ar" ? "ضبط الكسب" : "Set Gain"}</h2>
        <div class="result-block" style="color:#1a2940;font-size:1.04em;">
          <div><b>${LANG === "ar" ? "الكسب الحالي:" : "Current Gain:"}</b> <span id="current-gain-value">...</span></div>
        </div>
        
        <div id="simple-gain-section" style="margin-top:15px;">
            <label for="gain-select" class="label">${LANG === "ar" ? "اختر قيمة الكسب" : "Select Gain Value"}</label>
            <select id="gain-select" onchange="setGainFromDropdown()">
                ${GAIN_OPTIONS.map(option => `<option value="${option}">${option.includes("auto") ? option : option + "db"}</option>`).join('')}
            </select>
        </div>

        <div style="margin-top:20px;">
            <button class="action" id="toggle-gain-btn" onclick="toggleAdvancedGain()">${LANG === "ar" ? "ضبط الكسب المتقدم" : "Advanced Gain Settings"}</button>
        </div>

        <div id="advanced-gain-section" style="display:none; margin-top:20px;">
            <label for="advancedGainInput" class="label">${LANG === "ar" ? "أدخل قيمة الكسب المتقدمة" : "Enter Advanced Gain Value"}</label>
            <input id="advancedGainInput" type="text" placeholder="${txt[LANG].gain_value} (e.g. auto-verbose,12,-24,-6,35)" />
            <button class="action" onclick="setAdvancedGain()">${LANG === "ar" ? "تطبيق الكسب المتقدم" : "Apply Advanced Gain"}</button>
        </div>
        <div id="result-gain"></div>
      `;
      updateCurrentGainDisplay();
    }

    function toggleAdvancedGain() {
        const simpleSection = document.getElementById('simple-gain-section');
        const advancedSection = document.getElementById('advanced-gain-section');
        const toggleButton = document.getElementById('toggle-gain-btn');

        if (simpleSection.style.display === 'none') {
            simpleSection.style.display = 'block';
            advancedSection.style.display = 'none';
            if (toggleButton) {
                toggleButton.innerText = LANG === "ar" ? "ضبط الكسب المتقدم" : "Advanced Gain Settings";
            }
        } else {
            simpleSection.style.display = 'none';
            advancedSection.style.display = 'block';
            if (toggleButton) {
                toggleButton.innerText = LANG === "ar" ? "العودة لخيارات Gain العادية" : "Return to Normal Gain Options";
            }
        }
    }

    function setGainFromDropdown() {
        const gainSelect = document.getElementById('gain-select');
        if (gainSelect) {
            const selectedGain = gainSelect.value;
            setGain(selectedGain);
        }
    }

    function setAdvancedGain() {
        const advancedGainInput = document.getElementById('advancedGainInput');
        if (advancedGainInput) {
            const advancedGain = advancedGainInput.value;
            if (!advancedGain) {
                showCustomAlert(LANG === "ar" ? "قيمة الكسب المتقدمة مطلوبة" : "Advanced Gain value is required");
                return;
            }
            setGain(advancedGain);
        }
    }

    function setGain(gainValue) {
      callAPI('/api/service/readsb/set-gain', 'POST', {gain: gainValue}, 'result-gain').then(() => {
          updateCurrentGainDisplay();
      });
    }

    function updateCurrentGainDisplay() {
        const currentGainSpan = document.getElementById('current-gain-value');
        if (currentGainSpan) {
            currentGainSpan.innerText = LANG === "ar" ? "جاري التحميل..." : "Loading...";
            callAPI('/api/service/readsb/get-gain', 'GET', null, null, true).then((gainRes) => {
                if (gainRes && gainRes.gain) {
                    currentGainSpan.innerText = gainRes.gain;
                } else {
                    currentGainSpan.innerText = LANG === "ar" ? "غير محدد" : "Not set";
                }
            }).catch(() => {
                currentGainSpan.innerText = LANG === "ar" ? "خطأ في التحميل" : "Error loading";
            });
        }
    }

    // --- QOL Options Functions ---
    function renderGraphsColorscheme() {
      const mainContent = document.getElementById("main-content");
      if (!mainContent) return;
      let html = `
        <h2 style="color:#219150">${LANG === "ar" ? "وضع الرسوم البيانية" : "graphs1090 mode"}</h2>
        <div style="margin:20px 0;">${
          LANG === "ar"
            ? "اختر وضع العرض لصفحة الرسوم البيانية (graphs1090):"
            : "Which mode do you prefer for graphs1090 page/chart display?"
        }</div>
        <div style="display:flex;gap:20px;">
          <button class="action" onclick="setColorscheme('dark')">${LANG === "ar" ? "غامق" : "Dark"}</button>
          <button class="action" onclick="setColorscheme('default')">${LANG === "ar" ? "فاتح" : "Light"}</button>
        </div>
        <div id="result-graphs1090"></div>
      `;
      mainContent.innerHTML = html;
    }

    function setColorscheme(color) {
      callAPI('/api/service/graphs1090/colorscheme', 'POST', {color: color}, 'result-graphs1090');
    }

    function renderTarRoutes() {
      const mainContent = document.getElementById("main-content");
      if (!mainContent) return;
      let html = `
        <h2 style="color:#219150">${LANG === "ar" ? "مسارات الرحلات" : "Route Info"}</h2>
        <div style="margin:20px 0;">
          ${LANG === "ar" ? "تفعيل أو تعطيل معلومات مسار الرحلات في tar1090:" : "Enable or disable tar1090 route info:"}
        </div>
        <button class="action" onclick="toggleRouteInfo(true)">${LANG === "ar" ? "تفعيل" : "Enable"}</button>
        <button class="action" onclick="toggleRouteInfo(false)">${LANG === "ar" ? "تعطيل" : "Disable"}</button>
        <div id="result-tar1090"></div>
      `;
      mainContent.innerHTML = html;
    }
    function toggleRouteInfo(enable) {
      showCustomConfirm(LANG === "ar" ? "تفعيل معلومات المسار؟" : "Enable route info?", (confirmed) => {
        if (confirmed) {
          callAPI('/api/service/tar1090/route-info', 'POST', {enable: enable}, 'result-tar1090');
        }
      });
    }

    function renderTarHeatmaps() {
      const mainContent = document.getElementById("main-content");
      if (!mainContent) return;
      let html = `
        <h2 style="color:#219150">${LANG === "ar" ? "خرائط الحرارة" : "Heatmaps"}</h2>
        <div style="margin:20px 0;">
          ${LANG === "ar"
            ? "ميزة تجريبية: تفعيل أو تعطيل جمع بيانات خرائط الحرارة (heatmap) في readsb (قد تحتاج سكربت إضافي)."
            : "Experimental: Enable/disable readsb heatmap data (may need extra script support)."}
        </div>
        <div style="margin:16px 0;">
          <button class="action" onclick="enableHeatmap()">${LANG === "ar" ? "تفعيل" : "Enable"}</button>
          <button class="action" onclick="disableHeatmap()">${LANG === "ar" ? "تعطيل" : "Disable"}</button>
        </div>
    	<div id="result-heatmap"></div>
      `;
      mainContent.innerHTML = html;
    }
    function enableHeatmap() {
      callAPI('/api/service/readsb/heatmap', 'POST', {enable: true}, 'result-heatmap');
    }
    function disableHeatmap() {
      callAPI('/api/service/readsb/heatmap', 'POST', {enable: false}, 'result-heatmap');
    }

    // --- URLs Functions ---
    function renderURLs() {
      const mainContent = document.getElementById("main-content");
      if (!mainContent) return;
      mainContent.innerHTML = `<h2>Station URLs</h2>
        <div id="urls-list" style="margin-top:12px;">Loading...</div>`;
      fetch('/api/service/urls', {
        headers: { 'X-Auth-Token': AUTH_TOKEN }
      })
        .then(res => res.json())
        .then(js => {
          const urlsListEl = document.getElementById("urls-list");
          if (js && js.urls && js.urls.length > 0) {
            let html = js.urls.map(
              url => `<div style="margin-bottom:9px;">
                <b>${url.title}:</b><br>
                <a href="${url.url}" target="_blank">${url.url}</a>
              </div>`
            ).join('');
            if (urlsListEl) urlsListEl.innerHTML = html;
          } else {
            if (urlsListEl) urlsListEl.innerHTML = `<span style="color:#c00">No URLs found.</span>`;
          }
        }).catch(err => {
          const urlsListEl = document.getElementById("urls-list");
          if (urlsListEl) urlsListEl.innerHTML = `<span style="color:#c00">${err.message}</span>`;
        });
    }

    // --- Support Menu Functions ---
    function renderDebug() {
      const mainContent = document.getElementById("main-content");
      if (!mainContent) return;
      mainContent.innerHTML = `<h2>${LANG === "ar" ? "نتائج التصحيح" : "Debugging Output"}</h2>
        <div id="debug-block" style="font-family: monospace; white-space: pre-wrap; background: #f0f0f0; padding: 15px; border-radius: 8px; overflow-x: auto;">Loading...</div>`;
      callAPI('/api/service/wingbits/debug', 'GET', null, 'debug-block');
    }

    function renderAllLogs() {
      const mainContent = document.getElementById("main-content");
      if (!mainContent) return;
      mainContent.innerHTML = `<h2>${LANG === "ar" ? "جميع السجلات الحديثة" : "All Recent Logs"}</h2>
        <div id="result-alllogs">Loading...</div>`;
      callAPI('/api/service/wingbits/logs', 'GET', null, 'result-alllogs');
      callAPI('/api/service/readsb/logs', 'GET', null, 'result-alllogs');
    }

    function renderLastInstallLog() {
      const mainContent = document.getElementById("main-content");
      if (!mainContent) return;
      mainContent.innerHTML = `<h2>${LANG === "ar" ? "سجل التثبيت الأخير" : "Last Install Log"}</h2>
        <div id="result-installlog">Loading...</div>`;
      callAPI('/api/service/wingbits/last-install-log', 'GET', null, 'result-installlog');
    }

    // Confirm Wingbits Client update with logs panel
    function confirmUpdateClient() {
      showCustomConfirm(txt[LANG].confirm_update_client, async (confirmed) => {
        if (confirmed) {
          const mainContent = document.getElementById("main-content");
          if (!mainContent) return;

          mainContent.innerHTML = `
            <h2>${txt[LANG].update_client_progress}</h2>
            <div id="update-status-message" style="margin-bottom:15px;font-weight:bold;">${txt[LANG].update_started}</div>
            <div id="update-log-display" class="result-block" style="min-height:200px;">${txt[LANG].update_log_placeholder}</div>
            <button class="action" onclick="stopUpdatePolling()" style="margin-top:20px;" id="stop-update-btn">${LANG === 'ar' ? 'إيقاف عرض السجلات' : 'Stop Viewing Logs'}</button>
          `;
          document.getElementById('stop-update-btn').style.display = 'block';

          const response = await callAPI('/api/service/wingbits/update-client', 'POST', null, null, true);
          const statusMessageEl = document.getElementById('update-status-message');
          if (response && response.ok) {
            if (statusMessageEl) statusMessageEl.style.color = 'blue';
            startUpdatePolling();
          } else {
            if (statusMessageEl) {
              statusMessageEl.style.color = 'red';
              statusMessageEl.innerText = response.msg || txt[LANG].update_failed;
            }
            document.getElementById('stop-update-btn').style.display = 'block';
          }
        }
      });
    }

    function startUpdatePolling() {
      if (updateLogTimer) {
        clearInterval(updateLogTimer);
        updateLogTimer = null;
      }

      const logDisplayEl = document.getElementById('update-log-display');
      const statusMessageEl = document.getElementById('update-status-message');
      if (logDisplayEl) logDisplayEl.innerText = txt[LANG].fetching_logs;

      const fetchLogs = async () => {
        const response = await callAPI('/api/service/wingbits/update-logs', 'GET', null, null, true);
        if (response && response.ok) {
          if (logDisplayEl) {
            logDisplayEl.innerHTML = escapeHTML(response.logs);
            logDisplayEl.scrollTop = logDisplayEl.scrollHeight;
          }
          if (response.status === 'finished' || response.status === 'not_started') {
            stopUpdatePolling();
            if (statusMessageEl) {
                if (response.logs.includes("error") || response.logs.includes("failed") || response.logs.includes("Error:") || response.logs.includes("Failed")) { 
                    statusMessageEl.style.color = 'red';
                    statusMessageEl.innerText = txt[LANG].update_failed;
                } else {
                    statusMessageEl.style.color = 'green';
                    statusMessageEl.innerText = txt[LANG].update_finished;
                }
            }
          } else {
            if (statusMessageEl) {
              statusMessageEl.style.color = 'blue';
              statusMessageEl.innerText = txt[LANG].update_started;
            }
          }
        } else {
          stopUpdatePolling();
          if (statusMessageEl) {
            statusMessageEl.style.color = 'red';
            statusMessageEl.innerText = response.msg || txt[LANG].update_failed;
          }
        }
      };

      fetchLogs();
      updateLogTimer = setInterval(fetchLogs, 3000);
    }

    function stopUpdatePolling() {
      if (updateLogTimer) {
        clearInterval(updateLogTimer);
        updateLogTimer = null;
      }
      const stopBtn = document.getElementById('stop-update-btn');
      if (stopBtn) stopBtn.style.display = 'none';
    }

    // Modal to update/reinstall specific components
    function openUpdateModal() {
      let old = document.getElementById('update-modal');
      if (old) old.remove();

      const modal = document.createElement('div');
      modal.id = 'update-modal';
      modal.style = "display:flex;position:fixed;left:0;top:0;width:100vw;height:100vh;z-index:3000;background:rgba(0,0,0,0.33);justify-content:center;align-items:center;";
      modal.innerHTML = `
        <div style="background:#fff;max-width:370px;width:95vw;padding:26px 20px 20px 20px;border-radius:12px;box-shadow:0 3px 18px #0003;position:relative">
          <h3 style="margin-bottom:16px;text-align:${LANG==='ar'?'right':'left'}">${LANG==="ar"?"تحديث أو إعادة تثبيت المكونات":"Update/Reinstall Components"}</h3>
          <div>
            <div style="display:flex;align-items:center;gap:8px;margin-bottom:12px;direction:ltr;">
              <input type="checkbox" id="comp_wingbits" checked style="width:18px;height:18px;">
              <label for="comp_wingbits" style="font-size:1.12em;min-width:110px;cursor:pointer">${LANG==="ar"?"عميل Wingbits":"Wingbits Client"}</label>
            </div>
            <div style="display:flex;align-items:center;gap:8px;margin-bottom:12px;direction:ltr;">
              <input type="checkbox" id="comp_readsb" checked style="width:18px;height:18px;">
              <label for="comp_readsb" style="font-size:1.12em;min-width:110px;cursor:pointer">readsb</label>
            </div>
            <div style="display:flex;align-items:center;gap:8px;margin-bottom:12px;direction:ltr;">
              <input type="checkbox" id="comp_tar1090" checked style="width:18px;height:18px;">
              <label for="comp_tar1090" style="font-size:1.12em;min-width:110px;cursor:pointer">tar1090</label>
            </div>
            <div style="display:flex;align-items:center;gap:8px;margin-bottom:8px;direction:ltr;">
              <input type="checkbox" id="comp_panel" style="width:18px;height:18px;">
              <label for="comp_panel" style="font-size:1.12em;min-width:110px;cursor:pointer">${LANG==="ar"?"لوحة التحكم":"Web Panel"}</label>
            </div>
            <div style="display:flex;align-items:center;gap:8px;margin-bottom:8px;direction:ltr;">
              <input type="checkbox" id="comp_deps" style="width:18px;height:18px;">
              <label for="comp_deps" style="font-size:1.12em;min-width:110px;cursor:pointer">${LANG==="ar"?"الاعتماديات (python, rtl-sdr)":"Dependencies (python, rtl-sdr)"}</label>
            </div>
          </div>
          <div id="update-modal-status" style="margin:14px 0 8px 0; color:#1560db;"></div>
          <div style="text-align:right;margin-top:12px">
            <button onclick="doUpdateReinstall()" style="padding:6px 18px">${LANG==="ar"?"تأكيد":"Confirm"}</button>
            <button onclick="closeUpdateModal()" style="padding:6px 18px">${LANG==="ar"?"إغلاق":"Close"}</button>
          </div>
        </div>
      `;
      document.body.appendChild(modal);
    }

    function closeUpdateModal() {
      let modal = document.getElementById('update-modal');
      if (modal) modal.remove();
    }

    function doUpdateReinstall() {
      const comps = [];
      if(document.getElementById("comp_wingbits").checked) comps.push("wingbits");
      if(document.getElementById("comp_readsb").checked) comps.push("readsb");
      if(document.getElementById("comp_tar1090").checked) comps.push("tar1090");
      if(document.getElementById("comp_panel").checked) comps.push("panel");
      if(document.getElementById("comp_deps").checked) comps.push("deps");

      if(comps.length === 0) {
        document.getElementById("update-modal-status").style.color = "red";
        document.getElementById("update-modal-status").innerText = LANG==="ar"?"اختر مكون واحد على الأقل!":"Please select at least one component!";
        return;
      }
      document.getElementById("update-modal-status").style.color = "#1560db";
      document.getElementById("update-modal-status").innerText = LANG==="ar"?"جاري التنفيذ...":"Running, please wait...";
      fetch('/api/update/reinstall', {
        method: "POST",
        headers: {
            'Content-Type': 'application/json',
            'X-Auth-Token': AUTH_TOKEN
        },
        body: JSON.stringify({components: comps})
      }).then(res=>res.json()).then(js=>{
        if(js.ok) {
          document.getElementById("update-modal-status").style.color = "green";
          document.getElementById("update-modal-status").innerText = (js.msg || (LANG==="ar"?"تم التنفيذ!":"Done!")) + "\n" + (js.detail||"");
        } else {
          document.getElementById("update-modal-status").style.color = "red";
          document.getElementById("update-modal-status").innerText = (js.msg||"Unknown error");
        }
      }).catch(()=>{
        document.getElementById("update-modal-status").style.color = "red";
        document.getElementById("update-modal-status").innerText = LANG==="ar"?"خطأ في الاتصال!":"Network error!";
      });
    }

    // Versions
    function loadFeederVersions() {
      const block = document.getElementById("feeder-versions-block");
      if (!block) return;
      block.innerHTML = (LANG === "ar" ? "جاري التحميل..." : "Loading...");
      fetch('/api/feeder/versions', {
        headers: { 'X-Auth-Token': AUTH_TOKEN }
      }).then(res => res.json()).then(js => {
        if (js && js.ok && js.versions) {
          const v = js.versions;
          block.innerHTML = `
            <div style="font-size:1em">
              <b>Wingbits:</b> ${v.wingbits || '-'}<br>
              <b>readsb:</b> ${v.readsb || '-'}<br>
              <b>tar1090:</b> ${v.tar1090 || '-'}<br>
              <b>${LANG === "ar" ? "لوحة التحكم" : "Web Panel"}:</b> ${v.panel || '-'}<br>
            </div>
            <div style="color:#666;font-size:0.92em;margin-top:4px">
              ${LANG === "ar" ? "آخر تحديث:" : "Checked at:"} ${js.checked_at || "-"}
            </div>
          `;
        } else {
          block.innerHTML = `<span style="color:red">${(js && js.msg) ? js.msg : (LANG === "ar" ? "تعذر جلب الإصدارات" : "Failed to load versions")}</span>`;
        }
      }).catch(() => {
        block.innerHTML = `<span style="color:red">${LANG === "ar" ? "خطأ في الشبكة!" : "Network error!"}</span>`;
      });
    }

    // System/service status snapshot
    function loadStatusBlock() {
      const block = document.getElementById("status-block");
      if (!block) return;
      block.innerHTML = (LANG === "ar" ? "جاري الفحص..." : "Checking...");
      fetch('/api/status/check', {
        headers: { 'X-Auth-Token': AUTH_TOKEN }
      }).then(res=>res.json()).then(js=>{
        if(js && js.ok && js.status) {
          const s = js.status;
          let html = `
            <div style="display:grid;grid-template-columns:1fr 1fr;gap:8px 22px;font-size:1em;margin-bottom:12px">
              <div>${LANG==="ar"?"الإنترنت":"Internet"}</div>
              <div>${s.internet?'<span style="color:green">&#10004;</span>':'<span style="color:red">&#10008;</span>'}</div>
              <div>Wingbits</div>
              <div>${s.wingbits?'<span style="color:green">&#10004;</span>':'<span style="color:red">&#10008;</span>'}</div>
              <div>readsb</div>
              <div>${s.readsb?'<span style="color:green">&#10004;</span>':'<span style="color:red">&#10008;</span>'}</div>
              <div>tar1090</div>
              <div>${s.tar1090?'<span style="color:green">&#10004;</span>':'<span style="color:red">&#10008;</span>'}</div>
            </div>
          `;

          if(s.wb_details) {
            let lines = s.wb_details.split('\n')
              .filter(line => line.trim() && !/^Wingbits version/i.test(line));
            html += `<div style="background:#f7f7fa;padding:10px 16px;border-radius:7px;border:1px solid #eee;font-size:1em">`;
            lines.forEach(line => {
              let color = line.includes("OK") || line.includes("✓") ? "green"
                : (line.includes("fail") || line.includes("not") || line.includes("Error") || line.includes("✗")) ? "red" : "#333";
              html += `<div style="color:${color}">${line.replace("✓", "&#10004;").replace("✗", "&#10008;")}</div>`;
            });
            html += `</div>`;
          }
          block.innerHTML = html;
        } else {
          block.innerHTML = `<div style="color:red">${LANG === "ar" ? "فشل جلب الحالة" : "Failed to fetch status"}</div>`;
        }
      }).catch(()=>{
        block.innerHTML = `<span style="color:red">${LANG === "ar" ? "خطأ في الاتصال" : "Network error"}</span>`;
      });
    }

    function loadAlerts() {
      const block = document.getElementById("alerts-content");
      if (!block) return;
      block.innerHTML = `<div style="padding:32px;text-align:center;color:#888;font-size:1.1em">${LANG==="ar"?"جاري البحث عن تنبيهات...":"Checking for alerts..."}</div>`;
      fetch('/api/alerts', {
        headers: { 'X-Auth-Token': AUTH_TOKEN }
      }).then(res=>res.json()).then(js=>{
        if(js && js.ok) {
          if(js.alerts && js.alerts.length) {
            block.innerHTML = js.alerts.map(a=>`
              <div style="background:#fff3f3;border:1px solid #e7b1b1;color:#c70a0a;border-radius:7px;margin-bottom:12px;padding:12px 17px;font-size:1.1em;">
                <span style="font-family:monospace">${a}</span>
              </div>
            `).join('');
          } else {
            block.innerHTML = `<div style="padding:28px;text-align:center;color:green;font-size:1.13em">${LANG==="ar"?"لا توجد أخطاء أو تحذيرات نشطة":"No active alerts."}</div>`;
          }
        } else {
          block.innerHTML = `<div style="padding:20px;color:red">${LANG==="ar"?"فشل تحميل التنبيهات":"Failed to load alerts."}</div>`;
        }
      }).catch(()=>{
        block.innerHTML = `<div style="padding:20px;color:red">${LANG==="ar"?"خطأ بالشبكة":"Network error."}</div>`;
      });
    }

    // System info block on dashboard
    function updateSystemInfoBlock() {
      fetch('/api/system/info', {
        headers: { 'X-Auth-Token': AUTH_TOKEN }
      }).then(res=>res.json()).then(js=>{
        const systemInfoBlockEl = document.getElementById("system-info-block");
        if (js && js.ok) {
          const d = js.info;
          if (systemInfoBlockEl) {
            systemInfoBlockEl.innerHTML = `
          <div style="display:grid;grid-template-columns:1fr 1fr;gap:0.3em 1.7em">
            <div>${LANG==="ar" ? "اسم المضيف" : "Hostname"}</div><div><b>${d.hostname}</b></div>
            <div>${LANG==="ar" ? "النظام" : "OS"}</div><div><b>${d.os}</b></div>
            <div>${LANG==="ar" ? "المعالج" : "CPU"}</div><div><b>${d.cpu}</b></div>
            <div>${LANG==="ar" ? "عدد الأنوية" : "Cores"}</div><div><b>${d.cores}</b></div>
            <div>${LANG==="ar" ? "المعمارية" : "Arch"}</div><div><b>${d.arch}</b></div>
            <div>${LANG==="ar" ? "متوسط التحميل" : "Load Avg"}</div><div><b>${d.load_avg ? d.load_avg.map(x=>x.toFixed(2)).join(' / ') : "-"}</b></div>
            <div>${LANG==="ar" ? "الرام الكلي (MB)" : "Total RAM (MB)"}</div><div><b>${d.ram_total_mb}</b></div>
            <div>${LANG==="ar" ? "الرام المتاح (MB)" : "Free RAM (MB)"}</div><div><b>${d.ram_free_mb}</b></div>
            <div>${LANG==="ar" ? "الهارد الكلي (GB)" : "Disk total (GB)"}</div><div><b>${d.disk_total_gb}</b></div>
            <div>${LANG==="ar" ? "الهارد المتاح (GB)" : "Disk free (GB)"}</div><div><b>${d.disk_free_gb}</b></div>
            <div>${LANG==="ar" ? "مدة التشغيل (ساعة)" : "Uptime (hours)"}</div><div><b>${d.uptime_hr}</b></div>
            <div>${LANG==="ar" ? "درجة حرارة المعالج" : "CPU Temp (°C)"}</div><div><b>${d.cpu_temp ?? "-"}</b></div>
            <div>${LANG==="ar" ? "حالة SDR" : "SDR Dongle"}</div>
            <div><b>${
              d.sdr_status === "connected"
              ? (LANG === "ar" ? "متصل" : "Connected")
              : (LANG === "ar" ? "غير متصل" : "Not Connected")
            }</b></div>
          </div>
          `;
          }
        } else {
          if (systemInfoBlockEl) {
            systemInfoBlockEl.innerHTML = `<div style="color:red">Error: ${js.msg || "unknown error"}</div>`;
          }
        }
      });
    }

    function updateNetStatusBlock() {
      fetch('/api/netstatus', {
        headers: { 'X-Auth-Token': AUTH_TOKEN }
      }).then(res=>res.json()).then(js=>{
        const netstatusBlockEl = document.getElementById("netstatus-block");
        if(js && js.ok) {
          const d = js.net;
          let txtConn = (LANG==="ar" ? 
            (d.online ? "متصل بالإنترنت" : "غير متصل بالإنترنت") :
            (d.online ? "Internet: Connected" : "Internet: Not connected"));
          let txtSrv = (LANG==="ar" ?
            (d.server_ok ? "متصل بسيرفر Wingbits" : "تعذر الاتصال بسيرفر Wingbits") :
            (d.server_ok ? "Wingbits server: Connected" : "Wingbits server: Not reachable"));
          let txtLast = d.last_sync ?
            ((LANG==="ar" ? "آخر مزامنة:" : "Last Sync:") + " <b>" + d.last_sync + "</b>") : "";

          if (netstatusBlockEl) {
            netstatusBlockEl.innerHTML = `
            <div style="color:${d.online ? "#197b1f":"#b80c09"};font-weight:bold;margin-bottom:2px">${txtConn}</div>
            <div style="color:${d.server_ok ? "#1355c2":"#bb0d27"};font-weight:bold;margin-bottom:2px">${txtSrv}</div>
            <div style="color:#5c5c5c;font-size:0.98em">${txtLast}</div>
            `;
          }
        } else {
          if (netstatusBlockEl) {
            netstatusBlockEl.innerHTML = `<span style="color:red">${LANG==="ar"?"خطأ":"Error"}</span>`;
          }
        }
      }).catch(()=>{
        const netstatusBlockEl = document.getElementById("netstatus-block");
        if (netstatusBlockEl) {
          netstatusBlockEl.innerHTML = `<span style="color:red">${LANG==="ar"?"خطأ بالشبكة":"Network Error"}</span>`;
        }
      });
    }

    function copyDebugInfo() {
      const statusEl = document.getElementById("copy-debug-info-status");
      if (!statusEl) return;
      statusEl.style.color = "black";
      statusEl.innerText = LANG === "ar" ? "جاري التجميع..." : "Gathering info...";
      fetch('/api/debug/info', {
        headers: { 'X-Auth-Token': AUTH_TOKEN }
      }).then(res => {
        if (!res.ok) throw new Error("Network response was not ok");
        return res.json();
      }).then(js => {
        if(js && js.ok && js.info) {
          const d = js.info;
          let infoText =
`Station Debug Info
----------------------------------------
ID: ${d.station_id || "-"}
Host: ${d.hostname || "-"}
IP: ${d.ip || "-"}
Location: ${d.lat || "-"},${d.lon || "-"}
Wingbits: ${d.wingbits_ver || "-"}
readsb: ${d.readsb_ver || "-"}
tar1090: ${d.tar1090_ver || "-"}
Recent Logs:
${d.logs || "-"}
`;
          if (navigator.clipboard && navigator.clipboard.writeText) {
            navigator.clipboard.writeText(infoText).then(() => {
              statusEl.style.color = "green";
              statusEl.innerText = LANG === "ar" ? "تم نسخ بيانات التشخيص!" : "Debug info copied!";
              setTimeout(() => statusEl.innerText = "", 3000);
            }).catch(err => {
              statusEl.style.color = "red";
              statusEl.innerText = (LANG === "ar" ? "فشل النسخ: " : "Copy failed: ") + err;
            });
          } else {
            let textarea = document.createElement('textarea');
            textarea.value = infoText;
            document.body.appendChild(textarea);
            textarea.select();
            try {
              document.execCommand('copy');
              statusEl.style.color = "green";
              statusEl.innerText = LANG === "ar" ? "تم النسخ يدويًا!" : "Copied manually!";
            } catch (e) {
              statusEl.style.color = "red";
              statusEl.innerText = LANG === "ar" ? "فشل النسخ اليدوي!" : "Manual copy failed!";
            }
            document.body.removeChild(textarea);
          }
        } else {
          statusEl.style.color = "red";
          statusEl.innerText = (js && js.msg) ? js.msg : (LANG === "ar" ? "خطأ غير معروف!" : "Unknown error!");
        }
      }).catch(err => {
        statusEl.style.color = "red";
        statusEl.innerText = (LANG === "ar" ? "Network error: " : "Network error: ") + err;
      });
    }

    // --- Restart / Shutdown Functions ---
    function renderPower() {
      const mainContent = document.getElementById("main-content");
      if (!mainContent) return;
      let html = `
        <h2>${LANG === "ar" ? "إعادة تشغيل الخدمات / الجهاز" : "Restart / Shutdown"}</h2>
        <div class="result-block" style="margin-bottom:18px;">
          <b>wingbits restart</b><br>
          Restart the wingbits service<br>
          <button class="action" onclick="callAPI('/api/service/wingbits/restart','POST',null,'result-wingbits-restart')">${LANG === "ar" ? "إعادة تشغيل" : "Restart"}</button>
          <div id="result-wingbits-restart"></div>
          <hr/>
          <b>readsb restart</b><br>
          Restart the readsb service<br>
          <button class="action" onclick="callAPI('/api/service/readsb/restart','POST',null,'result-readsb-restart')">${LANG === "ar" ? "إعادة تشغيل" : "Restart"}</button>
          <div id="result-readsb-restart"></div>
          <hr/>
          <b>tar1090 restart</b><br>
          Restart tar1090 service<br>
          <button class="action" onclick="callAPI('/api/service/tar1090/restart','POST',null,'result-tar1090-restart')">${LANG === "ar" ? "إعادة تشغيل" : "Restart"}</button>
          <div id="result-tar1090-restart"></div>
          <hr/>
          <b>Device restart</b><br>
          Restart the Wingbits Station<br>
          <button class="action" style="background:#d35400" onclick="confirmReboot()">${LANG === "ar" ? "إعادة تشغيل الجهاز" : "Restart Device"}</button>
          <div id="result-pi-reboot"></div>
          <hr/>
          <b>SHUTDOWN device</b><br>
          Shutdown the Wingbits Station<br>
          <button class="action" style="background:#e74c3c" onclick="confirmShutdown()">${LANG === "ar" ? "إيقاف التشغيل" : "Shutdown Device"}</button>
          <div id="result-pi-shutdown"></div>
        </div>
      `;
      mainContent.innerHTML = html;
    }

    function confirmReboot() {
      showCustomConfirm(LANG === "ar" ? "سيتم إعادة تشغيل الجهاز!" : "Device will reboot!", (confirmed) => {
        if (confirmed) {
          callAPI('/api/system/reboot', 'POST', null, 'result-pi-reboot');
        }
      });
    }
    function confirmShutdown() {
      showCustomConfirm(LANG === "ar" ? "سيتم إيقاف تشغيل الجهاز!" : "Device will shutdown!", (confirmed) => {
        if (confirmed) {
          callAPI('/api/system/shutdown', 'POST', null, 'result-pi-shutdown');
        }
      });
    }

    // --- Diagnostics Page Functions ---
    function renderDiagnosticsPage() {
        const mainContent = document.getElementById("main-content");
        if (!mainContent) return;
        mainContent.innerHTML = `
            <h2>${txt[LANG].diagnostics_title}</h2>
            
            <div class="diagnostics-section">
                <h3>${txt[LANG].generate_log_url_title}</h3>
                <p>${txt[LANG].generate_log_url_desc}</p>
                <button class="action" onclick="generateLogLink('wingbits_readsb', 'log-link-result-1')">${txt[LANG].generate_wingbits_readsb_link}</button>
                <div id="log-link-result-1"></div>
                <button class="action" onclick="generateLogLink('all', 'log-link-result-2')">${txt[LANG].generate_all_logs_link}</button>
                <div id="log-link-result-2"></div>
            </div>

            <div class="diagnostics-section">
                <h3>${txt[LANG].handy_commands_title}</h3>
                <div class="diag-command-item">
                    <button class="action" onclick="runDiagnosticCommand('os_release', 'diag-result-os')">${txt[LANG].view_os_release}</button>
                    <div id="diag-result-os"></div>
                </div>
                <div class="diag-command-item">
                    <button class="action" onclick="runDiagnosticCommand('lsusb', 'diag-result-lsusb')">${txt[LANG].view_usb_devices}</button>
                    <div id="diag-result-lsusb"></div>
                </div>
                <div class="diag-command-item">
                    <button class="action" onclick="runDiagnosticCommand('throttled', 'diag-result-throttled')">${txt[LANG].check_voltage} (Pi only)</button>
                    <div id="diag-result-throttled"></div>
                </div>
                <div class="diag-command-item">
                    <button class="action" onclick="runDiagnosticCommand('wingbits_status_verbose', 'diag-result-wb-status')">${txt[LANG].view_wingbits_status_verbose}</button>
                    <div id="diag-result-wb-status"></div>
                </div>
                <div class="diag-command-item">
                    <button class="action" onclick="runDiagnosticCommand('geosigner_info', 'diag-result-geo')">${txt[LANG].view_geosigner_info}</button>
                    <div id="diag-result-geo"></div>
                </div>
            </div>
        `;
    }

    function generateLogLink(logType, resultId) {
        const resultElement = document.getElementById(resultId);
        if (resultElement) {
            resultElement.innerHTML = `<div class="log-link-result" style="color:#888; padding: 10px;">${txt[LANG].please_wait}</div>`;
        }
        callAPI('/api/diagnostics/generate-log-link', 'POST', { type: logType }, null, true)
            .then(data => {
                if (resultElement) {
                    if (data && data.ok && data.result.startsWith('http')) {
                        const uniqueInputId = `log-url-${resultId}`;
                        resultElement.innerHTML = `
                            <div style="display: flex; align-items: center; gap: 10px; margin-top: 10px;">
                                <input type="text" id="${uniqueInputId}" value="${escapeHTML(data.result)}" readonly style="flex-grow: 1; background-color: #e9f5ff; border: 1px solid #b3d7ff; color: #333;">
                                <button class="action" onclick="copyToClipboard('${uniqueInputId}', this)" style="width: auto; padding: 10px 15px; margin-top: 0;">${txt[LANG].copy_link}</button>
                            </div>
                        `;
                    } else {
                        resultElement.innerHTML = `<div class="log-link-result" style="color:red;">Error: ${data.msg || data.result || 'Failed to generate link.'}</div>`;
                    }
                }
            });
    }
    
    function copyToClipboard(elementId, buttonElement) {
        const input = document.getElementById(elementId);
        if (input) {
            input.select();
            input.setSelectionRange(0, 99999); // For mobile devices
            try {
                if (navigator.clipboard && navigator.clipboard.writeText) {
                    navigator.clipboard.writeText(input.value);
                } else {
                    document.execCommand('copy');
                }
                
                if(buttonElement) {
                    const oldText = buttonElement.innerText;
                    buttonElement.innerText = txt[LANG].copied;
                    buttonElement.disabled = true;
                    setTimeout(() => { 
                        buttonElement.innerText = oldText; 
                        buttonElement.disabled = false;
                    }, 2000);
                }
            } catch (err) {
                showCustomAlert('Failed to copy: ' + err);
            }
        }
    }

    function runDiagnosticCommand(commandKey, resultId) {
        callAPI('/api/diagnostics/run-command', 'POST', { command: commandKey }, resultId);
    }

    // --- Help / About Page ---
    function renderHelp() {
      const mainContent = document.getElementById("main-content");
      if (!mainContent) return;
      let html = `<h2>${txt[LANG].about}</h2>
        <div style="margin:10px 0;">
          <b>Wingbits Station Web Config</b><br/>
          ${LANG === "ar" ? "لوحة تحكم مبنية باستخدام بايثون وHTML لسهولة إدارة محطة التتبع." : "A simple Python+HTML dashboard for easy station management."}
          <br/><br/>
          </div>
        <div style="margin:14px 0 0 0;font-size:0.98em;color:#888;">by Said Albalushi</div>
        <div id="result-block"></div>
      `;
      mainContent.innerHTML = html;
    }

    // --- Authentication Pages and Functions ---
    function renderLoginPage() {
      if (liveChart) {
        liveChart.destroy();
        liveChart = null;
      }
      if (liveTimer) {
        clearInterval(liveTimer);
        liveTimer = null;
      }
      if (updateLogTimer) {
        clearInterval(updateLogTimer);
        updateLogTimer = null;
      }

      const container = document.getElementById("container");
      if (!container) {
        console.error("Container element not found for login page.");
        return;
      }
      container.innerHTML = `
        <div class="login-container" id="login-container">
          <div class="login-box">
            <h2>${txt[LANG].login}</h2>
            <input type="text" id="username" placeholder="${txt[LANG].username}" />
            <input type="password" id="password" placeholder="${txt[LANG].password}" />
            <button class="action" onclick="loginUser()">${txt[LANG].login}</button>
            <div id="login-message" class="login-message"></div>
          </div>
        </div>
      `;
      document.body.classList.remove('rtl');
      document.body.dir = 'ltr';

      const passwordInput = document.getElementById('password');
      if (passwordInput) {
        passwordInput.addEventListener('keydown', function(event) {
          if (event.key === 'Enter' || event.keyCode === 13) {
            event.preventDefault();
            loginUser();
          }
        });
      }
    }

    async function loginUser() {
      const usernameInput = document.getElementById('username');
      const passwordInput = document.getElementById('password');
      const loginMessage = document.getElementById('login-message');

      if (!usernameInput || !passwordInput || !loginMessage) {
        console.error("Login page elements not found.");
        return;
      }

      const username = usernameInput.value;
      const password = passwordInput.value;
      loginMessage.innerText = txt[LANG].please_wait;
      loginMessage.style.color = '#888';

      try {
        const response = await fetch('/api/login', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ username, password })
        });
        const data = await response.json();

        if (data.ok) {
          AUTH_TOKEN = data.token;
          localStorage.setItem('auth_token', AUTH_TOKEN);
          loginMessage.innerText = '';
          checkAuthAndRender();
        } else {
          loginMessage.style.color = 'red';
          loginMessage.innerText = data.msg || txt[LANG].login_failed;
        }
      } catch (error) {
        loginMessage.style.color = 'red';
        loginMessage.innerText = 'Network error during login.';
        console.error('Login error:', error);
      }
    }

    async function logoutUser() {
      showCustomConfirm(LANG === "ar" ? "هل أنت متأكد من تسجيل الخروج؟" : "Are you sure you want to log out?", async (confirmed) => {
        if (confirmed) {
          try {
            const response = await fetch('/api/logout', {
              method: 'POST',
              headers: { 'X-Auth-Token': AUTH_TOKEN }
            });
            const data = await response.json();

            if (data.ok) {
              AUTH_TOKEN = null;
              localStorage.removeItem('auth_token');
              if (liveChart) {
                liveChart.destroy();
                liveChart = null;
              }
              if (liveTimer) {
                clearInterval(liveTimer);
                liveTimer = null;
              }
              if (updateLogTimer) {
                clearInterval(updateLogTimer);
                updateLogTimer = null;
              }
              checkAuthAndRender();
            } else {
              showCustomAlert(data.msg || "Logout failed.");
            }
          } catch (error) {
            showCustomAlert("Network error during logout.");
            console.error('Logout error:', error);
          }
        }
      });
    }

    function renderChangePasswordPage() {
      const mainContent = document.getElementById("main-content");
      if (!mainContent) return;
      mainContent.innerHTML = `
        <h2>${txt[LANG].change_password}</h2>
        <div class="form-group">
          <label for="old_password">${txt[LANG].old_password}</label>
          <input type="password" id="old_password" />
        </div>
        <div class="form-group">
          <label for="new_password">${txt[LANG].new_password}</label>
          <input type="password" id="new_password" />
        </div>
        <div class="form-group">
          <label for="confirm_new_password">${txt[LANG].confirm_new_password}</label>
          <input type="password" id="confirm_new_password" />
        </div>
        <button class="action" onclick="changePassword()">${txt[LANG].update_password}</button>
        <div id="password-change-message" class="login-message"></div>
      `;
    }

    async function changePassword() {
      const oldPasswordInput = document.getElementById('old_password');
      const newPasswordInput = document.getElementById('new_password');
      const confirmNewPasswordInput = document.getElementById('confirm_new_password');
      const messageDiv = document.getElementById('password-change-message');

      if (!oldPasswordInput || !newPasswordInput || !confirmNewPasswordInput || !messageDiv) {
        console.error("Password change page elements not found.");
        return;
      }

      const oldPassword = oldPasswordInput.value;
      const newPassword = newPasswordInput.value;
      const confirmNewPassword = confirmNewPasswordInput.value;

      if (newPassword !== confirmNewPassword) {
        messageDiv.style.color = 'red';
        messageDiv.innerText = txt[LANG].password_mismatch;
        return;
      }
      if (newPassword.length < 6) {
        messageDiv.style.color = 'red';
        messageDiv.innerText = txt[LANG].password_too_short;
        return;
      }

      messageDiv.innerText = txt[LANG].please_wait;
      messageDiv.style.color = '#888';

      try {
        const response = await fetch('/api/change_password', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'X-Auth-Token': AUTH_TOKEN
          },
          body: JSON.stringify({ old_password: oldPassword, new_password: newPassword })
        });
        const data = await response.json();

        if (data.ok) {
          messageDiv.style.color = 'green';
          messageDiv.innerText = txt[LANG].password_changed_success;
          AUTH_TOKEN = null;
          localStorage.removeItem('auth_token');
          if (liveChart) {
            liveChart.destroy();
            liveChart = null;
          }
          if (liveTimer) {
            clearInterval(liveTimer);
            liveTimer = null;
          }
          if (updateLogTimer) {
            clearInterval(updateLogTimer);
            updateLogTimer = null;
          }
          setTimeout(checkAuthAndRender, 2000);
        } else {
          messageDiv.style.color = 'red';
          messageDiv.innerText = data.msg || txt[LANG].password_change_fail;
        }
      } catch (error) {
        messageDiv.style.color = 'red';
        messageDiv.innerText = 'Network error during password change.';
        console.error('Password change error:', error);
      }
    }

    // --- General Utility Functions ---
    function showModal(title, content) {
      let m = document.createElement("div");
      m.style = "position:fixed;left:0;top:0;width:100vw;height:100vh;z-index:999;background:rgba(0,0,0,0.4);display:flex;align-items:center;justify-content:center";
      m.innerHTML = `<div style="background:#fff;padding:16px 22px;min-width:280px;max-width:96vw;max-height:85vh;overflow:auto;border-radius:12px;box-shadow:0 6px 32px #0003">
        <div style="font-weight:bold;font-size:1.2em;margin-bottom:10px">${title}</div>
        ${content}
        <div style="text-align:center;margin-top:12px"><button onclick="this.parentNode.parentNode.parentNode.remove()">OK</button></div>
      </div>`;
      document.body.appendChild(m);
    }

    function showCustomConfirm(message, callback) {
      const modalId = 'custom-confirm-modal';
      let oldModal = document.getElementById(modalId);
      if (oldModal) oldModal.remove();

      const modal = document.createElement('div');
      modal.id = modalId;
      modal.style = "display:flex;position:fixed;left:0;top:0;width:100vw;height:100vh;z-index:3000;background:rgba(0,0,0,0.33);justify-content:center;align-items:center;";
      modal.innerHTML = `
        <div style="background:#fff;max-width:370px;width:95vw;padding:26px 20px 20px 20px;border-radius:12px;box-shadow:0 3px 18px #0003;position:relative">
          <p style="margin-bottom:20px;font-size:1.1em;text-align:center;">${message}</p>
          <div style="text-align:center;">
            <button id="confirm-yes-btn" class="action" style="background:#28a745; margin-right: 10px;">${LANG === "ar" ? "نعم" : "Yes"}</button>
            <button id="confirm-no-btn" class="action" style="background:#dc3545;">${LANG === "ar" ? "لا" : "No"}</button>
          </div>
        </div>
      `;
      document.body.appendChild(modal);

      const yesBtn = document.getElementById('confirm-yes-btn');
      const noBtn = document.getElementById('confirm-no-btn');

      if (yesBtn) {
        yesBtn.addEventListener('click', () => {
          modal.remove();
          if (callback) callback(true);
        });
      }
      if (noBtn) {
        noBtn.addEventListener('click', () => {
          modal.remove();
          if (callback) callback(false);
        });
      }
    }

    function showCustomAlert(message) {
      const modalId = 'custom-alert-modal';
      let oldModal = document.getElementById(modalId);
      if (oldModal) oldModal.remove();

      const modal = document.createElement('div');
      modal.id = modalId;
      modal.style = "display:flex;position:fixed;left:0;top:0;width:100vw;height:100vh;z-index:3000;background:rgba(0,0,0,0.33);justify-content:center;align-items:center;";
      modal.innerHTML = `
        <div style="background:#fff;max-width:370px;width:95vw;padding:26px 20px 20px 20px;border-radius:12px;box-shadow:0 3px 18px #0003;position:relative">
          <p style="margin-bottom:20px;font-size:1.1em;text-align:center;">${message}</p>
          <div style="text-align:center;">
            <button class="action" onclick="document.getElementById('${modalId}').remove();">${LANG === "ar" ? "موافق" : "OK"}</button>
          </div>
        </div>
      `;
      document.body.appendChild(modal);
    }

    function escapeHTML(txt) {
      return (""+txt).replace(/[<>&"]/g, function(c) {
        return {'<':'&lt;','>':'&gt;','&':'&amp;','"':'&quot;'}[c];
      });
    }

    // --- API Communication with Backend ---
    async function callAPI(url, method = 'GET', data = null, resultId = "result-block", returnPromise = false) {
      const resultElement = document.getElementById(resultId);
      if(resultId && resultElement) {
        resultElement.innerHTML = `<span style="color:#888">${txt[LANG].please_wait}</span>`;
      }
      let opts = {method: method};
      opts.headers = { 'Content-Type': 'application/json' };
      if (AUTH_TOKEN) {
        opts.headers['X-Auth-Token'] = AUTH_TOKEN;
      }
      if(data) opts.body = JSON.stringify(data);
      try {
        let q = url.includes("?") ? "&" : "?";
        let res = await fetch(url + q + "lang=" + LANG, opts);

        if (res.status === 401) {
            AUTH_TOKEN = null;
            localStorage.removeItem('auth_token');
            checkAuthAndRender();
            return null;
        }

        let js = await res.json();

        let result = js.result || js.msg || js.ok || "";
        let desc = js.desc ? `<div class="desc-block">${js.desc}</div>` : "";
        if(resultId && resultElement) {
          resultElement.innerHTML =
            desc + (result ? `<div class="result-block">${escapeHTML(result)}</div>` : "");
        }
        if (returnPromise) return js;
      } catch (e) {
        if(resultId && resultElement) {
          resultElement.innerHTML = `<div style="color:#e74c3c">${e.message}</div>`;
        }
        if (returnPromise) return null;
      }
    }

    // --- Updates Page (Panel & Wingbits Client) ---
    async function renderUpdatesPage() {
      const mainContent = document.getElementById("main-content");
      if (!mainContent) return;

      mainContent.innerHTML = `
        <h2>${txt[LANG].updates_panel_title}</h2>
        <div id="updates-status" class="result-block" style="font-size:1.02em">${txt[LANG].please_wait}</div>

        <div id="updates-cards" style="display:grid;gap:14px;margin-top:10px"></div>

        <div style="display:flex;gap:10px;margin-top:10px">
          <button class="action" onclick="checkUpdatesNow()">${txt[LANG].check_updates}</button>
          <button class="action" onclick="loadFeederVersions()">${LANG==='ar'?'تحديث الإصدارات الحالية':'Refresh installed versions'}</button>
        </div>

        <div style="margin-top:16px">
          <h4 style="margin:8px 0 6px 0">${LANG==='ar'?'الإصدارات الحالية':'Installed versions'}</h4>
          <div id="feeder-versions-block" style="font-family:monospace"></div>
        </div>
      `;

      loadFeederVersions();
      await checkUpdatesNow();
    }

    async function checkUpdatesNow() {
      const statusEl = document.getElementById('updates-status');
      const cardsEl = document.getElementById('updates-cards');
      if (statusEl) {
        statusEl.style.color = '#333';
        statusEl.innerText = txt[LANG].please_wait;
      }

      // 1) Installed versions (local)
      let installed = {};
      try {
        const js = await callAPI('/api/feeder/versions','GET',null,null,true);
        if (js && js.ok && js.versions) installed = js.versions;
      } catch(_) {}

      // 2) Latest versions (via backend)
      let latest = {};
      let has = { panel:false, wingbits:false };
      try {
        const upd = await callAPI('/api/updates/check','GET',null,null,true);
        if (upd && upd.ok) {
          latest = upd.latest || {};
          has = upd.has_updates || has;
        }
      } catch(_) {}

      const mkLine = (label, value) => `
        <div style="display:flex;gap:8px;align-items:center">
          <div style="min-width:160px;color:#555">${label}</div>
          <div><b>${value || txt[LANG].unknown}</b></div>
        </div>`;

      const panelHas = !!has.panel;
      const wingHas  = !!has.wingbits;

      const panelCard = `
        <div class="ts-row ${panelHas?'ts-warn':'ts-ok'}">
          <div class="ts-title">Panel (Web UI) ${panelHas?`&nbsp; <span class="ts-badge warn">${txt[LANG].update_available}</span>`:''}</div>
          <div class="ts-details">
            ${mkLine(txt[LANG].current_version, installed.panel || txt[LANG].unknown)}
            ${mkLine(txt[LANG].latest_version, latest.panel || txt[LANG].unknown)}
            ${panelHas
              ? `<div style="margin-top:10px"><button class="action" onclick="updatePanelNow()">${txt[LANG].update_panel_now}</button></div>`
              : `<div style="margin-top:10px;color:#2e7d32">${txt[LANG].panel_up_to_date}</div>`
            }
          </div>
        </div>`;

      const wingCard = `
        <div class="ts-row ${wingHas?'ts-warn':'ts-ok'}">
          <div class="ts-title">Wingbits Client ${wingHas?`&nbsp; <span class="ts-badge warn">${txt[LANG].update_available}</span>`:''}</div>
          <div class="ts-details">
            ${mkLine(txt[LANG].current_version, installed.wingbits || txt[LANG].unknown)}
            ${mkLine(txt[LANG].latest_version, latest.wingbits || txt[LANG].unknown)}
            ${wingHas
              ? `<div style="margin-top:10px"><button class="action" onclick="confirmUpdateClient()">${txt[LANG].update_wingbits_now}</button></div>`
              : `<div style="margin-top:10px;color:#2e7d32">${txt[LANG].wingbits_up_to_date}</div>`
            }
          </div>
        </div>`;

      if (cardsEl) cardsEl.innerHTML = panelCard + wingCard;

      if (statusEl){
        if (!latest.panel && !latest.wingbits) {
          statusEl.innerText = '';
        } else {
          statusEl.style.color = '#2e7d32';
          statusEl.innerText = LANG==='ar'
            ? 'تم فحص التحديثات.'
            : 'Update check completed.';
        }
      }
    }

    async function updatePanelNow(){
      const ok = await new Promise(resolve => {
        showCustomConfirm(LANG==='ar'?'تأكيد تحديث سكربت اللوحة؟':'Confirm updating the Panel script?', r => resolve(r));
      });
      if (!ok) return;
      try {
        const resp = await fetch('/api/update/reinstall', {
          method:'POST',
          headers:{'Content-Type':'application/json','X-Auth-Token': AUTH_TOKEN},
          body: JSON.stringify({components: ['panel']})
        });
        const js = await resp.json();
        showCustomAlert((js && js.msg) || (LANG==='ar'?'تم بدء التحديث. برجاء الانتظار دقيقة ثم أعد تحميل الصفحة.':'Update triggered. Please wait a minute and reload.'));
      } catch(e){
        showCustomAlert((LANG==='ar'?'خطأ: ':'Error: ')+ e.message);
      }
    }

    // --- Authentication Check and Page Rendering ---
    async function checkAuthAndRender() {
        AUTH_TOKEN = localStorage.getItem('auth_token');
        let sidebar = document.getElementById('sidebar');
        let logoutBtn = document.getElementById('logout-btn');
        const container = document.getElementById('container'); 

        if (!AUTH_TOKEN) {
            if (liveChart) {
                liveChart.destroy();
                liveChart = null;
            }
            if (liveTimer) {
                clearInterval(liveTimer);
                liveTimer = null;
            }
            if (updateLogTimer) {
                clearInterval(updateLogTimer);
                updateLogTimer = null;
            }
            if (sidebar) sidebar.style.display = 'none';
            if (logoutBtn) logoutBtn.style.display = 'none';
            renderLoginPage();
            return;
        }

        // Verify token with a simple API call
        try {
            const response = await fetch('/api/system/info', {
                headers: { 'X-Auth-Token': AUTH_TOKEN }
            });
            if (response.status === 401) {
                AUTH_TOKEN = null;
                localStorage.removeItem('auth_token');
                if (liveChart) {
                    liveChart.destroy();
                    liveChart = null;
                }
                if (liveTimer) {
                    clearInterval(liveTimer);
                    liveTimer = null;
                }
                if (updateLogTimer) {
                    clearInterval(updateLogTimer);
                    updateLogTimer = null;
                }
                if (sidebar) sidebar.style.display = 'none';
                if (logoutBtn) logoutBtn.style.display = 'none';
                renderLoginPage();
                return;
            }
            
            // If authenticated, ensure main app structure exists (after login page)
            if (!document.getElementById('side-menu') || !document.getElementById('main-content')) { 
                container.innerHTML = `
                    <div class="sidebar" id="sidebar">
                        <img class="logo" src="https://wingbits.com/apple-icon.png?34e8dd62bf865c3e" alt="Wingbits" />
                        <div class="side-title" id="side-title">Wingbits Web Config</div>
                        <div class="side-menu" id="side-menu"></div>
                        <div class="lang-switch">
                            <button id="en-btn" class="active" onclick="setLang('en')">EN</button>
                            <button id="ar-btn" class="active" onclick="setLang('ar')">العربية</button>
                        </div>
                        <button class="action" style="margin-top: auto; margin-bottom: 15px; width: 80%;" onclick="logoutUser()" id="logout-btn"></button>
                    </div>
                    <div class="main" id="main-content"></div>
                `;
                sidebar = document.getElementById('sidebar');
                logoutBtn = document.getElementById('logout-btn');
            } 
            
            if (sidebar) sidebar.style.display = 'flex';
            if (logoutBtn) logoutBtn.style.display = 'block';

            setLang(LANG);
            renderMenuPage('live_stats');
        } catch (error) {
            console.error('Authentication check failed:', error);
            if (liveChart) {
                liveChart.destroy();
                liveChart = null;
            }
            if (liveTimer) {
                clearInterval(liveTimer);
                liveTimer = null;
            }
            if (updateLogTimer) {
                clearInterval(updateLogTimer);
                updateLogTimer = null;
            }
            if (sidebar) sidebar.style.display = 'none';
            if (logoutBtn) logoutBtn.style.display = 'none';
            renderLoginPage();
            const loginMessage = document.getElementById('login-message');
            if (loginMessage) {
              loginMessage.innerText = 'Network error during authentication check. Please try again.';
              loginMessage.style.color = 'red';
            }
        }
    }

    // --- Page Initialization ---
    window.onload = function() {
      checkAuthAndRender();
    }
  </script>

<!-- ===== Smart Troubleshooter injection (enhanced) [FIXED] ===== -->
<script id="WB_TS_V3_INJECTION">
;(() => {
  // ==== i18n additions ====
  const txt = window.txt || { en: {}, ar: {} };

  Object.assign(txt.en, {
    ts_init_title: 'Initializing',
    ts_init_msg: 'Recent boot/replug detected. For best diagnostic result wait Remaining seconds, then run diagnostics again.',
    ts_init_now: 'Current time',
    ts_init_boot_time: 'Boot/replug time',
    ts_init_remaining: 'Remaining',
    ts_readsb_hint_port_issue: '- readsb network/port output issue.',
    ts_readsb_hint_cleared: '[Cleared] readsb currently healthy; older log warning ignored.',
    run_again_60: 'Run again in 300s'
  });
  Object.assign(txt.ar, {
    ts_init_title: 'Initializing',
    ts_init_msg: 'تم اكتشاف تشغيل/إعادة توصيل حديث. انتظر 180–300 ثانية ثم شغّل التشخيص مجددًا.',
    ts_init_now: 'الوقت الحالي',
    ts_init_boot_time: 'وقت التشغيل/إعادة التوصيل',
    ts_init_remaining: 'المتبقي',
    ts_readsb_hint_port_issue: '- مشكلة شبكة/منفذ لإخراج readsb.',
    ts_readsb_hint_cleared: '[تم التجاهل] readsb يعمل حاليًا بشكل سليم؛ تم تجاهل تحذير قديم.',
    run_again_60: 'تشغيل مجددًا بعد 300 ثانية'
  });

  // Translator
  window.LANG = (window.LANG === 'ar' || window.LANG === 'en') ? window.LANG : 'en';
  function L(k){ return (txt[window.LANG] && txt[window.LANG][k]) || (txt.en && txt.en[k]) || k; }

  // ---- Time & Wait helpers ----
  let _tsClockTimer = null;
  let _tsWaitTimer = null;
  let _tsBootEpochMs = null;
  function _wb_two(n){return (n<10?'0':'')+n}
  function _wb_formatTime(dt){try{return _wb_two(dt.getHours())+':'+_wb_two(dt.getMinutes())+':'+_wb_two(dt.getSeconds())}catch(_){return '--:--:--'}}
  function _wb_tickClock(){try{const el=document.getElementById('ts-now'); if(el) el.textContent=_wb_formatTime(new Date())}catch(_){}}
  function _wb_startClock(){try{if(_tsClockTimer)clearInterval(_tsClockTimer); _wb_tickClock(); _tsClockTimer=setInterval(_wb_tickClock,1000)}catch(_){}}  
  function _wb_updateWaitRemaining(){
    try{
      const rem=document.getElementById('ts-wait-rem');
      const bootAt=document.getElementById('ts-boot-at');
      if (!rem) return;
      if (_tsBootEpochMs){
        const elapsed=Math.max(0,Math.floor((Date.now()-_tsBootEpochMs)/1000));
        const minR=Math.max(0,180-elapsed);
        const maxR=Math.max(0,300-elapsed);
        rem.textContent=(minR+'–'+maxR+'s');
        if (bootAt) bootAt.textContent=_wb_formatTime(new Date(_tsBootEpochMs));
      } else {
        rem.textContent='180–300s';
      }
    }catch(_){}
  }
  function _wb_startWaitTicker(){try{if(_tsWaitTimer)clearInterval(_tsWaitTimer); _wb_updateWaitRemaining(); _tsWaitTimer=setInterval(_wb_updateWaitRemaining,1000)}catch(_){ }}

  // Infer status
  function _wb_inferStatus(details, status, title){
    const t  = (details||'').toLowerCase();
    const ti = (title||'').toLowerCase();

    if (/(readsb|wingbits|tar1090)\s+service/.test(ti)) return status || 'OK';

    const benign = ['connection refused','update check failed'];
    if (benign.some(p => t.includes(p))) {
      return status === 'FAIL' ? 'WARN' : (status || 'WARN');
    }

    const hardErr =
        /\b(active:\s*failed|unit .* failed|failed to start|error:)\b/i.test(details||'')
     || /\b(no geosigner device found|geosigner not available|geosigner is not linked)\b/i.test(t)
     || /[✗×]/.test(details || '');

    if (hardErr) return 'FAIL';
    if (/\bwarn(ing)?\b/i.test(t)) return status === 'OK' ? 'WARN' : (status || 'WARN');
    return status || 'OK';
  }

  function addTSButton(){
    const side = document.getElementById('side-menu');
    if (!side) return;
    const subMenus = side.querySelectorAll('.sub-menu, div[style*="margin-left"]');
    let container = null;
    subMenus.forEach(div => {
      const hasDiag = Array.from(div.querySelectorAll('button')).some(b => {
        const t = (b.textContent || '').trim().toLowerCase();
        return t === 'diagnostics' || t === 'تصحيح' || t === 'التشخيص' || t.includes('wingbits status');
      });
      if (hasDiag) container = div;
    });
    if (!container) return;
    if (container.querySelector('button[data-sub="troubleshooter"]')) return;

    const btn = document.createElement('button');
    btn.textContent = (window.LANG === 'ar' ? 'أداة تشخيص ذكية' : 'Smart Troubleshooter');
    btn.setAttribute('data-key','support_menu');
    btn.setAttribute('data-sub','troubleshooter');
    btn.onclick = function(){ if (typeof window.renderMenuPage==='function'){ window.renderMenuPage('support_menu','troubleshooter'); } };
    container.insertBefore(btn, container.firstChild);
  }

  if (typeof window.renderMenuPage === 'function') {
    const _origRenderMenuPage = window.renderMenuPage;
    window.renderMenuPage = function(key, sub, qolSub){
      const r = _origRenderMenuPage.apply(this, arguments);
      if (key === 'support_menu') { setTimeout(addTSButton, 0); }
      if (key === 'support_menu' && sub === 'troubleshooter'){
        if (typeof window.renderTroubleshooter === 'function'){ window.renderTroubleshooter(); return; }
      }
      return r;
    };
  } else {
    setTimeout(addTSButton, 500);
  }

  window.renderTroubleshooter = function(){
    const el = document.getElementById('main-content');
    if (!el) return;
    el.innerHTML =
      '<div class="ts-top">'
      +   '<h2>'+(window.LANG==='ar'?'أداة تشخيص ذكية':'Smart Troubleshooter')+'</h2>'
      +   '<label style="display:flex;gap:10px;align-items:center;font-weight:600">'
      +     '<input type="checkbox" id="ts-safe-fix" />'
      +     (window.LANG==='ar'?'تفعيل الإصلاح التلقائي الآمن':'Enable safe auto-fix')
      +   '</label>'
      + '</div>'
      + '<div id="ts-init-banner" style="margin:6px 0 10px 0"></div>'
      + '<div style="display:flex;gap:10px;align-items:center;flex-wrap:wrap">'
      +   '<button class="action" onclick="runTroubleshooter()">'+(window.LANG==='ar'?'تشغيل التشخيص':'Run diagnostics')+'</button>'
      +   '<button class="action" id="ts-run-again" style="display:none;background:#f39c12">'+(window.LANG==='ar'?txt.ar.run_again_60:txt.en.run_again_60)+'</button>'
      + '</div>'
      + '<div id="ts-summary" style="margin:14px 0;font-weight:700;"></div>'
      + '<div id="ts-results"></div>';
  
    _wb_probeInitAndRenderBanner();
  };

  // Run-again 300s button logic
  let _tsRunAgainTimer = null;
  function _wb_startRunAgainCountdown(sec) {
    try {
      const btn = document.getElementById('ts-run-again');
      if (!btn) return;
      let left = (typeof sec === 'number' && sec > 0) ? sec : 300;
      btn.disabled = true;
      const base = (window.LANG === 'ar' ? txt.ar.run_again_60 : txt.en.run_again_60);
      btn.textContent = base + ' (' + left + 's)';
      if (_tsRunAgainTimer) clearInterval(_tsRunAgainTimer);
      _tsRunAgainTimer = setInterval(() => {
        left -= 1;
        if (left <= 0) {
          clearInterval(_tsRunAgainTimer); _tsRunAgainTimer = null;
          btn.disabled = false; btn.style.display = 'none';
          runTroubleshooter();
        } else {
          btn.textContent = base + ' (' + left + 's)';
        }
      }, 1000);
    } catch (_) {}
  }

  // ===== Fallback scanner for replug info (from /api/system/info) =====
function _wb_scanObjectForReplugAgeSec(obj){
  try{
    const nowSec = Math.floor(Date.now()/1000);
    let bestAge = null;
    function maybeSetAge(age){
      if (!Number.isFinite(age) || age < 0 || age > 86400) return;
      bestAge = (bestAge==null) ? age : Math.min(bestAge, age);
    }
    function walk(o, depth){
      if (!o || depth>6) return;
      if (Array.isArray(o)){ o.forEach(x=>walk(x, depth+1)); return; }
      if (typeof o !== 'object') return;
      for (const [k,v] of Object.entries(o)){
        const kl = (k||'').toLowerCase();
        const isReplugKey = /replug|usb.*(reset|replug)|geosigner|dongle/.test(kl);
        if (typeof v === 'number'){
          if (isReplugKey && /(ago|elapsed|sec)/.test(kl)) maybeSetAge(v);
          if (isReplugKey && /(unix|ts)$/.test(kl)){
            const ts = v > 1e12 ? Math.floor(v/1000) : v;
            maybeSetAge(nowSec - ts);
          }
        } else if (typeof v === 'string' && isReplugKey){
          // "123s ago" OR ISO date
          let m = v.match(/(\d+)\s*s(ec(?:onds)?)?\s*ago/i);
          if (m){ maybeSetAge(parseInt(m[1],10)); }
          const t = Date.parse(v);
          if (!isNaN(t)) maybeSetAge(Math.floor((Date.now()-t)/1000));
        } else if (typeof v === 'object'){
          walk(v, depth+1);
        }
      }
    }
    walk(obj, 0);
    return bestAge; // seconds ago or null
  }catch(_){ return null; }
}

async function _wb_probeReplugFallback(){
  try{
    const token = (typeof AUTH_TOKEN!=='undefined'&&AUTH_TOKEN)||localStorage.getItem('auth_token')||'';
    const r = await fetch('/api/system/info',{headers:{'X-Auth-Token':token}});
    if (!r.ok) return {recent:false};
    const js = await r.json();
    const d = (js && js.info) || {};

// NEW: use uptime_hr as a boot-age hint (<= 5 min)
if (Number.isFinite(d.uptime_hr)) {
  const age = Math.floor(d.uptime_hr * 3600);
  if (age < 300) {
    const bootEpoch = Math.floor(Date.now()/1000) - age;
    return {recent:true, ageSec: age, bootEpoch};
  }
}

    const ageSec = _wb_scanObjectForReplugAgeSec(js);
    if (Number.isFinite(ageSec) && ageSec < 300){
      const bootEpoch = Math.floor(Date.now()/1000) - ageSec;
      return {recent:true, ageSec, bootEpoch};
    }
  }catch(_){}
  return {recent:false};
}


  // INIT probe banner
  async function _wb_probeInitAndRenderBanner(){
  try{
    const token = (typeof AUTH_TOKEN!=='undefined'&&AUTH_TOKEN)||localStorage.getItem('auth_token')||'';
    const res = await fetch('/api/troubleshoot/probe-init',{headers:{'X-Auth-Token':token}});
    if (res.status === 401) return;
    const js = await res.json();

    const banner = document.getElementById('ts-init-banner');
    const runAgain = document.getElementById('ts-run-again');

    function _hideInit(){
      if (banner) banner.innerHTML = '';
      if (runAgain){ runAgain.style.display='none'; runAgain.onclick = null; }
      try{
        if (_tsClockTimer){ clearInterval(_tsClockTimer); _tsClockTimer = null; }
        if (_tsWaitTimer){ clearInterval(_tsWaitTimer); _tsWaitTimer = null; }
        _tsBootEpochMs = null;
      }catch(_){}
    }

    // ---- 1) أولاً: استخدم probe-init كالمعتاد
    let info = (js && js.init) || {};
    const num = v => (typeof v === 'number' && isFinite(v)) ? v : null;
    let ageSec = num(info.age_sec) ?? num(info.boot_seconds_ago) ?? num(info.elapsed) ?? null;

    if (ageSec === null && info.reason){
      const s = String(info.reason);
      let m = s.match(/(\d+)\s*s(?:ec(?:onds)?)?\s*ago/i)
            || s.match(/boot(?:ed)?\s+(\d+)\s*s/i)
            || s.match(/replug(?:ged)?\s+(\d+)\s*s/i);
      if (m) ageSec = parseInt(m[1],10);
    }

    let bootEpoch = num(info.boot_epoch) ?? num(info.boot_ts) ?? num(info.boot_unix) ?? null;
    if (!bootEpoch && ageSec!==null) bootEpoch = Math.floor(Date.now()/1000) - ageSec;
    if (!bootEpoch && info.boot_time){
      const parsed = Date.parse(info.boot_time);
      if (!isNaN(parsed)) bootEpoch = Math.floor(parsed/1000);
    }

    let recent = (ageSec !== null) ? (ageSec < 300) : (info.recent === true);

    // ---- 2) إن لم يكن حديثًا: افحص /api/system/info للـ replug (GeoSigner/SDR)
    if (!recent){
      const fb = await _wb_probeReplugFallback();
      if (fb.recent){
        recent = true;
        ageSec = fb.ageSec ?? fb.age_seconds ?? null;
        bootEpoch = fb.bootEpoch ?? fb.replugEpoch ?? (ageSec!=null ? Math.floor(Date.now()/1000)-ageSec : null);
      }
    }

    if (!recent){ _hideInit(); return; }

    // ---- 3) اعرض البطاقة
    if (banner){
      banner.innerHTML =
        '<div class="ts-row ts-warn">'
        +  '<div class="ts-title">' + L('ts_init_title') + ' &nbsp; <span class="ts-badge warn">' + L('ts_init_title') + '</span></div>'
        +  '<div class="ts-details">' + L('ts_init_msg') + '</div>'
        +  '<div class="ts-details" style="display:flex;gap:16px;flex-wrap:wrap;margin-top:6px">'
        +    '<div><strong>' + L('ts_init_now') + ':</strong> <span id="ts-now">--:--:--</span></div>'
        +    '<div><strong>' + L('ts_init_boot_time') + ':</strong> <span id="ts-boot-at">--:--:--</span></div>'
        +    '<div><strong>' + L('ts_init_remaining') + ':</strong> <span id="ts-wait-rem">180–300s</span></div>'
        +  '</div>'
        +'</div>';
    }

    if (runAgain){
      runAgain.style.display = 'inline-block';
      runAgain.onclick = ()=> _wb_startRunAgainCountdown(300);
    }

    try{
      _tsBootEpochMs = bootEpoch ? (bootEpoch * 1000) : (_tsBootEpochMs ?? null);
      _wb_startClock();
      _wb_startWaitTicker();
      if (_tsBootEpochMs){
        const bootAt = document.getElementById('ts-boot-at');
        if (bootAt) bootAt.textContent = _wb_formatTime(new Date(_tsBootEpochMs));
      }
    }catch(_){}
  }catch(_){}
}


  // Execute Troubleshooter
  window.runTroubleshooter = async function(){
    const resultsEl = document.getElementById('ts-results');
    const summaryEl = document.getElementById('ts-summary');

    if (resultsEl) {
      resultsEl.innerHTML = '<div style="padding:12px;color:#666">'+(window.LANG==='ar'?'يرجى الانتظار...':'Please wait...')+'</div>';
    }
    if (summaryEl) summaryEl.innerHTML = '';

    try{
      const apply_fix = !!(document.getElementById('ts-safe-fix') && document.getElementById('ts-safe-fix').checked);
      const res = await fetch('/api/troubleshoot/run', {
        method:'POST',
        headers:{
          'Content-Type':'application/json',
          'X-Auth-Token': (typeof AUTH_TOKEN!=='undefined'&&AUTH_TOKEN)||localStorage.getItem('auth_token')||''
        },
        body: JSON.stringify({apply_fix})
      });

      if (res.status === 401){
        window.AUTH_TOKEN = null; localStorage.removeItem('auth_token');
        if (typeof window.renderLoginPage === 'function') window.renderLoginPage();
        return;
      }

      const js = await res.json();
      _wb_probeInitAndRenderBanner();

      if (!js || js.ok === false) throw new Error((js && js.msg) || 'Failed');

      let checks = (js.checks || []).map(c => ({ ...c, status: _wb_inferStatus(c.details, c.status, c.title) }));

      try{
        const readsbHealthy = (checks || []).some(x => /wingbits detailed status/i.test(x.title||'') && /data input status:\s*ok/i.test(x.details||''));
        if (readsbHealthy){
          checks = checks.map(x => {
            if ((x.title||'').toLowerCase().includes('readsb recent log hints')){
              x.status = 'OK';
              x.details = (x.details||'') + '\n\n' + L('ts_readsb_hint_cleared');
            }
            return x;
          });
        }
      }catch(_){}

      let overall = 'OK';
      if (checks.some(c=>c.status==='FAIL')) overall = 'FAIL';
      else if (checks.some(c=>c.status==='WARN')) overall = 'WARN';

      if (summaryEl){
        summaryEl.textContent =
          overall==='OK'   ? (window.LANG==='ar'?'المحطة تعمل بشكل طبيعي.':'Station is running normally.')
        : overall==='WARN' ? (window.LANG==='ar'?'المحطة تعمل مع تحذيرات.':'Station is running with warnings.')
                           : (window.LANG==='ar'?'المحطة ليست بحالة جيدة.':'Station is NOT healthy.');
      }

      const badge = (state)=> state==='OK' ? '<span class="ts-badge ok">OK</span>'
                            : state==='WARN' ? '<span class="ts-badge warn">WARN</span>'
                                             : '<span class="ts-badge fail">FAIL</span>';

      if (resultsEl){
  resultsEl.innerHTML =
    (checks||[]).map(c=>{
      const cls = c.status==='OK' ? 'ts-ok' : (c.status==='WARN' ? 'ts-warn' : 'ts-fail');
      const esc = s => (''+s).replace(/[&<>]/g, m => ({'&':'&amp;','<':'&lt;','>':'&gt;'}[m]));

      // جهّز التفاصيل مع فلترة العربية عندما LANG=en
      let detRaw = c.details || '';
      if ((c.title||'').toLowerCase().includes('readsb recent log hints')) {
        detRaw = detRaw.split('\n').map(line=>{
          if (window.LANG==='en' && /[\u0600-\u06FF]/.test(line)) return '';
          return line;
        }).filter(Boolean).join('\n');
      }
      const det = esc(detRaw);

      // عرض Next steps إن وُجدت
      let stepsBlock = '';
      if (Array.isArray(c.steps) && c.steps.length){
        const label = (window.LANG==='ar' ? 'الخطوات المقترحة' : 'Next steps');
        stepsBlock =
          '<div class="ts-details" style="margin-top:8px"><b>'+label+':</b>\n'
          + c.steps.map(s=>'• '+esc(s)).join('\n')
          + '</div>';
      }

      return (
        '<div class="ts-row '+cls+'">'
        +  '<div class="ts-title">'+esc(c.title||'')+' &nbsp; '+badge(c.status)+'</div>'
        +  '<div class="ts-details">'+det+'</div>'
        +  stepsBlock
        +'</div>'
      );
    }).join('')

    + ((js.autofix && js.autofix.applied && js.autofix.applied.length)
      ? ('<div class="ts-row ts-ok"><div class="ts-title">Auto-fix actions</div><div class="ts-details">'
          + js.autofix.applied.map(a=>'• '+esc(a.action)+'\n'+esc(a.result||'')).join('\n\n')
          + '</div></div>')
      : '');
}

    }catch(e){
      if (resultsEl){
        let msg = (e && e.message) || 'Error';
        msg = msg.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
        resultsEl.innerHTML =
          '<div class="ts-row ts-fail"><div class="ts-title">Error</div><div class="ts-details">'+msg+'</div></div>';
      }
    }
  };

  // نهاية حقن الـ Troubleshooter (fixed)
})();
</script>

</body>
</html>
