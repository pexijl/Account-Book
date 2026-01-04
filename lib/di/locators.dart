import 'package:account_book/services/transaction_service.dart';
import 'package:get_it/get_it.dart' show GetIt;

final getIt = GetIt.instance;

Future<void> setupLocators() async {
  // 注册为单例 (Singleton)
  // getIt.registerSingleton<AppSettingService>(AppSettingService());
  // await getIt<AppSettingService>().init();

  // getIt.registerSingleton<CategoryService>(CategoryService());
  // await getIt<CategoryService>().init();

  // 注册 TransactionService 为单例
  final transactionService = TransactionService();

  // 核心步骤：在此处初始化 Service 内部的 Box
  await transactionService.init();

  // 将初始化完成的服务交给 GetIt 管理
  getIt.registerSingleton<TransactionService>(transactionService);
}
