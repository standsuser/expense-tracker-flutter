import 'package:flutter/material.dart';
import 'package:expense_tracker/expense_item.dart';
import 'package:expense_tracker/expense_entry_bottom_sheet.dart';
import 'package:expense_tracker/expense.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_database/firebase_database.dart'; // Import the Firebase Realtime Database package



// // Set the custom Realtime Database URL
// final rtdb = FirebaseDatabase.instanceFor(
//   app: firebaseApp,
//   databaseURL: 'https://masroufi-201e5-default-rtdb.firebaseio.com/expenses.json',
// );

class PrimaryScreen extends StatefulWidget {
  @override
  _PrimaryScreenState createState() => _PrimaryScreenState();
}

class _PrimaryScreenState extends State<PrimaryScreen> {
  List<ExpenseItemData> expenses = [];
  double totalExpenses = 0.0;

void addExpense(ExpenseItemData expense) async {
  // Add the expense locally
  setState(() {
    expenses.add(expense);
    totalExpenses += expense.amount;
  });

  // Get a reference to the Realtime Database
  final DatabaseReference databaseRef = FirebaseDatabase.instance.reference();

  // Create a new child node under 'expenses' with a unique key
  final DatabaseReference expenseRef = databaseRef.child('expenses').push();

  // Set the expense data
  await expenseRef.set({
    'title': expense.title,
    'amount': expense.amount,
    'date': expense.date.toIso8601String(), // Convert DateTime to ISO 8601 format
    // Add any other relevant fields here
  });

  print('Expense added to the database successfully.');

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
