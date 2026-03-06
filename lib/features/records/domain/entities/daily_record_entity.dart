class DailyRecordEntity {
  final List<SalesItem> salesItems;
  final List<ExpenseItem> expenseItems;
  final List<PurchaseItem> purchaseItems;

  final double totalSales;
  final double totalExpense;
  final double totalPurchases;
  final DateTime date;

  DailyRecordEntity({
    required this.salesItems,
    required this.expenseItems,
    required this.purchaseItems,
    this.totalSales = 0,
    this.totalExpense = 0,
    this.totalPurchases = 0,
    DateTime? date,
  }) : date = date ?? DateTime.now();
}

// ================= SALES =================

class SalesItem {
  final String itemName;
  final int quantity;
  final double price;

  SalesItem({
    required this.itemName,
    required this.quantity,
    required this.price,
  });

  double get subtotal => quantity * price;
}

// ================= EXPENSE =================

class ExpenseItem {
  final String category;
  final int quantity;
  final double price;

  ExpenseItem({
    required this.category,
    required this.quantity,
    required this.price,
  });

  double get subtotal => quantity * price;
}

// ================= PURCHASE =================

class PurchaseItem {
  final String category;
  final int quantity;
  final double price;

  PurchaseItem({
    required this.category,
    required this.quantity,
    required this.price,
  });

  double get subtotal => quantity * price;
}