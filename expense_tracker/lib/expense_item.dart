import 'package:flutter/material.dart';

class ExpenseItem extends StatelessWidget {
  final String title;
  final double amount;
  final DateTime date;

  ExpenseItem({
    required this.title,
    required this.amount,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text('Amount: \$${amount.toString()} | Date: ${date.toString()}'),
    );
  }
}
