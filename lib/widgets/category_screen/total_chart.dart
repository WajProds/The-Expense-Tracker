import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/database_provider.dart';

class TotalChart extends StatefulWidget {
  const TotalChart({super.key});

  @override
  State<TotalChart> createState() => _TotalChartState();
}

class _TotalChartState extends State<TotalChart> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(builder: (_, db, __) {
      var list = db.categories;
      var total = db.calculateTotalExpenses();

      return Row(
        children: [
          Expanded(
              flex: 60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.center,
                    child: Text(
                      'Total Expenses: ${NumberFormat.currency(locale: 'en_US', symbol: '\$').format(total)}',
                      textScaleFactor: 1.5,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  ...list.map((e) => Padding(
                        padding: const EdgeInsets.all(3),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              color: Colors.primaries[list.indexOf(e)],
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              e.title,
                              style: const TextStyle(color: (Colors.white)),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              total == 0
                                  ? '0%'
                                  : '${((e.totalAmount / total) * 100).toStringAsFixed(2)}%',
                              style: const TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ))
                ],
              )),
          Expanded(
            flex: 50,
            child: PieChart(
              PieChartData(
                borderData: FlBorderData(show: false),
                sectionsSpace: 2,
                centerSpaceRadius: 35,
                sections: total != 0
                    ? list
                        .map(
                          (e) => PieChartSectionData(
                            showTitle: false,
                            value: e.totalAmount,
                            color: Colors.primaries[list.indexOf(e)],
                          ),
                        )
                        .toList()
                    : list
                        .map(
                          (e) => PieChartSectionData(
                            showTitle: false,
                            color: Colors.primaries[list.indexOf(e)],
                          ),
                        )
                        .toList(),
              ),
            ),
          ),
        ],
      );
    });
  }
}
