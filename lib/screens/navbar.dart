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





/*
import 'package:flutter/material.dart';

class NavigationBarExample extends StatefulWidget {
  final Widget body; // Contenu de la page actuelle

  NavigationBarExample({required this.body});

  @override
  _NavigationBarExampleState createState() => _NavigationBarExampleState();
}

class _NavigationBarExampleState extends State<NavigationBarExample> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigation entre les pages
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/parcelle');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/controle');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/programme');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/suivi');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.body,
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home, size: 30), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.grass, size: 30), label: "Parcelle"),
          BottomNavigationBarItem(icon: Icon(Icons.control_camera, size: 30), label: "Contrôle"),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt, size: 30), label: "Programme"),
          BottomNavigationBarItem(icon: Icon(Icons.track_changes, size: 30), label: "Suivi"),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 16,
        unselectedFontSize: 14,
      ),
    );
  }
}
*/
