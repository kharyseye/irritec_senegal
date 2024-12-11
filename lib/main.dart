import 'package:flutter/material.dart';
import 'package:irrigation_app/screens/controle_screen.dart';
import 'package:irrigation_app/screens/dashboard_screen.dart';
import 'package:irrigation_app/screens/login_screen.dart';
import 'package:irrigation_app/screens/navbar.dart';
import 'package:irrigation_app/screens/parcelle_screen.dart';
import 'package:irrigation_app/screens/programme_screen.dart';
import 'package:irrigation_app/screens/suivi_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/home': (context) => DashboardScreen(), // Route vers le Dashboard
        '/parcelle': (context) => ParcellesScreen(), // Route vers Parcelles
        '/controle': (context) => ControleScreen(), // Route vers Contrôle
        '/programme': (context) => ProgrammeScreen(), // Route vers Programme
        '/suivi': (context) => SuiviScreen(), // Route vers Suivi
      },
      title: 'Irrigation Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),

      home: MainAppScreen(), // Écran d'accueil de l'application (Login)
    );
  }
}
