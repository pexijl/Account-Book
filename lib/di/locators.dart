import 'package:account_book/database/app_database.dart';
import 'package:account_book/repositories/transaction_repository.dart';
import 'package:account_book/services/transaction_service.dart';
import 'package:get_it/get_it.dart' show GetIt;

final getIt = GetIt.instance;

Future<void> setupLocators() async {
  // 1. 先注册数据库（因为 Service 依赖它）
  getIt.registerSingleton<AppDatabase>(AppDatabase());

  // 2. 必须手动注册你的 Service！
  getIt.registerLazySingleton<TransactionRepository>(
    () => TransactionRepository(),
  ); // 注册仓库
  getIt.registerLazySingleton<TransactionService>(
    () => TransactionService(),
  ); // 注册服务
}
