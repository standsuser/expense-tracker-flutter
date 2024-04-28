import 'dart:ffi';

class Expense {
  String id;
  String expenseTitle;
  double expenseAmount;
  DateTime expenseDate;

  Expense(
      {required this.id,
      required this.expenseTitle,
      required this.expenseAmount,
      required this.expenseDate});
}
