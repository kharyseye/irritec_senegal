import 'package:flutter/material.dart';
import 'package:irrigation_app/api/api_service.dart';
import 'creer_parcelle_screen.dart';

class ParcellesScreen extends StatefulWidget {
  @override
  _ParcellesScreenState createState() => _ParcellesScreenState();
}

class _ParcellesScreenState extends State<ParcellesScreen> {
  late Future<List<dynamic>> parcelles;

  @override
  void initState() {
    super.initState();
    parcelles = ApiService.fetchParcelles(); // Charge les parcelles au démarrage
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        title: Text(
          'Mes parcelles',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Naviguer vers la page de création
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreerParcelleScreen(),
                      ),
                    );
                  },
                  icon: Icon(Icons.add, color: Colors.white),
                  label: Text(
                    "Ajouter une parcelle",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: parcelles,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Erreur de connexion"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text("Aucune parcelle trouvée"));
                  }

                  // Si les données sont disponibles, afficher la liste des parcelles
                  List<dynamic> parcellesData = snapshot.data!;
                  return ListView.separated(
                    itemCount: parcellesData.length,
                    itemBuilder: (context, index) {
                      var parcelle = parcellesData[index];
                      String etat = parcelle['etatIrrigation'];
                      bool isBonneSante = etat.toUpperCase() == "BONNE_SANTE";

                      return _buildParcelleCard(
                        etat, // Texte de l'état
                        isBonneSante ? Colors.green[100]! : Colors.red[100]!, // Couleur d'arrière-plan
                        isBonneSante ? Colors.green : Colors.red, // Couleur du texte de l'état
                        parcelle['planteCultivee'],
                        "Dernier contrôle: il y a 00:00",
                        !isBonneSante, // Désactive le bouton pour BONNE_SANTE
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(height: 10), // Espacement entre les cartes
                  );

                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParcelleCard(
      String status,
      Color backgroundColor,
      Color statusColor,
      String title,
      String subtitle,
      bool hasActivateButton,
      ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              'assets/images/parcelle.jpg',
              height: 60,
              width: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: backgroundColor, // Couleur d'arrière-plan
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor, // Couleur du texte
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          if (hasActivateButton)
            ElevatedButton(
              onPressed: () {
                // Action pour activer l'irrigation
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: Size(80, 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: Text(
                "Activer",
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

}
