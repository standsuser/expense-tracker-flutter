import 'package:flutter/material.dart';
import 'package:expense_tracker/expense.dart';

class ExpenseEntryBottomSheet extends StatefulWidget {
  final Function(ExpenseItemData) addExpense;

  ExpenseEntryBottomSheet({required this.addExpense});

  @override
  _ExpenseEntryBottomSheetState createState() => _ExpenseEntryBottomSheetState();
}

class _ExpenseEntryBottomSheetState extends State<ExpenseEntryBottomSheet> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  void _submitExpense() {
    final title = _titleController.text;
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    final expense = ExpenseItemData(title: title, amount: amount, date: _selectedDate);
    widget.addExpense(expense);
    Navigator.of(context).pop();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: _amountController,
            decoration: InputDecoration(labelText: 'Amount'),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text('Date: ${_selectedDate.toString()}'),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => _selectDate(context),
                child: Text('Select Date'),
              ),
            ],
          ),
          SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: _submitExpense,
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
