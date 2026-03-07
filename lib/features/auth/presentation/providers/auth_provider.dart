import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store_sync/core/api/api_client.dart';
import 'package:store_sync/core/storage/token_storage.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';


// =====================
// STATE
// =====================
class AuthState {
  final bool isLoading;
  final UserEntity? user;
  final String? error;

  const AuthState({
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


// =====================
// NOTIFIER
// =====================
class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final AuthRepository repository;

  AuthNotifier(
    this.loginUseCase,
    this.logoutUseCase,
    this.repository,
  ) : super(const AuthState());

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
          error: "Invalid email or password",
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  // =======================
  // CHANGE PASSWORD
  // =======================
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await repository.changePassword(
        currentPassword,
        newPassword,
      );

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
      rethrow;
    }
  }

  // =======================
  // UPDATE PROFILE IMAGE
  // =======================
  void updateProfileImage(String imagePath) {
    if (state.user == null) return;

    final updatedUser = state.user!.copyWith(
      profileImage: imagePath,
    );

    state = state.copyWith(user: updatedUser);
  }

  // =======================
  // LOGOUT
  // =======================
  Future<void> logout() async {
    await logoutUseCase();
    state = const AuthState();
  }
}


// =====================
// PROVIDERS
// =====================

// Token Storage
final tokenStorageProvider =
    Provider<TokenStorage>((ref) => TokenStorage());

// API Client
final apiClientProvider =
    Provider<ApiClient>((ref) {
  final tokenStorage = ref.read(tokenStorageProvider);
  return ApiClient(tokenStorage);
});

// Repository
final authRepositoryProvider =
    Provider<AuthRepository>((ref) {
  final apiClient = ref.read(apiClientProvider);
  final tokenStorage = ref.read(tokenStorageProvider);

  return AuthRepositoryImpl(apiClient, tokenStorage);
});

// Use Cases
final loginUseCaseProvider =
    Provider<LoginUseCase>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return LoginUseCase(repository);
});

final logoutUseCaseProvider =
    Provider<LogoutUseCase>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return LogoutUseCase(repository);
});

// MAIN AUTH PROVIDER
final authProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final loginUseCase = ref.read(loginUseCaseProvider);
  final logoutUseCase = ref.read(logoutUseCaseProvider);
  final repository = ref.read(authRepositoryProvider);

  return AuthNotifier(
    loginUseCase,
    logoutUseCase,
    repository,
  );
});