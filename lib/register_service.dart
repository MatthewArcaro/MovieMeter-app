import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterService {
  static const String apiUrl = 'http://192.168.1.172:5000/register'; // Replace with your Flask server URL

  static Future<Map<String, dynamic>> register(String username, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        return json.decode(response.body); // Returns { "message": "...", "user_id": ... }
      } else {
        final error = json.decode(response.body)['error'];
        throw Exception(error);
      }
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }
}
