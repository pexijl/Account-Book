import 'package:account_book/screens/home/components/dashboard.dart';
import 'package:account_book/screens/home/components/recent_transactions.dart';
import 'package:account_book/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:file_picker/file_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
              child: Text('2026年3月15日 星期日', style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: IconButton(
              iconSize: 32,
              icon: const Icon(Icons.add),
              tooltip: '快速记账',
              onPressed: () {
                // TODO:快速记账逻辑
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
              Expanded(
                flex: 1,
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  alignment: Alignment.center,
                  child: FilledButton(
                    onPressed: () {
                      // TODO: 实现快速记账
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('快速记账'),
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
