import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/database_provider.dart';
import '../../models/expense.dart';

class WeeklyExpense extends StatefulWidget {
  const WeeklyExpense({super.key});

  @override
  State<WeeklyExpense> createState() => _WeeklyExpenseState();
}

class _WeeklyExpenseState extends State<WeeklyExpense> {
  late Future data;
  Future _weeklyExpenses() async {
    final provider = Provider.of<DatabaseProvider>(context, listen: false);
    return await provider.weeklyExpenses();
  }

  @override
  void initState() {
    data = _weeklyExpenses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else {
              return SizedBox(
                height: 250.0,
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              child: const Text(
                                'Spent this Week:',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            Consumer<DatabaseProvider>(builder: (_, db, __) {
                              var list = db.expenses;
                              List<double> data = [];
                              List<double> weeklyExpenses() {
                                List<Expense> expenses = list;

                                double total = 0;
                                for (int i = 0; i < 7; i++) {
                                  final weekDay = DateTime.now()
                                      .subtract(Duration(days: i));

                                  for (int j = 0; j < expenses.length; j++) {
                                    if (expenses[j].date.year == weekDay.year &&
                                        expenses[j].date.month ==
                                            weekDay.month &&
                                        expenses[j].date.day == weekDay.day) {
                                      total += expenses[j].amount;
                                    }
                                  }
                                }

                                data.add(total);
                             
                                return data;
                              }

                              double tit = weeklyExpenses()[0];

                              return Text(
                                NumberFormat.currency(
                                        locale: 'en_US', symbol: '\$')
                                    .format(tit),
                                style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
