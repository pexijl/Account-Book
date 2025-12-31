# account_book

A new Flutter project.

## 项目结构

```txt
finance_tracker/
├── android/                    # Android平台代码
├── ios/                      # iOS平台代码
├── lib/
│   ├── main.dart              # 应用入口
│   ├── app/                   # 应用配置
│   │   ├── app.dart           # 主应用Widget
│   │   ├── constants.dart     # 应用常量
│   │   ├── theme.dart         # 主题配置
│   │   └── routes.dart        # 路由配置
│   ├── models/                # 数据模型
│   │   ├── transaction.dart   # 交易模型
│   │   ├── category.dart      # 分类模型
│   │   ├── account.dart       # 账户模型
│   │   └── budget.dart        # 预算模型
│   ├── data/                  # 数据层
│   │   ├── local/            # 本地数据
│   │   │   ├── database.dart  # 数据库（SQLite）
│   │   │   ├── dao/          # 数据访问对象
│   │   │   └── repositories/  # 本地仓库实现
│   │   └── repositories/      # 仓库接口
│   ├── services/              # 业务逻辑层
│   │   ├── transaction_service.dart
│   │   ├── category_service.dart
│   │   ├── budget_service.dart
│   │   ├── report_service.dart
│   │   └── notification_service.dart
│   ├── screens/               # 页面/屏幕
│   │   ├── home/             # 首页相关
│   │   │   ├── home_screen.dart
│   │   │   └── home_viewmodel.dart
│   │   ├── transaction/       # 交易页面
│   │   │   ├── add_transaction_screen.dart
│   │   │   ├── transaction_list_screen.dart
│   │   │   └── transaction_detail_screen.dart
│   │   ├── category/          # 分类管理
│   │   │   ├── category_manage_screen.dart
│   │   │   └── category_edit_screen.dart
│   │   ├── report/           # 报表页面
│   │   │   ├── report_screen.dart
│   │   │   ├── chart_screen.dart
│   │   │   └── statistics_screen.dart
│   │   ├── budget/           # 预算页面
│   │   │   └── budget_screen.dart
│   │   └── settings/         # 设置页面
│   │       └── settings_screen.dart
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
