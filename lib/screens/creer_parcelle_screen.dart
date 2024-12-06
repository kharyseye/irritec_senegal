import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreerParcelleScreen extends StatefulWidget {
  @override
  _CreerParcelleScreenState createState() => _CreerParcelleScreenState();
}

class _CreerParcelleScreenState extends State<CreerParcelleScreen> {
  String? _selectedSoilType;
  bool _isIrrigationActivated = false;
  TextEditingController _superficieController = TextEditingController();
  TextEditingController _planteController = TextEditingController();

  Future<void> _createParcelle() async {
    final url = Uri.parse('http://192.168.2.253:8080/parcelles');
    final body = jsonEncode({
      "superficie": _superficieController.text,
      "planteCultivee": _planteController.text,
      "typeDeSol": _selectedSoilType,
      "etatIrrigation": "BESOIN_EAU", // Par défaut ou basé sur l'utilisateur
      "irrigationIntelligente": _isIrrigationActivated,
    });

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Parcelle créée avec succès !"),
          backgroundColor: Colors.green,
        ));
        // Réinitialiser les champs après succès
        _superficieController.clear();
        _planteController.clear();
        setState(() {
          _selectedSoilType = null;
          _isIrrigationActivated = false;
        });
      } else {
        print('Erreur backend : ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Échec de la création de la parcelle !"),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Erreur lors de la connexion au serveur."),
        backgroundColor: Colors.red,
      ));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Mes parcelles',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: _createParcelle,
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
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInputField("Superficie : *", _superficieController),
                    const SizedBox(height: 20),
                    _buildInputField("Type de culture : *", _planteController),
                    const SizedBox(height: 20),
                    _buildDropdownField(),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Checkbox(
                          value: _isIrrigationActivated,
                          onChanged: (value) {
                            setState(() {
                              _isIrrigationActivated = value!;
                            });
                          },
                        ),
                        const Text(
                          "Activer l'irrigation automatique ?",
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: ElevatedButton(
                        onPressed: _createParcelle,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Créer",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.green[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Type de sol : *",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 10),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedSoilType,
              hint: const Text("Sélectionnez un type de sol"),
              items: [
                "Sol argileux",
                "Sol sablonneux",
                "Sol limoneux",
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedSoilType = newValue;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
