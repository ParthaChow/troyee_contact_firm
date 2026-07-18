import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/core/theme/app_colors.dart';
import '../controller/info_controller.dart';

class InfoView extends GetView<InfoController> {
  const InfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F7),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _buildOfflineBanner(),
                  const SizedBox(height: 24),
                  _buildSectionHeader("পাখির তথ্য"),
                  const SizedBox(height: 12),
                  _buildBirdInfoCard(),
                  const SizedBox(height: 24),
                  _buildSectionHeader("খাদ্য ও পানি"),
                  const SizedBox(height: 12),
                  _buildFoodWaterCard(),
                  const SizedBox(height: 24),
                  _buildSectionHeader("পরিবেশ"),
                  const SizedBox(height: 12),
                  _buildEnvironmentCard(),
                  const SizedBox(height: 24),
                  _buildSectionHeader("বৃদ্ধি"),
                  const SizedBox(height: 12),
                  _buildGrowthCard(),
                  const SizedBox(height: 24),
                  _buildSectionHeader("স্বাস্থ্য"),
                  const SizedBox(height: 12),
                  _buildHealthCard(),
                  const SizedBox(height: 24),
                  _buildSectionHeader("মন্তব্য"),
                  const SizedBox(height: 12),
                  _buildRemarksCard(),
                  const SizedBox(height: 32),
                  _buildSubmitButton(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
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
      decoration: const BoxDecoration(
        color: Color(0xFF0F2D20),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 12),
              const Text(
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
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildOfflineBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFDE8E8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.wifi_off, size: 18, color: Color(0xFFC53030)),
          SizedBox(width: 8),
          Text(
            "অফলাইনে ডিভাইসে সংরক্ষিত হচ্ছে",
            style: TextStyle(
              color: Color(0xFFC53030),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
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
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F2D20),
          ),
        ),
      ],
    );
  }

  Widget _buildBirdInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
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
            "মুরগির সংখ্যা",
            "Bird count",
            controller.birdCount,
            controller.incrementBird,
            controller.decrementBird,
          ),
          const Divider(height: 32, color: Color(0xFFEEEEEE)),
          _buildCounterRow(
            "মৃত্যু",
            "Mortality",
            controller.mortalityCount,
            controller.incrementMortality,
            controller.decrementMortality,
          ),
          const Divider(height: 32, color: Color(0xFFEEEEEE)),
          _buildCounterRow(
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
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F2D20),
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            _buildCounterButton(Icons.remove, onRemove),
            const SizedBox(width: 16),
            Obx(() => Text(
                  _toBengaliNumber(count.value.toString()),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F2D20),
                  ),
                )),
            const SizedBox(width: 16),
            _buildCounterButton(Icons.add, onAdd),
          ],
        ),
      ],
    );
  }

  Widget _buildCounterButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F7F5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Icon(icon, size: 18, color: const Color(0xFF0F2D20)),
      ),
    );
  }

  Widget _buildFoodWaterCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
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
            "খাদ্য খরচ (কেজি)",
            "Feed consumption",
            controller.feedController,
          ),
          const Divider(height: 32, color: Color(0xFFEEEEEE)),
          _buildInputRow(
            "পানি খরচ (লিটার)",
            "Water consumption",
            controller.waterController,
          ),
        ],
      ),
    );
  }

  Widget _buildEnvironmentCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
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
            "তাপমাত্রা (°সে)",
            "Temperature",
            controller.tempController,
          ),
          const Divider(height: 32, color: Color(0xFFEEEEEE)),
          _buildInputRow(
            "আর্দ্রতা (%)",
            "Humidity",
            controller.humidityController,
          ),
          const Divider(height: 32, color: Color(0xFFEEEEEE)),
          _buildInputRow(
            "আলোর সময় (ঘণ্টা)",
            "Light hours",
            controller.lightHoursController,
          ),
        ],
      ),
    );
  }

  Widget _buildGrowthCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
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
        "গড় ওজন (গ্রাম)",
        "Average weight",
        controller.weightController,
      ),
    );
  }

  Widget _buildHealthCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
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
            "ব্যবহৃত ওষুধ",
            "Medicine used",
            controller.medicineController,
            hasDropdown: true,
          ),
          const Divider(height: 32, color: Color(0xFFEEEEEE)),
          _buildSelectRow(
            "ভ্যাকসিন",
            "Vaccine",
            controller.vaccineController,
          ),
        ],
      ),
    );
  }

  Widget _buildRemarksCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
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
          color: const Color(0xFFF5F7F5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: TextField(
          controller: controller.remarksController,
          maxLines: 3,
          style: const TextStyle(
            fontSize: 15,
            color: Color(0xFF0F2D20),
          ),
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
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F2D20),
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 150,
          height: 45,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F7F5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: textController,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F2D20),
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
                  child: Icon(Icons.keyboard_arrow_down, size: 20, color: Colors.grey),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInputRow(
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
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F2D20),
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 120,
          height: 45,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F7F5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          child: TextField(
            controller: textController,
            textAlign: TextAlign.end,
            keyboardType: TextInputType.number,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F2D20),
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
    return Obx(() => SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed: controller.isLoading.value ? null : () => controller.submitDailyEntry(),
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
                    "ক্যামেরা এ যান", // "Go to Camera" in Bengali
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
          ),
        ));
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
