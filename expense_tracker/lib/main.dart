import 'package:flutter/material.dart';
import 'package:expense_tracker/primary_screen.dart';

void main() {
  runApp(ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Masroufi Builder',
      theme: ThemeData(
        primaryColor: Colors.blue, 
        primarySwatch: Colors.blue, 
      ),
      home: PrimaryScreen(),
    );
  }
}
