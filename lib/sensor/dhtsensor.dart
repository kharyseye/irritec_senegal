class DhtSensor {
  final double temperature;
  final double humidity;

  DhtSensor({required this.temperature, required this.humidity});

  factory DhtSensor.fromJson(Map<String, dynamic> json) {
    return DhtSensor(
      temperature: json['temperature'].toDouble(),
      humidity: json['humidity'].toDouble(),

    );
  }
}
