import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/daily_record_entity.dart';
import '../providers/records_provider.dart';

class CreateRecordScreen extends ConsumerStatefulWidget {
  const CreateRecordScreen({super.key});

  @override
  ConsumerState<CreateRecordScreen> createState() =>
      _CreateRecordScreenState();
}

class _CreateRecordScreenState
    extends ConsumerState<CreateRecordScreen>
    with SingleTickerProviderStateMixin {

  late TabController _tabController;

  final List<SalesItem> salesItems = [];
  final List<ExpenseItem> expenseItems = [];
  final List<PurchaseItem> purchaseItems = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    Future.microtask(() {
      ref.read(recordsProvider.notifier).loadTodayRecord();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(recordsProvider);

    ref.listen<RecordsState>(recordsProvider, (previous, next) {

      if (next.isSuccess && previous?.isSuccess != true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Daily record saved successfully"),
            backgroundColor: Colors.green,
          ),
        );
        ref.read(recordsProvider.notifier).resetSuccess();
      }

      if (next.error != null && next.error != previous?.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Colors.red,
          ),
        );
      }

      if (next.record != null && previous?.record != next.record) {
        salesItems
          ..clear()
          ..addAll(next.record!.salesItems);

        expenseItems
          ..clear()
          ..addAll(next.record!.expenseItems);

        purchaseItems
          ..clear()
          ..addAll(next.record!.purchaseItems);

        setState(() {});
      }
    });

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 10),

          const Text(
            "Today's Record",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          if (state.hasUnsavedChanges)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              color: Colors.orange.shade100,
              child: const Text(
                "You have unsaved changes",
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),

          const SizedBox(height: 10),

          _buildSummarySection(),

          const SizedBox(height: 10),

          TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            tabs: const [
              Tab(text: "Sales"),
              Tab(text: "Expenses"),
              Tab(text: "Purchases"),
            ],
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSalesTab(),
                _buildExpensesTab(),
                _buildPurchasesTab(),
              ],
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _addItemBasedOnTab,
        child: const Icon(Icons.add),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: state.isLoading
              ? null
              : () {
                  final record = DailyRecordEntity(
                    salesItems: salesItems,
                    expenseItems: expenseItems,
                    purchaseItems: purchaseItems,
                  );

                  ref.read(recordsProvider.notifier)
                      .submitRecord(record);
                },
          child: state.isLoading
              ? const CircularProgressIndicator()
              : const Text("Submit Record"),
        ),
      ),
    );
  }

  // ================= SUMMARY =================

  Widget _buildSummarySection() {
    final totalSales =
        salesItems.fold<double>(0, (sum, item) => sum + item.subtotal);

    final totalExpense =
        expenseItems.fold<double>(0, (sum, item) => sum + item.subtotal);

    final totalPurchases =
        purchaseItems.fold<double>(0, (sum, item) => sum + item.subtotal);

    final profit = totalSales - totalExpense;

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
              _summaryRow("Total Sales", totalSales, Colors.green),
              _summaryRow("Total Expense", totalExpense, Colors.red),
              _summaryRow("Total Purchases", totalPurchases, Colors.orange),
              const Divider(),
              _summaryRow(
                "Net Profit",
                profit,
                profit >= 0 ? Colors.green : Colors.red,
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
          Text(title,
              style: const TextStyle(fontWeight: FontWeight.w600)),
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

  // ================= SALES TAB =================

  Widget _buildSalesTab() {
    return ListView.builder(
      itemCount: salesItems.length,
      itemBuilder: (context, index) {
        final item = salesItems[index];

        return ListTile(
          title: Text(item.itemName),
          subtitle: Text(
              "Qty: ${item.quantity} | Price: ${item.price} | Subtotal: ${item.subtotal}"),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit,
                    color: Theme.of(context).primaryColor),
                onPressed: () =>
                    _showSalesDialog(existingItem: item, index: index),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() => salesItems.removeAt(index));
                  ref.read(recordsProvider.notifier)
                      .markUnsavedChanges();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ================= EXPENSE TAB =================

  Widget _buildExpensesTab() {
    return ListView.builder(
      itemCount: expenseItems.length,
      itemBuilder: (context, index) {
        final item = expenseItems[index];

        return ListTile(
          title: Text(item.category),
          subtitle: Text(
              "Qty: ${item.quantity} | Price: ${item.price} | Subtotal: ${item.subtotal}"),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit,
                    color: Theme.of(context).primaryColor),
                onPressed: () =>
                    _showExpenseDialog(existingItem: item, index: index),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() => expenseItems.removeAt(index));
                  ref.read(recordsProvider.notifier)
                      .markUnsavedChanges();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ================= PURCHASE TAB =================

  Widget _buildPurchasesTab() {
    return ListView.builder(
      itemCount: purchaseItems.length,
      itemBuilder: (context, index) {
        final item = purchaseItems[index];

        return ListTile(
          title: Text(item.category),
          subtitle: Text(
              "Qty: ${item.quantity} | Price: ${item.price} | Subtotal: ${item.subtotal}"),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit,
                    color: Theme.of(context).primaryColor),
                onPressed: () =>
                    _showPurchaseDialog(existingItem: item, index: index),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() => purchaseItems.removeAt(index));
                  ref.read(recordsProvider.notifier)
                      .markUnsavedChanges();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ================= ADD SWITCH =================

  void _addItemBasedOnTab() {
    switch (_tabController.index) {
      case 0:
        _showSalesDialog();
        break;
      case 1:
        _showExpenseDialog();
        break;
      case 2:
        _showPurchaseDialog();
        break;
    }
  }

  // ================= DIALOGS =================

  void _showSalesDialog({SalesItem? existingItem, int? index}) {
    final nameController =
        TextEditingController(text: existingItem?.itemName ?? "");
    final qtyController =
        TextEditingController(text: existingItem?.quantity.toString() ?? "");
    final priceController =
        TextEditingController(text: existingItem?.price.toString() ?? "");

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title:
            Text(existingItem == null ? "Add Sales Item" : "Edit Sales Item"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController),
            TextField(controller: qtyController, keyboardType: TextInputType.number),
            TextField(controller: priceController, keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              final updatedItem = SalesItem(
                itemName: nameController.text,
                quantity: int.parse(qtyController.text),
                price: double.parse(priceController.text),
              );

              setState(() {
                if (existingItem == null) {
                  salesItems.add(updatedItem);
                } else {
                  salesItems[index!] = updatedItem;
                }
              });

              ref.read(recordsProvider.notifier)
                  .markUnsavedChanges();

              Navigator.pop(context);
            },
            child: Text(existingItem == null ? "Add" : "Update"),
          )
        ],
      ),
    );
  }

  void _showExpenseDialog({ExpenseItem? existingItem, int? index}) {
    final categoryController =
        TextEditingController(text: existingItem?.category ?? "");
    final qtyController =
        TextEditingController(text: existingItem?.quantity.toString() ?? "");
    final priceController =
        TextEditingController(text: existingItem?.price.toString() ?? "");

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title:
            Text(existingItem == null ? "Add Expense Item" : "Edit Expense Item"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: categoryController),
            TextField(controller: qtyController, keyboardType: TextInputType.number),
            TextField(controller: priceController, keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              final updatedItem = ExpenseItem(
                category: categoryController.text,
                quantity: int.parse(qtyController.text),
                price: double.parse(priceController.text),
              );

              setState(() {
                if (existingItem == null) {
                  expenseItems.add(updatedItem);
                } else {
                  expenseItems[index!] = updatedItem;
                }
              });

              ref.read(recordsProvider.notifier)
                  .markUnsavedChanges();

              Navigator.pop(context);
            },
            child: Text(existingItem == null ? "Add" : "Update"),
          )
        ],
      ),
    );
  }

  void _showPurchaseDialog({PurchaseItem? existingItem, int? index}) {
    final categoryController =
        TextEditingController(text: existingItem?.category ?? "");
    final qtyController =
        TextEditingController(text: existingItem?.quantity.toString() ?? "");
    final priceController =
        TextEditingController(text: existingItem?.price.toString() ?? "");

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(existingItem == null
            ? "Add Purchase Item"
            : "Edit Purchase Item"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: categoryController),
            TextField(controller: qtyController, keyboardType: TextInputType.number),
            TextField(controller: priceController, keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              final updatedItem = PurchaseItem(
                category: categoryController.text,
                quantity: int.parse(qtyController.text),
                price: double.parse(priceController.text),
              );

              setState(() {
                if (existingItem == null) {
                  purchaseItems.add(updatedItem);
                } else {
                  purchaseItems[index!] = updatedItem;
                }
              });

              ref.read(recordsProvider.notifier)
                  .markUnsavedChanges();

              Navigator.pop(context);
            },
            child: Text(existingItem == null ? "Add" : "Update"),
          )
        ],
      ),
    );
  }
}