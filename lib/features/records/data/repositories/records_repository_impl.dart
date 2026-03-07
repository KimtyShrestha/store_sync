import 'package:store_sync/core/api/api_client.dart';
import 'package:store_sync/core/api/api_endpoints.dart';

import '../../domain/entities/daily_record_entity.dart';
import '../../domain/repositories/records_repository.dart';

class RecordsRepositoryImpl implements RecordsRepository {
  final ApiClient _apiClient;

  RecordsRepositoryImpl(this._apiClient);

  // ============================================
  // CREATE OR UPDATE TODAY RECORD  (POST)
  // ============================================
  @override
  Future<void> createOrUpdateTodayRecord(
    DailyRecordEntity record,
  ) async {
    final requestBody = {
      "salesItems": record.salesItems
          .map((item) => {
                "itemName": item.itemName,
                "quantity": item.quantity,
                "price": item.price,
                "subtotal": item.subtotal,
              })
          .toList(),
      "expenseItems": record.expenseItems
          .map((item) => {
                "category": item.category,
                "quantity": item.quantity,
                "price": item.price,
                "subtotal": item.subtotal,
              })
          .toList(),
      "purchaseItems": record.purchaseItems
          .map((item) => {
                "category": item.category,
                "quantity": item.quantity,
                "price": item.price,
                "subtotal": item.subtotal,
              })
          .toList(),
    };

    await _apiClient.post(
      ApiEndpoints.todayRecord,
      body: requestBody,
      requiresAuth: true,
    );
  }

  // ============================================
  // GET TODAY RECORD  (GET)
  // ============================================
  @override
  Future<DailyRecordEntity?> getTodayRecord() async {
    final response = await _apiClient.get(
      ApiEndpoints.todayRecord,
      requiresAuth: true,
    );

    final data = response["data"];

    if (data == null) return null;

    final sales = (data["salesItems"] as List?) ?? [];
    final expenses = (data["expenseItems"] as List?) ?? [];
    final purchases = (data["purchaseItems"] as List?) ?? [];

    return DailyRecordEntity(
      salesItems: sales.map((item) {
        return SalesItem(
          itemName: item["itemName"] ?? "",
          quantity: item["quantity"] ?? 0,
          price: (item["price"] ?? 0).toDouble(),
        );
      }).toList(),
      expenseItems: expenses.map((item) {
        return ExpenseItem(
          category: item["category"] ?? "",
          quantity: item["quantity"] ?? 0,
          price: (item["price"] ?? 0).toDouble(),
        );
      }).toList(),
      purchaseItems: purchases.map((item) {
        return PurchaseItem(
          category: item["category"] ?? "",
          quantity: item["quantity"] ?? 0,
          price: (item["price"] ?? 0).toDouble(),
        );
      }).toList(),
      totalSales: (data["totalSales"] ?? 0).toDouble(),
      totalExpense: (data["totalExpense"] ?? 0).toDouble(),
      totalPurchases: (data["totalPurchases"] ?? 0).toDouble(),
      date: data["date"] != null
          ? DateTime.parse(data["date"])
          : DateTime.now(),
    );
  }

  // ============================================
  // GET ALL RECORDS (HISTORY)  (GET)
  // ============================================
  @override
  Future<List<DailyRecordEntity>> getAllRecords() async {
    final response = await _apiClient.get(
      ApiEndpoints.historyRecord,
      requiresAuth: true,
    );

    final List records = response["data"] ?? [];

    return records.map((data) {
      return DailyRecordEntity(
        salesItems: [],
        expenseItems: [],
        purchaseItems: [],
        totalSales: (data["totalSales"] ?? 0).toDouble(),
        totalExpense: (data["totalExpense"] ?? 0).toDouble(),
        totalPurchases: (data["totalPurchases"] ?? 0).toDouble(),
        date: DateTime.parse(data["date"]),
      );
    }).toList();
  }
}