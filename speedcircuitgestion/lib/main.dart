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
  bool _isLoading = false;

  Future<void> _login() async {
    final String identifiant = _identifiantController.text.trim();
    final String password = _passwordController.text.trim();

    // Validation basique
    if (identifiant.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Veuillez remplir tous les champs';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final result = await ApiService().login(identifiant, password);
      
      print('Résultat API: $result'); // Debug
      
      // Vérifier si la connexion a réussi
      if (result != null && !result.containsKey('error')) {
        // Connexion réussie - navigation
        if (mounted) {
          switch (result['user']['Poste']) {
            case 1:
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => EvenementPage())
              );
              break;
            case 2:
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => GestionVehicule())
              );
              break;
            default:
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => EvenementPage())
              );
          }
        }
      } else {
        // Échec de connexion
        setState(() {
          _errorMessage = result['error'] ?? 'Identifiants incorrects';
          _isLoading = false;
        });
      }
    } catch (error) {
      print('Erreur: $error'); // Debug
      setState(() {
        _errorMessage = 'Erreur de connexion au serveur: $error';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _identifiantController.dispose();
    _passwordController.dispose();
    super.dispose();
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
              decoration: InputDecoration(
                labelText: 'Identifiant',
                border: OutlineInputBorder(),
              ),
              enabled: !_isLoading,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Mot de passe',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              enabled: !_isLoading,
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    child: Text('Se connecter'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}