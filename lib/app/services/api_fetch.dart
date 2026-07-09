import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:troyee_contact_firm/models/login_response.dart';

import '../../modules/home/models/farm_task.dart';

class ApiFetch {
  Future<LoginResponse> login({
    required String username,
    required String password,
    required String baseUrl,
  }) async {
    final response = await http.post(
      Uri.parse("${baseUrl}Auth/login"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "username": username,
        "password": password,
        "deviceId": "string",
      }),
    );

    if (response.statusCode == 200) {
      return LoginResponse.fromJson(
        jsonDecode(response.body),
      );
    }

    throw Exception(response.body);
  }

  Future<List<FarmTask>> getFarmList({
    required String baseUrl,
    required String token,
  }) async {
    // According to curl, the farm-list endpoint is at the root, not under /api/
    final cleanBaseUrl = baseUrl.replaceAll('api/', '');
    final response = await http.get(
      Uri.parse("${cleanBaseUrl}farm-list"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => FarmTask.fromJson(json)).toList();
    }

    throw Exception("Failed to fetch farm list (Status: ${response.statusCode}): ${response.body}");
  }
}