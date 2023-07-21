import 'package:expense_tracker/widgets/category_screen/total_chart.dart';

import 'package:expense_tracker/widgets/scroll_view/weekly_expenses.dart';

import 'package:flutter/material.dart';

class ListViewer extends StatelessWidget {
  final PageController _controller;
  const ListViewer(this._controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: PageView(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        children: const [
          TotalChart(),
          WeeklyExpense(),
        ],
      ),
    );
  }
}
