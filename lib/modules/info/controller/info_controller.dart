import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/services/api_fetch.dart';
import '../../../app/services/services.dart';
import '../../../models/farm_batch_model.dart';

class InfoController extends GetxController {
  final ApiFetch _api = ApiFetch();
  
  final isLoading = true.obs;
  final showOfflineBanner = false.obs;
  final Rxn<FarmBatch> batch = Rxn<FarmBatch>();
  
  // Form fields
  final birdCount = 0.obs;
  final mortality = 0.obs;
  final culling = 0.obs;
  
  final feedController = TextEditingController();
  final waterController = TextEditingController();
  final tempController = TextEditingController();
  final humidityController = TextEditingController();
  final lightController = TextEditingController();
  final growthController = TextEditingController();
  final commentController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    final FarmBatch args = Get.arguments;
    // Set initial batch data from arguments so header can show info even if API fails
    batch.value = args;
    fetchBatchDetail(args.farmId, args.id);
  }

  Future<void> fetchBatchDetail(int farmId, int batchId) async {
    try {
      isLoading(true);
      
      // Initialize everything to 0 as requested
      birdCount.value = 0;
      mortality.value = 0;
      culling.value = 0;
      feedController.text = "0";
      waterController.text = "0";
      tempController.text = "0";
      humidityController.text = "0";
      lightController.text = "0";
      growthController.text = "0";
      commentController.text = "";

      final result = await _api.getBatchDetail(farmId: farmId, batchId: batchId);
      batch.value = result;
      showOfflineBanner.value = false;
      
      // If success, update with actual data
      birdCount.value = result.currentCount;
      mortality.value = result.mortalityCount;
      feedController.text = result.totalFeedKg.toString();
      growthController.text = result.averageWeightKg.toString();
      
    } catch (e) {
      // If it fails, we don't update birdCount, so it stays at the initialized 0
      showOfflineBanner.value = true;
      print("Fetch failed, showing initialized values: $e");
      // Optional: Get.snackbar("Info", "Using offline/initialized values");
    } finally {
      isLoading(false);
    }
  }

  void incrementBird() => birdCount.value++;
  void decrementBird() {
    if (birdCount.value > 0) birdCount.value--;
  }

  void incrementMortality() => mortality.value++;
  void decrementMortality() {
    if (mortality.value > 0) mortality.value--;
  }

  void incrementCulling() => culling.value++;
  void decrementCulling() {
    if (culling.value > 0) culling.value--;
  }

  Future<void> submitEntry() async {
    try {
      isLoading(true);
      final auth = Get.find<AuthService>();
      
      final Map<String, dynamic> data = {
        "visitId": 1, // Assuming 0 for a new entry
        "batchId": batch.value?.id ?? 0,
        "recordDate": DateTime.now().toIso8601String(),
        "birdCount": birdCount.value,
        "mortalityCount": mortality.value,
        "cullingCount": culling.value,
        "feedConsumptionKg": double.tryParse(feedController.text) ?? 0.0,
        "waterConsumptionLtr": double.tryParse(waterController.text) ?? 0.0,
        "temperatureC": double.tryParse(tempController.text) ?? 0.0,
        "humidityPercent": int.tryParse(humidityController.text) ?? 0,
        "averageWeightGm": double.tryParse(growthController.text) ?? 0.0,
        "lightHours": double.tryParse(lightController.text) ?? 0.0,
        "medicineUsed": "a",
        "vaccineUsed": "a",
        "remarks": commentController.text.isEmpty ? "a" : commentController.text,
      };

      await _api.submitDailyEntry(
        baseUrl: auth.baseUrl ?? "",
        token: auth.accessToken ?? "",
        data: data,

      );

      Get.back();
      Get.snackbar("Success", "Daily entry submitted successfully", 
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar("Error", "Failed to submit entry: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print(e);
    } finally {
      isLoading(false);
    }
  }

  @override
  void onClose() {
    feedController.dispose();
    waterController.dispose();
    tempController.dispose();
    humidityController.dispose();
    lightController.dispose();
    growthController.dispose();
    commentController.dispose();
    super.onClose();
  }
}
