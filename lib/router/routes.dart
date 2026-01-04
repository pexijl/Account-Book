import 'package:account_book/screens/main/main_screen.dart';
import 'package:account_book/screens/main/widgets/home/home_screen.dart';
import 'package:account_book/screens/settings/settings_screen.dart';
import 'package:account_book/screens/transaction/add_transaction_screen.dart';
import 'package:flutter/material.dart';

class Routes extends StatefulWidget {
  const Routes({super.key});

  @override
  State<Routes> createState() => _RoutesState();
}

class _RoutesState extends State<Routes> {
  final Map<String, WidgetBuilder> routes = {
    '/': (context) => const MainScreen(),
    '/addTransaction': (context) => const AddTransactionScreen(),
    '/settings': (context) => const SettingsScreen(),
  };
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Account Book',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/', // TODO: 重置回 '/'
      routes: routes,
    );
  }
}
