import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/ex_cataory.dart';

class CategoryCard extends StatelessWidget {
  final ExpenseCategory category;
  const CategoryCard(this.category, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 0, right: 0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
              style: BorderStyle.solid, width: 0.7, color: Colors.transparent),
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(colors: [
            Colors.deepPurple.shade400,
            Colors.blue.shade400,
          ], begin: Alignment.centerLeft, end: Alignment.centerRight),
        ),
        child: ListTile(
          onTap: () {
            Navigator.of(context).pushNamed(
              '/ExpenseScreen',
              arguments: category.title,
            );
          },
          leading: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(
              category.icon,
              color: Colors.black87,
            ),
          ),
          title: Text(
            category.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text('entries: ${category.entries}'),
          trailing: Text(
            NumberFormat.currency(locale: 'en_US', symbol: '\$')
                .format(category.totalAmount),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
