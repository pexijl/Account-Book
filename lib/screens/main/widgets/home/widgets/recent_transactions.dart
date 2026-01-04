import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:account_book/models/transaction.dart';
import 'package:account_book/services/hive_transaction_service.dart';

class RecentTransactions extends StatefulWidget {
  const RecentTransactions({super.key});

  @override
  State<RecentTransactions> createState() => _RecentTransactionsState();
}

class _RecentTransactionsState extends State<RecentTransactions> {
  final HiveTransactionService _transactionService = HiveTransactionService();

  Future<void> _initTransactionService() async {
    await _transactionService.init();
  }

  @override
  void initState() {
    super.initState();
    _initTransactionService();
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
                TextButton(onPressed: () {}, child: Text('查看全部')),
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
                valueListenable: Hive.box<Transaction>(
                  'transactions_box',
                ).listenable(),
                builder: (context, box, _) {
                  // TODO: 实现懒加载
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
                      final isExpense =
                          transaction.type == TransactionType.expense;

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isExpense
                              ? Colors.red[50]
                              : Colors.green[50],
                          child: Icon(
                            isExpense ? Icons.remove : Icons.add,
                            color: isExpense ? Colors.red : Colors.green,
                          ),
                        ),
                        title: Text(transaction.category),
                        subtitle: Text(
                          transaction.date.toString().split(' ')[0],
                        ),
                        trailing: Text(
                          '${isExpense ? '-' : '+'}¥${transaction.amount.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: isExpense ? Colors.red : Colors.green,
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
