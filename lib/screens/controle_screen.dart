import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ControleScreen extends StatefulWidget {
  @override
  _ControleScreenState createState() => _ControleScreenState();
}

class _ControleScreenState extends State<ControleScreen> {
  List<Map<String, dynamic>> parcelles = []; // Liste dynamique pour les parcelles

  @override
  void initState() {
    super.initState();
    _fetchParcelles(); // Charger les parcelles au démarrage
  }

  // Méthode pour récupérer les parcelles depuis l'API
  Future<void> _fetchParcelles() async {
    final response = await http.get(Uri.parse('http://192.168.2.253:8080/parcelles')); // URL de l'API

    if (response.statusCode == 200) {
      final List<dynamic> parcellesData = json.decode(response.body);

      // Filtrage des parcelles avec l'état BESOIN_EAU
      final filteredParcelles = parcellesData.where((parcelle) {
        return parcelle['etatIrrigation'] == 'BESOIN_EAU';
      }).toList();

      setState(() {
        parcelles = filteredParcelles.map((parcelle) {
          return {
            "status": parcelle['etatIrrigation'], // Assurez-vous que l'attribut est correctement nommé
            "statusColor": _getStatusColor(parcelle['etatIrrigation']), // Couleur basée sur l'état d'irrigation
            "name": parcelle['planteCultivee'],
            "selected": false,
          };
        }).toList();
      });
    } else {
      // Gérer l'erreur de la requête
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Erreur de récupération des parcelles."),
        backgroundColor: Colors.red,
      ));
    }
  }


  // Méthode pour obtenir la couleur de statut en fonction de l'état d'irrigation
  Color _getStatusColor(String etatIrrigation) {
    switch (etatIrrigation) {
      case 'BESOIN_EAU':
        return Colors.red;
      case 'BONNE_SANTE':
        return Colors.green;
      case 'IRRIGATION_EN_COURS':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contrôle'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "* Sélectionner une ou des parcelles",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            SizedBox(height: 20),
            // Liste des parcelles
            Expanded(
              child: ListView(
                children: parcelles.map((parcelle) {
                  return _buildParcelleCard(
                    status: parcelle["status"],
                    statusColor: parcelle["statusColor"],
                    name: parcelle["name"],
                    //lastChecked: parcelle["lastChecked"],
                    isSelected: parcelle["selected"],
                    onCheckboxChanged: (bool? value) {
                      setState(() {
                        parcelle["selected"] = value ?? false;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            // Boutons en bas
            SizedBox(height: 20),

          ElevatedButton(
          onPressed: () {
            _activateIrrigation();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: EdgeInsets.all(16),
      ),
      child: Text(
      "Activer irrigation",
      style: TextStyle(color: Colors.white),
      ),
    ),

    SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  // Widget de construction de carte de parcelle
  Widget _buildParcelleCard({
    required String status,
    required Color statusColor,
    required String name,
    required bool isSelected,
    required ValueChanged<bool?> onCheckboxChanged,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Checkbox(
          value: isSelected,
          onChanged: onCheckboxChanged,
        ),
        title: Text(
          name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Affichage de l'état de l'irrigation
            Text(
              status,
              style: TextStyle(
                color: statusColor, // Applique la couleur selon l'état
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _activateIrrigation() {
    showDialog(
      context: context,
      barrierDismissible: false, // Empêche de fermer en cliquant en dehors
      builder: (BuildContext context) {
        // Affiche une animation (exemple : spinner)
        return AlertDialog(
          title: Text("Activation en cours"),
          content: Row(
            children: [
              CircularProgressIndicator(), // Animation spinner
              SizedBox(width: 16),
              Expanded(child: Text("L'irrigation est en train de s'activer...")),
            ],
          ),
        );
      },
    );

    // Simule un délai pour l'activation (peut être remplacé par une requête HTTP)
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pop(); // Ferme le dialogue d'animation

      // Affiche un popup de confirmation
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Succès"),
            content: Text("L'irrigation a été activée avec succès !"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Ferme le popup
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    });
  }


}
