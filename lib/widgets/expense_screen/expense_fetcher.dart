import 'package:expense_tracker/models/database_provider.dart';

import 'package:expense_tracker/widgets/expense_screen/expense_chart.dart';
import 'package:expense_tracker/widgets/expense_screen/expense_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseFetcher extends StatefulWidget {
  final String category;
  const ExpenseFetcher(this.category, {super.key});

  @override
  State<ExpenseFetcher> createState() => _ExpenseFetcherState();
}

class _ExpenseFetcherState extends State<ExpenseFetcher> {
  late Future _expenseList;
  Future _getExpenseList() async {
    final provider = Provider.of<DatabaseProvider>(context, listen: false);
    return await provider.fetchExpenses(widget.category);
  }

  @override
  void initState() {
    _expenseList = _getExpenseList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _expenseList,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Weekly Chart',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    SizedBox(
                      height: 250.0,
                      child: ExpenseChart(widget.category),
                    ),
                    const Expanded(child: ExpenseList()),
                    
                  ],
                ),
              );
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
