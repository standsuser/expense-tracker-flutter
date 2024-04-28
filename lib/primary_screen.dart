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
  double totalExpenses = 0.0;

  //  Future<void> addExpense(String t, double a, DateTime d) {
  //   return http
  //       .post(expensesURL, body: json.encode({'expenseTitle': t, 'expenseAmount': a, 'expenseDate': d}))
  //       .then((response) {
  //     _expenses.add(Expense(
  //         id: json.decode(response.body)['name'], expenseTitle: t, expenseAmount: a, expenseDate: d));
  //   }).catchError((err) {
  //     print("provider:" + err.toString());
  //     throw err;
  //   });
  // }

//---------------------------------

  Future<void> fetchExpensesFromServer() async {
    try {
      var response = await http.get(expensesURL);
      var fetchedData = json.decode(response.body) as Map<String, dynamic>;
      setState(() {
        _expenses.clear();
        fetchedData.forEach((key, value) {
          _expenses.add(Expense(
              id: key,
              expenseTitle: value['expenseTitle'],
              expenseAmount: value['expenseAmount'],
              expenseDate: value['expenseDate']));
        });
      });
    } catch (err) {
      print(err);
    }
  }

  void deleteIdea(String id_to_delete) async {
    var expenseToDeleteURL = Uri.parse(
        'https://no-provider-default-rtdb.europe-west1.firebasedatabase.app/expenses/$id_to_delete.json');
    try {
      await http
          .delete(expenseToDeleteURL); // wait for the delete request to be done
      setState(() {
        _expenses.removeWhere((element) {
          // when done, remove it locally.
          return element.id == id_to_delete;
        });
      });
    } catch (err) {
      print(err);
    }
  }

  // ------------------------------------------
  void initState() {
    fetchExpensesFromServer();
    super.initState();
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
        child: ListView.builder(
            itemCount: _expenses.length,
            itemBuilder: (ctx, index) {
              return Dismissible(
                key: ValueKey(_expenses[index].id),
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20),
                  color: Color.fromARGB(255, 2, 34, 218),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (dir) {
                  deleteIdea(_expenses[index].id);
                },
                child: ListTile(
                  title: Text(_expenses[index].expenseTitle),
                  subtitle: Text(
                    '${_expenses[index].expenseAmount} - ${_expenses[index].expenseDate}',
                  ),
                ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return ExpenseEntryBottomSheet();
            },
          );
        },
        tooltip: 'Add Expense',
        child: Icon(Icons.add),
      ),
    );
  }
}
