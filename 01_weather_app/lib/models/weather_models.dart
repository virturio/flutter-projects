final class Weather {
  final String city;
  final double tempC;
  final String mainCondition;

  const Weather({
    required this.city,
    required this.tempC,
    required this.mainCondition,
  });

  factory Weather.fromJSON(Map<String, dynamic> json) => Weather(
        city: json['name'],
        mainCondition: json['weather'][0]['main'],
        tempC: json['main']['temp'].toDouble() - 273.15,
      );
}
