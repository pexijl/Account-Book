import 'package:account_book/di/locators.dart';
import 'package:account_book/services/transaction_service.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _transactionService = getIt<TransactionService>(); // 通过 GetIt 获取服务
  final DateTime _currentMonth = DateTime.now();
  @override
  Widget build(BuildContext context) {
    // 1. 监听 TransactionService 提供的 Box 监听器
    return ValueListenableBuilder(
      valueListenable: _transactionService.listenable(),
      builder: (context, box, _) {
        // 2. 每次数据库变化，这里都会重新计算最新数值
        final surplus = _transactionService.getSurplus(date: _currentMonth);
        final income = _transactionService.getTotalIncome(date: _currentMonth);
        final expense = _transactionService.getTotalExpense(
          date: _currentMonth,
        );
        return Container(
          margin: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: 8,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple[400]!, Colors.indigo[400]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Column(
              children: [
                _SurplusSection(surplus: surplus),
                Expanded(
                  flex: 60,
                  child: Container(
                    margin: const EdgeInsets.only(left: 8, right: 8),
                    child: Row(
                      children: [
                        _StatCard(title: '收入', isIncome: true, amount: income),
                        _StatCard(
                          title: '支出',
                          isIncome: false,
                          amount: expense,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SurplusSection extends StatelessWidget {
  final double surplus;
  const _SurplusSection({required this.surplus});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 40,
      child: Container(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 20,
              child: Container(
                margin: const EdgeInsets.only(top: 8, left: 16),
                alignment: Alignment.centerLeft,
                child: Text(
                  '结余',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        offset: Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 30,
              child: Container(
                margin: const EdgeInsets.only(left: 16),
                alignment: Alignment.centerLeft,
                child: Text(
                  '${surplus.toStringAsFixed(3)} 元',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        offset: Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ],
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final bool isIncome;
  final double amount;
  const _StatCard({
    required this.title,
    required this.isIncome,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        alignment: Alignment.centerLeft,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Column(
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        offset: Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${isIncome ? '+' : '-'}${amount.toStringAsFixed(2)} 元',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        offset: Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ],
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
