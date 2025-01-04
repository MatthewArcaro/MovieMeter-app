import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginService {
  static const String apiUrl = 'http://192.168.1.172:5000/login';

  static Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'message': data['message'], // e.g., 'Login successful'
          'user_id': data['user_id'], // User ID
        };
      } else {
        throw Exception(json.decode(response.body)['error']);
      }
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }
}
