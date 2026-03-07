// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../../../dashboard/presentation/pages/dashboard_screen.dart';
// import '../../presentation/providers/auth_provider.dart';

// class LoginScreen extends ConsumerStatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   ConsumerState<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends ConsumerState<LoginScreen> {
//   bool _obscurePassword = true;

//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();

//   @override
//   void dispose() {
//     emailController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final state = ref.watch(authProvider);

//     // Listen for login success
//     ref.listen<AuthState>(authProvider, (previous, next) {
//       if (next.user != null && previous?.user == null) {
//         if (!mounted) return;

//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (_) => const DashboardScreen(),
//           ),
//         );
//       }
//     });

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 24),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const SizedBox(height: 60),

//               Image.asset("assets/images/store_logo3.png", height: 85),

//               const SizedBox(height: 40),

//               const Text(
//                 "Login to your Store Sync ID",
//                 style: TextStyle(
//                   fontSize: 15,
//                   color: Colors.black87,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),

//               const SizedBox(height: 35),

//               // EMAIL FIELD
//               TextFormField(
//                 controller: emailController,
//                 decoration: InputDecoration(
//                   hintText: "Enter your Email",
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 22),

//               // PASSWORD FIELD
//               TextFormField(
//                 controller: passwordController,
//                 obscureText: _obscurePassword,
//                 decoration: InputDecoration(
//                   hintText: "Password",
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       _obscurePassword
//                           ? Icons.visibility_off
//                           : Icons.visibility,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         _obscurePassword = !_obscurePassword;
//                       });
//                     },
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 10),

//               // ERROR MESSAGE
//               if (state.error != null)
//                 Text(
//                   state.error!,
//                   style: const TextStyle(color: Colors.red),
//                 ),

//               const SizedBox(height: 20),

//               // LOGIN BUTTON
//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: OutlinedButton(
//                   onPressed: state.isLoading
//                       ? null
//                       : () {
//                           ref.read(authProvider.notifier).login(
//                                 emailController.text.trim(),
//                                 passwordController.text.trim(),
//                               );
//                         },
//                   child: state.isLoading
//                       ? const CircularProgressIndicator(
//                           color: Colors.black,
//                         )
//                       : const Text(
//                           "Login",
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.black,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                 ),
//               ),

//               const SizedBox(height: 40),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../dashboard/presentation/pages/dashboard_screen.dart';
import '../../presentation/providers/auth_provider.dart';

const _kRed        = Color(0xFFD32F2F);
const _kWhite      = Color(0xFFFFFFFF);
const _kBackground = Color(0xFFF5F5F5);
const _kLine       = Color(0xFFE0E0E0);
const _kTextDark   = Color(0xFF1A1A1A);
const _kTextGrey   = Color(0xFF757575);

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _obscurePassword = true;

  final emailController    = TextEditingController();
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

    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.user != null && previous?.user == null) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
        );
      }
    });

    return Scaffold(
      backgroundColor: _kWhite,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
        children: [

          // ── Decorative circles ────────────────────────────────────────
          Positioned(
            top: -70,
            right: -70,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _kRed.withValues(alpha: 0.06),
              ),
            ),
          ),
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _kRed.withValues(alpha:0.08),
              ),
            ),
          ),
          Positioned(
            top: 320,
            left: -110,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _kRed.withValues(alpha:0.05),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: -60,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _kRed.withValues(alpha:0.06),
              ),
            ),
          ),
          Positioned(
            bottom: 60,
            right: -20,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _kRed.withValues(alpha:0.08),
              ),
            ),
          ),

          // ── Content ───────────────────────────────────────────────────
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const SizedBox(height: 56),

                  // Logo
                  Image.asset(
                    "assets/images/store_logo2.png",
                    height: 52,
                  ),

                  const SizedBox(height: 52),

                  // Red accent bar
                  Container(
                    width: 32,
                    height: 3,
                    decoration: BoxDecoration(
                      color: _kRed,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Welcome back",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: _kTextDark,
                      letterSpacing: 0.2,
                      height: 1.1,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    "Login to your Store Sync ID",
                    style: TextStyle(fontSize: 13, color: _kTextGrey),
                  ),

                  const SizedBox(height: 36),

                  // ── Email ──────────────────────────────────────────────
                  _fieldLabel("Email"),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(fontSize: 14, color: _kTextDark),
                    decoration: _inputDecoration(
                      hint: "you@example.com",
                      icon: Icons.email_outlined,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Password ───────────────────────────────────────────
                  _fieldLabel("Password"),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: passwordController,
                    obscureText: _obscurePassword,
                    style: const TextStyle(fontSize: 14, color: _kTextDark),
                    decoration: _inputDecoration(
                      hint: "Enter your password",
                      icon: Icons.lock_outline,
                    ).copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 20,
                          color: _kTextGrey,
                        ),
                        onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                  ),

                  // ── Error ──────────────────────────────────────────────
                  if (state.error != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEBEE),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: _kRed.withValues(alpha:0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline,
                              color: _kRed, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              state.error!,
                              style: const TextStyle(
                                  color: _kRed, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 36),

                  // ── Login button ───────────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: state.isLoading
                          ? null
                          : () {
                              ref.read(authProvider.notifier).login(
                                    emailController.text.trim(),
                                    passwordController.text.trim(),
                                  );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _kRed,
                        disabledBackgroundColor: _kRed.withValues(alpha:0.5),
                        foregroundColor: _kWhite,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: state.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: _kWhite,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.4,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── Bottom divider ─────────────────────────────────────
                  Row(
                    children: [
                      Expanded(child: Divider(color: _kLine, thickness: 1)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          "Store Sync",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade400,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: _kLine, thickness: 1)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────

  static Widget _fieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: _kTextDark,
        letterSpacing: 0.3,
      ),
    );
  }

  static InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: _kTextGrey, fontSize: 13),
      prefixIcon: Icon(icon, size: 18, color: _kTextGrey),
      filled: true,
      fillColor: _kBackground,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _kLine),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _kRed, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _kRed),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _kRed, width: 1.5),
      ),
    );
  }
}