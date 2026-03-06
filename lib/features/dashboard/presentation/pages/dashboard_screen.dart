import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../home/presentation/pages/home_screen.dart';
import '../../../records/presentation/pages/create_record_screen.dart';
import '../../../records/presentation/pages/history_screen.dart';
import '../../../records/presentation/providers/records_provider.dart';
import '../../../settings/presentation/pages/settings_screen.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    CreateRecordScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final recordsState = ref.watch(recordsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Store Sync"),
        actions: [

          // 📊 History Button
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const HistoryScreen(),
                ),
              );
            },
          ),

          // 🚪 Logout Button (Protected)
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {

              if (recordsState.hasUnsavedChanges == true) {
                _showUnsavedDialog(context);
                return;
              }

              await ref.read(authProvider.notifier).logout();

              if (!mounted) return;

              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
          ),
        ],
      ),

      body: _screens[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: "Records",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }

  // ==============================
  // UNSAVED CHANGES DIALOG
  // ==============================
  void _showUnsavedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Unsaved Changes"),
        content: const Text(
          "You have unsaved changes.\n\nSubmit the record before logging out?",
        ),
        actions: [

          // Cancel
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),

          // Logout anyway
          TextButton(
            onPressed: () async {
              Navigator.pop(context);

              await ref.read(authProvider.notifier).logout();

              if (!mounted) return;

              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
            child: const Text(
              "Logout Anyway",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}