import 'package:get/get.dart';

class AuthService extends GetxService {
  final isLoggedIn = false.obs;

  void login() {
    isLoggedIn.value = true;
  }

  void logout() {
    isLoggedIn.value  = false;
  }

  Future<AuthService> init() async {
    String? token;

    token = "abcd";
    return this;
  }
}