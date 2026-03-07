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

// ─── Theme constants matching your app ───────────────────────────────────────
const _kRed        = Color(0xFFD32F2F);
const _kWhite      = Color(0xFFFFFFFF);
const _kBackground = Color(0xFFF5F5F5);
const _kTextDark   = Color(0xFF1A1A1A);
const _kTextGrey   = Color(0xFF757575);
// ─────────────────────────────────────────────────────────────────────────────

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

  final List<SalesItem>    salesItems    = [];
  final List<ExpenseItem>  expenseItems  = [];
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
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle, color: _kWhite, size: 18),
                  SizedBox(width: 8),
                  Text("Daily record saved successfully"),
                ],
              ),
              backgroundColor: Colors.green.shade600,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.all(16),
            ),
          );
          ref.read(recordsProvider.notifier).resetSuccess();
        }

        if (next.error != null && next.error != previous?.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error_outline, color: _kWhite, size: 18),
                  const SizedBox(width: 8),
                  Expanded(child: Text(next.error!)),
                ],
              ),
              backgroundColor: _kRed,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.all(16),
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
      backgroundColor: _kBackground,

      // ── Red header matching your dashboard ──────────────────────────────
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: const BoxDecoration(
            color: _kRed,
            borderRadius: BorderRadius.only(
              bottomLeft:  Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Today's Record",
                          style: TextStyle(
                            color: _kWhite,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "Add your daily sales, expenses & purchases",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Unsaved badge in header
                  if (state.hasUnsavedChanges)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white38),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.circle, color: Colors.orangeAccent,
                              size: 7),
                          SizedBox(width: 5),
                          Text(
                            "Unsaved",
                            style: TextStyle(
                              color: _kWhite,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),

      body: Column(
        children: [

          const SizedBox(height: 14),

          // ── Summary card ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: RecordSummaryCard(
              salesItems:    salesItems,
              expenseItems:  expenseItems,
              purchaseItems: purchaseItems,
            ),
          ),

          const SizedBox(height: 14),

          // ── Tab bar ───────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Container(
              height: 42,
              decoration: BoxDecoration(
                color: _kWhite,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.006),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: _kRed,
                  borderRadius: BorderRadius.circular(10),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: _kWhite,
                unselectedLabelColor: _kTextGrey,
                labelStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                dividerColor: Colors.transparent,
                overlayColor: WidgetStateProperty.resolveWith<Color?>(
                  (states) {
                    if (states.contains(WidgetState.hovered) ||
                        states.contains(WidgetState.pressed)) {
                      return const Color(0xFFEEEEEE);
                    }
                    return Colors.transparent;
                  },
                ),
                padding: const EdgeInsets.all(4),
                tabs: const [
                  Tab(text: "Sales"),
                  Tab(text: "Expenses"),
                  Tab(text: "Purchases"),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          // ── Tab content ───────────────────────────────────────────────
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [

                SalesTabList(
                  salesItems: salesItems,
                  onDelete: (index) {
                    setState(() => salesItems.removeAt(index));
                    ref.read(recordsProvider.notifier).markUnsavedChanges();
                  },
                  onEdit: (index, item) {
                    _showSalesDialog(existingItem: item, index: index);
                  },
                ),

                ExpenseTabList(
                  expenseItems: expenseItems,
                  onDelete: (index) {
                    setState(() => expenseItems.removeAt(index));
                    ref.read(recordsProvider.notifier).markUnsavedChanges();
                  },
                  onEdit: (index, item) {
                    _showExpenseDialog(existingItem: item, index: index);
                  },
                ),

                PurchaseTabList(
                  purchaseItems: purchaseItems,
                  onDelete: (index) {
                    setState(() => purchaseItems.removeAt(index));
                    ref.read(recordsProvider.notifier).markUnsavedChanges();
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

      // ── FAB ─────────────────────────────────────────────────────────────
      floatingActionButton: FloatingActionButton(
        onPressed: _addItemBasedOnTab,
        backgroundColor: const Color(0xFFEEEEEE),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.add, color: _kTextDark, size: 26),
      ),

      // ── Submit button ────────────────────────────────────────────────────
      bottomNavigationBar: Container(
        color: _kBackground,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: state.isLoading
                ? null
                : () {
                    final record = DailyRecordEntity(
                      salesItems:    salesItems,
                      expenseItems:  expenseItems,
                      purchaseItems: purchaseItems,
                    );
                    ref.read(recordsProvider.notifier).submitRecord(record);
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: _kRed,
              disabledBackgroundColor: _kRed.withValues(alpha: 0.05),
              foregroundColor: _kWhite,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: state.isLoading
                ? const SizedBox(
                    height: 20,
                    width:  20,
                    child:  CircularProgressIndicator(
                      color: _kWhite,
                      strokeWidth: 2.5,
                    ),
                  )
                : const Text(
                    "Submit Record",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  // ================= ADD SWITCH =================

  void _addItemBasedOnTab() {
    switch (_tabController.index) {
      case 0: _showSalesDialog();    break;
      case 1: _showExpenseDialog();  break;
      case 2: _showPurchaseDialog(); break;
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
          ref.read(recordsProvider.notifier).markUnsavedChanges();
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
          ref.read(recordsProvider.notifier).markUnsavedChanges();
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
          ref.read(recordsProvider.notifier).markUnsavedChanges();
        },
      ),
    );
  }
}