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

Future<List<Map<String, dynamic>>> fetchVehicules() async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/vehicule'),
      headers: {'Content-Type': 'application/json'},
    );
    
    if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map<Map<String, dynamic>>((vehicule) {
      return {
        "IdVehicule": vehicule["IdVehicule"],
        "Marque": vehicule["Marque"],
        "Modele": vehicule["Modele"],
      };
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
    try{
      final response = await http.get(
        Uri.parse('$baseUrl/toutes-reservations/today'),
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

  Future<List<String>> fetchPastReservations() async {
    try{
      final response = await http.get(
        Uri.parse('$baseUrl/toutes-reservations/past'),
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
  
  final String baseUrl = 'http://172.16.194.254:5000';
}