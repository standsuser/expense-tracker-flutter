import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:expense_tracker/main.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/expense_item.dart';
import 'package:expense_tracker/expense_entry_bottom_sheet.dart';
import 'package:expense_tracker/expense.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_database/firebase_database.dart'; // Import the Firebase Realtime Database package
import 'expense.dart';
import 'globals.dart';
import 'package:provider/provider.dart';
import 'expenses_provider.dart';

class PrimaryScreen extends StatefulWidget {
  @override
  _PrimaryScreenState createState() => _PrimaryScreenState();
}

class _PrimaryScreenState extends State<PrimaryScreen> {
  void initState() {
    super.initState();
    var expensesProvider =
        Provider.of<ExpensesProvider>(context, listen: false);
    expensesProvider.fetchExpensesFromServer();
  }

  @override
  Widget build(BuildContext context) {
    final expensesProvider =
        Provider.of<ExpensesProvider>(context, listen: false);
    final expenses = expensesProvider.getAllExpenses;
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
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/AddIdeaRoute');
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: RefreshIndicator(
          onRefresh: () => expensesProvider.fetchExpensesFromServer(),
          child: Column(children: [
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
                  itemBuilder: (ctx, index) {
                    return Dismissible(
                        key: ValueKey(expenses[index].id),
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 20),
                          color: Colors.red,
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        direction: DismissDirection.endToStart,
                        onDismissed: (dir) {
                          setState(() {
                            // Get the ID of the expense to delete
                            String expenseIdToDelete = expenses[index].id;
                            // Print the ID to verify it's correct
                            print(
                                'Deleting expense with ID: $expenseIdToDelete');
                            // Delete the expense using the correct ID
                            expensesProvider.deleteExpense(expenseIdToDelete);
                            expenses.removeAt(index);
                          });
                        },
                        child: ListTile(
                          title: Text(expenses[index].expenseTitle),
                          subtitle: Row(
                            children: [
                              Text(
                                  'Amount: ${expenses[index].expenseAmount.toStringAsFixed(2)}'),
                              SizedBox(
                                  width:
                                      10), // Add spacing between amount and date
                              Text('Date: ${expenses[index].expenseDate}')
                            ],
                          ),
                        ));
                  }),
            )
          ])),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return ExpenseEntryBottomSheet();
            },
          ).then((_) {
            setState(() {
              // Refresh the UI here
              expensesProvider.fetchExpensesFromServer();
            });
          });
        },
        tooltip: 'Add Expense',
        child: Icon(Icons.add),
      ),
    );
  }
}
