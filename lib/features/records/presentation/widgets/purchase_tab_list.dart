import 'package:flutter/material.dart';
import '../../domain/entities/daily_record_entity.dart';

class PurchaseTabList extends StatelessWidget {
  final List<PurchaseItem> purchaseItems;
  final Function(int) onDelete;
  final Function(int, PurchaseItem) onEdit;

  const PurchaseTabList({
    super.key,
    required this.purchaseItems,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {

    if (purchaseItems.isEmpty) {
      return const Center(
        child: Text("No purchase items added"),
      );
    }

    return ListView.builder(
      itemCount: purchaseItems.length,
      itemBuilder: (context, index) {

        final item = purchaseItems[index];

        return ListTile(
          title: Text(item.category),

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