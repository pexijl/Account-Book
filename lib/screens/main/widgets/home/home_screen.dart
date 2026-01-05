import 'package:account_book/screens/main/widgets/home/widgets/dashboard.dart';
import 'package:account_book/screens/main/widgets/home/widgets/recent_transactions.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DateTime _currentTime = DateTime.now();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                '仪表盘',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                '${_currentTime.year}年${_currentTime.month}月${_currentTime.day}日 星期${["日", "一", "二", "三", "四", "五", "六"][_currentTime.weekday % 7]}',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
        actions: [
          // TODO: 其他操作按钮
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: IconButton(
              iconSize: 32,
              icon: const Icon(Icons.delete_forever),
              tooltip: '清空交易',
              onPressed: () {
                // TODO: 清空交易
                // _transactionService.clearAll();
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Expanded(flex: 4, child: Dashboard()),
              Expanded(flex: 9, child: RecentTransactions()),
            ],
          ),
        ),
      ),
    );
  }
}
