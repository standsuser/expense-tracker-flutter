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

// FirebaseDatabase database = FirebaseDatabase.instance;
// // // Set the custom Realtime Database URL
// final rtdb = FirebaseDatabase.instanceFor(
//   app: firebaseApp,
//   databaseURL: 'https://no-provider-default-rtdb.europe-west1.firebasedatabase.app/expenses.json',
// );
// DatabaseReference ref = FirebaseDatabase.instance.ref();
class PrimaryScreen extends StatefulWidget {
  @override
  _PrimaryScreenState createState() => _PrimaryScreenState();
}

class _PrimaryScreenState extends State<PrimaryScreen> {
  List<Expense> _expenses = [];
  var isLoading = false;
  final expensesURL = Uri.parse(
      'https://no-provider-default-rtdb.europe-west1.firebasedatabase.app/expenses.json');
//--------------------------------------------------------

  Future<void> fetchExpensesFromServer() async {
    setState(() {
      isLoading = true;
    });
    try {
      var response = await http.get(expensesURL);
      var fetchedData = json.decode(response.body) as Map<String, dynamic>;
      setState(() {
        _expenses.clear();
        totalExpenses = 0;
        fetchedData.forEach((key, value) {
          // Parse string date to DateTime object
          DateTime expenseDate = DateTime.parse(value['expenseDate']);
          _expenses.add(Expense(
              id: key,
              expenseTitle: value['expenseTitle'],
              expenseAmount: value['expenseAmount'],
              expenseDate: expenseDate));
          totalExpenses += value['expenseAmount'];
          // Assign parsed DateTime
        });
        isLoading = false;
      });
      // totalExpenses = 0;
      // for (var expense in _expenses) {
      //   totalExpenses += expense.expenseAmount;
      // }
    } catch (err) {
      print(err);
      setState(() {
        isLoading = false;
      });
    }
  }

  void deleteExpense(String id_to_delete) async {
    var expenseToDeleteURL = Uri.parse(
        'https://no-provider-default-rtdb.europe-west1.firebasedatabase.app/expenses/$id_to_delete.json');
    try {
      var deletedExpense =
          _expenses.firstWhere((element) => element.id == id_to_delete);
      await http
          .delete(expenseToDeleteURL); // Wait for the delete request to be done
      setState(() {
        _expenses.removeWhere((element) => element.id == id_to_delete);
        totalExpenses -= deletedExpense.expenseAmount;
      });
    } catch (err) {
      print(err);
    }
  }

  // ------------------------------------------
  void initState() {
    super.initState();
    fetchExpensesFromServer();
  }

//-----------------------------------------------------
  //   // Set the expense data
  //   await expenseRef.set({
  //     'title': expense.title,
  //     'amount': expense.amount,
  //     'date':
  //         expense.date.toIso8601String(), // Convert DateTime to ISO 8601 format
  //     // Add any other relevant fields here
  //   });

  //   print('Expense added to the database successfully.');
  // }

  // void removeExpense(ExpenseItemData expense) {
  //   setState(() {
  //     expenses.remove(expense);
  //     totalExpenses -= expense.amount;
  //   });
  // }

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
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/AddIdeaRoute');
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: RefreshIndicator(
          onRefresh: () => fetchExpensesFromServer(),
          child: Column(
            children: [
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
                  itemCount: _expenses.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ExpenseItem(
                      expense: _expenses[index],
                      onDelete: (expense) {
                        deleteExpense(_expenses[index].id);
                        setState(() {
                          _expenses.remove(expense);
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return ExpenseEntryBottomSheet();
            },
          ).then((_) {
            // This block of code executes after the bottom sheet is dismissed
            setState(() {
              // Refresh the UI here
              fetchExpensesFromServer();
            });
          });
        },
        tooltip: 'Add Expense',
        child: Icon(Icons.add),
      ),
    );
  }
}
