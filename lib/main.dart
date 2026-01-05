import 'package:account_book/di/locators.dart';
import 'package:account_book/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'models/transaction.dart'; // 导入交易模型

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // final path = await getApplicationDocumentsDirectory();
  // print('Application Documents Directory: ${path.path}');
  final dir = await getApplicationSupportDirectory();
  // print('Application Support Directory: ${dir.path}');

  // 1. 初始化 Hive, 设置存储路径
  // windows: C:\Users\Lenovo\AppData\Roaming\com.manbo\account_book
  // android: /data/user/0/com.manbo.accountbook/files
  await Hive.initFlutter(dir.path);
  // await Hive.initFlutter();

  // await Hive.deleteBoxFromDisk('transactions_box'); // 重置数据盒子， 执行一次后删除或者注释掉

  // 2. 注册适配器
  Hive.registerAdapter(TransactionAdapter());
  Hive.registerAdapter(TransactionTypeAdapter());

  // 3. 执行 GetIt 初始化 (这会触发所有 Service 的 init)
  await setupLocators();

  // 4. 其他简单的配置 Box（如设置）可以留在这里或也存入 SettingService
  await Hive.openBox('settings');

  runApp(Routes());
}
