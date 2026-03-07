import 'package:flutter/material.dart';
import '../domain/entities/daily_record_entity.dart';

class SalesItemDialog extends StatefulWidget {

  final SalesItem? existingItem;
  final Function(SalesItem) onSave;

  const SalesItemDialog({
    super.key,
    this.existingItem,
    required this.onSave,
  });

  @override
  State<SalesItemDialog> createState() => _SalesItemDialogState();
}

class _SalesItemDialogState extends State<SalesItemDialog> {

  late TextEditingController nameController;
  late TextEditingController qtyController;
  late TextEditingController priceController;

  @override
  void initState() {
    super.initState();

    nameController =
        TextEditingController(text: widget.existingItem?.itemName ?? "");

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
            ? "Add Sales Item"
            : "Edit Sales Item",
      ),

      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: "Item Name"),
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

            final item = SalesItem(
              itemName: nameController.text,
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