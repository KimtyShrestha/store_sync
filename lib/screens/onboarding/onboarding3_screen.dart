import 'package:flutter/material.dart';

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
                      TextSpan(
                        text: "Let\n",
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                      TextSpan(
                        text: "Store Sync\n",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: "Be your Assistant, ",
                        style: TextStyle(color: Colors.white, fontSize: 22),
                      ),
                      TextSpan(
                        text: "Solve it ",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: "for you",
                        style: TextStyle(color: Colors.white, fontSize: 22),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 20),

              // BIG IMAGE (same style as onboarding1)
              SizedBox(
                height: screenHeight * 0.70,
                child: Image.asset(
                  "assets/images/onboarding3.png",
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),

              const SizedBox(height: 20),

              // NEXT BUTTON (navigate to login for now)
              SizedBox(
                width: 160,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Navigate to LoginScreen once created
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Login screen not created yet"),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
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
