import 'package:account_book/database/app_database.dart';
import 'package:account_book/di/locators.dart';
import 'package:account_book/screens/main/widgets/home/widgets/recent_transaction_item.dart';
import 'package:account_book/services/transaction_service.dart';
import 'package:flutter/material.dart';

class RecentTransactions extends StatefulWidget {
  const RecentTransactions({super.key});

  @override
  State<RecentTransactions> createState() => _RecentTransactionsState();
}

class _RecentTransactionsState extends State<RecentTransactions> {
  final _transactionService = getIt<TransactionService>(); // 通过 GetIt 获取服务

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 550,
      margin: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: Column(children: [_buildHeader(), _buildBody()]),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '最近交易',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: () {
              // TODO: 跳转全部页面
            },
            child: const Text('查看全部'),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return StreamBuilder<List<Transaction>>(
      stream: _transactionService.watchRecentTransactions(6),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final transactions = snapshot.data ?? [];

        if (transactions.isEmpty) {
          return const Center(child: Text('暂无交易记录'));
        }

        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(), // 禁止滚动
          shrinkWrap: true, // 允许 ListView 填充剩余空间
          padding: EdgeInsets.zero,
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final transaction = transactions[index];
            return RecentTransactionItem(transaction: transaction);
          },
        );
      },
    );
  }
}
