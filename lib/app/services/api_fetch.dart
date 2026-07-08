import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:troyee_contact_firm/models/login_response.dart';

import '../../models/user_model.dart';

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
}