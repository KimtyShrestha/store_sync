import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sensors_plus/sensors_plus.dart';

import 'dart:io';
import 'dart:async';

import '../widgets/expense_tab_list.dart';
import '../widgets/sales_tab_list.dart';
import '../widgets/purchase_tab_list.dart';
import '../widgets/record_summary_card.dart';

import '../../dialogs/sales_item_dialog.dart';
import '../../dialogs/expense_item_dialog.dart';
import '../../dialogs/purchase_item_dialog.dart';

import '../../domain/entities/daily_record_entity.dart';
import '../providers/records_provider.dart';

/// Theme constants
const _kRed = Color(0xFFD32F2F);
const _kWhite = Color(0xFFFFFFFF);
const _kBackground = Color(0xFFF5F5F5);
const _kTextDark = Color(0xFF1A1A1A);
const _kTextGrey = Color(0xFF757575);

class CreateRecordScreen extends ConsumerStatefulWidget {
  const CreateRecordScreen({super.key});

  @override
  ConsumerState<CreateRecordScreen> createState() =>
      _CreateRecordScreenState();
}

class _CreateRecordScreenState extends ConsumerState<CreateRecordScreen>
    with SingleTickerProviderStateMixin {

  /// Image
  File? selectedImage;
  final ImagePicker picker = ImagePicker();

  /// Accelerometer
  StreamSubscription? accelerometerSubscription;
  double lastX = 0;
  double lastY = 0;
  double lastZ = 0;
  DateTime lastShakeTime = DateTime.now();

  /// Tabs
  late TabController _tabController;

  /// Riverpod listener
  late final ProviderSubscription<RecordsState> _recordsListener;

  /// Lists
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

    /// Provider listener
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

        /// Success message
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
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );

          ref.read(recordsProvider.notifier).resetSuccess();
        }

        /// Error message
        if (next.error != null && next.error != previous?.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error_outline, color: _kWhite),
                  const SizedBox(width: 8),
                  Expanded(child: Text(next.error!)),
                ],
              ),
              backgroundColor: _kRed,
            ),
          );
        }
      },
    );

    /// Shake detection
    accelerometerSubscription = accelerometerEvents.listen((event) {

      double dx = (event.x - lastX).abs();
      double dy = (event.y - lastY).abs();
      double dz = (event.z - lastZ).abs();

      double movement = dx + dy + dz;

      if (movement > 25) {

        final now = DateTime.now();

        if (now.difference(lastShakeTime).inSeconds > 2) {

          lastShakeTime = now;

          debugPrint("PHONE SHAKEN");

          _showDeleteConfirmation();
        }
      }

      lastX = event.x;
      lastY = event.y;
      lastZ = event.z;
    });
  }

  /// Take Photo
  Future<void> takePhoto() async {

    final XFile? image = await picker.pickImage(
      source: ImageSource.camera,
    );

    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  /// Delete Confirmation
  void _showDeleteConfirmation() {

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {

        return AlertDialog(
          title: const Text("Clear all records?"),
          content: const Text(
            "You shook the phone. Do you want to delete all items in today's record?",
          ),
          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () {

                setState(() {
                  salesItems.clear();
                  expenseItems.clear();
                  purchaseItems.clear();
                });

                ref.read(recordsProvider.notifier).markUnsavedChanges();

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("All records cleared"),
                  ),
                );
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    accelerometerSubscription?.cancel();
    _recordsListener.close();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final state = ref.watch(recordsProvider);

    return Scaffold(
      backgroundColor: _kBackground,

      /// AppBar
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: const BoxDecoration(
            color: _kRed,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: const SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
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
                ],
              ),
            ),
          ),
        ),
      ),

      /// Body
      body: Column(
        children: [

          const SizedBox(height: 14),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: RecordSummaryCard(
              salesItems: salesItems,
              expenseItems: expenseItems,
              purchaseItems: purchaseItems,
            ),
          ),

          const SizedBox(height: 14),

          /// Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Container(
              height: 42,
              decoration: BoxDecoration(
                color: _kWhite,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: _kRed,
                  borderRadius: BorderRadius.circular(10),
                ),
                labelColor: _kWhite,
                unselectedLabelColor: _kTextGrey,
                tabs: const [
                  Tab(text: "Sales"),
                  Tab(text: "Expenses"),
                  Tab(text: "Purchases"),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [

                SalesTabList(
                  salesItems: salesItems,
                  onDelete: (i) {
                    setState(() => salesItems.removeAt(i));
                    ref.read(recordsProvider.notifier).markUnsavedChanges();
                  },
                  onEdit: (i, item) {
                    _showSalesDialog(existingItem: item, index: i);
                  },
                ),

                ExpenseTabList(
                  expenseItems: expenseItems,
                  onDelete: (i) {
                    setState(() => expenseItems.removeAt(i));
                    ref.read(recordsProvider.notifier).markUnsavedChanges();
                  },
                  onEdit: (i, item) {
                    _showExpenseDialog(existingItem: item, index: i);
                  },
                ),

                PurchaseTabList(
                  purchaseItems: purchaseItems,
                  onDelete: (i) {
                    setState(() => purchaseItems.removeAt(i));
                    ref.read(recordsProvider.notifier).markUnsavedChanges();
                  },
                  onEdit: (i, item) {
                    _showPurchaseDialog(existingItem: item, index: i);
                  },
                ),
              ],
            ),
          ),
        ],
      ),

      /// FAB
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [

          FloatingActionButton(
            heroTag: "camera",
            onPressed: takePhoto,
            backgroundColor: const Color(0xFFEEEEEE),
            child: const Icon(Icons.camera_alt, color: _kTextDark),
          ),

          const SizedBox(width: 10),

          FloatingActionButton(
            heroTag: "add",
            onPressed: _addItemBasedOnTab,
            backgroundColor: const Color(0xFFEEEEEE),
            child: const Icon(Icons.add, color: _kTextDark),
          ),
        ],
      ),

      /// Submit button
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: state.isLoading ? null : () {

              final record = DailyRecordEntity(
                salesItems: salesItems,
                expenseItems: expenseItems,
                purchaseItems: purchaseItems,
              );

              ref.read(recordsProvider.notifier).submitRecord(record);

            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _kRed,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: state.isLoading
                ? const CircularProgressIndicator(color: _kWhite)
                : const Text(
                    "Submit Record",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  /// Add item
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

  /// Sales dialog
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

  /// Expense dialog
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

  /// Purchase dialog
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