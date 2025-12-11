import 'package:flutter/material.dart';
import 'api_service.dart';

void main(){
    runApp(MyApp());
}

class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: 'Gestion des reservations',
            theme: ThemeData(primaryColor: Color(0xFF1a0a7f)),
            home: ReservationPage(),
        );
    }
}

class ReservationPage extends StatefulWidget {
    const ReservationPage({Key? key}) : super(key: key);

    @override
    State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
    final ApiService apiService = ApiService();
    List<String> allReservation = [];
    List<String> todayReservation = [];
    List<String> pastReservation = [];

    bool isLoading = true;

    @override
    void initState(){
        super.initState();
        _loadReservations();
    }

    Future<void> _loadReservations() async {
        try {
            final results  = await Future.wait([
                apiService.fetchAllReservations(),
                apiService.fetchTodayReservations(),
                apiService.fetchPastReservations(),
            ]);

            setState((){
                allReservation = results[0];
                todayReservation = results[1];
                pastReservation = results[2];
                isLoading = false;
            });

        } catch (e) {
            setState((){
                isLoading = false;
            });
            print("Erreur de chargement des reservations: $e");
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
                        Text(
                            'Accueil',
                            style: TextStyle(color: Colors.white)
                        ),
                    ],
                ),
            ),
            body: isLoading
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Text(
                                    'Toutes les reservations',
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                ...allReservation.map((res)=> ListTile(title: Text(res))).toList(),
                                SizedBox(height: 20),
                                Text(
                                    'Reservations d\'aujourd\'hui',
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                if (todayReservation.isEmpty)
                                    Text('Aucune réservation pour aujourd\'hui.'),
                                ...todayReservation.map((res)=> ListTile(title: Text(res))).toList(),
                                SizedBox(height: 20),
                                Text(
                                    'Reservations passées',
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                ...pastReservation.map((res)=> ListTile(title: Text(res))).toList(),
                            ]
                        )
                    )
                )
        );
    }
}