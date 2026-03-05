import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../core/storage/token_storage.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

// Android emulator localhost URL
const String baseUrl = "http://10.0.2.2:5050/api/auth";

class AuthRepositoryImpl implements AuthRepository {

  final TokenStorage _tokenStorage = TokenStorage();
  AuthRepositoryImpl();

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
    final url = Uri.parse("$baseUrl/register");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "password": password,
        "confirmPassword": password,
        "role": "manager", // Mobile app only for managers
      }),
    );

    final body = jsonDecode(response.body);

    if (response.statusCode != 201) {
      throw Exception(body["message"] ?? "Signup failed");
    }

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
  final url = Uri.parse("$baseUrl/login");

  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "email": email,
      "password": password,
    }),
  );

  final body = jsonDecode(response.body);

  if (response.statusCode != 200) {
    throw Exception(body["message"] ?? "Invalid credentials");
  }

  final user = body["data"];
  final token = body["token"];

  // Save token locally
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
  // LOGOUT
  // =======================
  @override
Future<void> logout() async {
  await _tokenStorage.clearToken();

  final url = Uri.parse("$baseUrl/logout");

  await http.post(
    url,
    headers: {"Content-Type": "application/json"},
  );
}
}