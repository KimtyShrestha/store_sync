import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '../records/records_screen.dart';
import '../projects/projects_screen.dart';
import '../settings/settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    RecordsScreen(),
    ProjectsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,

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
            icon: Icon(Icons.work),
            label: "Projects",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Setting",
          ),
        ],
      ),
    );
  }
}
