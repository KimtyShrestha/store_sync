import 'package:flutter/material.dart';
import 'onboarding3_screen.dart';

class Onboarding2Screen extends StatelessWidget {
  const Onboarding2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 30),

            /// Title Text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: "Too Many ",
                      style: TextStyle(color: Colors.white, fontSize: 26),
                    ),
                    const TextSpan(
                      text: "Tasks",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(
                      text: ", Too Little Time?",
                      style: TextStyle(color: Colors.white, fontSize: 26),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 10),


            Transform.translate(
              offset: const Offset(0, -40),
              child: SizedBox(
                height: screenHeight * 0.60,
                width: double.infinity,
                child: Image.asset(
                  "assets/images/onboarding2.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 10),

            /// Next Button
            Padding(
              padding: const EdgeInsets.only(bottom: 25),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Onboarding3Screen(),
                    ),
                  );
                },
                child: const Text(
                  "Next",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
