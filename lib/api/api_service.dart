/*
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'http://192.168.2.253:8080'; // Pour l'émulateur Android
  // static const String baseUrl = 'http://localhost:8080'; // Pour Chrome ou macOS

  static Future<List<dynamic>> fetchParcelles() async {
    final response = await http.get(Uri.parse('$baseUrl/parcelles'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load parcelles');
    }
  }
}
*/
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'http://192.168.2.253:8080'; // URL du backend

  /// Récupérer les parcelles avec une requête GET
  static Future<List<dynamic>> fetchParcelles() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/parcelles'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Erreur lors de la récupération des parcelles : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur de connexion : $e');
    }
  }

  }

