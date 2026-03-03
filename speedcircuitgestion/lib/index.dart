import 'package:flutter/material.dart';
import 'api_service.dart';
import 'evenement.dart';
import 'gestion_vehicule.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Page d\'acceuil',
      theme: ThemeData(primaryColor: Color(0xff1a0a7f)),
      home: Index(),
    );
  }
}

class Index extends StatefulWidget {
  const Index({Key? key}) : super(key: key);

  @override
  State<Index> createState() => _Index();
}

class _Index extends State<Index> {
  List<dynamic> info_user = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInformationUser();
  }

  Future<void> _loadInformationUser() async {
    try {
      final data = await ApiService().getCompte();
      print('Résultat API : $data');
      setState(() {
        info_user = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> menuItems = [];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1a0a7f),
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
            Text('Acceuil', style: TextStyle(color: Colors.white)),
          ],
        ),
        actions: [
          Container(
            color: Color(0xffd63447),
            padding: EdgeInsets.symmetric(horizontal: 16),
          ),
        ],
      ),
    );
  }
}
