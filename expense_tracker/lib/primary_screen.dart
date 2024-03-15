import 'package:flutter/material.dart';
import 'package:expense_tracker/expense_item.dart';

class PrimaryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Overall Expenses:',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              '\$1000', // Replace with actual overall expenses
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: 5, // Replace with actual number of expenses
                itemBuilder: (BuildContext context, int index) {
                  return ExpenseItem(
                    title: 'Expense ${index + 1}',
                    amount: 100, // Replace with actual amount
                    date: DateTime.now(), // Replace with actual date
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Open bottom sheet for adding new expense
          // Implement this
        },
        tooltip: 'Add Expense',
        child: Icon(Icons.add),
      ),
    );
  }
}
