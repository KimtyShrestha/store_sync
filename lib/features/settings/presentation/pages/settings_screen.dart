import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../profile/presentation/providers/profile_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: user?.profileImage != null
                ? NetworkImage("http://10.0.2.2:5050/${user!.profileImage!}")
                : null,
            child: user?.profileImage == null
                ? const Icon(Icons.person, size: 60)
                : null,
          ),

          const SizedBox(height: 16),

          ElevatedButton(
            onPressed: () async {
              final picker = ImagePicker();
              final picked = await picker.pickImage(source: ImageSource.gallery);

              if (picked != null) {
                final file = File(picked.path);
                await ref.read(profileProvider.notifier).uploadImage(file);
              }
            },
            child: const Text("Upload New Image"),
          )
        ],
      ),
    );
  }
}
