import 'package:account_book/screens/main/widgets/assets/assets_screen.dart';
import 'package:account_book/screens/main/widgets/home/home_screen.dart';
import 'package:account_book/screens/main/widgets/profile/profile.dart';
import 'package:account_book/screens/main/widgets/report/report_screen.dart';
import 'package:account_book/screens/main/widgets/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // 当前选中的页面索引
  int _currentIndex = 0;

  // 页面列表
  final List<Widget> _screens = [
    const HomeScreen(),
    const ReportScreen(),
    const AssetsScreen(),
    const Profile(),
  ];

  // 导航列表
  final List<BottomNavItem> _navItems = [
    BottomNavItem(icon: Icons.home, label: '首页'),
    BottomNavItem(icon: Icons.bar_chart, label: '统计'),
    BottomNavItem(icon: Icons.account_balance_wallet, label: '资产'),
    BottomNavItem(icon: Icons.person, label: '我的'),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Account Book',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        bottomNavigationBar: SafeArea(
          child: CustomBottomNavBar(
            currentIndex: _currentIndex,
            items: _navItems,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            onAddPressed: () {
              Navigator.pushNamed(context, '/addTransaction');
            },
          ),
        ),
        body: IndexedStack(index: _currentIndex, children: _screens),
      ),
    );
  }
}
