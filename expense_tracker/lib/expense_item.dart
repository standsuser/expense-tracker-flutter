import 'package:flutter/material.dart';
import 'package:expense_tracker/expense.dart';

class ExpenseItem extends StatelessWidget {
  final ExpenseItemData expense;
  final Function(ExpenseItemData) onDelete;

  ExpenseItem({required this.expense, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    String formattedDate = '${expense.date.day}/${expense.date.month}/${expense.date.year}';

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Card(
        elevation: 4,
        child: ListTile(
          contentPadding: EdgeInsets.all(16.0),
          title: Text(expense.title),
          subtitle: Text('Amount: \$${expense.amount.toString()} | Date: $formattedDate'),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => onDelete(expense),
          ),
        ),
      ),
    );
  }
}
