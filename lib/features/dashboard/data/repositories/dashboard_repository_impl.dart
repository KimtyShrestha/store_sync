import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../core/storage/cache_storage.dart';
import '../../../../core/storage/token_storage.dart';
import '../../../../core/utils/network_checker.dart';
import '../../domain/entities/branch_info_entity.dart';

const String baseUrl = "http://10.0.2.2:5050/api";

class DashboardRepositoryImpl {

  final TokenStorage _tokenStorage = TokenStorage();
  final CacheStorage _cacheStorage = CacheStorage();

  // =============================
  // GET BRANCH INFO
  // =============================
  Future<BranchInfoEntity> getMyBranchInfo() async {

    final online = await NetworkChecker.isOnline();

    if (!online) {

      final cached = await _cacheStorage.getCache("branch_info");

      if (cached != null) {
        return BranchInfoEntity(
          branchName: cached["branchName"] ?? "",
          location: cached["location"] ?? "",
          ownerName: cached["ownerName"] ?? "",
        );
      }

      throw Exception("No internet and no cached branch info available");
    }

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

    // SAVE CACHE
    await _cacheStorage.saveCache("branch_info", data);

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

    final online = await NetworkChecker.isOnline();

    if (!online) {

      final cached = await _cacheStorage.getCache("history_cache");

      if (cached != null) {
        return List<dynamic>.from(cached);
      }

      throw Exception("No internet and no cached history available");
    }

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

    final data = body["data"];

    // SAVE CACHE
    await _cacheStorage.saveCache("history_cache", data);

    return List<dynamic>.from(data);
  }
}