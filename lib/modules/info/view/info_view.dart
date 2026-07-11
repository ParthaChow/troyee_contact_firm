import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../app/core/theme/app_colors.dart';
import '../controller/info_controller.dart';

class InfoView extends GetView<InfoController> {
  const InfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          
          final batch = controller.batch.value;
          if (batch == null) {
            return const Center(child: Text("No data found"));
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HeaderSection(
                  batchName: batch.batchCode ?? "Batch",
                  farmName: batch.farmName ?? "Farm",
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Obx(() => controller.showOfflineBanner.value 
                        ? Column(
                            children: [
                              _OfflineBanner(),
                              const SizedBox(height: 20),
                            ],
                          )
                        : const SizedBox.shrink()),
                      _SectionTitle(title: "পাখির তথ্য"),
                      const SizedBox(height: 12),
                      _BirdInfoCard(),
                      const SizedBox(height: 24),
                      _SectionTitle(title: "খাদ্য ও পানি"),
                      const SizedBox(height: 12),
                      _ConsumptionCard(),
                      const SizedBox(height: 24),
                      _SectionTitle(title: "পরিবেশ"),
                      const SizedBox(height: 12),
                      _EnvironmentCard(),
                      const SizedBox(height: 24),
                      _SectionTitle(title: "বৃদ্ধি"),
                      _GrowthCard(),
                      const SizedBox(height: 40),
                      const SizedBox(height: 24),
                      _SectionTitle(title: "মন্তব্য"),
                      _CommentCard(),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () => controller.submitEntry(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            "তথ্য সংরক্ষণ করুন",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  final String farmName;
  final String batchName;

  const _HeaderSection({required this.batchName, required this.farmName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        10,
        MediaQuery.of(context).padding.top + 10,
        20,
        40,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Get.back(),
              ),
              const Text(
                "Daily Info Entry",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 50),
            child: Text(
              "$batchName / $farmName",
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OfflineBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xffFDEEEE),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          Icon(Icons.sync_problem, color: Color(0xffD32F2F), size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "- অফলাইনে ডিভাইসে সংরক্ষিত হচ্ছে",
              style: TextStyle(
                color: Color(0xffD32F2F),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: const Color(0xffE7A512),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xff0F2D20),
          ),
        ),
      ],
    );
  }
}

class _BirdInfoCard extends GetView<InfoController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
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
          Obx(() => _CounterRow(
            label: "মুরগির সংখ্যা",
            subLabel: "Bird count",
            value: controller.birdCount.value,
            onIncrement: controller.incrementBird,
            onDecrement: controller.decrementBird,
          )),
          const Divider(height: 32),
          Obx(() => _CounterRow(
            label: "মৃত্যু",
            subLabel: "Mortality",
            value: controller.mortality.value,
            onIncrement: controller.incrementMortality,
            onDecrement: controller.decrementMortality,
          )),
          const Divider(height: 32),
          Obx(() => _CounterRow(
            label: "কালিং",
            subLabel: "Culling",
            value: controller.culling.value,
            onIncrement: controller.incrementCulling,
            onDecrement: controller.decrementCulling,
          )),
        ],
      ),
    );
  }
}

class _CounterRow extends StatelessWidget {
  final String label;
  final String subLabel;
  final int value;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _CounterRow({
    required this.label,
    required this.subLabel,
    required this.value,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff212121),
                ),
              ),
              Text(
                subLabel,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xff727272),
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            _CounterButton(icon: Icons.remove, onTap: onDecrement),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                value.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _CounterButton(icon: Icons.add, onTap: onIncrement),
          ],
        ),
      ],
    );
  }
}

class _CounterButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CounterButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xffF5F5F5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xffE0E0E0)),
        ),
        child: Icon(icon, size: 20, color: Colors.black),
      ),
    );
  }
}

class _ConsumptionCard extends GetView<InfoController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
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
          _InputField(
            label: "খাদ্য খরচ (কেজি)",
            subLabel: "Feed consumption",
            controller: controller.feedController,
          ),
          const SizedBox(height: 20),
          _InputField(
            label: "পানি খরচ (লিটার)",
            subLabel: "Water consumption",
            controller: controller.waterController,
          ),
        ],
      ),
    );
  }
}

class _EnvironmentCard extends GetView<InfoController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
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
          _InputField(
            label: "তাপমাত্রা (°সে)",
            subLabel: "Temperature",
            controller: controller.tempController,
          ),
          const Divider(height: 32),
          _InputField(
            label: "আর্দ্রতা (%)",
            subLabel: "Humidity",
            controller: controller.humidityController,
          ),
          const Divider(height: 32),
          _InputField(
            label: "আলোর সময় (ঘণ্টা)",
            subLabel: "Light hours",
            controller: controller.lightController,
          ),
        ],
      ),
    );
  }
}
class _GrowthCard extends GetView<InfoController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: _InputField(
        label: "গড় ওজন (গ্রাম)",
        subLabel: "Average weight",
        controller: controller.growthController,
      ),
    );
  }
}
class _InputField extends StatelessWidget {
  final String label;
  final String subLabel;
  final TextEditingController controller;

  const _InputField({
    required this.label,
    required this.subLabel,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff212121),
                ),
              ),
              Text(
                subLabel,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xff727272),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 120,
          child: TextField(
            controller: controller,
            textAlign: TextAlign.right,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xffF5F5F5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _CommentCard extends GetView<InfoController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller.commentController,
        maxLines: 4,
        decoration: InputDecoration(
          hintText: " অতিরিক্ত কিছু পর্যবেক্ষণ লিখুন ",
          hintStyle: const TextStyle(color: Color(0xffA3A3A3), fontSize: 14),
          filled: true,
          fillColor: const Color(0xffF5F5F5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }
}
