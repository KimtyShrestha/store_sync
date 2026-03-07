import 'package:flutter/material.dart';
import '../../domain/entities/daily_record_entity.dart';

class SalesTabList extends StatelessWidget {
  final List<SalesItem> salesItems;
  final Function(int) onDelete;
  final Function(int, SalesItem) onEdit;

  const SalesTabList({
    super.key,
    required this.salesItems,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    if (salesItems.isEmpty) {
      return const Center(
        child: Text("No sales items added"),
      );
    }

    return ListView.builder(
      itemCount: salesItems.length,
      itemBuilder: (context, index) {
        final item = salesItems[index];

        return ListTile(
          title: Text(item.itemName),
          subtitle: Text(
            "Qty: ${item.quantity} | Price: ${item.price} | Subtotal: ${item.subtotal}",
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () => onEdit(index, item),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => onDelete(index),
              ),
            ],
          ),
        );
      },
    );
  }
}