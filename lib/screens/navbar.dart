import 'package:flutter/material.dart';
import 'package:irrigation_app/screens/dashboard_screen.dart';
import 'package:irrigation_app/screens/parcelle_screen.dart';
import 'package:irrigation_app/screens/programme_screen.dart';
import 'package:irrigation_app/screens/suivi_screen.dart';
import 'package:irrigation_app/screens/controle_screen.dart';

class MainAppScreen extends StatefulWidget {
  @override
  _MainAppScreenState createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  int _currentIndex = 0;

  // Liste des pages
  final List<Widget> _pages = [
    DashboardScreen(), // Remplace par ton écran Dashboard
    ParcellesScreen(),
    ProgrammeScreen(),
    SuiviScreen(),
    ControleScreen(),
  ];

  // Méthode pour changer de page
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grass),
            label: "Parcelles",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "Programme",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.track_changes),
            label: "Suivi",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.control_camera),
            label: "Contrôle",
          ),
        ],
      ),
    );
  }
}

