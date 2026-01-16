import 'package:account_book/database/app_database.dart';
import 'package:account_book/models/enums.dart';
import 'package:flutter/material.dart';

class RecentTransactionItem extends StatelessWidget {
  final Transaction transaction;
  const RecentTransactionItem({super.key, required this.transaction});

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

  @override
  Widget build(BuildContext context) {
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
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          // 这里假设你在 TransactionType 枚举里定义了扩展方法处理颜色和图标
          backgroundColor: _getBackgroundColor(transaction.type),
          child: Icon(
            _getIcon(transaction.type),
            color: _getColor(transaction.type),
          ),
        ),
        title: Text(transaction.category),
        subtitle: Text(transaction.date.toString().split(' ')[0]),
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
  }
}
