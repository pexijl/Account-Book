import 'package:account_book/screens/assets/assets_screen.dart';
import 'package:account_book/screens/home/home_screen.dart';
import 'package:account_book/screens/report/report_screen.dart';
import 'package:account_book/screens/settings/settings_screen.dart';
import 'package:account_book/screens/transaction/transaction_list_screen.dart';
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
  final List<Widget> _pages = [
    const HomeScreen(),
    const ReportScreen(),
    const AssetsScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Account Book',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
            BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: '统计'),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance),
              label: '资产',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: '设置'),
          ],
        ),
        body: IndexedStack(index: _currentIndex, children: _pages),
      ),
    );
  }
}
