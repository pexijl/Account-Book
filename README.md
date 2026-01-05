# account_book

一个基于Flutter的个人记账应用.

## 项目结构

```txt
account_book/
├── android/                  # Android平台代码
├── ios/                      # iOS平台代码
├── lib/
│   ├── main.dart              # 应用入口
│   ├── app/                   # 应用配置
│   │   ├── constants.dart     # 应用常量
│   │   ├── theme.dart         # 主题配置
│   ├── models/                # 数据模型
│   │   ├── account.dart       # 账户模型
│   │   ├── budget.dart        # 预算模型
│   │   ├── category.dart      # 分类模型
│   │   └── transaction.dart   # 交易模型
│   ├── database/                  # 数据层
│   │   ├── tables/            # 数据表定义
│   │   └── app_database.dart  # 数据库（SQLite）
│   ├── di/                  # get_it 配置
│   ├── repositories/                  # 仓库层
│   │   └──  transaction_repository.dart # 交易数据仓库
│   ├── services/              # 业务逻辑层
│   │   ├── budget_service.dart
│   │   ├── category_service.dart
│   │   ├── notification_service.dart
│   │   ├── report_service.dart
│   │   └── transaction_service.dart
│   ├── screens/              # UI页面
│   │   ├── category/         # 分类管理
│   │   ├── main/             # 主页面
│   │   │   ├── widgets/           # 主页面组件
│   │   │   │   ├── assets/         # 资产页面组件
│   │   │   │   ├── home/           # 首页组件
│   │   │   │   ├── profile/        # 个人中心组件
│   │   │   │   ├── report/         # 报表页面组件
│   │   │   │   └── custom_bottom_nav_bar.dart  # 底部导航栏
│   │   │   └── main_screen.dart     # 主页面
│   │   └── settings/         # 设置页面
│   │   ├── transaction/      # 交易页面
│   ├── router/               # 路由管理
│   │   └── routes.dart        # 路由配置
│   ├── widgets/              # 可复用组件
│   │   ├── common/           # 通用组件
│   │   │   ├── app_button.dart
│   │   │   ├── app_text_field.dart
│   │   │   └── loading_indicator.dart
│   │   ├── transaction/      # 交易相关组件
│   │   │   ├── transaction_item.dart
│   │   │   ├── transaction_list.dart
│   │   │   └── amount_input.dart
│   │   ├── charts/           # 图表组件
│   │   │   ├── pie_chart.dart
│   │   │   ├── bar_chart.dart
│   │   │   └── line_chart.dart
│   │   └── dashboard/        # 首页仪表板组件
│   │       ├── balance_card.dart
│   │       ├── quick_action.dart
│   │       └── recent_transactions.dart
│   ├── utils/               # 工具类
│   │   ├── formatters.dart  # 格式化工具
│   │   ├── validators.dart  # 验证工具
│   │   ├── helpers.dart     # 辅助函数
│   │   └── enums.dart       # 枚举类型
│   └── state/               # 状态管理
│       ├── providers/       # Provider相关
│       └── viewmodels/      # ViewModel
├── assets/                  # 静态资源
│   ├── images/             # 图片资源
│   │   ├── icons/          # 图标
│   │   │   ├── food.png
│   │   │   ├── transportation.png
│   │   │   └── salary.png
│   │   └── logos/
│   └── fonts/              # 字体文件
├── test/                   # 测试文件
├── pubspec.yaml           # 依赖配置
└── README.md
```

敏感信息（Token）: flutter_secure_storage
应用设置: shared_preferences
业务相关: drift
导出报表: path_provider

# drift 使用指南

创建数据库文件：

1. 创建数据库文件 `lib/database/app_database.dart`，定义数据表和DAO。
2. 创建表 `lib/database/tables/` 目录下的Dart文件，定义数据表结构。

运行命令：

```cmd
flutter pub run build_runner build --delete-conflicting-outputs
```

```
层次,操作类型,返回值建议,理由
Repository,基础查询,Stream<List<T>>,提供响应式数据源
Repository,基础增删改,Future<int/void>,数据库操作是瞬间任务
Service,复杂逻辑聚合,Stream<CustomModel>,将多个 Repo 的流合并（如 SurplusStream）
Service,业务流程,Future<Result>,比如“保存并关闭页面”这种逻辑流

总结建议
UI 层的 ListView 和 Text 数字：全部接入 Stream。
点击按钮后的 save 逻辑：全部使用 Future。
```