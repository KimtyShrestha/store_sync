import 'package:flutter/material.dart';
import '../../domain/entities/daily_record_entity.dart';

class ExpenseTabList extends StatelessWidget {
  final List<ExpenseItem> expenseItems;
  final Function(int) onDelete;
  final Function(int, ExpenseItem) onEdit;

  const ExpenseTabList({
    super.key,
    required this.expenseItems,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {

    if (expenseItems.isEmpty) {
      return const Center(
        child: Text("No expense items added"),
      );
    }

    return ListView.builder(
      itemCount: expenseItems.length,
      itemBuilder: (context, index) {
        final item = expenseItems[index];

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