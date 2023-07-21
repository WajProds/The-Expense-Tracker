import 'package:flutter/material.dart';

import '../widgets/expense_screen/expense_fetcher.dart';

class ExpenseScreen extends StatelessWidget {
  const ExpenseScreen({super.key});
  static const name = '/expense_screen';

  @override
  Widget build(BuildContext context) {
    final category = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.deepPurple),
        centerTitle: true,
        elevation: 1,
        title: Text(
          category,
          style: const TextStyle(color: Colors.white, fontSize: 25),
        ),
      ),
      body: Container(
          padding: const EdgeInsets.only(top: 20),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black, Color.fromARGB(255, 22, 3, 46)])),
          child: ExpenseFetcher(category)),
    );
  }
}
