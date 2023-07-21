import 'package:expense_tracker/screens/home_page.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import './models/database_provider.dart';
import './screens/expense_screen.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (_) => DatabaseProvider(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
      routes: {
        '/ExpenseScreen': (context) => const ExpenseScreen(),
      },
    );
  }
}
