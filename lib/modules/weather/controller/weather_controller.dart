import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../models/weather_model.dart';




class WeatherController extends GetxController {
  final RxList<WeatherForecast> forecastList = <WeatherForecast>[].obs;
  final RxBool isLoading = true.obs;
  final RxString cityName = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    try {
      isLoading.value = true;
      
      // Get location
      Position position = await _determinePosition();
      
      // Fetch from OpenWeatherMap (API Key from .env)
      final apiKey = dotenv.env['OPENWEATHER_API_KEY'] ?? "";
      final url = "https://api.openweathermap.org/data/2.5/forecast?lat=${position.latitude}&lon=${position.longitude}&appid=$apiKey&units=metric";
      // final url = "https://api.openweathermap.org/data/2.5/forecast?lat=23.7533055556&lon=90.3917222222&appid=$apiKey&units=metric";

      final response = await http.get(Uri.parse(url));


      if (response.statusCode == 200) {
        final Geocoding geocoding = Geocoding();

        List<Placemark> placemarks = await geocoding.placemarkFromCoordinates(position.latitude,position.longitude);
          Placemark place = placemarks[0];
          String location = place.street ?? "";
        if (location.contains(',')) {
          int lastCommaIndex = location.lastIndexOf(',');
          location = location.substring(0, lastCommaIndex).trim();
        }
        final data = jsonDecode(response.body);
        cityName.value = location;

        print(cityName.value);
        final List list = data['list'];
        final Map<String, WeatherForecast> dailyForecasts = {};
        
        for (var item in list) {
          final date = DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000);
          final dateString = "${date.year}-${date.month}-${date.day}";
          
          if (!dailyForecasts.containsKey(dateString)) {
            dailyForecasts[dateString] = WeatherForecast.fromJson(item);
          }
          
          if (dailyForecasts.length >= 7) break;
        }
        
        forecastList.assignAll(dailyForecasts.values.toList());
      } else {
        _loadMockData();
      }
    } catch (e) {
      print("Error fetching weather: $e");
      _loadMockData();
    } finally {
      isLoading.value = false;
    }
  }

  void _loadMockData() {
    cityName.value = "Kushtia (Mock)";
    final now = DateTime.now();
    forecastList.assignAll([
      WeatherForecast(date: now, temp: 28.5, description: "Sunny", icon: "01d", humidity: 60, windSpeed: 5.2),
      WeatherForecast(date: now.add(const Duration(days: 1)), temp: 27.2, description: "Cloudy", icon: "03d", humidity: 65, windSpeed: 4.8),
      WeatherForecast(date: now.add(const Duration(days: 2)), temp: 26.8, description: "Rain", icon: "10d", humidity: 80, windSpeed: 6.5),
      WeatherForecast(date: now.add(const Duration(days: 3)), temp: 29.0, description: "Clear", icon: "01d", humidity: 55, windSpeed: 3.9),
      WeatherForecast(date: now.add(const Duration(days: 4)), temp: 30.2, description: "Sunny", icon: "01d", humidity: 50, windSpeed: 4.2),
      WeatherForecast(date: now.add(const Duration(days: 5)), temp: 31.0, description: "Hot", icon: "01d", humidity: 45, windSpeed: 3.5),
      WeatherForecast(date: now.add(const Duration(days: 6)), temp: 29.5, description: "Partly Cloudy", icon: "02d", humidity: 55, windSpeed: 4.0),
    ]);
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    } 

    return await Geolocator.getCurrentPosition();
  }
}
