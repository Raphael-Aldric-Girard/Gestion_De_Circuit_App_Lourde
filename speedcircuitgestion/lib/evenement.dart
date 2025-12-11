import 'package:flutter/material.dart';
import 'api_service.dart';
import 'dart:convert';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion des événements',
      theme: ThemeData(primaryColor: Color(0xFF1a0a7f)),
      home: EvenementPage(),
    );
  }
}

class EvenementPage extends StatefulWidget {
  const EvenementPage({Key? key}) : super(key: key);

  @override
  State<EvenementPage> createState() => _EvenementPageState();
}

class _EvenementPageState extends State<EvenementPage> {
  final ApiService apiService = ApiService();
  List<Map<String, dynamic>> evenements = [];  // ← Changement ici
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEvenements();
  }

  Future<void> _loadEvenements() async {
    try {
      final data = await apiService.fetchEvenements();
      print("Données des événements: $data");
      setState(() {
        evenements = data;  // ← Pas besoin de conversion
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Erreur de chargement : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1a0a7f),
        title: Row(
          children: [
            Text(
              'Speed Circuit',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(width: 40),
            Text('Accueil', style: TextStyle(color: Colors.white)),
          ],
        ),
        actions: [
          Container(
            color: Color(0xFFd63447),
            padding: EdgeInsets.symmetric(horizontal: 16),
          ),
        ],
      ),
      body: isLoading
    ? Center(child: CircularProgressIndicator())
    : Container(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            // En-têtes
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Text(
                      'Événement',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1a0a7f),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    width: 2,
                    height: 30,
                    color: Colors.transparent,
                  ),
                  Expanded(
                    child: Text(
                      'Date',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1a0a7f),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    width: 2,
                    height: 30,
                    color: Colors.transparent,
                  ),
                  Expanded(
                    child: Text(
                      'Prix',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1a0a7f),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            // Séparateur sous les en-têtes
            Divider(
              color: Color(0xFF1a0a7f),
              thickness: 2,
              height: 0,
            ),
            SizedBox(height: 16),
            // Liste des événements
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[200],
                ),
                padding: EdgeInsets.all(16),
                child: ListView.separated(
                  itemCount: evenements.length,
                  separatorBuilder: (context, index) => Divider(
                    color: Colors.grey[400],
                    thickness: 1,
                    height: 16,
                  ),
                  itemBuilder: (context, index) {
                    bool isEven = index % 2 == 0;
                    final Map<String, dynamic> evenement = evenements[index];
                    
                    // Extraction sécurisée des valeurs
                    String libelle = evenement['LibelleEvenement']?.toString() ?? 'Sans nom';
                    String dateStr = evenement['DateEvenement']?.toString() ?? 'Date inconnue';
                    String prix = evenement['Prix']?.toString() ?? '0';
                    
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: isEven
                            ? Color(0xFFff9999)
                            : Color(0xFF8b7bb8),
                      ),
                      padding: EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Text(
                              libelle,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            width: 2,
                            height: 30,
                            color: Colors.white.withOpacity(0.5),
                          ),
                          Expanded(
                            child: Text(
                              dateStr,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            width: 2,
                            height: 30,
                            color: Colors.white.withOpacity(0.5),
                          ),
                          Expanded(
                            child: Text(
                              '$prix €',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}