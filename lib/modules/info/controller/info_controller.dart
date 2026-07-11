import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:troyee_contact_firm/app/services/services.dart';
import 'package:troyee_contact_firm/modules/sign_in/controller/sign_in_controller.dart';

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

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;
    task = args['task'];
    // Initial batch data from arguments
    batch.value = args['batch'];
    checkInResponse = args['checkInResponse'];
    
    fetchBatchDetails();
  }

  Future<void> fetchBatchDetails() async {
    try {
      isLoading.value = true;
      final baseUrl = _authService.baseUrl;
      final token = _authService.accessToken;

      if (baseUrl != null && token != null) {
        final updatedBatch = await _apiFetch.getBatchDetails(
          baseUrl: baseUrl,
          token: token,
          farmId: task.id,
          batchId: batch.value!.id,
        );
        batch.value = updatedBatch;
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch batch details: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitDailyEntry() async {
    try {
      isLoading.value = true;
      final baseUrl = _authService.baseUrl;
      final token = _authService.accessToken;

      if (baseUrl == null || token == null) {
        throw Exception("Session expired");
      }

      // Assuming visitId is 'id' from checkInResponse
      final visitId = checkInResponse['id'];
      if (visitId == null) {
        throw Exception("Visit ID not found in check-in response");
      }

      final data = {
        "visitId": visitId,
        "batchId": batch.value?.id ?? 0,
        "recordDate": DateTime.now().toUtc().toIso8601String(),
        "birdCount": 0,
        "mortalityCount": 0,
        "cullingCount": 0,
        "feedConsumptionKg": 0,
        "waterConsumptionLtr": 0,
        "temperatureC": 0,
        "humidityPercent": 0,
        "averageWeightGm": 0,
        "lightHours": 0,
        "medicineUsed": "string",
        "vaccineUsed": "string",
        "remarks": "string"
      };

      final response = await _apiFetch.postDailyEntry(
        baseUrl: baseUrl,
        token: token,
        data: data,
      );

      Get.snackbar("Success", "Daily Entry Posted: ${response['syncStatus']}");
      
      // Navigate to camera visit
      Get.toNamed(Routes.camera_visit, arguments: {
        'task': task,
        'batch': batch.value,
        'dailyEntryResponse': response,
      });
      
    } catch (e) {
      Get.snackbar("Error", "Failed to post daily entry: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
