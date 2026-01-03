import 'package:account_book/screens/main/main_screen.dart';
import 'package:account_book/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/transaction.dart'; // 导入交易模型

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. 初始化 Hive
  await Hive.initFlutter();

  // 2. 注册 TypeAdapter（生成适配器后取消注释）
  // 注意：需要先运行 flutter packages pub run build_runner build
  Hive.registerAdapter(TransactionAdapter());
  Hive.registerAdapter(TransactionTypeAdapter());

  // 3. 打开 Box（可以预打开，也可以在使用时打开）
  await Hive.openBox('settings');
  await Hive.openBox<Transaction>('transactions_box');

  runApp(Routes());
}
