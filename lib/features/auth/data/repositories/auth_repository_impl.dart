import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/storage/token_storage.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _apiClient;
  final TokenStorage _tokenStorage;

  AuthRepositoryImpl(this._apiClient, this._tokenStorage);

  // =======================
  // SIGNUP
  // =======================
  @override
  Future<UserEntity?> signup(
    String firstName,
    String lastName,
    String email,
    String password,
  ) async {
    final body = await _apiClient.post(
      ApiEndpoints.register,
      body: {
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "password": password,
        "confirmPassword": password,
        "role": "manager",
      },
    );

    final user = body["data"];

    return UserEntity(
      id: user["_id"],
      email: user["email"],
      role: user["role"],
      status: user["status"],
      firstName: user["firstName"],
      lastName: user["lastName"],
      ownerId: user["ownerId"],
      profileImage: user["profileImage"],
    );
  }

  // =======================
  // LOGIN
  // =======================
  @override
  Future<UserEntity?> login(String email, String password) async {
    final body = await _apiClient.post(
      ApiEndpoints.login,
      body: {
        "email": email,
        "password": password,
      },
    );

    final user = body["data"];
    final token = body["token"];

    await _tokenStorage.saveToken(token);

    return UserEntity(
      id: user["_id"],
      email: user["email"],
      role: user["role"],
      status: user["status"],
      firstName: user["firstName"],
      lastName: user["lastName"],
      ownerId: user["ownerId"],
      profileImage: user["profileImage"],
      token: token,
    );
  }

  // =======================
  // CHANGE PASSWORD
  // =======================
  @override
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    await _apiClient.patch(
      ApiEndpoints.changePassword,
      body: {
        "currentPassword": currentPassword,
        "newPassword": newPassword,
      },
      requiresAuth: true,
    );
  }

  // =======================
  // LOGOUT
  // =======================
  @override
  Future<void> logout() async {
    await _tokenStorage.clearToken();

    await _apiClient.post(ApiEndpoints.logout);
  }
}