import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../controller/sign_in_controller.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
          child: Text("Auth Page"),
        )
    );
  }
}
