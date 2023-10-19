import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService('c33c80d29c32b117c91ee98814593039');
  Weather? _weather;

  // fetch  weather
  _fetchWeather() async {
    //get the current city
    String cityName = await _weatherService.getCurrentCity();

    //get weather for the current city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

//weather animations
  String getWatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunnyweather.json';
    switch (mainCondition) {
      case 'clouds':
      case 'mist':
      case 'fog':
      case 'haze':
      case 'smoke':
      case 'dust':
        return 'assets/cloudweather.json';
      case 'Rain':
      case 'drizzle':
      case "shower rain":
        return 'assets/rainweather.json';
      case 'clear':
        return 'assets/sunnyweather.json';
      default:
        return 'assets/sunnyweather.json';
    }
  }

//init state
  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(
                    child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter city name',
                    /* border: OutlineInputBorder(), */
                  ),
                  /*  onSubmitted: _searchWeather, */
                )),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    /* _searchWeather(_weather?.cityName ?? ''); */
                  },
                ),
              ],
            ),
            //city name
            Text(
              _weather?.cityName ?? 'Loading...',
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            //animations
            Lottie.asset(getWatherAnimation(_weather?.mainCondition)),
            //main condition
            Text(
              _weather?.mainCondition ?? '',
              style: const TextStyle(fontSize: 40),
            ),
            //temperature
            Text(
              '${_weather?.temperature.round() ?? ''}°C',
              style: const TextStyle(fontSize: 40),
            ),
          ],
        ),
      ),
    );
  }
}
