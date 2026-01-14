import 'package:account_book/screens/transaction/widgets/expense/expense.dart';
import 'package:account_book/screens/transaction/widgets/income/income.dart';
import 'package:account_book/screens/transaction/widgets/transfer/transfer.dart';
import 'package:flutter/material.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(
    length: 3,
    vsync: this,
  );

  final _tabs = [
    Tab(icon: Icon(Icons.arrow_downward), text: '支出'),
    Tab(icon: Icon(Icons.arrow_upward), text: '收入'),
    Tab(icon: Icon(Icons.compare_arrows), text: '转账'),
  ];

  final _tabPages = [const Expense(), const Income(), const Transfer()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('添加账单'),
        bottom: TabBar(controller: _tabController, tabs: _tabs),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
            tooltip: '设置',
          ),
        ],
      ),
      // TODO: 移除TabBarView页面，改为头部是一个表单设置交易类型，点击切换
      body: TabBarView(controller: _tabController, children: _tabPages),
    );
  }
}
