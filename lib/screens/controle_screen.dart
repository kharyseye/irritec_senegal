import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class WaterLevelCard extends StatelessWidget {
  final double waterLevel;

  const WaterLevelCard({
    Key? key,
    required this.waterLevel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Color(0xFF005BAE), // Couleur bleu #005BAE
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.water_drop,
                  color: Colors.white,
                  size: 30,
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Niveau d'eau disponible",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Text(
              "${waterLevel.toStringAsFixed(0)}%",
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ControleScreen extends StatefulWidget {
  @override
  _ControleScreenState createState() => _ControleScreenState();
}

class _ControleScreenState extends State<ControleScreen> {
  List<Map<String, dynamic>> parcelles = [];

  @override
  void initState() {
    super.initState();
    _fetchParcelles();
  }

  Future<void> _fetchParcelles() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.5.118:8080/parcelles'));

      if (response.statusCode == 200) {
        final List<dynamic> parcellesData = json.decode(response.body);

        final filteredParcelles = parcellesData.where((parcelle) {
          return parcelle['etatIrrigation'] == 'BESOIN_EAU';
        }).toList();


    setState(() {
          parcelles = filteredParcelles.map((parcelle) {
            return {
              "id": parcelle['id'] ?? 0, // ID par défaut
              "name": parcelle['planteCultivee'] ?? "Parcelle sans nom",
              "lastChecked": "environ 2mn", // Par défaut pour l'exemple
              "status": parcelle['etatIrrigation'],
              "statusColor": Colors.red,
              "image": "assets/images/parcelle.jpg", // Placeholder
              "selected": false,
            };
          }).toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Erreur de récupération des parcelles."),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Erreur: ${e.toString()}"),
        backgroundColor: Colors.red,
      ));
    }
  }

  void _activateIrrigation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Activation en cours"),
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Expanded(
                child: Text("L'irrigation est en train de s'activer..."),
              ),
            ],
          ),
        );
      },
    );

    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pop();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Succès"),
            content: Text("L'irrigation a été activée avec succès !"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    });
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
          children: [
            // Carte pour le niveau d'eau
            WaterLevelCard(
              waterLevel: 75, // Exemple : passez la valeur réelle ici
            ),
            SizedBox(height: 16),
            Text(
              "*Sélectionner une ou des parcelles",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 16),
            // Liste des parcelles
            parcelles.isEmpty
                ? Center(
              child: Text(
                "Aucune parcelle disponible",
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            )
                : Expanded(
              child: ListView.builder(
                itemCount: parcelles.length,
                itemBuilder: (context, index) {
                  final parcelle = parcelles[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Image de la parcelle
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.asset(
                              parcelle["image"],
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 16),
                          // Détails de la parcelle
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  parcelle["status"],
                                  style: TextStyle(
                                    color: parcelle["statusColor"],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  parcelle["name"],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Dernier contrôle: ${parcelle["lastChecked"]}",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),

                              ],
                            ),
                          ),
                          // Case à cocher
                          Checkbox(
                            value: parcelle["selected"],
                            onChanged: (bool? value) {
                              setState(() {
                                parcelle["selected"] = value ?? false;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            //SizedBox(height: 16),
            ElevatedButton(
              onPressed: _activateIrrigation,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.all(16),
              ),
              child: Text(
                "Activer",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

