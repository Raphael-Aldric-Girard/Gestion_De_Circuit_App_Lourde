import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  Future<Map<String, dynamic>> login(String identifiant, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'identifiant': identifiant, 'mdp': password}),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Echec de la connexion');
    }
  }
  
  // Dans votre classe ApiService

Future<List<String>> fetchVehicules() async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/vehicule'),
      headers: {'Content-Type': 'application/json'},
    );
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<String>.from(data ?? []);
      
    } else {
      throw Exception('Erreur ${response.statusCode}');
    }
  } catch (e) {
    print('Erreur API: $e');
    rethrow;
  }
}

  // Nouvelle méthode pour récupérer les événements
  Future<List<String>> fetchEvenements() async {
    final response = await http.get(Uri.parse('$baseUrl/evenement'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Echec du chargement des événements');
    }
  }
  


  final String baseUrl = 'http://172.16.194.254:5000';
}