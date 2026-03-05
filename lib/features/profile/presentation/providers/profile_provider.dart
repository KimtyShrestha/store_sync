import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/services/image_upload_service.dart';

final profileProvider = StateNotifierProvider<ProfileNotifier, AsyncValue<String?>>((ref) {
  return ProfileNotifier(ref);
});

class ProfileNotifier extends StateNotifier<AsyncValue<String?>> {
  final Ref ref;
  final uploadService = ImageUploadService();

  ProfileNotifier(this.ref) : super(const AsyncValue.data(null));

  Future<void> uploadImage(File imageFile) async {
    try {
      state = const AsyncValue.loading();

      final user = ref.read(authProvider).user;
      if (user == null) throw Exception("Not logged in");

      final imagePath = await uploadService.uploadProfileImage(imageFile, user.id);

      if (imagePath != null) {
        ref.read(authProvider.notifier).updateProfileImage(imagePath);
      }

      state = AsyncValue.data(imagePath);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
