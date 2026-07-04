import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../controller/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
          child: Text(
            "HomePage"
          ),
        )
    );
  }
}
