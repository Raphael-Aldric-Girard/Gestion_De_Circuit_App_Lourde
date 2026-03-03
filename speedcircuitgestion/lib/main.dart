import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_service.dart';
import 'index.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpeedCircuit Authentification',
      theme: ThemeData(primaryColor: Color(0xFF1a0a7f)),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  final _storage = FlutterSecureStorage();
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    final String? token = await _storage.read(key: 'auth_token');

    if (!mounted) return;

    if (token != null) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => Index()));
    } else {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => AuthScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _storage = FlutterSecureStorage();
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
        await _storage.write(
          key: 'auth_token',
          value: result['token'] ?? 'connected',
        );
        await _storage.write(
          key: 'user_id',
          value: result['user']['IdEntite'].toString(),
        );
        await _storage.write(
          key: 'user_prenom',
          value: result['user']['prenom'].toString(),
        );
        await _storage.write(
          key: 'user_poste',
          value: result['user']['idPoste'].toString(),
        );
        // Connexion réussie - navigation
        if (mounted) {
          Navigator.of(
            context,
          ).pushReplacement(MaterialPageRoute(builder: (context) => Index()));
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
