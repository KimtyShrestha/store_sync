import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../auth/presentation/pages/login_screen.dart';

class Onboarding3Screen extends StatelessWidget {
  const Onboarding3Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // TEXT
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: "Let\n",
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                      const TextSpan(
                        text: "Store Sync\n",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(
                        text: "Be your Assistant, ",
                        style: TextStyle(color: Colors.white, fontSize: 22),
                      ),
                      const TextSpan(
                        text: "Solve it ",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(
                        text: "for you",
                        style: TextStyle(color: Colors.white, fontSize: 22),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 20),

              // IMAGE
              SizedBox(
                height: screenHeight * 0.70,
                child: Image.asset(
                  "assets/images/onboarding3.png",
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),

              const SizedBox(height: 20),

              // BUTTON
              SizedBox(
                width: 160,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),

                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool("seenOnboarding", true);

                    if (!context.mounted) return;

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },

                  child: const Text(
                    "Next",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}