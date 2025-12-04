import 'package:flutter/material.dart';
import 'api_service.dart';

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
      final result = await ApiService.login(identifiant, password);
      if (result.containsKey('message')) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => )
        )
      }
    }
  }
}