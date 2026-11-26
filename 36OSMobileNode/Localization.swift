import SwiftUI

enum AppLanguage: String, CaseIterable, Identifiable {
    case english = "en"
    case persian = "fa"
    var id: String { rawValue }
    var displayName: String { self == .english ? "English" : "فارسی" }
    var direction: LayoutDirection { self == .persian ? .rightToLeft : .leftToRight }
}
enum Copy {
    static func text(_ key: String, _ language: AppLanguage) -> String {
        let en: [String: String] = [
            "home":"Home","compute":"Compute","workers":"Workers","intelligence":"Intelligence","system":"System",
            "command_center":"Command Center","overview":"Your distributed intelligence system at a glance.",
            "system_health":"System Health","awaiting":"Awaiting Connection","not_connected":"Not connected",
            "nodes":"Compute Nodes","active_workers":"Active Workers","queued_tasks":"Queued Tasks","models":"AI Models",
            "quick_actions":"Quick Actions","register_node":"Register Node","create_worker":"Create Worker",
            "model_manager":"Model Manager","security":"Security Center","recent_activity":"Recent Activity",
            "no_events":"No events recorded yet.","this_device":"This Device","node_registry":"Node Registry",
            "hardware":"Hardware Monitor","resources":"Resource Allocation","profiles":"Compute Profiles",
            "network":"Network & Connectivity","diagnostics":"Node Diagnostics","worker_overview":"Worker Overview",
            "worker_registry":"Worker Registry","groups":"Worker Groups","builder":"Worker Builder",
            "task_queue":"Task Queue","history":"Execution History","templates":"Worker Templates",
            "permissions":"Worker Permissions","local_models":"Local AI Models","inference":"Inference Runtime",
            "algorithm_lab":"Algorithm Laboratory","simulation":"Simulation Center","benchmark":"Evaluation & Benchmark",
            "proposals":"Evolution Proposals","cie_connection":"CIE Connection","os_connection":"36OS Connection",
            "creator":"Creator Control","identity":"Identity & Access","audit":"Audit Log",
            "backup":"Backup & Recovery","versions":"Updates & Versions","advanced":"Advanced Settings",
            "density":"Information Density","simple":"Simple","adaptive":"Adaptive","expert":"Expert",
            "language":"Interface Language","dark":"Dark Intelligence","manual":"Manual control",
            "pending":"Pending Approval","offline":"Offline","empty":"No data available",
            "preview_data":"Preview interface — live service data is not connected.",
            "not_implemented":"UI foundation only. Runtime integration is not enabled yet.",
            "cie_endpoint":"CIE API Endpoint","api_token":"Scoped API Token","save_token":"Save Token",
            "remove_token":"Remove Token","test_connection":"Test Connection","token_saved":"Token stored securely on this device.",
            "token_missing":"No API token saved.","connection_settings":"Connection Settings",
            "status":"Status","platform":"Platform","protocol":"Protocol","trust":"Trust State",
            "permissions_note":"Sensitive actions require re-authentication and an audit event.",
            "emergency":"Emergency Stop","cancel":"Cancel"
        ]
        let fa: [String: String] = [
            "home":"خانه","compute":"محاسبات","workers":"ورکرها","intelligence":"هوشمندی","system":"سیستم",
            "command_center":"مرکز فرماندهی","overview":"نمای کلی اکوسیستم هوشمندی توزیع‌شده.",
            "system_health":"سلامت سیستم","awaiting":"در انتظار اتصال","not_connected":"متصل نیست",
            "nodes":"گره‌های محاسباتی","active_workers":"ورکرهای فعال","queued_tasks":"وظایف در صف","models":"مدل‌های هوش مصنوعی",
            "quick_actions":"دسترسی سریع","register_node":"ثبت گره","create_worker":"ساخت ورکر",
            "model_manager":"مدیریت مدل‌ها","security":"مرکز امنیت","recent_activity":"فعالیت‌های اخیر",
            "no_events":"هنوز رویدادی ثبت نشده است.","this_device":"این دستگاه","node_registry":"فهرست گره‌ها",
            "hardware":"پایش سخت‌افزار","resources":"تخصیص منابع","profiles":"پروفایل‌های محاسباتی",
            "network":"شبکه و ارتباطات","diagnostics":"عیب‌یابی گره","worker_overview":"نمای کلی ورکرها",
            "worker_registry":"فهرست ورکرها","groups":"گروه‌های ورکر","builder":"سازنده ورکر",
            "task_queue":"صف وظایف","history":"تاریخچه اجرا","templates":"قالب‌های ورکر",
            "permissions":"مجوزهای ورکر","local_models":"مدل‌های هوش مصنوعی محلی","inference":"محیط اجرای مدل",
            "algorithm_lab":"آزمایشگاه الگوریتم","simulation":"مرکز شبیه‌سازی","benchmark":"ارزیابی و سنجش",
            "proposals":"پیشنهادهای تکامل","cie_connection":"اتصال CIE","os_connection":"اتصال 36OS",
            "creator":"کنترل Creator","identity":"هویت و دسترسی","audit":"گزارش رویدادها",
            "backup":"پشتیبان‌گیری و بازیابی","versions":"به‌روزرسانی و نسخه‌ها","advanced":"تنظیمات پیشرفته",
            "density":"تراکم اطلاعات","simple":"ساده","adaptive":"تطبیقی","expert":"تخصصی",
            "language":"زبان رابط","dark":"تم هوشمندی تیره","manual":"کنترل دستی",
            "pending":"در انتظار تأیید","offline":"آفلاین","empty":"داده‌ای موجود نیست",
            "preview_data":"پیش‌نمایش رابط؛ داده زنده سرویس‌ها متصل نیست.",
            "not_implemented":"زیرساخت رابط کاربری؛ اتصال Runtime هنوز فعال نشده است.",
            "cie_endpoint":"نشانی API سامانه CIE","api_token":"توکن دسترسی محدود API","save_token":"ذخیره توکن",
            "remove_token":"حذف توکن","test_connection":"آزمایش اتصال","token_saved":"توکن به‌صورت امن روی این دستگاه ذخیره شده است.",
            "token_missing":"توکن API ذخیره نشده است.","connection_settings":"تنظیمات اتصال",
            "status":"وضعیت","platform":"پلتفرم","protocol":"پروتکل","trust":"وضعیت اعتماد",
            "permissions_note":"عملیات حساس به احراز هویت مجدد و ثبت رویداد Audit نیاز دارند.",
            "emergency":"توقف اضطراری","cancel":"انصراف"
        ]
        return (language == .persian ? fa[key] : en[key]) ?? key
    }
}
enum InformationDensity: String, CaseIterable, Identifiable {
    case simple, adaptive, expert
    var id: String { rawValue }
}