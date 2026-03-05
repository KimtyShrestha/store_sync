class SalesItem {
  final String itemName;
  final int quantity;
  final double price;

  const SalesItem({
    required this.itemName,
    required this.quantity,
    required this.price,
  });
}

class ExpenseItem {
  final String itemName;
  final double amount;

  const ExpenseItem({
    required this.itemName,
    required this.amount,
  });
}

class PurchaseItem {
  final String itemName;
  final int quantity;
  final double price;

  const PurchaseItem({
    required this.itemName,
    required this.quantity,
    required this.price,
  });
}

class DailyRecordEntity {
  final List<SalesItem> salesItems;
  final List<ExpenseItem> expenseItems;
  final List<PurchaseItem> purchaseItems;

  const DailyRecordEntity({
    required this.salesItems,
    required this.expenseItems,
    required this.purchaseItems,
  });
}