import 'package:expense_tracker/models/ex_cataory.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../constants/icons.dart';
import 'expense.dart';

class DatabaseProvider with ChangeNotifier {
  String _searchText = '';
  String get searchText => _searchText;
  set searchText(String value) {
    _searchText = value;
    notifyListeners();
  }

  List<ExpenseCategory> _categories = [];
  List<ExpenseCategory> get categories => _categories;
  List<Expense> _expenses = [];
  List<Expense> get expenses {
    return _searchText != ''
        ? _expenses
            .where((e) =>
                e.title.toLowerCase().contains(_searchText.toLowerCase()))
            .toList()
        : _expenses;
  }

  static const cTable = 'categoryTable';
  static const eTable = 'expenseTable';

  Database? _database;

  Future<void> deleteExpense(int expId, String category, double amount) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete(eTable, where: 'id == ?', whereArgs: [expId]).then((_) {
        _expenses.removeWhere((element) => element.id == expId);
        notifyListeners();

        var ex = findCategory(category);

        updateCategory(category, ex.entries - 1, ex.totalAmount - amount);
      });
    });
  }

  Future<Database> get database async {
    final dbDirectory = await getDatabasesPath();

    const dbName = 'expense_tk.db';

    final path = join(dbDirectory, dbName);

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
    notifyListeners();
    return _database!;
  }

  Future<void> _createDb(Database db, int version) async {
    await db.transaction((txn) async {
      await txn.execute('''CREATE TABLE $cTable(
      title TEXT,
      entries INTEGER,
      totalAmount TEXT
    )''');

      await txn.execute('''CREATE TABLE $eTable(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      amount TEXT,
      date TEXT,
      category TEXT
    )''');

      for (int i = 0; i < icons.length; i++) {
        await txn.insert(cTable, {
          'title': icons.keys.toList()[i],
          'entries': 0,
          'totalAmount': (0.0).toString(),
        });
      }
    });
  }

  Future<List<ExpenseCategory>> fetchCategories() async {
    final db = await database;
    return await db.transaction((txn) async {
      return await txn.query(cTable).then((data) {
        final converted = List<Map<String, dynamic>>.from(data);
        List<ExpenseCategory> nList = List.generate(converted.length,
            (index) => ExpenseCategory.fromString(converted[index]));

        _categories = nList;

        return _categories;
      });
    });
  }

  Future<void> updateCategory(
    String category,
    int nEntries,
    double nTotalAmount,
  ) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn
          .update(
        cTable,
        {
          'entries': nEntries,
          'totalAmount': nTotalAmount.toString(),
        },
        where: 'title == ?',
        whereArgs: [category],
      )
          .then((_) {
        var file =
            _categories.firstWhere((element) => element.title == category);
        file.entries = nEntries;
        file.totalAmount = nTotalAmount;
        notifyListeners();
      });
    });
  }

  Future<void> addExpense(Expense exp) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn
          .insert(
        eTable,
        exp.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      )
          .then((generatedId) {
        final file = Expense(
          id: generatedId,
          title: exp.title,
          date: exp.date,
          amount: exp.amount,
          category: exp.category,
        );
        _expenses.add(file);

        notifyListeners();

        var ex = findCategory(exp.category);

        updateCategory(
            exp.category, ex.entries + 1, ex.totalAmount + exp.amount);
      });
    });
  }

  Future<List<Expense>> fetchExpenses(String category) async {
    final db = await database;
    return await db.transaction((txn) async {
      return await txn.query(eTable,
          where: 'category == ?', whereArgs: [category]).then((data) {
        final converted = List<Map<String, dynamic>>.from(data);
        List<Expense> nList = List.generate(
            converted.length, (index) => Expense.fromString(converted[index]));
        _expenses = nList;
        return _expenses;
      });
    });
  }

  ExpenseCategory findCategory(String title) {
    return _categories.firstWhere((element) => element.title == title);
  }

  Map<String, dynamic> calculateEntriesAndAmount(String category) {
    double total = 0.0;
    var list = _expenses.where((element) => element.category == category);
    for (final i in list) {
      total += i.amount;
    }

    return {'entries': list.length, 'totalAmount': total};
  }

  double calculateTotalExpenses() {
    return _categories.fold(
        0.0, (previousValue, element) => previousValue + element.totalAmount);
  }

  List<Map<String, dynamic>> calculateWeekExpenses() {
    List<Map<String, dynamic>> data = [];

    for (int i = 0; i < 7; i++) {
      double total = 0;
      final weekDay = DateTime.now().subtract(Duration(days: i));

      for (int j = 0; j < _expenses.length; j++) {
        if (_expenses[j].date.year == weekDay.year &&
            _expenses[j].date.month == weekDay.month &&
            _expenses[j].date.day == weekDay.day) {
          total += _expenses[j].amount;
        }
      }
      data.add({'day': weekDay, 'amount': total});
    }

    return data;
  }

  Future<List<double>> weeklyExpenses()async{
    List<Expense> expenses = await fetchAllExpenses();
    List<double> data = [];

    

    double total = 0;
    for (int i = 0; i < 7; i++) {
      final weekDay = DateTime.now().subtract(Duration(days: i));

      for (int j = 0; j < expenses.length; j++) {
        if (expenses[j].date.year == weekDay.year &&
            expenses[j].date.month == weekDay.month &&
            expenses[j].date.day == weekDay.day) {
          total += expenses[j].amount;
        }
      }
    }

    data.add(total);
    // notifyListeners();
    return data;
  }

  Future<List<Expense>> fetchAllExpenses() async {
    final db = await database;
    return await db.transaction((txn) async {
      return await txn.query(eTable).then((data) {
        final converted = List<Map<String, dynamic>>.from(data);
        List<Expense> nList = List.generate(
            converted.length, (index) => Expense.fromString(converted[index]));
        _expenses = nList;
        return _expenses;
      });
    });
  }
}
