import 'dart:convert';
import 'package:http/http.dart' as http;
import '../storage/token_storage.dart';
import 'api_endpoints.dart';

class ApiClient {
  final TokenStorage _tokenStorage;

  ApiClient(this._tokenStorage);

  Future<Map<String, String>> _buildHeaders({bool requiresAuth = false}) async {
    final headers = {
      "Content-Type": "application/json",
    };

    if (requiresAuth) {
      final token = await _tokenStorage.getToken();
      if (token != null && token.isNotEmpty) {
        headers["Authorization"] = "Bearer $token";
      }
    }

    return headers;
  }

  // ================= POST =================

  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = false,
  }) async {

    final headers = await _buildHeaders(requiresAuth: requiresAuth);

    final response = await http.post(
      Uri.parse("${ApiEndpoints.baseUrl}$endpoint"),
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );

    final decoded = jsonDecode(response.body);

    if (response.statusCode >= 400) {
      throw Exception(decoded["message"] ?? "Server Error");
    }

    return decoded;
  }

  // ================= PATCH =================

  Future<Map<String, dynamic>> patch(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = false,
  }) async {

    final headers = await _buildHeaders(requiresAuth: requiresAuth);

    final response = await http.patch(
      Uri.parse("${ApiEndpoints.baseUrl}$endpoint"),
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );

    final decoded = jsonDecode(response.body);

    if (response.statusCode >= 400) {
      throw Exception(decoded["message"] ?? "Server Error");
    }

    return decoded;
  }

  // ================= GET =================

  Future<Map<String, dynamic>> get(
    String endpoint, {
    bool requiresAuth = false,
  }) async {

    final headers = await _buildHeaders(requiresAuth: requiresAuth);

    final response = await http.get(
      Uri.parse("${ApiEndpoints.baseUrl}$endpoint"),
      headers: headers,
    );

    final decoded = jsonDecode(response.body);

    if (response.statusCode >= 400) {
      throw Exception(decoded["message"] ?? "Server Error");
    }

    return decoded;
  }
}