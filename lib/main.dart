import 'package:flutter/material.dart';
import 'package:expense_tracker/primary_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseDatabase database =
    FirebaseDatabase.instance; //creating a firebase instance

final firebaseApp = Firebase.app();
final rtdb = FirebaseDatabase.instanceFor(
    app: firebaseApp,
    databaseURL: 'https://masroufi-201e5-default-rtdb.firebaseio.com/');
//connecting the rtdb

DatabaseReference ref =
    FirebaseDatabase.instance.ref(); //for reading and writing into the db

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
