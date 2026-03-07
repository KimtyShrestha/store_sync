import 'package:flutter/material.dart';
import '../domain/entities/daily_record_entity.dart';

class PurchaseItemDialog extends StatefulWidget {

  final PurchaseItem? existingItem;
  final Function(PurchaseItem) onSave;

  const PurchaseItemDialog({
    super.key,
    this.existingItem,
    required this.onSave,
  });

  @override
  State<PurchaseItemDialog> createState() => _PurchaseItemDialogState();
}

class _PurchaseItemDialogState extends State<PurchaseItemDialog> {

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
            ? "Add Purchase Item"
            : "Edit Purchase Item",
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

            final item = PurchaseItem(
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