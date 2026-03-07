// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import '../../../dashboard/presentation/providers/dashboard_provider.dart';

// // class InventoryScreen extends ConsumerWidget {
// //   const InventoryScreen({super.key});

// //   static const _red = Color(0xFFD32F2F);
// //   static const _green = Color(0xFF2E7D32);
// //   static const _orange = Color(0xFFFF9800);
// //   static const _line = Color(0xFFEDEDED);
// //   static const _bg = Color(0xFFFAFAFA);

// //   @override
// //   Widget build(BuildContext context, WidgetRef ref) {
// //     final dashboardState = ref.watch(dashboardProvider);
// //     final history = dashboardState.history;

// //     final Map<String, int> stockMap = {};

// //     // Calculate stock
// //     for (final record in history) {
// //       final purchases = record["purchaseItems"] ?? [];
// //       final sales = record["salesItems"] ?? [];

// //       for (final item in purchases) {
// //         final name = item["category"] ?? "Unknown";
// //         final qty = ((item["quantity"] ?? 0) as num).toInt();

// //         stockMap[name] = (stockMap[name] ?? 0) + qty;
// //       }

// //       for (final item in sales) {
// //         final name = item["itemName"] ?? "Unknown";
// //         final qty = ((item["quantity"] ?? 0) as num).toInt();

// //         stockMap[name] = (stockMap[name] ?? 0) - qty;
// //       }
// //     }

// //     final inventory = stockMap.entries.toList();

// //     final totalItems = inventory.length;
// //     final totalStock =
// //         inventory.fold<int>(0, (sum, item) => sum + item.value);

// //     return Scaffold(
// //       backgroundColor: _bg,
// //       body: Column(
// //         children: [

// //           // HEADER
// //           Container(
// //             width: double.infinity,
// //             padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
// //             decoration: const BoxDecoration(
// //               color: _red,
// //               borderRadius: BorderRadius.only(
// //                 bottomLeft: Radius.circular(16),
// //                 bottomRight: Radius.circular(16),
// //               ),
// //             ),
// //             child: const Text(
// //               "Inventory Overview",
// //               style: TextStyle(
// //                 color: Colors.white,
// //                 fontSize: 18,
// //                 fontWeight: FontWeight.w700,
// //               ),
// //             ),
// //           ),

// //           const SizedBox(height: 20),

// //           // SUMMARY CARDS
// //           Padding(
// //             padding: const EdgeInsets.symmetric(horizontal: 16),
// //             child: Row(
// //               children: [
// //                 _summaryCard("Total Items", totalItems.toString()),
// //                 const SizedBox(width: 12),
// //                 _summaryCard("Total Stock", totalStock.toString()),
// //               ],
// //             ),
// //           ),

// //           const SizedBox(height: 20),

// //           // INVENTORY LIST
// //           Expanded(
// //             child: inventory.isEmpty
// //                 ? const Center(child: Text("No inventory data available"))
// //                 : ListView.builder(
// //                     padding: const EdgeInsets.symmetric(horizontal: 16),
// //                     itemCount: inventory.length,
// //                     itemBuilder: (context, index) {
// //                       final item = inventory[index];
// //                       final stock = item.value;

// //                       Color statusColor;
// //                       String status;

// //                       if (stock <= 0) {
// //                         status = "Out of Stock";
// //                         statusColor = _red;
// //                       } else if (stock < 5) {
// //                         status = "Low Stock";
// //                         statusColor = _orange;
// //                       } else {
// //                         status = "In Stock";
// //                         statusColor = _green;
// //                       }

// //                       return Container(
// //                         margin: const EdgeInsets.only(bottom: 12),
// //                         padding: const EdgeInsets.all(14),
// //                         decoration: BoxDecoration(
// //                           color: Colors.white,
// //                           borderRadius: BorderRadius.circular(10),
// //                           border: Border.all(color: _line),
// //                         ),
// //                         child: Row(
// //                           children: [

// //                             const Icon(Icons.inventory, size: 20),

// //                             const SizedBox(width: 12),

// //                             Expanded(
// //                               child: Text(
// //                                 item.key,
// //                                 style: const TextStyle(
// //                                   fontSize: 14,
// //                                   fontWeight: FontWeight.w600,
// //                                 ),
// //                               ),
// //                             ),

// //                             Column(
// //                               crossAxisAlignment: CrossAxisAlignment.end,
// //                               children: [
// //                                 Text(
// //                                   stock.toString(),
// //                                   style: const TextStyle(
// //                                     fontWeight: FontWeight.bold,
// //                                     fontSize: 15,
// //                                   ),
// //                                 ),
// //                                 Text(
// //                                   status,
// //                                   style: TextStyle(
// //                                     fontSize: 11,
// //                                     color: statusColor,
// //                                   ),
// //                                 ),
// //                               ],
// //                             ),
// //                           ],
// //                         ),
// //                       );
// //                     },
// //                   ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _summaryCard(String title, String value) {
// //     return Expanded(
// //       child: Container(
// //         padding: const EdgeInsets.all(16),
// //         decoration: BoxDecoration(
// //           color: Colors.white,
// //           borderRadius: BorderRadius.circular(10),
// //           border: Border.all(color: _line),
// //         ),
// //         child: Column(
// //           children: [
// //             Text(
// //               value,
// //               style: const TextStyle(
// //                 fontSize: 20,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //             const SizedBox(height: 4),
// //             Text(
// //               title,
// //               style: const TextStyle(
// //                 fontSize: 11,
// //                 color: Colors.grey,
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }


// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../../dashboard/presentation/providers/dashboard_provider.dart';

// class InventoryScreen extends ConsumerWidget {
//   const InventoryScreen({super.key});

//   static const _red    = Color(0xFFD32F2F);
//   static const _green  = Color(0xFF2E7D32);
//   static const _orange = Color(0xFFFF9800);
//   static const _line   = Color(0xFFEDEDED);
//   static const _bg     = Color(0xFFF5F5F5);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final dashboardState = ref.watch(dashboardProvider);
//     final history        = dashboardState.history;

//     final Map<String, int> stockMap = {};

//     for (final record in history) {
//       final purchases = record["purchaseItems"] ?? [];
//       final sales     = record["salesItems"]    ?? [];

//       for (final item in purchases) {
//         final name = item["category"] ?? "Unknown";
//         final qty  = ((item["quantity"] ?? 0) as num).toInt();
//         stockMap[name] = (stockMap[name] ?? 0) + qty;
//       }

//       for (final item in sales) {
//         final name = item["itemName"] ?? "Unknown";
//         final qty  = ((item["quantity"] ?? 0) as num).toInt();
//         stockMap[name] = (stockMap[name] ?? 0) - qty;
//       }
//     }

//     final inventory  = stockMap.entries.toList();
//     final totalItems = inventory.length;
//     final totalStock = inventory.fold<int>(0, (sum, e) => sum + e.value);
//     final outOfStock = inventory.where((e) => e.value <= 0).length;

//     return Scaffold(
//       backgroundColor: _bg,
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [

//           // ── Header ─────────────────────────────────────────────────────
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.fromLTRB(20, 48, 20, 14),
//             decoration: const BoxDecoration(
//               color: _red,
//               borderRadius: BorderRadius.only(
//                 bottomLeft:  Radius.circular(20),
//                 bottomRight: Radius.circular(20),
//               ),
//             ),
//             child: const Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Inventory",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontWeight: FontWeight.w700,
//                     letterSpacing: 0.3,
//                   ),
//                 ),
//                 SizedBox(height: 2),
//                 Text(
//                   "Stock levels at a glance",
//                   style: TextStyle(
//                     color: Colors.white70,
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 16),

//           // ── Summary cards ───────────────────────────────────────────────
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Row(
//               children: [
//                 _summaryCard("Total Items",  totalItems.toString(),
//                     Icons.category_outlined,        _red),
//                 const SizedBox(width: 10),
//                 _summaryCard("Total Stock",  totalStock.toString(),
//                     Icons.inventory_2_outlined,     Colors.blueGrey),
//                 const SizedBox(width: 10),
//                 _summaryCard("Out of Stock", outOfStock.toString(),
//                     Icons.remove_shopping_cart_outlined, _orange),
//               ],
//             ),
//           ),

//           const SizedBox(height: 18),

//           // ── Section label ───────────────────────────────────────────────
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Text(
//               "All Products",
//               style: TextStyle(
//                 fontSize: 13,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.grey.shade600,
//                 letterSpacing: 0.4,
//               ),
//             ),
//           ),

//           const SizedBox(height: 10),

//           // ── List ────────────────────────────────────────────────────────
//           Expanded(
//             child: inventory.isEmpty
//                 ? Center(
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(Icons.inventory_2_outlined,
//                             size: 48, color: Colors.grey.shade300),
//                         const SizedBox(height: 12),
//                         Text(
//                           "No inventory data yet",
//                           style: TextStyle(
//                             color: Colors.grey.shade400,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ],
//                     ),
//                   )
//                 : ListView.separated(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     itemCount:   inventory.length,
//                     separatorBuilder: (_, __) => const SizedBox(height: 1),
//                     itemBuilder: (context, index) {
//                       final item  = inventory[index];
//                       final stock = item.value;

//                       Color  statusColor;
//                       String statusLabel;

//                       if (stock <= 0) {
//                         statusLabel = "Out of Stock";
//                         statusColor = _red;
//                       } else if (stock < 5) {
//                         statusLabel = "Low Stock";
//                         statusColor = _orange;
//                       } else {
//                         statusLabel = "In Stock";
//                         statusColor = _green;
//                       }

//                       final isFirst = index == 0;
//                       final isLast  = index == inventory.length - 1;

//                       return Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 16, vertical: 14),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           border: Border.all(color: _line),
//                           borderRadius: BorderRadius.only(
//                             topLeft:     Radius.circular(isFirst ? 12 : 0),
//                             topRight:    Radius.circular(isFirst ? 12 : 0),
//                             bottomLeft:  Radius.circular(isLast  ? 12 : 0),
//                             bottomRight: Radius.circular(isLast  ? 12 : 0),
//                           ),
//                         ),
//                         child: Row(
//                           children: [

//                             // Left: icon + name
//                             Container(
//                               width: 36,
//                               height: 36,
//                               decoration: BoxDecoration(
//                                 color: _bg,
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Icon(
//                                 Icons.inventory_2_outlined,
//                                 size: 18,
//                                 color: Colors.grey.shade500,
//                               ),
//                             ),

//                             const SizedBox(width: 12),

//                             Expanded(
//                               child: Text(
//                                 item.key,
//                                 style: const TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w600,
//                                   color: Color(0xFF1A1A1A),
//                                 ),
//                               ),
//                             ),

//                             // Right: qty + status pill
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: [
//                                 Text(
//                                   stock.toString(),
//                                   style: const TextStyle(
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.w700,
//                                     color: Color(0xFF1A1A1A),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 3),
//                                 Container(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 8, vertical: 2),
//                                   decoration: BoxDecoration(
//                                     color: statusColor.withOpacity(0.1),
//                                     borderRadius: BorderRadius.circular(20),
//                                   ),
//                                   child: Text(
//                                     statusLabel,
//                                     style: TextStyle(
//                                       fontSize: 10,
//                                       fontWeight: FontWeight.w600,
//                                       color: statusColor,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//           ),

//           const SizedBox(height: 16),
//         ],
//       ),
//     );
//   }

//   Widget _summaryCard(
//       String title, String value, IconData icon, Color iconColor) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: _line),
//         ),
//         child: Column(
//           children: [
//             Icon(icon, size: 20, color: iconColor),
//             const SizedBox(height: 6),
//             Text(
//               value,
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w700,
//                 color: Color(0xFF1A1A1A),
//               ),
//             ),
//             const SizedBox(height: 3),
//             Text(
//               title,
//               style: const TextStyle(
//                 fontSize: 10,
//                 color: Colors.grey,
//                 fontWeight: FontWeight.w500,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../dashboard/presentation/providers/dashboard_provider.dart';

class InventoryScreen extends ConsumerWidget {
  const InventoryScreen({super.key});

  static const _red    = Color(0xFFD32F2F);
  static const _green  = Color(0xFF2E7D32);
  static const _orange = Color(0xFFFF9800);
  static const _line   = Color(0xFFEDEDED);
  static const _bg     = Color(0xFFF5F5F5);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardProvider);
    final history        = dashboardState.history;

    final Map<String, int> stockMap = {};

    for (final record in history) {
      final purchases = record["purchaseItems"] ?? [];
      final sales     = record["salesItems"] ?? [];

      for (final item in purchases) {
        final name = item["category"] ?? "Unknown";
        final qty  = ((item["quantity"] ?? 0) as num).toInt();
        stockMap[name] = (stockMap[name] ?? 0) + qty;
      }

      for (final item in sales) {
        final name = item["itemName"] ?? "Unknown";
        final qty  = ((item["quantity"] ?? 0) as num).toInt();
        stockMap[name] = (stockMap[name] ?? 0) - qty;
      }
    }

    final inventory  = stockMap.entries.toList();
    final totalItems = inventory.length;
    final totalStock = inventory.fold<int>(0, (sum, e) => sum + e.value);
    final outOfStock = inventory.where((e) => e.value <= 0).length;

    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 10), // thinner header
            decoration: const BoxDecoration(
              color: _red,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Inventory",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  "Stock levels at a glance",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // SUMMARY CARDS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _summaryCard(
                  "Total Items",
                  totalItems.toString(),
                  Icons.category_outlined,
                  _red,
                ),
                const SizedBox(width: 10),
                _summaryCard(
                  "Total Stock",
                  totalStock.toString(),
                  Icons.inventory_2_outlined,
                  Colors.blueGrey,
                ),
                const SizedBox(width: 10),
                _summaryCard(
                  "Out of Stock",
                  outOfStock.toString(),
                  Icons.remove_shopping_cart_outlined,
                  _orange,
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // SECTION LABEL
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "All Products",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
                letterSpacing: 0.4,
              ),
            ),
          ),

          const SizedBox(height: 10),

          // INVENTORY LIST
          Expanded(
            child: inventory.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 48,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "No inventory data yet",
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: inventory.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 1),
                    itemBuilder: (context, index) {
                      final item  = inventory[index];
                      final stock = item.value;

                      Color statusColor;
                      String statusLabel;

                      if (stock <= 0) {
                        statusLabel = "Out of Stock";
                        statusColor = _red;
                      } else if (stock < 5) {
                        statusLabel = "Low Stock";
                        statusColor = _orange;
                      } else {
                        statusLabel = "In Stock";
                        statusColor = _green;
                      }

                      final isFirst = index == 0;
                      final isLast  = index == inventory.length - 1;

                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: _line),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(isFirst ? 12 : 0),
                            topRight: Radius.circular(isFirst ? 12 : 0),
                            bottomLeft: Radius.circular(isLast ? 12 : 0),
                            bottomRight: Radius.circular(isLast ? 12 : 0),
                          ),
                        ),
                        child: Row(
                          children: [

                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: _bg,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.inventory_2_outlined,
                                size: 18,
                                color: Colors.grey.shade500,
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Text(
                                item.key,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1A1A1A),
                                ),
                              ),
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  stock.toString(),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1A1A1A),
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: statusColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    statusLabel,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: statusColor,
                                    ),
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

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _summaryCard(
      String title, String value, IconData icon, Color iconColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _line),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: iconColor),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              title,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}