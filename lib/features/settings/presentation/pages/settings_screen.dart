import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../dashboard/presentation/providers/dashboard_provider.dart';
import '../../../profile/presentation/providers/profile_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final dashboardState = ref.watch(dashboardProvider);
    final user = authState.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // PROFILE IMAGE
            CircleAvatar(
              radius: 60,
              backgroundImage: user?.profileImage != null
                  ? NetworkImage("http://10.0.2.2:5050/${user!.profileImage!}")
                  : null,
              child: user?.profileImage == null
                  ? const Icon(Icons.person, size: 60)
                  : null,
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () async {
                final picker = ImagePicker();
                final picked =
                    await picker.pickImage(source: ImageSource.gallery);

                if (picked != null) {
                  final file = File(picked.path);
                  await ref
                      .read(profileProvider.notifier)
                      .uploadImage(file);
                }
              },
              child: const Text("Upload New Image"),
            ),

            const SizedBox(height: 30),

            // PROFILE INFO
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Profile",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 10),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _infoRow("Name",
                        "${user?.firstName ?? ""} ${user?.lastName ?? ""}"),
                    _infoRow("Email", user?.email ?? ""),
                    _infoRow("Role", user?.role ?? ""),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            // BRANCH INFO
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Branch Information",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 10),

            if (dashboardState.branchInfo != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _infoRow(
                          "Branch",
                          dashboardState.branchInfo!.branchName),
                      _infoRow(
                          "Location",
                          dashboardState.branchInfo!.location),
                      _infoRow(
                          "Owner",
                          dashboardState.branchInfo!.ownerName),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 25),

            // SECURITY
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Security",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 10),

            Card(
              child: ListTile(
                leading: const Icon(Icons.lock),
                title: const Text("Change Password"),
                trailing:
                    const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  _showChangePasswordDialog(context, ref);
                },
              ),
            ),

            const SizedBox(height: 20),

            // LOGOUT
            Card(
              child: ListTile(
                leading:
                    const Icon(Icons.logout, color: Colors.red),
                title: const Text("Logout"),
                onTap: () async {
                  await ref.read(authProvider.notifier).logout();

                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(color: Colors.grey)),
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(
      BuildContext context, WidgetRef ref) {
    final currentController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Change Password"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentController,
              obscureText: true,
              decoration: const InputDecoration(
                  labelText: "Current Password"),
            ),
            TextField(
              controller: newController,
              obscureText: true,
              decoration: const InputDecoration(
                  labelText: "New Password"),
            ),
            TextField(
              controller: confirmController,
              obscureText: true,
              decoration: const InputDecoration(
                  labelText: "Confirm Password"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (newController.text !=
                  confirmController.text) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content: Text(
                        "Passwords do not match"),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              try {
                await ref
                    .read(authProvider.notifier)
                    .changePassword(
                      currentController.text,
                      newController.text,
                    );

                Navigator.pop(context);

                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content: Text(
                        "Password updated successfully"),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  SnackBar(
                    content: Text(e.toString()),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }
}