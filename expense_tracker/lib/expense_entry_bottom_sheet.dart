import 'package:flutter/material.dart';

class ExpenseEntryBottomSheet extends StatefulWidget {
  @override
  _ExpenseEntryBottomSheetState createState() => _ExpenseEntryBottomSheetState();
}

class _ExpenseEntryBottomSheetState extends State<ExpenseEntryBottomSheet> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

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
                onPressed: () {
                  // Show date picker
                  // Implement this
                },
                child: Text('Select Date'),
              ),
            ],
          ),
          SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                // Add expense entry
                // Implement this
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
