import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../core/storage/token_storage.dart';
import '../../domain/entities/branch_info_entity.dart';

const String baseUrl = "http://10.0.2.2:5050/api";

class DashboardRepositoryImpl {
  final TokenStorage _tokenStorage = TokenStorage();

  // =============================
  // GET BRANCH INFO
  // =============================
  Future<BranchInfoEntity> getMyBranchInfo() async {
    final token = await _tokenStorage.getToken();

    if (token == null) {
      throw Exception("User not authenticated");
    }

    final response = await http.get(
      Uri.parse("$baseUrl/branch/my-branch"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    final body = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(body["message"] ?? "Failed to load branch info");
    }

    final data = body["data"];

    return BranchInfoEntity(
      branchName: data["branchName"] ?? "",
      location: data["location"] ?? "",
      ownerName: data["ownerName"] ?? "",
    );
  }

  // =============================
  // GET DAILY RECORD HISTORY
  // =============================
  Future<List<dynamic>> getHistory() async {
    final token = await _tokenStorage.getToken();

    if (token == null) {
      throw Exception("User not authenticated");
    }

    final response = await http.get(
      Uri.parse("$baseUrl/daily-record/history"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    final body = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(body["message"] ?? "Failed to load history");
    }

    return body["data"] as List<dynamic>;
  }
}