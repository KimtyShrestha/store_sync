import 'package:flutter/material.dart';
import '../domain/entities/daily_record_entity.dart';

class ExpenseItemDialog extends StatefulWidget {

  final ExpenseItem? existingItem;
  final Function(ExpenseItem) onSave;

  const ExpenseItemDialog({
    super.key,
    this.existingItem,
    required this.onSave,
  });

  @override
  State<ExpenseItemDialog> createState() => _ExpenseItemDialogState();
}

class _ExpenseItemDialogState extends State<ExpenseItemDialog> {

  late TextEditingController categoryController;
  late TextEditingController qtyController;
  late TextEditingController priceController;

  @override
  void initState() {
    super.initState();

    categoryController =
        TextEditingController(text: widget.existingItem?.category ?? "");

    qtyController =
        TextEditingController(text: widget.existingItem?.quantity.toString() ?? "");

    priceController =
        TextEditingController(text: widget.existingItem?.price.toString() ?? "");
  }

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: Text(
        widget.existingItem == null
            ? "Add Expense Item"
            : "Edit Expense Item",
      ),

      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          TextField(
            controller: categoryController,
            decoration: const InputDecoration(labelText: "Category"),
          ),

          TextField(
            controller: qtyController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: "Quantity"),
          ),

          TextField(
            controller: priceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: "Price"),
          ),

        ],
      ),

      actions: [

        TextButton(
          onPressed: () {

            final item = ExpenseItem(
              category: categoryController.text,
              quantity: int.parse(qtyController.text),
              price: double.parse(priceController.text),
            );

            widget.onSave(item);

            Navigator.pop(context);
          },
          child: Text(
            widget.existingItem == null ? "Add" : "Update",
          ),
        ),

      ],
    );
  }
}