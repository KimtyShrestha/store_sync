import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/login_usecase.dart';
import '../../domain/entities/user_entity.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/logout_usecase.dart';

class AuthState {
  final bool isLoading;
  final UserEntity? user;
  final String? error;

  AuthState({
    this.isLoading = false,
    this.user,
    this.error,
  });

  AuthState copyWith({
    bool? isLoading,
    UserEntity? user,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;

  AuthNotifier(
    this.loginUseCase,
    this.logoutUseCase,
  ) : super(AuthState());



  // =======================
  // LOGIN
  // =======================
  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await loginUseCase(email, password);

      if (user != null) {
        state = state.copyWith(user: user, isLoading: false);
      } else {
        state = state.copyWith(
            error: "Invalid email or password", isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  // =======================
  // UPDATE PROFILE IMAGE
  // =======================
  Future<void> updateProfileImage(String imageUrl) async {
    if (state.user == null) return;

    final updatedUser = state.user!.copyWith(profileImage: imageUrl);

    state = state.copyWith(user: updatedUser);
  }

  // =======================
  // LOGOUT
  // =======================
  Future<void> logout() async {
    await logoutUseCase();
    state = AuthState();
  }
}

// Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = AuthRepositoryImpl();

  return AuthNotifier(
    LoginUseCase(repository),
    LogoutUseCase(repository),
  );
});