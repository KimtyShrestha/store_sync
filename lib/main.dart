import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:store_sync/features/auth/presentation/pages/auth_check_page.dart';

import 'app/theme/app_theme.dart';

// Screens
import 'features/splash/presentation/pages/splash_screen.dart';
import 'features/onboarding/presentation/pages/onboarding1_screen.dart';
import 'features/onboarding/presentation/pages/onboarding2_screen.dart';
import 'features/onboarding/presentation/pages/onboarding3_screen.dart';
import 'features/auth/presentation/pages/login_screen.dart';
import 'features/home/presentation/pages/home_screen.dart';
import 'features/dashboard/presentation/pages/dashboard_screen.dart';

// Hive Model
import 'features/auth/data/models/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());

  // Riverpod must wrap the App
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: getApplicationTheme(),

      initialRoute: '/',


      routes: {
        '/': (context) => const SplashScreen(),
        '/onboarding1': (context) => const Onboarding1Screen(),
        '/onboarding2': (context) => const Onboarding2Screen(),
        '/onboarding3': (context) => const Onboarding3Screen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/auth-check': (context) => const AuthCheckPage(),


      },
    );
  }
}
