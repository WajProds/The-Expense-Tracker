import 'package:flutter/material.dart';

import '../widgets/all_expenses_screen/all_expenses_fetcher.dart';

class AllExpenses extends StatefulWidget {
  const AllExpenses({super.key});
  static const name = '/all_expenses';

  @override
  State<AllExpenses> createState() => _AllExpensesState();
}

class _AllExpensesState extends State<AllExpenses> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.deepPurple),
        centerTitle: true,
        elevation: 1,
        title: const Text(
          'All Expenses',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black, Color.fromARGB(255, 23, 3, 50)])),
          child: const AllExpensesFetcher()),
    );
  }
}
