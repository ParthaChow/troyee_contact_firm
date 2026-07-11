import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:troyee_contact_firm/app/routes/app_routes.dart';
import 'package:troyee_contact_firm/modules/info/controller/info_controller.dart';
import '../../../app/core/theme/app_colors.dart';

class InfoView extends GetView<InfoController> {
  const InfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Visit Info"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.batch.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final batch = controller.batch.value;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("Farm Task Info"),
              _buildInfoRow("Farm Name", controller.task.name),
              _buildInfoRow("Location", controller.task.location),
              _buildInfoRow("Capacity", controller.task.capacity.toString()),
              _buildInfoRow("Status", controller.task.status.name),
              const SizedBox(height: 20),
              
              if (batch != null) ...[
                _buildSectionTitle("Farm Batch Info (from API)"),
                _buildInfoRow("ID", batch.id.toString()),
                _buildInfoRow("Batch Code", batch.batchCode),
                _buildInfoRow("Breed", batch.breed),
                _buildInfoRow("Farm ID", batch.farmId.toString()),
                _buildInfoRow("Initial Count", batch.initialCount.toString()),
                _buildInfoRow("Current Count", batch.currentCount.toString()),
                _buildInfoRow("Mortality Count", batch.mortalityCount.toString()),
                _buildInfoRow("Placement Date", batch.placementDate.toString()),
                _buildInfoRow("Health Status", batch.healthStatus),
                _buildInfoRow("Avg Weight (kg)", batch.averageWeightKg.toString()),
                _buildInfoRow("Total Feed (kg)", batch.totalFeedKg.toString()),
                _buildInfoRow("Age (days)", batch.ageInDays.toString()),
                _buildInfoRow("Mortality Rate", "${(batch.mortalityRate * 100).toStringAsFixed(2)}%"),
                const SizedBox(height: 20),
              ],

              _buildSectionTitle("Check-In Response"),
              ...controller.checkInResponse.entries.map((entry) => 
                _buildInfoRow(entry.key, entry.value.toString())
              ).toList(),
             
             const SizedBox(height: 30),
             SizedBox(
               width: double.infinity,
               child: ElevatedButton(
                 onPressed: controller.isLoading.value ? null : () => controller.submitDailyEntry(),
                 child: controller.isLoading.value 
                   ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                   : const Text("Go to Camera"),
               ),
             ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              "$label:",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
