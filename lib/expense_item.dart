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
          title: Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: Text(
                    '\$${expense.amount.toStringAsFixed(2)}',
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    expense.title,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
          subtitle: Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  '| Date: $formattedDate',
                ),
              ),
            ],
          ),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => onDelete(expense),
          ),
        ),
      ),
    );
  }
}
