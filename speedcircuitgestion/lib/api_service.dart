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
     return data.map<String>((vehicule) {
        final marque = vehicule["Marque"];
        final modele = vehicule["Modele"];
        return "$marque $modele";
      }).toList();
    } else {
      throw Exception('Erreur ${response.statusCode}');
    }
  } catch (e) {
    print('Erreur API: $e');
    rethrow;
  }
}

  // Nouvelle méthode pour récupérer les événements
  Future<List<Map<String, dynamic>>> fetchEvenements() async {
    final response = await http.get(Uri.parse('$baseUrl/evenement'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Echec du chargement des événements');
    }
  }

  Future<List<String>> fetchAllReservations() async {
    try{
      final response = await http.get(
        Uri.parse('$baseUrl/toutes-reservations'),
        headers: {'Content-Type': 'application/json'},
        );
      
      if (response.statusCode == 200){
        final data = jsonDecode(response.body);
        return data.map<String>((reservation) {
          final IdSession = reservation["IdSession"];
          final NbReservations = reservation["NbReservationMax"];
          final DateSession = reservation["DateSession"];
          final Marque = reservation["Marque"];
          final Modele = reservation["Modele"];
          final Prenom = reservation["Prenom"];
          final Nom = reservation["Nom"];
          return "$IdSession $NbReservations $DateSession $Marque $Modele $Prenom $Nom";
        }).toList();
      } else {
        throw Exception('Erreur ${response.statusCode}');
      }
  } catch (e) {
      print('Erreur API: $e');
      rethrow;
    }
  }

  Future<List<String>> fetchTodayReservations() async {
    final response = await http.get(Uri.parse('$baseUrl/toutes-reservations/today'));
    if (response.statusCode ==200){
      final dynamic data = json.decode(response.body);
      if (data is List) {
        return data.map((e) => e.toString()).toList();
      }
      throw Exception('Format de réponse invalide');
    } else {
      throw Exception('Echec du chargement des réservations d\'aujourd\'hui');  
    }
  }

  Future<List<String>> fetchPastReservations() async {
    final response = await http.get(Uri.parse('$baseUrl/toutes-reservations/past'));
    if (response.statusCode ==200){
      final dynamic data = json.decode(response.body);
      if (data is List) {
        return data.map((e) => e.toString()).toList();
      }
      throw Exception('Format de réponse invalide');
    } else {
      throw Exception('Echec du chargement des réservations passées');  
    }
  }
  
  final String baseUrl = 'http://172.16.194.254:5000';
}