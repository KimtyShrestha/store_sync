import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/records_provider.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(recordsProvider.notifier).loadAllRecords();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(recordsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Record History"),
      ),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(RecordsState state) {
    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state.error != null) {
      return Center(
        child: Text(
          state.error!,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (state.allRecords.isEmpty) {
      return const Center(
        child: Text("No records found"),
      );
    }

    final records = List.from(state.allRecords);
    records.sort((a, b) => b.date.compareTo(a.date));

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: records.length,
      itemBuilder: (context, index) {
        final record = records[index];
        final profit = record.totalSales - record.totalExpense;

        return Card(
          elevation: 4,
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  _formatDate(record.date),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                _buildRow("Total Sales", record.totalSales, Colors.green),
                _buildRow("Total Expense", record.totalExpense, Colors.red),
                _buildRow("Total Purchases", record.totalPurchases, Colors.orange),

                const Divider(height: 24),

                _buildRow(
                  "Net Profit",
                  profit,
                  profit >= 0 ? Colors.green : Colors.red,
                  isBold: true,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRow(String label, double value, Color color, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            "Rs ${value.toStringAsFixed(2)}",
            style: TextStyle(
              color: color,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}