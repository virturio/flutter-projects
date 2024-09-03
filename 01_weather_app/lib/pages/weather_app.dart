import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/weather_models.dart';
import 'package:weather_app/services/weather_service.dart';

const API_KEY = "bc899071b5f8fb0386a988d53832f0ce";

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  final WeatherService _service = const WeatherService(apiKey: API_KEY);
  Weather? _weather;

  _fetchWeather() async {
    final (double lat, double lon) position =
        await _service.getPosition() ?? (0.0, 0.0);
    try {
      final Weather weather =
          await _service.getWeather(position.$1, position.$2);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    LottieBuilder lottieAsset() {
      final animationAsset = "assets/${switch (_weather?.mainCondition) {
        "clouds" => "cloud.json",
        "fog" => "cloud.json",
        "thunderstorm" => "thunder.json",
        "shower rain" => "rain.json",
        "rain" => "rain.json",
        "clear" => "sunny.json",
        String() => "sunny.json",
        null => "sunny.json"
      }}";

      return Lottie.asset(animationAsset);
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            _weather?.city ?? "Loading city...",
          ),
          lottieAsset(),
          Text("${(_weather?.tempC ?? 0.0).toInt()}°C"),
          Text(_weather?.mainCondition ?? "Sunny"),
        ],
      ),
    );
  }
}
