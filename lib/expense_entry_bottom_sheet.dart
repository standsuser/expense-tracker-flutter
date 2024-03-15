import 'package:flutter/material.dart';
import 'package:expense_tracker/expense.dart';
import 'package:flutter_hooks/flutter_hooks.dart'; // Import flutter_hooks

class ExpenseEntryBottomSheet extends HookWidget {
  final Function(ExpenseItemData) addExpense;

  ExpenseEntryBottomSheet({required this.addExpense});

  @override
  Widget build(BuildContext context) {
    final titleController = useTextEditingController();
    final amountController = useTextEditingController();
    final selectedDate = useState<DateTime>(DateTime.now());

    void selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate.value,
        firstDate: DateTime(2000),
        lastDate: DateTime.now(),
      );
      if (picked != null) {
        selectedDate.value = picked; // Update selectedDate
      }
    }

    void submitExpense() {
      final title = titleController.text;
      final amount = double.tryParse(amountController.text) ?? 0.0;
      final expense = ExpenseItemData(title: title, amount: amount, date: selectedDate.value);
      addExpense(expense);
      Navigator.of(context).pop();
    }

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text('Date: ${selectedDate.value.day}/${selectedDate.value.month}/${selectedDate.value.year}'),
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
              child: ElevatedButton(
                onPressed: submitExpense,
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
