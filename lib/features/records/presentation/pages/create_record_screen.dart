import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/expense_tab_list.dart';
import '../../domain/entities/daily_record_entity.dart';
import '../providers/records_provider.dart';
import '../widgets/record_summary_card.dart';
import '../widgets/sales_tab_list.dart';
import '../widgets/purchase_tab_list.dart';

import '../../dialogs/sales_item_dialog.dart';
import '../../dialogs/expense_item_dialog.dart';
import '../../dialogs/purchase_item_dialog.dart';

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
  late final ProviderSubscription<RecordsState> _recordsListener;

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

    _recordsListener = ref.listenManual<RecordsState>(
      recordsProvider,
      (previous, next) {

        // Populate UI lists when record loads
        if (next.record != null && previous?.record != next.record) {
          setState(() {
            salesItems
              ..clear()
              ..addAll(next.record!.salesItems);

            expenseItems
              ..clear()
              ..addAll(next.record!.expenseItems);

            purchaseItems
              ..clear()
              ..addAll(next.record!.purchaseItems);
          });
        }

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
      },
    );
  }

  @override
  void dispose() {
    _recordsListener.close();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final state = ref.watch(recordsProvider);

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

          RecordSummaryCard(
            salesItems: salesItems,
            expenseItems: expenseItems,
            purchaseItems: purchaseItems,
          ),

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

                SalesTabList(
                  salesItems: salesItems,
                  onDelete: (index) {
                    setState(() => salesItems.removeAt(index));
                    ref.read(recordsProvider.notifier)
                        .markUnsavedChanges();
                  },
                  onEdit: (index, item) {
                    _showSalesDialog(existingItem: item, index: index);
                  },
                ),

                ExpenseTabList(
                  expenseItems: expenseItems,
                  onDelete: (index) {
                    setState(() => expenseItems.removeAt(index));
                    ref.read(recordsProvider.notifier)
                        .markUnsavedChanges();
                  },
                  onEdit: (index, item) {
                    _showExpenseDialog(existingItem: item, index: index);
                  },
                ),

                PurchaseTabList(
                  purchaseItems: purchaseItems,
                  onDelete: (index) {
                    setState(() => purchaseItems.removeAt(index));
                    ref.read(recordsProvider.notifier)
                        .markUnsavedChanges();
                  },
                  onEdit: (index, item) {
                    _showPurchaseDialog(existingItem: item, index: index);
                  },
                ),
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

  // ================= SALES DIALOG =================

  void _showSalesDialog({SalesItem? existingItem, int? index}) {

    showDialog(
      context: context,
      builder: (_) => SalesItemDialog(
        existingItem: existingItem,
        onSave: (item) {

          setState(() {

            if (existingItem == null) {
              salesItems.add(item);
            } else {
              salesItems[index!] = item;
            }

          });

          ref.read(recordsProvider.notifier)
              .markUnsavedChanges();
        },
      ),
    );
  }

  // ================= EXPENSE DIALOG =================

  void _showExpenseDialog({ExpenseItem? existingItem, int? index}) {

    showDialog(
      context: context,
      builder: (_) => ExpenseItemDialog(
        existingItem: existingItem,
        onSave: (item) {

          setState(() {

            if (existingItem == null) {
              expenseItems.add(item);
            } else {
              expenseItems[index!] = item;
            }

          });

          ref.read(recordsProvider.notifier)
              .markUnsavedChanges();
        },
      ),
    );
  }

  // ================= PURCHASE DIALOG =================

  void _showPurchaseDialog({PurchaseItem? existingItem, int? index}) {

    showDialog(
      context: context,
      builder: (_) => PurchaseItemDialog(
        existingItem: existingItem,
        onSave: (item) {

          setState(() {

            if (existingItem == null) {
              purchaseItems.add(item);
            } else {
              purchaseItems[index!] = item;
            }

          });

          ref.read(recordsProvider.notifier)
              .markUnsavedChanges();
        },
      ),
    );
  }
}