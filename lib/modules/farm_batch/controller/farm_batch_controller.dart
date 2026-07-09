import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:troyee_contact_firm/modules/sign_in/controller/sign_in_controller.dart';

import '../../../models/farm_batch_model.dart';
import '../../../app/services/api_fetch.dart';

class FarmBatchController extends GetxController {
  var batches = <FarmBatch>[].obs;
  var isLoading = true.obs;
  late final int farmId;

  @override
  void onInit() {
    super.onInit();

    // ✅ CORRECT: Assignments and function calls go inside a method
    farmId = Get.arguments as int;
    fetchBatches();
  }

  Future<void> fetchBatches() async {
    try {
      isLoading(true);

      final url = Uri.parse('${SignInController().baseUrlController}/$farmId/batches');

      final response = await http.get(
        url,
        headers: {'accept': '*/*'},
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        batches.value = jsonList.map((json) => FarmBatch.fromJson(json)).toList();
      } else {
        Get.snackbar('Error', 'Failed to load batches: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading(false);
    }
  }
}