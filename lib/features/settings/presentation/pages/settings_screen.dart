// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:image_picker/image_picker.dart';

// import '../../../auth/presentation/providers/auth_provider.dart';
// import '../../../dashboard/presentation/providers/dashboard_provider.dart';
// import '../../../profile/presentation/providers/profile_provider.dart';

// class SettingsScreen extends ConsumerStatefulWidget {
//   const SettingsScreen({super.key});

//   @override
//   ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
// }

// class _SettingsScreenState extends ConsumerState<SettingsScreen> {

//   File? selectedImage;
//   bool isUploading = false;

//   Future<void> pickImage() async {
//     final picker = ImagePicker();

//     final picked = await picker.pickImage(source: ImageSource.gallery);

//     if (picked == null) return;

//     setState(() {
//       selectedImage = File(picked.path);
//       isUploading = true;
//     });

//     try {

//       await ref.read(profileProvider.notifier).uploadImage(selectedImage!);

//       ref.read(authProvider.notifier).updateProfileImage(
//         "/uploads/${selectedImage!.path.split('/').last}"
//       );

//     } catch (e) {

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(e.toString()),
//           backgroundColor: Colors.red,
//         ),
//       );

//     }

//     setState(() {
//       isUploading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {

//     final authState = ref.watch(authProvider);
//     final dashboardState = ref.watch(dashboardProvider);

//     final user = authState.user;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Settings"),
//       ),

//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),

//         child: Column(
//           children: [

//             // PROFILE IMAGE
//             CircleAvatar(
//               radius: 60,
//               backgroundImage: selectedImage != null
//                   ? FileImage(selectedImage!)
//                   : user?.profileImage != null
//                       ? NetworkImage("http://10.0.2.2:5050${user!.profileImage!}")
//                       : null,

//               child: selectedImage == null && user?.profileImage == null
//                   ? const Icon(Icons.person, size: 60)
//                   : null,
//             ),

//             const SizedBox(height: 12),

//             ElevatedButton(
//               onPressed: isUploading ? null : pickImage,
//               child: isUploading
//                   ? const CircularProgressIndicator(color: Colors.white)
//                   : Text(
//                       user?.profileImage != null || selectedImage != null
//                           ? "Change Image"
//                           : "Upload New Image",
//                     ),
//             ),

//             const SizedBox(height: 30),

//             // PROFILE SECTION
//             const Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 "Profile",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//             ),

//             const SizedBox(height: 10),

//             Card(
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   children: [
//                     _infoRow("Name", "${user?.firstName ?? ""} ${user?.lastName ?? ""}"),
//                     _infoRow("Email", user?.email ?? ""),
//                     _infoRow("Role", user?.role ?? ""),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 25),

//             // BRANCH INFO
//             const Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 "Branch Information",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//             ),

//             const SizedBox(height: 10),

//             if (dashboardState.branchInfo != null)
//               Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     children: [
//                       _infoRow("Branch", dashboardState.branchInfo!.branchName),
//                       _infoRow("Location", dashboardState.branchInfo!.location),
//                       _infoRow("Owner", dashboardState.branchInfo!.ownerName),
//                     ],
//                   ),
//                 ),
//               ),

//             const SizedBox(height: 25),

//             // LOGOUT
//             Card(
//               child: ListTile(
//                 leading: const Icon(Icons.logout, color: Colors.red),
//                 title: const Text("Logout"),
//                 onTap: () async {

//                   await ref.read(authProvider.notifier).logout();

//                   Navigator.pushNamedAndRemoveUntil(
//                     context,
//                     '/login',
//                     (route) => false,
//                   );

//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   static Widget _infoRow(String title, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(title, style: const TextStyle(color: Colors.grey)),
//           Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
//         ],
//       ),
//     );
//   }
// }


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../dashboard/presentation/providers/dashboard_provider.dart';
import '../../../profile/presentation/providers/profile_provider.dart';

const _kRed        = Color(0xFFD32F2F);
const _kWhite      = Color(0xFFFFFFFF);
const _kBackground = Color(0xFFF5F5F5);
const _kLine       = Color(0xFFEDEDED);
const _kTextDark   = Color(0xFF1A1A1A);
const _kTextGrey   = Color(0xFF757575);

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {

  File? selectedImage;
  bool isUploading = false;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked == null) return;

    setState(() {
      selectedImage = File(picked.path);
      isUploading = true;
    });

    try {
      await ref.read(profileProvider.notifier).uploadImage(selectedImage!);
      ref.read(authProvider.notifier).updateProfileImage(
        "/uploads/${selectedImage!.path.split('/').last}",
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: _kWhite, size: 18),
              const SizedBox(width: 8),
              Expanded(child: Text(e.toString())),
            ],
          ),
          backgroundColor: _kRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(16),
        ),
      );
    }

    setState(() => isUploading = false);
  }

  @override
  Widget build(BuildContext context) {
    final authState      = ref.watch(authProvider);
    final dashboardState = ref.watch(dashboardProvider);
    final user           = authState.user;
    final hasImage       = selectedImage != null || user?.profileImage != null;

    return Scaffold(
      backgroundColor: _kBackground,
      appBar: AppBar(
        backgroundColor: _kRed,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: _kWhite),
        title: const Text(
          "Settings",
          style: TextStyle(
            color: _kWhite,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            const SizedBox(height: 28),

            // ── Avatar + name ───────────────────────────────────────────
            Center(
              child: Column(
                children: [

                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 46,
                        backgroundColor: _kLine,
                        backgroundImage: selectedImage != null
                            ? FileImage(selectedImage!) as ImageProvider
                            : user?.profileImage != null
                                ? NetworkImage(
                                    "http://10.0.2.2:5050${user!.profileImage!}")
                                : null,
                        child: !hasImage
                            ? const Icon(Icons.person,
                                size: 44, color: _kTextGrey)
                            : null,
                      ),

                      GestureDetector(
                        onTap: isUploading ? null : pickImage,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: _kWhite,
                            shape: BoxShape.circle,
                            border: Border.all(color: _kLine, width: 1.5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: isUploading
                              ? const Padding(
                                  padding: EdgeInsets.all(6),
                                  child: CircularProgressIndicator(
                                    color: _kRed,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.edit,
                                  size: 14, color: _kTextGrey),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Text(
                    "${user?.firstName ?? ""} ${user?.lastName ?? ""}".trim(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: _kTextDark,
                    ),
                  ),

                  const SizedBox(height: 4),

                  if (user?.role != null)
                    Text(
                      user!.role,
                      style: const TextStyle(
                        fontSize: 12,
                        color: _kTextGrey,
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // ── Profile ─────────────────────────────────────────────────
            _sectionLabel("Profile"),
            _infoCard([
              _infoRow(Icons.person_outline, "Name",
                  "${user?.firstName ?? ""} ${user?.lastName ?? ""}".trim()),
              _divider(),
              _infoRow(Icons.email_outlined, "Email", user?.email ?? ""),
              _divider(),
              _infoRow(Icons.badge_outlined,  "Role",  user?.role  ?? ""),
            ]),

            const SizedBox(height: 24),

            // ── Branch ──────────────────────────────────────────────────
            if (dashboardState.branchInfo != null) ...[
              _sectionLabel("Branch Information"),
              _infoCard([
                _infoRow(Icons.store_outlined,       "Branch",
                    dashboardState.branchInfo!.branchName),
                _divider(),
                _infoRow(Icons.location_on_outlined, "Location",
                    dashboardState.branchInfo!.location),
                _divider(),
                _infoRow(Icons.person_outline,       "Owner",
                    dashboardState.branchInfo!.ownerName),
              ]),
              const SizedBox(height: 24),
            ],

            // ── Logout ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: _kWhite,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _kLine),
                ),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  leading: const Icon(Icons.logout, color: _kRed, size: 20),
                  title: const Text(
                    "Logout",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _kRed,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right,
                      color: _kLine, size: 20),
                  onTap: () async {
                    await ref.read(authProvider.notifier).logout();
                    Navigator.pushNamedAndRemoveUntil(
                      context, '/login', (route) => false,
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────

  Widget _sectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: _kTextGrey,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }

  Widget _infoCard(List<Widget> rows) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: _kWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _kLine),
        ),
        child: Column(children: rows),
      ),
    );
  }

  static Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Row(
        children: [
          Icon(icon, size: 17, color: _kTextGrey),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: _kTextGrey),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _kTextDark,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _divider() =>
      const Divider(height: 1, thickness: 1, color: _kLine, indent: 16);
}