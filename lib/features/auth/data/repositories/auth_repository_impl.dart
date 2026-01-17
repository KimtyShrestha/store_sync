import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

// Android emulator localhost URL
const String baseUrl = "http://10.0.2.2:5050/api/auth";

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl();

  @override
  Future<UserEntity?> signup(
    String firstName,
    String lastName,
    String username,
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
        "username": username,
        "email": email,
        "password": password,
      }),
    );

    final body = jsonDecode(response.body);

    if (response.statusCode != 201) {
      throw Exception(body["message"] ?? "Signup failed");
    }

    final user = body["data"];

    return UserEntity(
      id: user["_id"],
      firstName: user["firstName"],
      lastName: user["lastName"],
      username: user["username"],
      email: user["email"],
      role: user["role"],
    );
  }

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

    return UserEntity(
      id: user["_id"],
      firstName: user["firstName"],
      lastName: user["lastName"],
      username: user["username"],
      email: user["email"],
      role: user["role"],
      token: body["token"],
    );
  }

  @override
  Future<void> logout() async {
    // No backend logout API needed
  }
}
