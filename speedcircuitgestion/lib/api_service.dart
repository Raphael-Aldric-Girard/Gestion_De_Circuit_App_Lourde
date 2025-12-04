import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  Future<Map<String, dynamic>> login(String identifiant, String password) async {
    final response = await http.post(
      Uri.parse('$base64Url/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'identifiant': identifiant, 'password': password}),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Echec de la connexion');
    }
  }

  final String baseUrl = 'http://172.16.194.254:5000';
}