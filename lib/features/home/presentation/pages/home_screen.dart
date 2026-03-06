import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../dashboard/presentation/providers/dashboard_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {

  static const _red   = Color(0xFFD32F2F);
  static const _green = Color(0xFF2E7D32);
  static const _blue  = Color(0xFF1565C0);
  static const _ink   = Color(0xFF111111);
  static const _muted = Color(0xFF888888);
  static const _line  = Color(0xFFEDEDED);
  static const _bg    = Color(0xFFFAFAFA);

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(dashboardProvider.notifier).loadBranchInfo();
      ref.read(dashboardProvider.notifier).loadHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(dashboardProvider);
    final authState      = ref.watch(authProvider);

    final managerName = authState.user != null
        ? "${authState.user!.firstName ?? ""} ${authState.user!.lastName ?? ""}".trim()
        : "";

    final history = dashboardState.history;

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              _buildHeader(managerName),

              if (dashboardState.isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: CircularProgressIndicator(color: _red, strokeWidth: 1.5),
                  ),
                ),

              if (dashboardState.error != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: Text(
                    dashboardState.error!,
                    style: const TextStyle(color: _red, fontSize: 12),
                  ),
                ),

              if (dashboardState.branchInfo != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: _branchCard(dashboardState),
                ),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: _buildKpiTiles(history),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
                child: _buildSalesTrend(history),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
                child: _buildInsights(history),
              ),

              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  // ── HEADER ────────────────────────────────────────────────────────────
  Widget _buildHeader(String managerName) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: const BoxDecoration(
        color: _red,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hello, ${managerName.isNotEmpty ? managerName : "Manager"}",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            "Here's your dashboard overview",
            style: TextStyle(
              fontSize: 12,
              color: Colors.white60,
            ),
          ),
        ],
      ),
    );
  }

  // ── BRANCH CARD ───────────────────────────────────────────────────────
  Widget _branchCard(dashboardState) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _line),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(Icons.store_rounded, color: _red, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dashboardState.branchInfo!.branchName,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _ink,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    _metaChip(Icons.location_on_outlined, dashboardState.branchInfo!.location),
                    const SizedBox(width: 16),
                    _metaChip(Icons.person_outline, dashboardState.branchInfo!.ownerName),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _metaChip(IconData icon, String label) {
    return Flexible(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: _muted),
          const SizedBox(width: 3),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11, color: _muted),
            ),
          ),
        ],
      ),
    );
  }

  // ── KPI CARDS ─────────────────────────────────────────────────────────
  Widget _buildKpiTiles(List history) {
    if (history.isEmpty) return const SizedBox();

    final today   = history.last;
    final sales   = (today["totalSales"]   ?? 0).toDouble();
    final expense = (today["totalExpense"] ?? 0).toDouble();
    final profit  = sales - expense;

    return Row(
      children: [
        _kpiCard("Today's Sales", sales,  _green, Icons.trending_up_rounded),
        const SizedBox(width: 12),
        _kpiCard("Net Profit",    profit, _blue,  Icons.account_balance_wallet_outlined),
      ],
    );
  }

  Widget _kpiCard(String title, double value, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 12),
            Text(
              "Rs ${value.toStringAsFixed(0)}",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: color,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 3),
            Text(title, style: const TextStyle(fontSize: 11, color: _muted)),
          ],
        ),
      ),
    );
  }

  // ── SALES TREND CHART ─────────────────────────────────────────────────
  Widget _buildSalesTrend(List history) {
    if (history.isEmpty) return const SizedBox();

    final recent = history.length > 7
        ? history.sublist(history.length - 7)
        : history;

    final maxSale = recent
        .map((e) => (e["totalSales"] ?? 0).toDouble())
        .reduce((a, b) => a > b ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: const [
            Text(
              "Sales Comparison",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: _ink,
                letterSpacing: -0.2,
              ),
            ),
            Text(
              "Last 7 days",
              style: TextStyle(fontSize: 11, color: _muted),
            ),
          ],
        ),

        const SizedBox(height: 14),

        Container(
          padding: const EdgeInsets.fromLTRB(12, 16, 12, 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _line),
          ),
          child: SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceBetween,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxSale / 4,
                  getDrawingHorizontalLine: (_) => const FlLine(
                    color: Color(0xFFF2F2F2),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles:   AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:  AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles:    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= recent.length) return const SizedBox();
                        final date = DateTime.parse(recent[index]["date"]);
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            "${date.day}/${date.month}",
                            style: const TextStyle(fontSize: 9, color: _muted),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                barGroups: recent.asMap().entries.map((entry) {
                  final sale      = (entry.value["totalSales"] ?? 0).toDouble();
                  final isHighest = sale == maxSale;
                  return BarChartGroupData(
                    x: entry.key,
                    barRods: [
                      BarChartRodData(
                        toY: sale,
                        width: 16,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                        color: isHighest ? _green : const Color(0xFFC8E6C9),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── INSIGHTS ──────────────────────────────────────────────────────────
  Widget _buildInsights(List history) {
    if (history.isEmpty) return const SizedBox();

    final highest = history.reduce((a, b) =>
        a["totalSales"] > b["totalSales"] ? a : b);
    final lowest  = history.reduce((a, b) =>
        a["totalSales"] < b["totalSales"] ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const Text(
          "Performance Insights",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: _ink,
            letterSpacing: -0.2,
          ),
        ),

        const SizedBox(height: 12),

        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _line),
          ),
          child: Column(
            children: [
              _insightRow(
                emoji: "🏆",
                label: "Highest Sales",
                value: "Rs ${highest["totalSales"]}",
                valueColor: _green,
                showDivider: true,
              ),
              _insightRow(
                emoji: "📉",
                label: "Lowest Sales",
                value: "Rs ${lowest["totalSales"]}",
                valueColor: _red,
                showDivider: false,
              ),
            ],
          ),
        ),

      ],
    );
  }

  Widget _insightRow({
    required String emoji,
    required String label,
    required String value,
    required Color valueColor,
    required bool showDivider,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          child: Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 13, color: _muted),
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: valueColor,
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(height: 1, indent: 16, endIndent: 16, color: _line),
      ],
    );
  }
}