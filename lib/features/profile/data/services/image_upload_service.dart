import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ImageUploadService {
  // Backend Base URL
  // static const String baseUrl = "http://10.0.2.2:5050/api/user";

    static const String baseUrl = "http://10.166.172.155:5050/api";
  

  Future<String?> uploadProfileImage(File imageFile, String userId) async {
    final uri = Uri.parse("$baseUrl/upload-profile/$userId");

    final request = http.MultipartRequest("PUT", uri);

    // Add image file
    request.files.add(
      await http.MultipartFile.fromPath("profileImage", imageFile.path),
    );

    try {
      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Backend returns:  data.profileImage
        return data["data"]["profileImage"];
      } else {
        print("Upload failed: ${response.body}");
        return null;
      }
    } catch (e) {
      // ignore: avoid_print
      print("Error uploading image: $e");
      return null;
    }
  }
}
