import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/services/api_fetch.dart';
import '../../../app/services/services.dart';
import '../../../models/login_response.dart';

class SignInController extends GetxController {
  final ApiFetch _api = ApiFetch();


  final formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final baseUrlController = TextEditingController(
    text: "http://103.134.89.218:60657/api/",
  );

  final isLoading = false.obs;
  final obcsurePassword = true.obs;
  final showManualLogin = false.obs;

  final savedProfiles = <Map<String, dynamic>>[].obs;

  final Rxn<LoginResponse> user = Rxn<LoginResponse>();

  @override
  void onInit() {
    super.onInit();
    _loadProfiles();
    // usernameController.text = 'rafiq.fo';
    // passwordController.text = '12345678';
  }

  void _loadProfiles() {
    final auth = Get.find<AuthService>();
    savedProfiles.assignAll(auth.savedProfiles);
  }

  void selectProfile(Map<String, dynamic> profile) {
    usernameController.text = profile['username'] ?? '';
    passwordController.text = profile['password'] ?? '';

    // Auto-login if password exists
    if (passwordController.text.isNotEmpty) {
      login();
    }
  }


  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    baseUrlController.dispose();
    super.onClose();
  }

  void togglePassword() {
    obcsurePassword.toggle();
  }


  Future<void> login() async {
    if(!formKey.currentState!.validate()) return;

    try {
      isLoading.value  = true;

      final LoginResponse result = await _api.login(username: usernameController.text.trim(), password: passwordController.text.trim(), baseUrl: baseUrlController.text.trim(),);
      print(baseUrlController);

      user.value = result;

      final auth = Get.find<AuthService>();

      await auth.saveLogin(
        username: usernameController.text.trim(),
        password: passwordController.text.trim(),
        accessToken: result.accessToken,
        refreshToken: result.refreshToken,
        fullName: result.fullName,
        zone: result.zone,
        fieldOfficerId: result.fieldOfficerId,
        expiresAt: result.accessTokenExpiresAt.toIso8601String(),
        baseUrl: baseUrlController.text.trim(),
      );

      Get.snackbar("Success",
          "Welcome ${result.fullName}",
      snackPosition: SnackPosition.BOTTOM,);


      Get.offAllNamed(
        Routes.home,
        arguments: result,
      );
    } catch (e) {

      Get.snackbar("Login Failed",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,);
    } finally {
      isLoading.value = false;
    }
  }

  String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Username is required";
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }
    return null;
  }


}