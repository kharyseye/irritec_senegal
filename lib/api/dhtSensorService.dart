import 'dart:convert';
import 'package:http/http.dart' as http;
import '../sensor/dhtsensor.dart';

class DhtSensorService {
  Future<DhtSensor> getDhtSensorData() async {
    final response = await http.get(Uri.parse('http://192.168.5.118:8080/api/data/dht-sensor'));

    if (response.statusCode == 200) {
      // Assurez-vous que les données sont bien un Map<String, dynamic>
      final Map<String, dynamic> jsonResponse = json.decode(response.body) as Map<String, dynamic>;

      return DhtSensor.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load sensor data');
    }
  }
}

