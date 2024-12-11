import 'package:flutter/material.dart';
import 'package:irrigation_app/screens/parcelle_screen.dart';
import '../api/dhtSensorService.dart';
import '../sensor/dhtsensor.dart';


class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DhtSensor? _dhtSensorData; // Variable pour stocker les données récupérées
  final DhtSensorService _dhtSensorService = DhtSensorService();

  @override
  void initState() {
    super.initState();
    _fetchDhtSensorData(); // Récupérer les données au démarrage
  }

  // Fonction pour récupérer les données
  Future<void> _fetchDhtSensorData() async {
    try {
      final DhtSensor data = await _dhtSensorService.getDhtSensorData();
      setState(() {
        _dhtSensorData = data; // Mettre à jour les données dans l'état
      });
    } catch (e) {
      // Gérer les erreurs de récupération des données
      print('Erreur lors de la récupération des données : $e');
    }
  }
  void _navigateToPage(int index) {
    setState(() {

    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.settings, color: Colors.black),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.black),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/profile.png'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section météo
            Center(
              child: Column(
                children: [
                  Image.asset('assets/images/weather.png', width: 80, height: 80),
                  Text(
                    "24°",
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  Text(
                    "Journée ensoleillée !",
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Indicateurs météo
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildWeatherIndicator("77%", "Humidité"),
                _buildWeatherIndicator("<0,004", "Précipitation"),
                _buildWeatherIndicator("14km/h", "Vent"),
              ],
            ),
            const SizedBox(height: 30),
            // Section Mes parcelles
            _buildSectionTitle("Mes parcelles", onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ParcellesScreen()),
              );
            }),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildParcelleCard(
                    "Bonne santé",
                    "Tomates",
                    "12H",
                    Colors.green,
                    'assets/images/parcelle.jpg',
                    hasButton: true,
                    isButtonWhite: true,
                  ),
                  _buildParcelleCard(
                    "Besoin d'eau",
                    "Riz",
                    "12H",
                    Colors.red,
                    'assets/images/parcelle.jpg',
                    hasButton: true,
                  ),
                  _buildParcelleCard(
                    "Besoin d'eau",
                    "Carottes",
                    "2H",
                    Colors.red,
                    'assets/images/parcelle.jpg',
                    hasButton: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Section Température & Humidité
            _buildSectionTitle("Température & Humidité", onTap: () {}),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildInfoCard(
                    "Température",
                    _dhtSensorData != null ? "${_dhtSensorData!.temperature}°C" : "35ºC",
                    Colors.green,
                    Icons.thermostat,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildInfoCard(
                    "Humidité",
                    _dhtSensorData != null ? "${_dhtSensorData!.humidity}%" : "56%",
                    Colors.blue,
                    Icons.water_drop,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherIndicator(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, {VoidCallback? onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            "Voir plus >",
            style: TextStyle(color: Colors.green, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildParcelleCard(String status, String title, String time, Color color, String imagePath,
      {bool hasButton = false, bool isButtonWhite = false}) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête avec le statut
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            ),
            child: Text(
              status,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          // Image de la parcelle
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              imagePath,
              height: 80,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          // Détails sous l'image
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text(time, style: TextStyle(color: Colors.grey[600])),
                if (hasButton)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        backgroundColor: isButtonWhite ? Colors.white : Colors.green,
                        foregroundColor: isButtonWhite ? Colors.green : Colors.white,
                        side: isButtonWhite ? BorderSide(color: Colors.green) : BorderSide.none,
                      ),
                      child: Text("Activer"),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              Text(
                value,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
