import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:troyee_contact_firm/l10n/app_localizations.dart';
import 'package:troyee_contact_firm/modules/sign_in/controller/sign_in_controller.dart';

import '../../../models/farm_batch_model.dart';
import '../../../app/services/api_fetch.dart';
import '../../home/models/farm_task.dart';

class FarmBatchController extends GetxController {
  var batches = <FarmBatch>[].obs;
  var isLoading = true.obs;
  late final int farmId;
  late final String farmName;

  @override
  void onInit() {
    super.onInit();

    final task = Get.arguments as FarmTask;
    farmId = task.id;
    farmName = task.name;
    fetchBatches();
    print(farmId);
  }

  Future<void> fetchBatches() async {
    try {
      isLoading(true);

      String url = "http://103.134.89.218:60657/";
      final finalUrl = Uri.parse('$url$farmId/batches');
      print(url);
      final response = await http.get(
        finalUrl,
        headers: {'accept': '*/*'},
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        batches.value = jsonList.map((json) => FarmBatch.fromJson(json)).toList();
      } else {
        final l10n = AppLocalizations.of(Get.context!)!;
        Get.snackbar(l10n.error, '${l10n.failed_load_batches}: ${response.statusCode}');
      }
    } catch (e) {
      final l10n = AppLocalizations.of(Get.context!)!;
      Get.snackbar(l10n.error, '${l10n.error}: $e');
      print('Error An error occurred: $e');
    } finally {
      isLoading(false);
    }
  }
}