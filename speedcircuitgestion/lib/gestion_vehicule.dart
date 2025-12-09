import 'api_service.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion des véhicules',
      theme: ThemeData(primaryColor: Color(0xFF1a0a7f)),
      home: GestionVehicule(),
    );
  }
}


class GestionVehicule extends StatefulWidget {
  const GestionVehicule({Key? key}): super(key: key);
  //final String title;

  @override
  State<GestionVehicule> createState() => _GestionVehicule();
}

class _GestionVehicule extends State<GestionVehicule> {
  

  List<String> nom_vehicule = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVehicules();
  }

  Future<void> _loadVehicules() async {
    try {
      // Appel à l'API pour récupérer les noms des véhicules
      final data = await ApiService().fetchVehicules();
      setState(() {
        nom_vehicule = data;  
        isLoading = false;
      });
      
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Erreur de chargement des véhicules : $e");
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
                fontStyle: FontStyle.italic
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
          : ListView.builder(
              itemCount: nom_vehicule.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(nom_vehicule[index]),
                );
              },
            ),
    );
  }
}