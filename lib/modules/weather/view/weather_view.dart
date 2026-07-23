import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../app/core/theme/app_colors.dart';
import '../../../models/weather_model.dart';
import '../controller/weather_controller.dart';

class WeatherView extends GetView<WeatherController> {
  const WeatherView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('আবহাওয়ার পূর্বাভাস', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }

        if (controller.forecastList.isEmpty) {
          return const Center(child: Text("তথ্য পাওয়া যায়নি"));
        }

        final current = controller.forecastList.first;

        return RefreshIndicator(
          onRefresh: () => controller.fetchWeather(),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _buildCurrentWeather(current),
              const SizedBox(height: 24),
              const Text(
                "Forcast for next 5 days",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 16),
              ...controller.forecastList.skip(1).map((w) => _buildForecastItem(w)),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildCurrentWeather(WeatherForecast current) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            controller.cityName.value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            DateFormat('EEEE, d MMMM').format(current.date),
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                "https://openweathermap.org/img/wn/${current.icon}@2x.png",
                width: 50,
                height: 50,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.wb_sunny, size: 40, color: Colors.orange),
              ),
              const SizedBox(width: 12),
              Text(
                "${current.temp.toStringAsFixed(1)}°",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 42,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
          Text(
            current.description.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildWeatherDetail(Icons.water_drop_outlined, "${current.humidity.toInt()}%", "আর্দ্রতা"),
              _buildWeatherDetail(Icons.air, "${current.windSpeed} km/h", "বাতাস"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetail(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 10),
        ),
      ],
    );
  }

  Widget _buildForecastItem(WeatherForecast w) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              DateFormat('EEEE').format(w.date),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Image.network(
                  "https://openweathermap.org/img/wn/${w.icon}.png",
                  width: 40,
                  height: 40,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.wb_cloudy, size: 24),
                ),
                const SizedBox(width: 8),
                Text(w.description, style: const TextStyle(color: AppColors.textSecondary)),
              ],
            ),
          ),
          Text(
            "${w.temp.toStringAsFixed(1)}°",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
