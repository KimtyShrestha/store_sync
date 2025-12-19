import 'package:flutter/material.dart';
import 'package:store_sync/screens/dashboard/dashboard_screen.dart';
import '../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),

              /// Logo
              Image.asset(
                "assets/images/store_logo3.png",
                height: 85,
              ),

              const SizedBox(height: 10),

              const SizedBox(height: 35),

              const Text(
                "Login to your Store Sync ID",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 35),

              /// USERNAME FIELD
              SizedBox(
                width: double.infinity,
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Enter your Username",
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: Colors.black26, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: Colors.black, width: 1.3),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              /// PASSWORD FIELD
              SizedBox(
                width: double.infinity,
                child: TextFormField(
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: "************",
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: Colors.black26, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: Colors.black, width: 1.3),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey[700],
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              /// FORGOT PASSWORD
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Forgot Password ?",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              /// LOGIN BUTTON
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.black, width: 1.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DashboardScreen(),
                      ),
                    );
                  },
                  child: const Text(
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
