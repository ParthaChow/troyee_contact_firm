import 'package:troyee_contact_firm/models/login_response.dart';

import '../../models/user_model.dart';
import 'api_fetch.dart';

class AuthRepository {
  final ApiFetch api;

  AuthRepository(this.api);

  Future<LoginResponse> login({
    required String username,
    required String password,
    required String baseUrl,
  }) {
    return api.login(
      username: username,
      password: password,
      baseUrl: baseUrl,
    );
  }
}