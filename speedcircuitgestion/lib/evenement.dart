import 'package:flutter/material.dart';

class EvenementPage extends StatefulWidget {
  const EvenementPage({Key? key}) : super(key: key);

  @override
  State<EvenementPage> createState() => _EvenementPageState();
}

class _EvenementPageState extends State<EvenementPage> {
  List<String> evenements = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEvenements();
  }

  Future<void> _loadEvenements() async {
    try {
      // Remplacez ceci par votre appel à la base de données
      final data = await fetchEvenementsFromDatabase();
      setState(() {
        evenements = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Future<List<String>> fetchEvenementsFromDatabase() async {
    // Intégrez votre logique de base de données ici
    // (Firebase, API REST, SQLite, etc.)
    await Future.delayed(Duration(seconds: 1));
    return [
      'Course 1',
      'Essai 1',
      'Libre 1',
      'Evenement 2',
      'Evenement 4',
    ];
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