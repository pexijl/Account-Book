import 'package:account_book/di/locators.dart';
import 'package:account_book/services/transaction_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:account_book/models/transaction.dart';

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
      margin: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '最近交易',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    _transactionService.debugExportAsJson();
                  },
                  child: Text('查看全部'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ValueListenableBuilder<Box<Transaction>>(
                valueListenable: _transactionService.listenable(),
                builder: (context, box, _) {
                  final transactions = box.values.toList();
                  // 按日期降序排序
                  transactions.sort((a, b) => b.date.compareTo(a.date));
                  if (transactions.isEmpty) {
                    return const Center(child: Text('暂无交易记录'));
                  }
                  return ListView.builder(
                    itemCount: transactions.length > 10
                        ? 10
                        : transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: transaction.type.backgroundColor,
                          child: Icon(
                            transaction.type.icon,
                            color: transaction.type.color,
                          ),
                        ),
                        title: Text(transaction.category),
                        subtitle: Text(
                          transaction.date.toString().split(' ')[0],
                        ),
                        trailing: Text(
                          '${transaction.type == TransactionType.expense
                              ? '-'
                              : transaction.type == TransactionType.income
                              ? '+'
                              : '⇆'}¥${transaction.amount.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: transaction.type.color,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
