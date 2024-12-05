import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProgrammeScreen extends StatefulWidget {
  @override
  State<ProgrammeScreen> createState() => _ProgrammeScreenState();
}

class _ProgrammeScreenState extends State<ProgrammeScreen> {

 // int _currentIndex = 3; // Correspond à la position de la page actuelle dans la navbar

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        title: Text(
          "Mes programmes",
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20), // Espace sous l'entête

              // Bouton "Voir historique"
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    // Action pour voir l'historique
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: Text(
                    "Voir mon historique",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Calendrier (exactement comme sur le design)
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[300]!,
                      blurRadius: 5,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Mois et navigation
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.arrow_back_ios, size: 16, color: Colors.grey),
                        Text(
                          "Janvier 2024",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Jours de la semaine
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildDayLabel("Lu"),
                        _buildDayLabel("Ma"),
                        _buildDayLabel("Me"),
                        _buildDayLabel("Je"),
                        _buildDayLabel("Ve"),
                        _buildDayLabel("Sam"),
                        _buildDayLabel("Dim"),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Dates (exactement comme le design)
                    Column(
                      children: [
                        _buildWeekRow([29, 30, 1, 2, 3, 4, 5], [true, true, false, false, false, false, false]),
                        _buildWeekRow([6, 7, 8, 9, 10, 11, 12], [false, true, false, false, false, true, false]),
                        _buildWeekRow([13, 14, 15, 16, 17, 18, 19], [false, false, true, false, false, false, true]),
                        _buildWeekRow([20, 21, 22, 23, 24, 25, 26], [false, false, false, false, false, false, false]),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Section "Récapitulatif de la semaine/mois"
              _buildRecapCards(),

              const SizedBox(height: 20),
              
            ],
          ),
        ),
      ),
      // Barre de navigation (réutilisée)
      /* bottomNavigationBar:
      BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 30,
              color: _currentIndex == 0 ? Colors.green : Colors.grey,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.grass,
              size: 30,
              color: _currentIndex == 1 ? Colors.green : Colors.grey,
            ),
            label: "Parcelles",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.track_changes,
              size: 30,
              color: _currentIndex == 2 ? Colors.green : Colors.grey,
            ),
            label: "Suivi",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.calendar_today,
              size: 30,
              color: _currentIndex == 3 ? Colors.green : Colors.grey,
            ),
            label: "Programme",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.control_camera,
              size: 30,
              color: _currentIndex == 4 ? Colors.green : Colors.grey,
            ),
            label: "Contrôle",
          ),
        ],
        
      ),*/
    );
  }

  Widget _buildDayLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildWeekRow(List<int> dates, List<bool> isColored) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(dates.length, (index) {
        return CircleAvatar(
          radius: 16,
          backgroundColor: isColored[index] ? Colors.green[300] : Colors.grey[200],
          child: Text(
            dates[index].toString(),
            style: TextStyle(
              color: isColored[index] ? Colors.white : Colors.black,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildRecapCards() {
    return Column(
      children: [
        // Ligne contenant "Récapitulatif de la semaine" et "Voir plus"
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Récapitulatif de la semaine",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            GestureDetector(
              onTap: () {
                // Action pour voir plus
                print("Voir plus cliqué");
              },
              child: Text(
                "Voir plus",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10), // Espacement sous la ligne

        // Carte "Quantité d'eau utilisé par parcelle"
        _buildRecapCard("Quantité d'eau utilisé par parcelle", "150 L", Colors.blue, Icons.water),
        const SizedBox(height: 10),

        // Carte "Événements critiques"
        _buildRecapCard("Événements critiques", "02", Colors.orange, Icons.warning),
      ],
    );
  }


  Widget _buildRecapCard(String title, String value, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300]!,
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

}