import 'package:flutter/material.dart';
import 'api_service.dart';
import 'evenement.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpeedCircuit Authentification',
      theme: ThemeData(primaryColor: Color(0xFF1a0a7f)),
      home: AuthScreen(),
    );
  }
}

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _identifiantController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  Future<void> _login() async {
    final String identifiant = _identifiantController.text;
    final String password = _passwordController.text;

    try {
      final result = await ApiService().login(identifiant, password);
      if (result.containsKey('message')) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => EvenementPage())
        );
      } else {
        setState(() {
          _errorMessage = 'Echec de la connexion : ${result['error']}';
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'Erreur de connexion au serveur';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Connexion')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _identifiantController,
              decoration: InputDecoration(labelText: 'Identifiant'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Mot de passe'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _login, child: Text('Se conncter')),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(_errorMessage, style: TextStyle(color: Colors.red)),
              ),
          ],
        ),
      ),
    );
  }
}