import 'package:flutter/material.dart';
import 'package:expense_tracker/primary_screen.dart';
import 'package:expense_tracker/expense_entry_bottom_sheet.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseDatabase database = FirebaseDatabase.instance;
// final firebaseApp = Firebase.app();
// final rtdb = FirebaseDatabase.instanceFor(
//     app: firebaseApp,
//     databaseURL: 'https://masroufi-201e5-default-rtdb.firebaseio.com/expenses.json');
// //connecting the rtdb
// DatabaseReference ref = FirebaseDatabase.instance.ref();
void main(){
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
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
      initialRoute: '/',
          routes: {
            '/': (ctx) => PrimaryScreen(),
            '/AddExpense': (ctx) => ExpenseEntryBottomSheet(),
          });
  }
}
