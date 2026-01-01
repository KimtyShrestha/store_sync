import 'package:flutter/material.dart';
import 'package:store_sync/features/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:store_sync/features/home/presentation/pages/home_screen.dart';
import 'features/splash/presentation/pages/splash_screen.dart';
import 'features/onboarding/presentation/pages/onboarding1_screen.dart';
import 'features/onboarding/presentation/pages/onboarding2_screen.dart';
import 'features/onboarding/presentation/pages/onboarding3_screen.dart';
import 'features/auth/presentation/pages/login_screen.dart';
import 'app/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: getApplicationTheme(),

      // Start from splash screen
      initialRoute: '/',

      // Named routes for navigation
      routes: {
        '/': (context) => const SplashScreen(),
        '/onboarding1': (context) => const Onboarding1Screen(),
        '/onboarding2': (context) => const Onboarding2Screen(),
        '/onboarding3': (context) => const Onboarding3Screen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/dashboard': (context) => const DashboardScreen(),
      },
    );
  }
}