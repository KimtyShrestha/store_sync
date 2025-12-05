import 'package:flutter/material.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/onboarding/onboarding1_screen.dart';
import 'screens/onboarding/onboarding2_screen.dart';
import 'screens/onboarding/onboarding3_screen.dart';
import 'screens/auth/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // Start from splash screen
      initialRoute: '/',

      // Named routes for navigation
      routes: {
        '/': (context) => const SplashScreen(),
        '/onboarding1': (context) => const Onboarding1Screen(),
        '/onboarding2': (context) => const Onboarding2Screen(),
        '/onboarding3': (context) => const Onboarding3Screen(),
        '/login': (context) => const LoginScreen(),  // ✅ Added
      },
    );
  }
}
