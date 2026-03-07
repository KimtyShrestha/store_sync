import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../dashboard/presentation/providers/dashboard_provider.dart';

class InventoryScreen extends ConsumerWidget {
  const InventoryScreen({super.key});

  static const _red = Color(0xFFD32F2F);
  static const _green = Color(0xFF2E7D32);
  static const _orange = Color(0xFFFF9800);
  static const _line = Color(0xFFEDEDED);
  static const _bg = Color(0xFFFAFAFA);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardProvider);
    final history = dashboardState.history;

    final Map<String, int> stockMap = {};

    // Calculate stock
    for (final record in history) {
      final purchases = record["purchaseItems"] ?? [];
      final sales = record["salesItems"] ?? [];

      for (final item in purchases) {
        final name = item["category"] ?? "Unknown";
        final qty = ((item["quantity"] ?? 0) as num).toInt();

        stockMap[name] = (stockMap[name] ?? 0) + qty;
      }

      for (final item in sales) {
        final name = item["itemName"] ?? "Unknown";
        final qty = ((item["quantity"] ?? 0) as num).toInt();

        stockMap[name] = (stockMap[name] ?? 0) - qty;
      }
    }

    final inventory = stockMap.entries.toList();

    final totalItems = inventory.length;
    final totalStock =
        inventory.fold<int>(0, (sum, item) => sum + item.value);

    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        children: [

          // HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
            decoration: const BoxDecoration(
              color: _red,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: const Text(
              "Inventory Overview",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // SUMMARY CARDS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _summaryCard("Total Items", totalItems.toString()),
                const SizedBox(width: 12),
                _summaryCard("Total Stock", totalStock.toString()),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // INVENTORY LIST
          Expanded(
            child: inventory.isEmpty
                ? const Center(child: Text("No inventory data available"))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: inventory.length,
                    itemBuilder: (context, index) {
                      final item = inventory[index];
                      final stock = item.value;

                      Color statusColor;
                      String status;

                      if (stock <= 0) {
                        status = "Out of Stock";
                        statusColor = _red;
                      } else if (stock < 5) {
                        status = "Low Stock";
                        statusColor = _orange;
                      } else {
                        status = "In Stock";
                        statusColor = _green;
                      }

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: _line),
                        ),
                        child: Row(
                          children: [

                            const Icon(Icons.inventory, size: 20),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Text(
                                item.key,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  stock.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  status,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: statusColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _line),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}