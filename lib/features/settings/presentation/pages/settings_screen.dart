import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../dashboard/presentation/providers/dashboard_provider.dart';
import '../../../profile/presentation/providers/profile_provider.dart';

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
        "/uploads/${selectedImage!.path.split('/').last}"
      );

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );

    }

    setState(() {
      isUploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

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
              backgroundImage: selectedImage != null
                  ? FileImage(selectedImage!)
                  : user?.profileImage != null
                      ? NetworkImage("http://10.0.2.2:5050${user!.profileImage!}")
                      : null,

              child: selectedImage == null && user?.profileImage == null
                  ? const Icon(Icons.person, size: 60)
                  : null,
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: isUploading ? null : pickImage,
              child: isUploading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      user?.profileImage != null || selectedImage != null
                          ? "Change Image"
                          : "Upload New Image",
                    ),
            ),

            const SizedBox(height: 30),

            // PROFILE SECTION
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
                    _infoRow("Name", "${user?.firstName ?? ""} ${user?.lastName ?? ""}"),
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
                      _infoRow("Branch", dashboardState.branchInfo!.branchName),
                      _infoRow("Location", dashboardState.branchInfo!.location),
                      _infoRow("Owner", dashboardState.branchInfo!.ownerName),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 25),

            // LOGOUT
            Card(
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}