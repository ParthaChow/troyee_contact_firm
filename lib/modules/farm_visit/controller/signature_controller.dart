import 'package:get/get.dart';
import 'package:signature/signature.dart';
import 'package:flutter/material.dart';

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
    if (signatureController.isEmpty) {
      Get.snackbar("Success", "Info is saved successfully", snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (!isConfirmed.value) {
      Get.snackbar("ত্রুটি", "দয়া করে তথ্য নিশ্চিত করুন", snackPosition: SnackPosition.BOTTOM);
      return;
    }
    
    /// TODO: Logic to save signature and sync
    Get.snackbar("সফল", "তথ্য সফলভাবে সংরক্ষিত হয়েছে", snackPosition: SnackPosition.BOTTOM);
    
    // Navigate to home or success screen
    // Get.offAllNamed(Routes.home);
  }

  @override
  void onClose() {
    signatureController.dispose();
    super.onClose();
  }
}
