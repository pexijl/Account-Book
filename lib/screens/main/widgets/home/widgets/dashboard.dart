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
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple[400]!, Colors.indigo[400]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _SurplusSection(
            stream: _transactionService.watchTotalBalance(date: _currentMonth),
          ),
          Expanded(
            flex: 60,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  _StatCard(
                    title: '收入',
                    isIncome: true,
                    stream: _transactionService.watchTotalIncome(),
                  ),
                  _StatCard(
                    title: '支出',
                    isIncome: false,
                    stream: _transactionService.watchTotalExpense(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SurplusSection extends StatelessWidget {
  final Stream<double>? stream;
  const _SurplusSection({required this.stream});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, asyncSnapshot) {
        final surplus = asyncSnapshot.data ?? 0.0;
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
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final bool isIncome;
  final Stream<double>? stream;
  const _StatCard({
    required this.title,
    required this.isIncome,
    required this.stream,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, asyncSnapshot) {
        final amount = asyncSnapshot.data ?? 0.0;
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
      },
    );
  }
}
