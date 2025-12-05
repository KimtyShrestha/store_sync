import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: "Records",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.workspaces_outline),
            label: "Projects",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: "Setting",
          ),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 15),

              // HEADER: LOGO + Bell icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/store_logo2.png",
                        height: 28,
                      ),
                      const SizedBox(width: 6),

                    ],
                  ),

                  const Icon(Icons.notifications_none, size: 26),
                ],
              ),

              const SizedBox(height: 20),

              // Greeting
              const Text(
                "Hello",
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const Text(
                "Kimti Shrestha",
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              // Red Welcome Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.red.shade800,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome Kimty’s Collection",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      "Branch : Basundhara\n"
                          "Location : Kathmandu\n"
                          "Manager : Kumar Shrestha",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Big White Container (empty placeholder)
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
