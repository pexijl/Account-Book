import 'package:account_book/screens/assets/assets_screen.dart';
import 'package:account_book/screens/home/home_screen.dart';
import 'package:account_book/screens/report/report_screen.dart';
import 'package:account_book/screens/settings/settings_screen.dart';
import 'package:account_book/screens/transaction/transaction_list_screen.dart';
import 'package:account_book/app/components/custom_bottom_nav_bar.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  // 当前选中的页面索引
  int _currentIndex = 0;

  // 页面列表
  final List<Widget> _screens = [
    const HomeScreen(),
    const ReportScreen(),
    const AssetsScreen(),
    const SettingsScreen(),
  ];

  // 导航列表
  final List<BottomNavItem> _navItems = [
    BottomNavItem(icon: Icons.home, label: '首页'),
    BottomNavItem(icon: Icons.bar_chart, label: '统计'),
    BottomNavItem(icon: Icons.account_balance_wallet, label: '资产'),
    BottomNavItem(icon: Icons.settings, label: '设置'),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Account Book',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: _currentIndex,
          items: _navItems,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          onAddPressed: () {
            print('添加');
            // TODO: 打开添加记账页面
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => const TransactionListScreen(),
            //   ),
            // );
          },
        ),
        body: IndexedStack(index: _currentIndex, children: _screens),
      ),
    );
  }
}
