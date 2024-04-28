import 'package:flutter/material.dart';
import 'package:expense_tracker/primary_screen.dart';
import 'package:expense_tracker/expense_entry_bottom_sheet.dart';
import 'package:firebase_database/firebase_database.dart';
import 'expenses_provider.dart';
import 'package:provider/provider.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => ExpensesProvider(),
      child: MaterialApp(
          title: 'Masroufi Builder',
          theme: ThemeData(
            primaryColor: Colors.blue,
            primarySwatch: Colors.blue,
          ),
          initialRoute: '/',
          routes: {
            '/': (ctx) => PrimaryScreen(),
            '/AddExpense': (ctx) => ExpenseEntryBottomSheet(),
          }),
    );
  }
}
