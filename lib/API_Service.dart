import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:5000'; // Replace with your Flask API URL

  // Fetch comments for a movie
  static Future<List<dynamic>> fetchComments(int movieId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/comments/$movieId'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load comments: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching comments: $e');
    }
  }

  // Post a new comment
  static Future<void> postComment(int movieId, int userId, String content) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/comments'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'movie_id': movieId,
          'user_id': userId,
          'content': content,
        }),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to post comment: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error posting comment: $e');
    }
  }

  // Change password
  static Future<void> changePassword({
    required int userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/change_password'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user_id': userId,
          'current_password': currentPassword,
          'new_password': newPassword,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to change password: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error changing password: $e');
    }
  }

  // Logout (if needed for backend session tracking, optional)
  static Future<void> logout(int userId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'user_id': userId}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to logout: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error logging out: $e');
    }
  }
}