import '../../../records/domain/entities/daily_record_entity.dart';
import '../entities/analytics_entity.dart';

class CalculateTodayAnalyticsUseCase {

  AnalyticsEntity call({
    required List<SalesItem> salesItems,
    required List<ExpenseItem> expenseItems,
    required List<PurchaseItem> purchaseItems,
  }) {

    final totalSales =
        salesItems.fold<double>(0, (sum, item) => sum + item.subtotal);

    final totalExpense =
        expenseItems.fold<double>(0, (sum, item) => sum + item.subtotal);

    final totalPurchases =
        purchaseItems.fold<double>(0, (sum, item) => sum + item.subtotal);

    final profit = totalSales - totalExpense;

    return AnalyticsEntity(
      totalSales: totalSales,
      totalExpense: totalExpense,
      totalPurchases: totalPurchases,
      netProfit: profit,
    );
  }
}