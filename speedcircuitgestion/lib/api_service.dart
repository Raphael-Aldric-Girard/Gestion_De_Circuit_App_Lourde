import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://172.16.194.254:5000';

  Future<Map<String, dynamic>> login(String identifiant, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'identifiant': identifiant, 'mdp': password}),
      );
      
      print('Status code login: ${response.statusCode}');
      print('Response body login: ${response.body}');
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'error': 'Echec de la connexion - Code: ${response.statusCode}'};
      }
    } catch (e) {
      print('Erreur login: $e');
      return {'error': 'Erreur de connexion: $e'};
    }
  }

  Future<List<String>> fetchVehicules() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/vehicule'));
      
      print('Status code vehicules: ${response.statusCode}');
      print('Response body vehicules: ${response.body}');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => item.toString()).toList();
      } else {
        throw Exception('Echec du chargement des véhicules - Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur fetchVehicules: $e');
      throw Exception('Erreur: $e');
    }
  }

  Future<List<String>> fetchEvenements() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/evenement'));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => item.toString()).toList();
      } else {
        throw Exception('Echec du chargement des événements');
      }
    } catch (e) {
      print('Erreur fetchEvenements: $e');
      throw Exception('Erreur: $e');
    }
  }
}