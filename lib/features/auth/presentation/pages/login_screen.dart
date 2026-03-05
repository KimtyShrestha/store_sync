import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../dashboard/presentation/pages/dashboard_screen.dart';
import '../../presentation/providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _obscurePassword = true;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authProvider);

    // Listen for login success
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.user != null && previous?.user == null) {
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const DashboardScreen(),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),

              Image.asset("assets/images/store_logo3.png", height: 85),

              const SizedBox(height: 40),

              const Text(
                "Login to your Store Sync ID",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 35),

              // EMAIL FIELD
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Enter your Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // PASSWORD FIELD
              TextFormField(
                controller: passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // ERROR MESSAGE
              if (state.error != null)
                Text(
                  state.error!,
                  style: const TextStyle(color: Colors.red),
                ),

              const SizedBox(height: 20),

              // LOGIN BUTTON
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: state.isLoading
                      ? null
                      : () {
                          ref.read(authProvider.notifier).login(
                                emailController.text.trim(),
                                passwordController.text.trim(),
                              );
                        },
                  child: state.isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.black,
                        )
                      : const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}