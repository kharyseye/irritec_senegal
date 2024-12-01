import 'package:flutter/material.dart';

class ControleScreen extends StatefulWidget {
  @override
  _ControleScreenState createState() => _ControleScreenState();
}

class _ControleScreenState extends State<ControleScreen> {
  // Liste des parcelles avec les propriétés nécessaires
  final List<Map<String, dynamic>> parcelles = [
    {
      "status": "Besoin d'eau",
      //"backgroundColor": Colors.red[100]!,
      "statusColor": Colors.red,
      "name": "Parcelle de tomates",
      "lastChecked": "Dernier contrôle : il y a 2 min",
      "selected": false,
    },
    {
      "status": "Bonne santé",
      //"backgroundColor": Colors.green[100]!,
      "statusColor": Colors.green,
      "name": "Parcelle de maïs",
      "lastChecked": "Dernier contrôle : il y a 5 min",
      "selected": false,
    },
    {
      "status": "Irrigation en cours",
     // "backgroundColor": Colors.yellow[100]!,
      "statusColor": Colors.orange,
      "name": "Parcelle de carottes",
      "lastChecked": "Dernier contrôle : il y a 3 min",
      "selected": false,
    },
  ];

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
                    //backgroundColor: parcelle["backgroundColor"],
                    statusColor: parcelle["statusColor"],
                    name: parcelle["name"],
                    lastChecked: parcelle["lastChecked"],
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
                // Action pour activer l'irrigation
                print("Irrigation activée pour les parcelles sélectionnées");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Couleur de fond verte
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.all(16),
              ),
              child: Text(
                "Activer irrigation",
                style: TextStyle(color: Colors.white), // Couleur du texte en blanc
              ),
            ),

            SizedBox(height: 50),
            /*ElevatedButton(
              onPressed: () {
                // Action pour activer la multi-irrigation
                print("Multi-irrigation activée");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.all(16),
              ),
              child: Text("Activer multi-irrigation"),
            ),*/
          ],
        ),
      ),
    );
  }

  // Widget de construction de carte de parcelle
  Widget _buildParcelleCard({
    required String status,
   // required Color backgroundColor,
    required Color statusColor,
    required String name,
    required String lastChecked,
    required bool isSelected,
    required ValueChanged<bool?> onCheckboxChanged,
  }) {
    return Card(
     // color: backgroundColor,
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
            Text(
              lastChecked,
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 4),
            Text(
              status,
              style: TextStyle(color: statusColor),
            ),
          ],
        ),
      ),
    );
  }
}
