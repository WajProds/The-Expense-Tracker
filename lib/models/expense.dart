

class Expense {
  final int id;
  final String title;
  final DateTime date;
  final double amount;
  final String category;

  Expense({
    required this.id,
    required this.title,
    required this.date,
    required this.amount,
    required this.category,
  });

  Map<String, dynamic> toMap() => {
        'title': title,
        'date': date.toString(),
        'amount': amount.toString(),
        'category': category,
      };

  factory Expense.fromString(Map<String, dynamic> value) => Expense(
      id: value['id'],
      title: value['title'],
      date: DateTime.parse(value['date']),
      amount: double.parse(value['amount']),
      category: value['category']);
}
 