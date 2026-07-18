import 'package:get/get.dart';
import 'package:signature/signature.dart';
import 'package:flutter/material.dart';

class FarmSignatureController extends GetxController {
  late final SignatureController signatureController;

  final RxBool isConfirmed = false.obs;
  
  // Summary Data
  final mortality = 0.obs;
  final avgWeight = 0.obs;
  final feedExpense = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
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
      Get.snackbar("ত্রুটি", "দয়া করে স্বাক্ষর করুন", snackPosition: SnackPosition.BOTTOM);
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
