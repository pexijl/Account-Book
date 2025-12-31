import 'package:account_book/screens/home/home_screen.dart';
import 'package:flutter/material.dart';

class Routes extends StatefulWidget {
  const Routes({super.key});

  @override
  State<Routes> createState() => _RoutesState();
}

class _RoutesState extends State<Routes> {
  final Map<String, WidgetBuilder> routes = {
    '/': (context) => const HomeScreen(),
  };
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Account Book',
      theme: ThemeData(primarySwatch: Colors.blue),
      routes: routes,
    );
  }
}
