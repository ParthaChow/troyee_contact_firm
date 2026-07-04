import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:troyee_contact_farm/models/user_model.dart';

class ApiFetch {
  Future<UserInfo> login({
    required String username,
    required String password,
    required String baseUrl,
  }) async {
    final response = await rootBundle.loadString('assets/userInfo.json');

    final data = jsonDecode(response);
    return UserInfo.fromJson(data['UserInfo']);
  }
}