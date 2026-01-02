import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../../domain/entities/user_entity.dart';
import '../providers/auth_provider.dart';

import '../../../dashboard/presentation/pages/dashboard_screen.dart';
import 'login_screen.dart';

class AuthCheckPage extends ConsumerWidget {
  const AuthCheckPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authProvider);

    return FutureBuilder<UserEntity?>(
      future: ref.read(authProvider.notifier).loadSavedUser(),
      builder: (context, snapshot) {
        // Splash loading UI
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // If user exists → go to dashboard
        if (snapshot.data != null) {
          return const DashboardScreen();
        }

        // Otherwise → go to login
        return const LoginScreen();
      },
    );
  }
}
