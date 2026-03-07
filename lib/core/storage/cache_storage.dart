import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CacheStorage {

  Future<void> saveCache(String key, dynamic data) async {

    final prefs = await SharedPreferences.getInstance();

    final encoded = jsonEncode(data);

    await prefs.setString(key, encoded);

  }

  Future<dynamic> getCache(String key) async {

    final prefs = await SharedPreferences.getInstance();

    final cached = prefs.getString(key);

    if (cached == null) return null;

    return jsonDecode(cached);

  }

}