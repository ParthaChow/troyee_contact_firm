import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/core/theme/app_colors.dart';
import '../controller/info_controller.dart';

class InfoView extends GetView<InfoController> {
  const InfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const SizedBox(height: 16),
                    // _buildOfflineBanner(),
                    const SizedBox(height: 24),
                    _buildSectionHeader(context, "পাখির তথ্য"),
                    const SizedBox(height: 12),
                    _buildBirdInfoCard(context),
                    const SizedBox(height: 24),
                    _buildSectionHeader(context, "খাদ্য ও পানি"),
                    const SizedBox(height: 12),
                    _buildFoodWaterCard(context),
                    const SizedBox(height: 24),
                    _buildSectionHeader(context, "পরিবেশ"),
                    const SizedBox(height: 12),
                    _buildEnvironmentCard(context),
                    const SizedBox(height: 24),
                    _buildSectionHeader(context, "বৃদ্ধি"),
                    const SizedBox(height: 12),
                    _buildGrowthCard(context),
                    const SizedBox(height: 24),
                    _buildSectionHeader(context, "স্বাস্থ্য"),
                    const SizedBox(height: 12),
                    _buildHealthCard(context),
                    const SizedBox(height: 24),
                    _buildSectionHeader(context, "মন্তব্য"),
                    const SizedBox(height: 12),
                    _buildRemarksCard(context),
                    const SizedBox(height: 32),
                    _buildSubmitButton(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        bottom: 25,
        left: 20,
        right: 20,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light 
            ? const Color(0xFF0F2D20) 
            : const Color(0xff0a1b15),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              SizedBox(width: 12),
              Text(
                "দৈনিক তথ্য এন্ট্রি",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 38),
            child: Obx(() {
              final farmName = controller.task.name;
              final age = controller.batch.value?.ageInDays ?? 0;
              return Text(
                "$farmName • দিন $age",
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              );
            }),
          ),
        ],
      ),
    );
  }

  // Widget _buildOfflineBanner() {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
  //     decoration: BoxDecoration(
  //       color: const Color(0xFFFDE8E8),
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: const [
  //         Icon(Icons.wifi_off, size: 18, color: Color(0xFFC53030)),
  //         SizedBox(width: 8),
  //         Text(
  //           "অফলাইনে ডিভাইসে সংরক্ষিত হচ্ছে",
  //           style: TextStyle(
  //             color: Color(0xFFC53030),
  //             fontSize: 14,
  //             fontWeight: FontWeight.w500,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  //
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: const Color(0xFFE7A512),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).brightness == Brightness.light 
                ? const Color(0xFF0F2D20) 
                : Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildBirdInfoCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildCounterRow(
            context,
            "মুরগির সংখ্যা",
            "Bird count",
            controller.birdCount,
            controller.incrementBird,
            controller.decrementBird,
          ),
          Divider(height: 32, color: Theme.of(context).dividerColor.withOpacity(0.1)),
          _buildCounterRow(
            context,
            "মৃত্যু",
            "Mortality",
            controller.mortalityCount,
            controller.incrementMortality,
            controller.decrementMortality,
          ),
          Divider(height: 32, color: Theme.of(context).dividerColor.withOpacity(0.1)),
          _buildCounterRow(
            context,
            "কালিং",
            "Culling",
            controller.cullingCount,
            controller.incrementCulling,
            controller.decrementCulling,
          ),
        ],
      ),
    );
  }

  Widget _buildCounterRow(
    BuildContext context,
    String title,
    String subtitle,
    RxInt count,
    VoidCallback onAdd,
    VoidCallback onRemove,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        Row(
          children: [
            _buildCounterButton(context, Icons.remove, onRemove),
            const SizedBox(width: 16),
            Obx(
              () => Text(
                _toBengaliNumber(count.value.toString()),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),
            const SizedBox(width: 16),
            _buildCounterButton(context, Icons.add, onAdd),
          ],
        ),
      ],
    );
  }

  Widget _buildCounterButton(BuildContext context, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light 
              ? const Color(0xFFF5F7F5) 
              : Colors.white10,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.2)),
        ),
        child: Icon(icon, size: 18, color: Theme.of(context).iconTheme.color),
      ),
    );
  }

  Widget _buildFoodWaterCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInputRow(
            context,
            "খাদ্য খরচ (কেজি)",
            "Feed consumption",
            controller.feedController,
          ),
          Divider(height: 32, color: Theme.of(context).dividerColor.withOpacity(0.1)),
          _buildInputRow(
            context,
            "পানি খরচ (লিটার)",
            "Water consumption",
            controller.waterController,
          ),
        ],
      ),
    );
  }

  Widget _buildEnvironmentCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInputRow(
            context,
            "তাপমাত্রা (°সে)",
            "Temperature",
            controller.tempController,
          ),
          Divider(height: 32, color: Theme.of(context).dividerColor.withOpacity(0.1)),
          _buildInputRow(
            context,
            "আর্দ্রতা (%)",
            "Humidity",
            controller.humidityController,
          ),
          Divider(height: 32, color: Theme.of(context).dividerColor.withOpacity(0.1)),
          _buildInputRow(
            context,
            "আলোর সময় (ঘণ্টা)",
            "Light hours",
            controller.lightHoursController,
          ),
        ],
      ),
    );
  }

  Widget _buildGrowthCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: _buildInputRow(
        context,
        "গড় ওজন (গ্রাম)",
        "Average weight",
        controller.weightController,
      ),
    );
  }

  Widget _buildHealthCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSelectRow(
            context,
            "ব্যবহৃত ওষুধ",
            "Medicine used",
            controller.medicineController,
            hasDropdown: true,
          ),
          Divider(height: 32, color: Theme.of(context).dividerColor.withOpacity(0.1)),
          _buildSelectRow(context, "ভ্যাকসিন", "Vaccine", controller.vaccineController),
        ],
      ),
    );
  }

  Widget _buildRemarksCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light 
              ? const Color(0xFFF5F7F5) 
              : Colors.white10,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.2)),
        ),
        child: TextField(
          controller: controller.remarksController,
          maxLines: 3,
          style: TextStyle(fontSize: 15, color: Theme.of(context).textTheme.bodyLarge?.color),
          decoration: const InputDecoration(
            hintText: "মন্তব্য লিখুন...",
            border: InputBorder.none,
            isDense: true,
          ),
        ),
      ),
    );
  }

  Widget _buildSelectRow(
    BuildContext context,
    String title,
    String subtitle,
    TextEditingController textController, {
    bool hasDropdown = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        Container(
          width: 150,
          height: 45,
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light 
                ? const Color(0xFFF5F7F5) 
                : Colors.white10,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: textController,
                  textAlign: TextAlign.end,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
              if (hasDropdown)
                const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    size: 20,
                    color: Colors.grey,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInputRow(
    BuildContext context,
    String title,
    String subtitle,
    TextEditingController textController,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        Container(
          width: 120,
          height: 45,
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light 
                ? const Color(0xFFF5F7F5) 
                : Colors.white10,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.2)),
          ),
          child: TextField(
            controller: textController,
            textAlign: TextAlign.end,
            keyboardType: TextInputType.number,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 12),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          onPressed: controller.isLoading.value
              ? null
              : () => controller.submitDailyEntry(),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0F2D20),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 0,
          ),
          child: controller.isLoading.value
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text(
                  "Next",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
        ),
      ),
    );
  }

  String _toBengaliNumber(String number) {
    const bengaliNumbers = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
    String result = '';
    for (int i = 0; i < number.length; i++) {
      if (number[i] == '.') {
        result += '.';
      } else if (number[i] == ',') {
        result += ',';
      } else {
        int index = int.tryParse(number[i]) ?? -1;
        if (index != -1) {
          result += bengaliNumbers[index];
        } else {
          result += number[i];
        }
      }
    }
    return result;
  }
}
