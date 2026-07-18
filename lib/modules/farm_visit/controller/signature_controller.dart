import 'package:get/get.dart';
import 'package:signature/signature.dart';
import 'package:flutter/material.dart';

import '../../../app/routes/app_routes.dart';
import '../../../models/farm_batch_model.dart';

class FarmSignatureController extends GetxController {
  late final SignatureController signatureController;

  final RxBool isConfirmed = false.obs;
  
  // Summary Data
  int mortalityCount = 0;
  double averageWeightKg = 0;
  double totalFeedKg = 0.0;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    print(args);
    if (args != null) {
      final batch = args['batch'] as FarmBatch?;
      mortalityCount = batch!.mortalityCount;
      totalFeedKg = batch.totalFeedKg;
      averageWeightKg = batch.averageWeightKg;
      print("mortality count ${mortalityCount}");
      print("avgweightkg ${averageWeightKg}");
      print("feedkg ${totalFeedKg}");
    }
    signatureController = SignatureController(
      penStrokeWidth: 3,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
    );
  }

  void clearSignature() {
    signatureController.clear();
  }

  void toggleConfirmation(bool? value) {
    isConfirmed.value = value ?? false;
  }

  Future<void> submit() async {
    // if (signatureController.isEmpty) {
    //   Get.snackbar(
    //     "ত্রুটি",
    //     "দয়া করে স্বাক্ষর করুন",
    //     backgroundColor: Colors.red.withOpacity(0.7),
    //     colorText: Colors.white,
    //     snackPosition: SnackPosition.TOP,
    //     margin: const EdgeInsets.all(15),
    //   );
    //   return;
    // }
    if (!isConfirmed.value) {
      Get.snackbar(
        "ত্রুটি",
        "দয়া করে তথ্য নিশ্চিত করুন",
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(15),
      );
      return;
    }

    Get.snackbar(
      "সফল",
      "তথ্য সফলভাবে সংরক্ষিত হয়েছে",
      backgroundColor: Colors.green.withOpacity(0.7),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(15),

    );
    
    // Clear all navigation stack and go to home screen
    Get.offAllNamed(Routes.home);
  }

  @override
  void onClose() {
    signatureController.dispose();
    super.onClose();
  }
}
