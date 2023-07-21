import 'package:expense_tracker/models/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseSearch extends StatefulWidget {
  const ExpenseSearch({super.key});

  @override
  State<ExpenseSearch> createState() => _ExpenseSearchState();
}

class _ExpenseSearchState extends State<ExpenseSearch> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DatabaseProvider>(context, listen: false);
    return Container(
        height: 70,
        margin: const EdgeInsets.only(
          top: 20,
          bottom: 0,
          right: 20,
          left: 20,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        decoration: BoxDecoration(
          border: Border.all(
              style: BorderStyle.solid, width: 0.7, color: Colors.transparent),
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(colors: [
            Colors.white,
            Colors.blue.shade100,
          ], begin: Alignment.centerLeft, end: Alignment.centerRight),
        ),
        child: TextField(
          onChanged: (value) {
            provider.searchText = value;
          },
          decoration: const InputDecoration(
              labelText: 'Search Expenses',
              labelStyle: TextStyle(color: Colors.deepPurple),
              suffixIcon: Icon(
                Icons.search,
                color: Colors.deepPurple,
              ),
              focusColor: Colors.deepPurple),
        ));
  }
}
