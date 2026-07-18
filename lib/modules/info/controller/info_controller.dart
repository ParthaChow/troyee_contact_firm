import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:troyee_contact_firm/app/services/services.dart';

import '../../../app/routes/app_routes.dart';
import '../../../models/farm_batch_model.dart';
import '../../../app/services/api_fetch.dart';
import '../../home/models/farm_task.dart';

class InfoController extends GetxController {
  final ApiFetch _apiFetch = ApiFetch();
  final AuthService _authService = Get.find<AuthService>();

  late FarmTask task;
  final Rxn<FarmBatch> batch = Rxn<FarmBatch>();
  late Map<String, dynamic> checkInResponse;
  final RxBool isLoading = true.obs;

  // Input Fields
  final birdCount = 0.obs;
  final mortalityCount = 0.obs;
  final cullingCount = 0.obs;
  final feedController = TextEditingController(text: "0");
  final waterController = TextEditingController(text: "0");
  final tempController = TextEditingController(text: "0");
  final humidityController = TextEditingController(text: "0");
  final lightHoursController = TextEditingController(text: "0");
  final weightController = TextEditingController(text: "0");
  final medicineController = TextEditingController();
  final vaccineController = TextEditingController();
  final remarksController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;
    task = args['task'];
    batch.value = args['batch'];
    checkInResponse = args['checkInResponse'];
    
    // Initialize bird count from batch if available
    if (batch.value != null) {
      birdCount.value = batch.value!.currentCount;
      mortalityCount.value = batch.value!.mortalityCount;
      feedController.text = batch.value!.totalFeedKg.toString();
      weightController.text = batch.value!.averageWeightKg.toString();
    }
    
    fetchBatchDetails();
  }

  Future<void> fetchBatchDetails() async {
    try {
      isLoading.value = true;
      final baseUrl = _authService.baseUrl;

      if (baseUrl != null && (await _authService.ensureValidToken())) {
        final updatedBatch = await _apiFetch.getBatchDetails(
          baseUrl: baseUrl,
          token: _authService.accessToken!,
          farmId: task.id,
          batchId: batch.value!.id,
        );
        batch.value = updatedBatch;
        if (birdCount.value == 0) {
          birdCount.value = updatedBatch.currentCount;
          feedController.text = updatedBatch.totalFeedKg.toString();
          weightController.text = updatedBatch.averageWeightKg.toString();
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch batch details: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void incrementBird() => birdCount.value++;
  void decrementBird() => birdCount.value > 0 ? birdCount.value-- : null;
  
  void incrementMortality() => mortalityCount.value++;
  void decrementMortality() => mortalityCount.value > 0 ? mortalityCount.value-- : null;

  void incrementCulling() => cullingCount.value++;
  void decrementCulling() => cullingCount.value > 0 ? cullingCount.value-- : null;

  Future<void> submitDailyEntry() async {
    try {
      final visitId = checkInResponse['visitId'];
      if (visitId == null) {
        throw Exception("Visit ID not found");
      }

      final dailyEntryData = {
        "visitId": visitId,
        "batchId": batch.value?.id ?? 0,
        "recordDate": DateTime.now().toUtc().toIso8601String(),
        "birdCount": birdCount.value,
        "mortalityCount": mortalityCount.value,
        "cullingCount": cullingCount.value,
        "totalFeedKg": double.tryParse(feedController.text) ?? 0,
        "waterConsumptionLtr": double.tryParse(waterController.text) ?? 0,
        "temperatureC": double.tryParse(tempController.text) ?? 0,
        "humidityPercent": double.tryParse(humidityController.text) ?? 0,
        "averageWeightGm": double.tryParse(weightController.text) ?? 0,
        "lightHours": double.tryParse(lightHoursController.text) ?? 0,
        "medicineUsed": medicineController.text,
        "vaccineUsed": vaccineController.text,
        "remarks": remarksController.text
      };

      // Update the batch object with new values before passing it forward
      final updatedBatch = batch.value?.copyWith(
        mortalityCount: mortalityCount.value,
        totalFeedKg: double.tryParse(feedController.text) ?? 0,
        averageWeightKg: double.tryParse(weightController.text) ?? 0,
        currentCount: birdCount.value,
      );

      // Navigate to camera visit WITHOUT posting to server yet
      Get.toNamed(Routes.camera_visit, arguments: {
        ...Get.arguments as Map<String, dynamic>,
        'batch': updatedBatch,
        'dailyEntryData': dailyEntryData,
        'visitId': visitId,
      });
      
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed: $e",
        backgroundColor: Colors.red.withValues(alpha: 0.7),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(15),
      );
    }
  }
}
