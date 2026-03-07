import 'package:flutter/material.dart';
import '../../domain/entities/daily_record_entity.dart';
import '../../../analytics/domain/usecases/calculate_today_analytics_usecase.dart';

class RecordSummaryCard extends StatelessWidget {
  final List<SalesItem> salesItems;
  final List<ExpenseItem> expenseItems;
  final List<PurchaseItem> purchaseItems;

  const RecordSummaryCard({
    super.key,
    required this.salesItems,
    required this.expenseItems,
    required this.purchaseItems,
  });

  @override
  Widget build(BuildContext context) {
    final analytics = CalculateTodayAnalyticsUseCase().call(
    salesItems: salesItems,
    expenseItems: expenseItems,
    purchaseItems: purchaseItems,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _summaryRow("Total Sales", analytics.totalSales, Colors.green),
              _summaryRow("Total Expense", analytics.totalExpense, Colors.red),
              _summaryRow("Total Purchases", analytics.totalPurchases, Colors.orange),
              const Divider(),
              _summaryRow("Net Profit",
                analytics.netProfit,
                analytics.netProfit >= 0 ? Colors.green : Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryRow(String title, double amount, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Text(
            "Rs ${amount.toStringAsFixed(2)}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}