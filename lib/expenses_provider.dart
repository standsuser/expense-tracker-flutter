import './expense.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'globals.dart';

class ExpensesProvider with ChangeNotifier {
  List<Expense> _expenses = [];
  final expensesURL = Uri.parse(
      'https://provider-950c1-default-rtdb.europe-west1.firebasedatabase.app/expenses.json');
//--------------------------------------------------------

  Future<void> fetchExpensesFromServer() async {
    try {
      var response = await http.get(expensesURL);
      var fetchedData = json.decode(response.body) as Map<String, dynamic>;
      _expenses.clear();
      totalExpenses = 0;
      fetchedData.forEach((key, value) {
        DateTime expenseDate = DateTime.parse(value['expenseDate']);
        _expenses.add(Expense(
            id: key,
            expenseTitle: value['expenseTitle'],
            expenseAmount: value['expenseAmount'],
            expenseDate: expenseDate));
        totalExpenses += value['expenseAmount'];
      });
      notifyListeners();
    } catch (err) {
      print(err);
    }
  }

  Future<void> addExpense(String t, double a, DateTime d) {
    final formattedDate =
        d.toIso8601String(); // Convert DateTime to ISO 8601 string
    totalExpenses += a;
    return http
        .post(expensesURL,
            body: json.encode({
              'expenseTitle': t,
              'expenseAmount': a,
              'expenseDate': formattedDate
            }))
        .then((response) {
      _expenses.add(Expense(
          id: json.decode(response.body)['name'],
          expenseTitle: t,
          expenseAmount: a,
          expenseDate: d));
      notifyListeners();
    }).catchError((err) {
      print("provider:" + err.toString());
      throw err;
    });
  }

  List<Expense> get getAllExpenses {
    return _expenses;
  }



  // void deleteExpense(String id_to_delete) async {
  //   var expenseToDeleteURL = Uri.parse(
  //       'https://no-provider-default-rtdb.europe-west1.firebasedatabase.app/expenses/$id_to_delete.json');
  //   try {
  //     await http
  //         .delete(expenseToDeleteURL); // wait for the delete request to be done
  //     _expenses.removeWhere((element) => element.id == id_to_delete);
  //     notifyListeners(); // to update our list without the need to refresh
  //   } catch (err) {
  //     print('Error deleting expense: $err');
  //   }
  // }


  Future<void> deleteExpense(String id_to_delete) {
  final expenseIndex = _expenses.indexWhere((expense) => expense.id == id_to_delete);
  if (expenseIndex >= 0) {
    final deletedAmount = _expenses[expenseIndex].expenseAmount;
    totalExpenses -= deletedAmount;
  final expensesURL = Uri.parse(
            'https://provider-950c1-default-rtdb.europe-west1.firebasedatabase.app/expenses/$id_to_delete.json');
    return http.delete(expensesURL).then((_) {
      _expenses.removeAt(expenseIndex);
      notifyListeners();
    }).catchError((err) {
      print("provider:" + err.toString());
      throw err;
    });
  } else {
    print("Expense not found");
    // Handle error or throw an exception if necessary
    return Future.error("Expense not found");
  }
}

}
