import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import '../constants/icons.dart';
import 'package:provider/provider.dart';
import '../models/database_provider.dart';

class ExpenseForm extends StatefulWidget {
  const ExpenseForm({
    super.key,
    required NotchBottomBarController controller,
    required PageController pageController,
  })  : _controller = controller,
        _pageController = pageController;

  final NotchBottomBarController _controller;
  final PageController _pageController;

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class PageChanger {
  void changePage(NotchBottomBarController controller,
      PageController pageController, int index) {
    controller.jumpTo(index);
    pageController.jumpToPage(index);
  }
}

class _ExpenseFormState extends State<ExpenseForm> {
  final _title = TextEditingController();
  final _amount = TextEditingController();
  DateTime? _date;
  String _initialValue = 'Other';
  _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2022),
        lastDate: DateTime.now());

    if (pickedDate != null) {
      if (mounted) {
        setState(() {
          _date = pickedDate;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DatabaseProvider>(context, listen: false);
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomCenter,
              colors: [Colors.black54, Color.fromARGB(255, 31, 5, 66)])),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            const Text(
              'Add Expense',
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 20.0),
            Container(
              padding: const EdgeInsets.only(right: 275, top: 30, bottom: 5),
              child: Text(
                'Title',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade300),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 0,
                bottom: 20,
                right: 20,
                left: 20,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10)),
              child: TextField(
                controller: _title,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(right: 45),
                  hintText: 'Title of expense',
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Container(
              padding: const EdgeInsets.only(right: 250, top: 0, bottom: 5),
              child: Text(
                'Amount',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade300),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 0,
                bottom: 20,
                right: 20,
                left: 20,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10)),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: _amount,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(right: 45),
                  hintText: 'Amount of expense',
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                const Padding(padding: EdgeInsets.symmetric(horizontal: 13)),
                Expanded(
                    child: Text(
                  _date != null
                      ? DateFormat('MMMM dd, yyyy').format(_date!)
                      : 'Select Date',
                  style: TextStyle(color: Colors.grey.shade300),
                )),
                IconButton(
                    padding: const EdgeInsets.only(right: 20),
                    onPressed: () => _pickDate(),
                    icon: Icon(
                      Icons.calendar_month,
                      color: Colors.deepPurpleAccent.shade700,
                    )),
              ],
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                const Padding(padding: EdgeInsets.symmetric(horizontal: 13)),
                Expanded(
                  child: Text(
                    'Category',
                    style: TextStyle(color: Colors.grey.shade300),
                  ),
                ),
                Expanded(
                    child: DropdownButton(
                  padding: const EdgeInsets.only(right: 22),
                  borderRadius: BorderRadius.circular(20),
                  dropdownColor: const Color.fromARGB(255, 19, 19, 19),
                  items: icons.keys
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(
                              e,
                              style: TextStyle(color: Colors.grey.shade300),
                            ),
                          ))
                      .toList(),
                  value: _initialValue,
                  onChanged: (newValue) {
                    if (mounted) {
                      setState(() {
                        _initialValue = newValue!;
                      });
                    }
                  },
                ))
              ],
            ),
            const SizedBox(height: 20.0),
            ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(
                      Colors.deepPurpleAccent.shade400),
                ),
                onPressed: () {
                  if (_title.text != '' && _amount.text != '') {
                    final file = Expense(
                      id: 0,
                      title: _title.text,
                      date: _date != null ? _date! : DateTime.now(),
                      amount: double.parse(_amount.text),
                      category: _initialValue,
                    );

                    PageChanger().changePage(
                        widget._controller, widget._pageController, 0);

                    provider.addExpense(file);
                  }
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Expense')),
          ],
        ),
      ),
    );
  }
}
