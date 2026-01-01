# Hive 使用指南

## 📦 什么是 Hive？

Hive 是一个轻量级、快速的键值对数据库，专为 Flutter 设计。它不需要原生配置，支持所有平台。

## 🚀 快速开始

### 1. 配置已完成 ✅

在 `pubspec.yaml` 中已添加：
- `hive: ^2.2.3` - Hive 核心
- `hive_flutter: ^1.1.0` - Flutter 集成
- `hive_generator: ^2.0.1` - 代码生成器
- `build_runner: ^2.4.13` - 构建工具

### 2. 生成 TypeAdapter

运行以下命令生成适配器：

```bash
flutter pub get
flutter packages pub run build_runner build
```

### 3. 注册 Adapter（在 main.dart 中）

```dart
import 'package:hive_flutter/hive_flutter.dart';
import 'models/transaction.dart'; // 导入你的模型

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化 Hive
  await Hive.initFlutter();

  // 注册 TypeAdapter
  Hive.registerAdapter(TransactionAdapter());
  Hive.registerAdapter(TransactionTypeAdapter());

  // 打开 Box
  await Hive.openBox<Transaction>('transactions_box');

  runApp(MyApp());
}
```

## 📝 两种使用方式

### 方式 1️⃣：存储基本类型和 Map

查看：`lib/services/storage_service.dart`

**优点：**
- 简单快速，无需代码生成
- 适合简单数据结构

**示例：**
```dart
final storage = StorageService();

// 保存数据
await storage.saveSetting('theme', 'dark');
await storage.saveSetting('budget', 1000.0);

// 读取数据
final theme = storage.getSetting<String>('theme');
final budget = storage.getSetting<double>('budget');

// 保存复杂对象（Map）
await storage.saveTransaction({
  'id': 1,
  'amount': 50.0,
  'category': 'food',
  'date': DateTime.now(),
});
```

### 方式 2️⃣：存储自定义对象（推荐）

查看：
- 模型：`lib/models/transaction.dart`
- 服务：`lib/services/hive_transaction_service.dart`

**优点：**
- 类型安全
- 更好的性能
- 支持对象方法
- IDE 自动补全

**步骤：**

#### Step 1: 创建模型

```dart
import 'package:hive/hive.dart';

part 'transaction.g.dart'; // 声明生成的文件

@HiveType(typeId: 0) // 唯一类型 ID (0-223)
class Transaction extends HiveObject {
  @HiveField(0) // 字段编号（必须连续）
  late int id;

  @HiveField(1)
  late double amount;

  @HiveField(2)
  late String category;

  Transaction({
    required this.id,
    required this.amount,
    required this.category,
  });
}
```

#### Step 2: 生成适配器

```bash
flutter packages pub run build_runner build
```

#### Step 3: 使用服务

```dart
final service = HiveTransactionService();
await service.init();

// 添加交易
final transaction = Transaction.expense(
  id: 1,
  amount: 50.0,
  category: '餐饮',
  date: DateTime.now(),
  note: '午餐',
);
await service.addTransaction(transaction);

// 获取所有交易
final all = service.getAllTransactions();

// 按类型查询
final expenses = service.getTransactionsByType(TransactionType.expense);

// 统计
final balance = service.getBalance();
```

## 🎯 核心概念

### Box（盒子）
Box 是数据的容器，类似于数据库的表：

```dart
// 打开 Box
final box = await Hive.openBox<Transaction>('my_box');

// 或者懒加载（第一次使用时自动打开）
final box = await Hive.openBoxLazy<Transaction>('my_box');
```

### HiveObject
让你的模型继承 `HiveObject`，获得额外方法：

```dart
class Transaction extends HiveObject {
  // ...
}

// 使用示例
final transaction = Transaction(...);
await box.put(1, transaction);

// 直接操作
await transaction.save(); // 保存到当前 box
await transaction.delete(); // 从 box 删除
```

## 💡 最佳实践

### 1. TypeID 管理
- 每个 TypeAdapter 必须有唯一的 typeId (0-223)
- 建议创建常量管理：
```dart
class HiveTypeIds {
  static const int transaction = 0;
  static const int category = 1;
  static const int budget = 2;
  // ...
}
```

### 2. Box 管理
创建服务类封装 Box 操作（参考 `hive_transaction_service.dart`）

### 3. 错误处理
```dart
try {
  await service.addTransaction(transaction);
} catch (e) {
  print('保存失败: $e');
}
```

### 4. 数据加密（敏感数据）
使用 Hive 的加密功能：
```dart
final encryptionCipher = HiveAesCipher(await _getKey());
await Hive.openBox('secureBox', encryptionCipher: encryptionCipher);
```

## 📊 数据存储位置

Hive 自动选择合适的存储位置：

- **Android**: `/data/data/你的包名/files/hive/
- **iOS**: `应用沙盒/Library/Application Support/hive/
- **Windows**: `%APPDATA%/你的应用名/hive/
- **macOS**: `~/Library/Application Support/你的应用名/hive/
- **Linux**: `~/.config/你的应用名/hive/

## 🔧 常用命令

```bash
# 安装依赖
flutter pub get

# 生成适配器（首次）
flutter packages pub run build_runner build

# 删除生成的适配器
flutter packages pub run build_runner clean

# 重新生成（有冲突时使用）
flutter packages pub run build_runner build --delete-conflicting-outputs

# 监听模式（开发时自动重新生成）
flutter packages pub run build_runner watch
```

## 📚 更多资源

- [Hive 官方文档](https://docs.hivedb.dev/)
- [Hive GitHub](https://github.com/hivedb/hive)
- [pub.dev: hive](https://pub.dev/packages/hive)

## ⚠️ 注意事项

1. **typeId 不能重复**：整个应用中唯一
2. **字段编号必须连续**：@HiveField(0), @HiveField(1), ...
3. **修改模型后要重新生成**：运行 build_runner
4. **不要跳过字段编号**：会影响性能
5. **生产环境考虑加密**：敏感数据要加密存储

## 🎉 项目中的应用

本项目已创建：

- ✅ `lib/services/storage_service.dart` - 基本类型存储示例
- ✅ `lib/models/transaction.dart` - 自定义模型示例
- ✅ `lib/services/hive_transaction_service.dart` - 完整的服务实现

可以直接使用这些服务开始开发！
