import 'package:flutter/material.dart';
import 'package:expense_tracker/expense_item.dart';
import 'package:expense_tracker/expense_entry_bottom_sheet.dart';
import 'package:expense_tracker/expense.dart';

class PrimaryScreen extends StatefulWidget {
  @override
  _PrimaryScreenState createState() => _PrimaryScreenState();
}

class _PrimaryScreenState extends State<PrimaryScreen> {
  List<ExpenseItemData> expenses = [];
  double totalExpenses = 0.0;

  void addExpense(ExpenseItemData expense) {
    setState(() {
      expenses.add(expense);
      totalExpenses += expense.amount;
    });
  }

  void removeExpense(ExpenseItemData expense) {
    setState(() {
      expenses.remove(expense);
      totalExpenses -= expense.amount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Masroufi Builder',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
body: Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Container(
        width: double.infinity,
        margin: EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Total Expenses: \$${totalExpenses.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
      ),
      SizedBox(height: 20),
      Expanded(
        child: ListView.builder(
          itemCount: expenses.length,
          itemBuilder: (BuildContext context, int index) {
            return ExpenseItem(
              expense: expenses[index],
              onDelete: removeExpense,
            );
          },
        ),
      ),
    ],
  ),
),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return ExpenseEntryBottomSheet(addExpense: addExpense);
            },
          );
        },
        tooltip: 'Add Expense',
        child: Icon(Icons.add),
      ),
    );
  }
}
