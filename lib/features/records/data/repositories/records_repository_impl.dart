import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../core/storage/token_storage.dart';
import '../../domain/entities/daily_record_entity.dart';
import '../../domain/repositories/records_repository.dart';

const String baseUrl = "http://10.0.2.2:5050/api/daily-record";

class RecordsRepositoryImpl implements RecordsRepository {
  final TokenStorage _tokenStorage = TokenStorage();

  // ===============================
  // CREATE OR UPDATE TODAY RECORD
  // ===============================
  @override
  Future<void> createOrUpdateTodayRecord(
    DailyRecordEntity record,
  ) async {
    final token = await _tokenStorage.getToken();

    if (token == null) {
      throw Exception("User not authenticated");
    }

    final url = Uri.parse("$baseUrl/today");

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

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(requestBody),
    );

    final responseBody = jsonDecode(response.body);

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(responseBody["message"] ?? "Failed to submit record");
    }
  }

  // ===============================
  // GET TODAY RECORD
  // ===============================
  @override
  Future<DailyRecordEntity?> getTodayRecord() async {
    final token = await _tokenStorage.getToken();

    if (token == null) {
      throw Exception("User not authenticated");
    }

    final url = Uri.parse("$baseUrl/today");

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 404) {
      return null;
    }

    final responseBody = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(responseBody["message"] ?? "Failed to fetch record");
    }

    final data = responseBody["data"] ?? {};

    final sales = (data["salesItems"] as List?) ?? [];
    final expenses = (data["expenseItems"] as List?) ?? [];
    final purchases = (data["purchaseItems"] as List?) ?? [];

    return DailyRecordEntity(
      salesItems: sales.map((item) {
        return SalesItem(
          itemName: (item["itemName"] ?? "") as String,
          quantity: (item["quantity"] ?? 0) as int,
          price: (item["price"] ?? 0).toDouble(),
        );
      }).toList(),
      expenseItems: expenses.map((item) {
        return ExpenseItem(
          category: (item["category"] ?? "") as String,
          quantity: (item["quantity"] ?? 0) as int,
          price: (item["price"] ?? 0).toDouble(),
        );
      }).toList(),
      purchaseItems: purchases.map((item) {
        return PurchaseItem(
          category: (item["category"] ?? "") as String,
          quantity: (item["quantity"] ?? 0) as int,
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

  // ===============================
  // GET ALL RECORDS (HISTORY)
  // ===============================
  @override
  Future<List<DailyRecordEntity>> getAllRecords() async {
    final token = await _tokenStorage.getToken();

    if (token == null) {
      throw Exception("User not authenticated");
    }

    final response = await http.get(
      Uri.parse("$baseUrl/history"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    final body = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(body["message"] ?? "Failed to fetch history");
    }

    final List records = body["data"] ?? [];

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