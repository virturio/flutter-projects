import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/models/weather_models.dart';
import 'package:http/http.dart' as http;

// ignore: constant_identifier_names
const BASE_URL = "https://api.openweathermap.org/data/2.5/weather";

class WeatherService {
  const WeatherService({required this.apiKey});
  final String apiKey;

  Future<Weather> getWeather(double lat, double lon) async {
    final url = "$BASE_URL?lat=$lat&lon=$lon&appid=$apiKey";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      print(json);
      return Weather.fromJSON(json);
    } else {
      throw Exception("Failed to load weather data");
    }
  }

  Future<(double lat, double lon)?> getPosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // get current position
    final Position location = await Geolocator.getCurrentPosition(
        locationSettings: AndroidSettings(
      accuracy: LocationAccuracy.best,
    ));

    return (location.latitude, location.longitude);
  }
}
