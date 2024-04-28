import 'package:flutter/material.dart';
import 'package:expense_tracker/expense.dart';
import 'package:firebase_database/firebase_database.dart';
import 'primary_screen.dart';
import 'expense_entry_bottom_sheet.dart';
import 'expense.dart';

class ExpenseItem extends StatelessWidget {
  final Expense expense;
  final Function(Expense) onDelete;

  ExpenseItem({required this.expense, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    String formattedDate = '${expense.expenseDate}';

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
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
                    '\$${expense.expenseAmount.toStringAsFixed(2)}',
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    expense.expenseTitle,
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
