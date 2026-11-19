import 'package:flutter/material.dart';

void main() {
  runApp(const CieMobileApp());
}

class CieMobileApp extends StatelessWidget {
  const CieMobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CIE Mobile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5267D8),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF0B1020),
        cardTheme: CardThemeData(
          color: const Color(0xFF151D32),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: Color(0xFF26314D)),
          ),
        ),
      ),
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child ?? const SizedBox.shrink(),
      ),
      home: const CieHomePage(),
    );
  }
}

class CieHomePage extends StatefulWidget {
  const CieHomePage({super.key});

  @override
  State<CieHomePage> createState() => _CieHomePageState();
}

class _CieHomePageState extends State<CieHomePage> {
  int _selectedIndex = 0;

  static const _sections = <Widget>[
    DashboardSection(),
    AgentsSection(),
    TasksSection(),
    ActivitySection(),
  ];

  static const _titles = ['نمای کلی', 'عامل‌ها', 'وظایف', 'گزارش فعالیت'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.hub_outlined, color: Color(0xFF91A2FF)),
            SizedBox(width: 10),
            Text('CIE Mobile', style: TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'وضعیت اتصال',
            onPressed: () => _showInfo(context),
            icon: const Icon(Icons.cloud_off_outlined),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: IndexedStack(index: _selectedIndex, children: _sections),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'نمای کلی',
          ),
          NavigationDestination(
            icon: Icon(Icons.smart_toy_outlined),
            selectedIcon: Icon(Icons.smart_toy),
            label: 'عامل‌ها',
          ),
          NavigationDestination(
            icon: Icon(Icons.checklist_outlined),
            selectedIcon: Icon(Icons.checklist),
            label: 'وظایف',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'فعالیت',
          ),
        ],
      ),
    );
  }

  void _showInfo(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('اتصال هسته CIE'),
        content: const Text(
          'رابط کاربری اولیه آماده‌سازی شده است. اتصال به API هسته هنوز پیکربندی نشده؛ '
          'برای فعال‌سازی، نشانی امن API و روش احراز هویت باید در مرحله بعد تعریف شود.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('متوجه شدم'),
          ),
        ],
      ),
    );
  }
}

class DashboardSection extends StatelessWidget {
  const DashboardSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'مرکز فرماندهی',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(
          'نمای کلی وضعیت اکوسیستم هوش جمعی',
          style: TextStyle(color: Colors.blueGrey.shade200),
        ),
        const SizedBox(height: 20),
        const _StatusCard(),
        const SizedBox(height: 18),
        const Text(
          'دسترسی سریع',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        const _FeatureTile(
          icon: Icons.smart_toy_outlined,
          title: 'مدیریت عامل‌ها',
          subtitle: 'مشاهده و مدیریت عامل‌های متصل',
        ),
        const _FeatureTile(
          icon: Icons.add_task,
          title: 'ارسال وظیفه',
          subtitle: 'ثبت و پیگیری دستورهای جدید',
        ),
        const _FeatureTile(
          icon: Icons.insights_outlined,
          title: 'گزارش‌های اکوسیستم',
          subtitle: 'مشاهده رویدادها و خروجی‌ها',
        ),
        const SizedBox(height: 12),
        Text(
          'نسخه اولیه رابط کاربری — اتصال عملیاتی در مرحله بعد',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.blueGrey.shade400, fontSize: 12),
        ),
      ],
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.radio_button_checked, color: Colors.orange, size: 17),
                SizedBox(width: 8),
                Text('هسته هنوز متصل نیست'),
              ],
            ),
            const SizedBox(height: 14),
            const Text(
              'CIE Core',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              'رابط موبایل ایجاد شده؛ برای تبادل داده باید API هسته معرفی شود.',
              style: TextStyle(color: Colors.blueGrey.shade200, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  const _FeatureTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF27345B),
          child: Icon(icon, color: const Color(0xFFB7C1FF)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

class AgentsSection extends StatelessWidget {
  const AgentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const _PlaceholderSection(
      icon: Icons.smart_toy_outlined,
      title: 'عامل‌های هوشمند',
      description:
          'پس از اتصال API، وضعیت عامل‌هایی مانند ChatGPT، Perplexity و Grok در این بخش نمایش داده می‌شود.',
    );
  }
}

class TasksSection extends StatelessWidget {
  const TasksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const _PlaceholderSection(
      icon: Icons.checklist,
      title: 'مدیریت وظایف',
      description:
          'در مرحله اتصال به هسته، امکان ثبت دستور، مشاهده صف اجرا و پیگیری نتیجه اضافه خواهد شد.',
    );
  }
}

class ActivitySection extends StatelessWidget {
  const ActivitySection({super.key});

  @override
  Widget build(BuildContext context) {
    return const _PlaceholderSection(
      icon: Icons.receipt_long_outlined,
      title: 'گزارش فعالیت',
      description:
          'گزارش اجراها، خطاها، تصمیم‌ها و تغییرات اکوسیستم پس از راه‌اندازی سرویس ثبت رویداد نمایش داده می‌شود.',
    );
  }
}

class _PlaceholderSection extends StatelessWidget {
  const _PlaceholderSection({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 54, color: const Color(0xFF91A2FF)),
            const SizedBox(height: 18),
            Text(
              title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.blueGrey.shade200, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}
