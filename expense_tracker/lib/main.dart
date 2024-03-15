import 'package:flutter/material.dart';
import 'package:expense_tracker/primary_screen.dart';

void main() {
  runApp(ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(
        primaryColor: Colors.blue, // Set primary color to blue
        primarySwatch: Colors.blue, // Set primary swatch to blue
      ),
      home: PrimaryScreen(),
    );
  }
}
