import 'package:expense_tracker/models/database_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ExpenseChart extends StatefulWidget {
  final String category;
  const ExpenseChart(this.category, {super.key});

  @override
  State<ExpenseChart> createState() => _ExpenseChartState();
}

class _ExpenseChartState extends State<ExpenseChart> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(builder: (_, db, __) {
      var maxY = db.calculateEntriesAndAmount(widget.category)['totalAmount'];
      var list = db.calculateWeekExpenses().reversed.toList();
      return Padding(
        padding: const EdgeInsets.only(top: 20, left: 13, right: 13),
        child: BarChart(
          BarChartData(
            borderData: FlBorderData(show: false),
            gridData: const FlGridData(show: false),
            backgroundColor: Colors.transparent,
            minY: 0,
            maxY: maxY,
            barTouchData: BarTouchData(
              allowTouchBarBackDraw: false,
              touchTooltipData:
                  BarTouchTooltipData(tooltipBgColor: Colors.black),
            ),
            barGroups: [
              ...list.map(
                (e) => BarChartGroupData(
                  x: list.indexOf(e),
                  barRods: [
                    BarChartRodData(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.deepPurple.shade500,
                          Colors.cyan,
                          Colors.blue.shade700,
                        ],
                        stops: const [
                          0.0,
                          0.5,
                          1.0,
                        ],
                      ),
                      toY: e['amount'],
                      width: 20.0,
                      borderRadius: BorderRadius.circular(20),
                    )
                  ],
                ),
              )
            ],
            titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                  drawBelowEverything: true,
                ),
                leftTitles: const AxisTitles(
                  drawBelowEverything: true,
                ),
                rightTitles: const AxisTitles(
                  drawBelowEverything: true,
                ),
                bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, _) => Text(
                    DateFormat.E().format(list[value.toInt()]['day']),
                    style: const TextStyle(color: Colors.white),
                  ),
                ))),
          ),
        ),
      );
    });
  }
}
