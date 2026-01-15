import 'package:account_book/database/app_database.dart';
import 'package:account_book/di/locators.dart';
import 'package:account_book/models/enums.dart';
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
      height: 450,
      margin: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: StreamBuilder<List<Transaction>>(
              stream: _transactionService.watchRecentTransactions(10),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final transactions = snapshot.data ?? [];

                if (transactions.isEmpty) {
                  return const Center(child: Text('暂无交易记录'));
                }

                return ListView.builder(
                  controller: PrimaryScrollController.of(context),
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = transactions[index];

                    // 注意：Drift 生成的 Transaction 对象字段名
                    // 与你在 tables.dart 中定义的一致
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 2), // 阴影位置
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          // 这里假设你在 TransactionType 枚举里定义了扩展方法处理颜色和图标
                          backgroundColor: _getBackgroundColor(
                            transaction.type,
                          ),
                          child: Icon(
                            _getIcon(transaction.type),
                            color: _getColor(transaction.type),
                          ),
                        ),
                        title: Text(transaction.category),
                        subtitle: Text(
                          transaction.date.toString().split(' ')[0],
                        ),
                        trailing: Text(
                          '${_getSymbol(transaction.type)}¥${transaction.amount.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: _getColor(transaction.type),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getSymbol(TransactionType type) {
    switch (type) {
      case TransactionType.expense:
        return '-';
      case TransactionType.income:
        return '+';
      case TransactionType.transfer:
        return '⇆';
    }
  }

  Color _getColor(TransactionType type) =>
      type == TransactionType.income ? Colors.green : Colors.red;
  IconData _getIcon(TransactionType type) =>
      type == TransactionType.income ? Icons.add : Icons.remove;
  Color _getBackgroundColor(TransactionType type) =>
      _getColor(type).withValues(alpha: 0.1);

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
}
