import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/farm_batch_controller.dart';

class FarmBatchView extends GetView<FarmBatchController> {
  const FarmBatchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farm Batches'),
        centerTitle: true,
        // Here is your back button that pops the screen
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.batches.isEmpty) {
          return const Center(child: Text('No batches found for this farm.'));
        }

        return ListView.builder(
          itemCount: controller.batches.length,
          itemBuilder: (context, index) {
            final batch = controller.batches[index];

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ID (Explicitly labeled as Batch ID so it isn't confused with Farm ID)
                    Text(
                      'Batch ID: ${batch.id}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Divider(),
                    const SizedBox(height: 4),

                    // Batch Code
                    Text(
                      'Batch Code: ${batch.batchCode}',
                      style: const TextStyle(fontSize: 15),
                    ),
                    const SizedBox(height: 8),

                    // Breed
                    Text(
                      'Breed: ${batch.breed}',
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}