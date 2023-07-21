import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../constants/icons.dart';
import '../../models/expense.dart';

import 'delete_dialog.dart';

class ExpenseCard extends StatelessWidget {
  final Expense exp;
  const ExpenseCard(this.exp, {super.key});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(exp.id),
      confirmDismiss: (_) async {
        return showDialog(
            context: context, builder: (_) => ConfirmBox(exp: exp));
      },
      background: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      ),
      direction: DismissDirection.endToStart,
      secondaryBackground: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              style: BorderStyle.solid,
              width: 0.7,
            ),
            color: Colors.red,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 22),
                child: Icon(Icons.delete),
              ),
            ],
          ),
        ),
      ),
      child: Container(
          height: 70,
          margin: const EdgeInsets.only(
            top: 20,
            bottom: 0,
            right: 20,
            left: 20,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          decoration: BoxDecoration(
            border: Border.all(
                style: BorderStyle.solid,
                width: 0.7,
                color: Colors.transparent),
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(colors: [
              Colors.deepPurple.shade400,
              Colors.blue.shade400,
            ], begin: Alignment.centerLeft, end: Alignment.centerRight),
          ),
          child: ListTile(
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(
                icons[exp.category],
                color: Colors.black87,
              ),
            ),
            title: Text(
              exp.title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            subtitle: Text(
              DateFormat('MMMM dd, yyyy').format(exp.date),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            trailing: Text(
              NumberFormat.currency(locale: 'en_US', symbol: '\$')
                  .format(exp.amount),
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
          )),
    );
  }
}
