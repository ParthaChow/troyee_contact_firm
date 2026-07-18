import 'package:get/get.dart';
import 'package:signature/signature.dart';
import 'package:flutter/material.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/services/api_fetch.dart';
import '../../../app/services/services.dart';
import '../../../app/services/upload_service.dart';
import '../../../models/farm_batch_model.dart';

class FarmSignatureController extends GetxController {
  final ApiFetch _apiFetch = ApiFetch();
  final AuthService _authService = Get.find<AuthService>();
  final UploadService _uploadService = Get.find<UploadService>();
  late final SignatureController signatureController;

  final RxBool isConfirmed = false.obs;
  final RxBool isLoading = false.obs;
  
  // Summary Data
  int mortalityCount = 0;
  double averageWeightKg = 0;
  double totalFeedKg = 0.0;
  
  Map<String, dynamic>? dailyEntryData;
  List<String> imagePaths = [];

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      final batch = args['batch'] as FarmBatch?;
      mortalityCount = batch?.mortalityCount ?? 0;
      totalFeedKg = batch?.totalFeedKg ?? 0.0;
      averageWeightKg = batch?.averageWeightKg ?? 0.0;
      dailyEntryData = args['dailyEntryData'];
      imagePaths = List<String>.from(args['imagePaths'] ?? []);
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
    if (!isConfirmed.value) {
      Get.snackbar(
        "ত্রুটি",
        "দয়া করে তথ্য নিশ্চিত করুন",
        backgroundColor: Colors.red.withValues(alpha: 0.7),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(15),
      );
      return;
    }

    if (dailyEntryData == null) {
      Get.snackbar("Error", "Daily entry data missing");
      return;
    }

    try {
      isLoading.value = true;
      final baseUrl = _authService.baseUrl;

      if (baseUrl == null || !(await _authService.ensureValidToken())) {
        Get.snackbar("Session Expired", "Please login again to continue");
        Get.offAllNamed(Routes.auth);
        return;
      }

      final validToken = _authService.accessToken!;

      // 1. Post the Daily Entry data to the server
      await _apiFetch.postDailyEntry(
        baseUrl: baseUrl,
        token: validToken,
        data: dailyEntryData!,
      );

      // 2. Add images to upload queue
      final visitId = dailyEntryData!['visitId'];
      for (var path in imagePaths) {
        _uploadService.addToQueue(visitId: visitId, imagePath: path);
      }

      Get.snackbar(
        "সফল",
        "তথ্য সফলভাবে সংরক্ষিত হয়েছে",
        backgroundColor: Colors.green.withValues(alpha: 0.7),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(15),
      );

      // 3. Clear all navigation stack and go to home screen
      Get.offAllNamed(Routes.home);
      
    } catch (e) {
      Get.snackbar(
        "ত্রুটি",
        "সার্ভারে তথ্য পাঠাতে ব্যর্থ: $e",
        backgroundColor: Colors.red.withValues(alpha: 0.7),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(15),
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    signatureController.dispose();
    super.onClose();
  }
}
