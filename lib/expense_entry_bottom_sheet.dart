import 'package:flutter/material.dart';
import 'package:expense_tracker/expense.dart';
import 'package:firebase_database/firebase_database.dart';
import 'primary_screen.dart';
import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'globals.dart';
import 'expenses_provider.dart';
import 'package:provider/provider.dart';
class ExpenseEntryBottomSheet extends StatefulWidget {
  @override
  _ExpenseEntryBottomSheetState createState() =>
      _ExpenseEntryBottomSheetState();
}

class _ExpenseEntryBottomSheetState extends State<ExpenseEntryBottomSheet> {
  final titleValue = TextEditingController();
  final amountValue = TextEditingController();
  final dateValue = TextEditingController();
  var isLoading = false;
  

  @override
  Widget build(BuildContext context) {

    final expensesProvider = Provider.of<ExpensesProvider>(context, listen: true);
    DateTime selectedDate = DateTime.now();

    void selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime.now(),
      );
      if (picked != null) {
        selectedDate = picked;
        dateValue.value = TextEditingValue(
            text: picked
                .toString()); // Update dateValue      // Update selectedDate
      }
    }

    return SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(16.0),
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: titleValue,
                        decoration: InputDecoration(labelText: 'Title'),
                      ),
                      TextField(
                        controller: amountValue,
                        decoration: InputDecoration(labelText: 'Amount'),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                              'Date: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () => selectDate(context),
                            child: Text('Select Date'),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: isLoading
                            ? CircularProgressIndicator()
                            : ElevatedButton.icon(
                                label: const Text('Submit'),
                                onPressed: () {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  double amount =
                                      double.parse(amountValue.text);
                                  expensesProvider.addExpense(
                                          titleValue.text, amount, selectedDate)
                                      .catchError((err) {
                                    return showDialog<Null>(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: const Text('An error occurred!'),
                                        content: Text(err.toString()),
                                        actions: [
                                          TextButton(
                                            child: const Text('Okay'),
                                            onPressed: () {
                                              Navigator.of(ctx).pop();
                                            },
                                          )
                                        ],
                                      ),
                                    );
                                  }).then((_) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    Navigator.of(context).pop();
                                  });
                                },
                                icon: const Icon(Icons.check)),
                      )
                    ],
                  )));
  }
}
