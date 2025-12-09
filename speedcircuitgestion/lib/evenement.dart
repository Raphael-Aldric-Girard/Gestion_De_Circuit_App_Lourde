import 'package:flutter/material.dart';
import 'api_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title : 'Gestion des événements',
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
  List<String> evenements = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEvenements();
  }

  Future<void> _loadEvenements() async {
    try {
      final data = await apiService.fetchEvenements();

      setState(() {
        evenements = List<String>.from(data);
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
          : Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey[200],
                          ),
                          padding: EdgeInsets.all(16),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: evenements.length,
                            itemBuilder: (context, index) {
                              bool isEven = index % 2 == 0;
                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: isEven
                                      ? Color(0xFFff9999)
                                      : Color(0xFF8b7bb8),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Center(
                                  child: Text(
                                    evenements[index],
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Info clients',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 24),
                        ...List.generate(
                          6,
                          (index) => Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              '-' * 14,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
