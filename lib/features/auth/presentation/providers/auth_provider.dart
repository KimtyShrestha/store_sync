import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';
import '../../domain/entities/user_entity.dart';
import '../../data/datasources/local/auth_local_datasource.dart';
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
  final SignupUseCase signupUseCase;
  final LogoutUseCase logoutUseCase;

  AuthNotifier(
    this.loginUseCase,
    this.signupUseCase,
    this.logoutUseCase,
  ) : super(AuthState());

  
Future<void> signup(String fullName, String email, String phone, String password) async {
  state = state.copyWith(isLoading: true, error: null);

  try {
    final user = await signupUseCase(fullName, email, phone, password);

    if (user != null) {
      state = state.copyWith(isLoading: false); // Do NOT set user
    } else {
      state = state.copyWith(error: "Signup failed", isLoading: false);
    }
  } catch (e) {
    state = state.copyWith(error: e.toString(), isLoading: false);
  }
}

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await loginUseCase(email, password);
      if (user != null) {
        state = state.copyWith(user: user, isLoading: false);
      } else {
        state = state.copyWith(error: "Invalid email or password", isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

 Future<UserEntity?> loadSavedUser() async {
  try {
    final datasource = AuthLocalDataSourceImpl();
    final saved = await datasource.getUser();   // <-- FROM LOCAL STORAGE

    if (saved != null) {
      final user = saved.toEntity();
      state = state.copyWith(user: user);
      return user;
    }

    return null;
  } catch (e) {
    return null;
  }
}

Future<void> logout() async {
  await logoutUseCase();
  state = AuthState(); // clear state
} 
}

/// REAL PROVIDER WITH DEPENDENCIES
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final datasource = AuthLocalDataSourceImpl();
  final repository = AuthRepositoryImpl(datasource);

  return AuthNotifier(
    LoginUseCase(repository),
    SignupUseCase(repository),
    LogoutUseCase(repository),
  );
});
