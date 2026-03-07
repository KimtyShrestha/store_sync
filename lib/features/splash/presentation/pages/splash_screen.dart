import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/storage/token_storage.dart';
import '../../../dashboard/presentation/pages/dashboard_screen.dart';
import '../../../auth/presentation/pages/login_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2));

    final prefs = await SharedPreferences.getInstance();
    final hasSeenOnboarding = prefs.getBool("seenOnboarding") ?? false;

    final tokenStorage = TokenStorage();
    final token = await tokenStorage.getToken();

    if (!mounted) return;

    // First time user → onboarding
    if (!hasSeenOnboarding) {
      Navigator.pushReplacementNamed(context, '/onboarding1');
      return;
    }

    // If token exists → dashboard
    if (token != null && token.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const DashboardScreen(),
        ),
      );
    } 
    // Otherwise → login
    else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}