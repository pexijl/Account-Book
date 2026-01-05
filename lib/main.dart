import 'package:account_book/di/locators.dart';
import 'package:account_book/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // final path = await getApplicationDocumentsDirectory();
  // print('Application Documents Directory: ${path.path}');
  final dir = await getApplicationSupportDirectory();
  // print('Application Support Directory: ${dir.path}');

  // 执行 GetIt 初始化 (这会触发所有 Service 的 init)
  await setupLocators();

  runApp(Routes());
}
