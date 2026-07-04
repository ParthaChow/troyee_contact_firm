import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../app/services/api_fetch.dart';
import '../../../app/services/services.dart';
import '../../../models/user_model.dart';

class SignInController extends GetxController {
  final ApiFetch _api = ApiFetch();


  final formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final baseUrlController = TextEditingController(
    text: "http://103.134.89.218:5053/api/",
  );

  final isLoading = false.obs;
  final obcsurePassword = true.obs;

  final Rxn<UserInfo> user = Rxn<UserInfo>();

  @override
  void onInit() {
    super.onInit();

    usernameController.text = 'Troyee';
    passwordController.text = '123456';
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

      final result = await _api.login(username: usernameController.text.trim(), password: passwordController.text.trim(), baseUrl: baseUrlController.text.trim(),);

      user.value = result;

      Get.find<AuthService>().login();

      Get.snackbar("Success",
          "Welcome ${result.uName}",
      snackPosition: SnackPosition.BOTTOM,);


      Get.offNamed(
        '/home',
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

  String? validateBaseUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Base URL is required";
    }
    return null;
  }
}