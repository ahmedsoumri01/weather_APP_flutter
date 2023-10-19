// ignore_for_file: non_constant_identifier_names

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:http/http.dart' as http;
import "dart:convert";

class WeatherService {
  // ignore: constant_identifier_names
  static const String BASE_URL =
      'https://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final Response = await http
        .get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'));
    if (Response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(Response.body));
    } else {
      throw Exception('Error getting weather for $cityName');
    }
  }

  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.requestPermission();
    // get permission from user
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      /* throw Exception('Location permissions are denied'); */
    }

    //fetch current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    //convert the location into a list of placemark objects
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    //extract the city name from the placemark object
    String? city = placemarks[0].locality;
    /*  Placemark place = placemarks[0]; */
    return city ?? "";
  }
}
