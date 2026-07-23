import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../controller/info_controller.dart';

class InfoView extends GetView<InfoController> {
  const InfoView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;

    // Localize numbers in controllers when locale changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _localizeAllControllers(locale);
    });

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Column(
          children: [
            _buildHeader(context, locale),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    _buildSectionHeader(context, l10n.bird_info),
                    const SizedBox(height: 12),
                    _buildBirdInfoCard(context, locale),
                    const SizedBox(height: 24),
                    _buildSectionHeader(context, l10n.food_and_water),
                    const SizedBox(height: 12),
                    _buildFoodWaterCard(context, locale),
                    const SizedBox(height: 24),
                    _buildSectionHeader(context, l10n.environment),
                    const SizedBox(height: 12),
                    _buildEnvironmentCard(context, locale),
                    const SizedBox(height: 24),
                    _buildSectionHeader(context, l10n.growth),
                    const SizedBox(height: 12),
                    _buildGrowthCard(context, locale),
                    const SizedBox(height: 24),
                    _buildSectionHeader(context, l10n.health),
                    const SizedBox(height: 12),
                    _buildHealthCard(context, locale),
                    const SizedBox(height: 24),
                    _buildSectionHeader(context, l10n.remarks),
                    const SizedBox(height: 12),
                    _buildRemarksCard(context),
                    const SizedBox(height: 32),
                    _buildSubmitButton(context),
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

  Widget _buildHeader(BuildContext context, String locale) {
    final l10n = AppLocalizations.of(context)!;
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
            children: [
              const SizedBox(width: 12),
              Text(
                l10n.daily_info_entry,
                style: const TextStyle(
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
              final localizedAge = _localizeNumber(age.toString(), locale);
              return Text(
                "$farmName • ${l10n.day} $localizedAge",
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              );
            }),
          ),
        ],
      ),
    );
  }

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

  Widget _buildBirdInfoCard(BuildContext context, String locale) {
    final l10n = AppLocalizations.of(context)!;
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
            l10n.bird_count_label,
            controller.birdCount,
            controller.incrementBird,
            controller.decrementBird,
            locale,
          ),
          Divider(height: 32, color: Theme.of(context).dividerColor.withOpacity(0.1)),
          _buildCounterRow(
            context,
            l10n.mortality_label,
            controller.mortalityCount,
            controller.incrementMortality,
            controller.decrementMortality,
            locale,
          ),
          Divider(height: 32, color: Theme.of(context).dividerColor.withOpacity(0.1)),
          _buildCounterRow(
            context,
            l10n.culling_label,
            controller.cullingCount,
            controller.incrementCulling,
            controller.decrementCulling,
            locale,
          ),
        ],
      ),
    );
  }

  Widget _buildCounterRow(
    BuildContext context,
    String title,
    RxInt count,
    VoidCallback onAdd,
    VoidCallback onRemove,
    String locale,
  ) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        ),
        Row(
          children: [
            _buildCounterButton(context, Icons.remove, onRemove),
            const SizedBox(width: 16),
            Obx(
              () => Text(
                _localizeNumber(count.value.toString(), locale),
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

  Widget _buildFoodWaterCard(BuildContext context, String locale) {
    final l10n = AppLocalizations.of(context)!;
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
            l10n.feed_consumption_label,
            controller.feedController,
            locale,
          ),
          Divider(height: 32, color: Theme.of(context).dividerColor.withOpacity(0.1)),
          _buildInputRow(
            context,
            l10n.water_consumption_label,
            controller.waterController,
            locale,
          ),
        ],
      ),
    );
  }

  Widget _buildEnvironmentCard(BuildContext context, String locale) {
    final l10n = AppLocalizations.of(context)!;
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
            l10n.temperature_label,
            controller.tempController,
            locale,
          ),
          Divider(height: 32, color: Theme.of(context).dividerColor.withOpacity(0.1)),
          _buildInputRow(
            context,
            l10n.humidity_label,
            controller.humidityController,
            locale,
          ),
          Divider(height: 32, color: Theme.of(context).dividerColor.withOpacity(0.1)),
          _buildInputRow(
            context,
            l10n.light_hours_label,
            controller.lightHoursController,
            locale,
          ),
        ],
      ),
    );
  }

  Widget _buildGrowthCard(BuildContext context, String locale) {
    final l10n = AppLocalizations.of(context)!;
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
        l10n.avg_weight_label,
        controller.weightController,
        locale,
      ),
    );
  }

  Widget _buildHealthCard(BuildContext context, String locale) {
    final l10n = AppLocalizations.of(context)!;
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
            l10n.medicine_used_label,
            controller.medicineController,
            locale,
            hasDropdown: true,
          ),
          Divider(height: 32, color: Theme.of(context).dividerColor.withOpacity(0.1)),
          _buildSelectRow(context, l10n.vaccine_label, controller.vaccineController, locale),
        ],
      ),
    );
  }

  Widget _buildRemarksCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
          decoration: InputDecoration(
            hintText: l10n.enter_remarks_hint,
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
    TextEditingController textController,
    String locale, {
    bool hasDropdown = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
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
                  onChanged: (value) {
                    if (locale == 'bn') {
                      final localized = _localizeNumber(value, 'bn');
                      if (localized != value) {
                        textController.text = localized;
                        textController.selection = TextSelection.fromPosition(
                          TextPosition(offset: textController.text.length),
                        );
                      }
                    }
                  },
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
    TextEditingController textController,
    String locale,
  ) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
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
            onChanged: (value) {
              if (locale == 'bn') {
                final localized = _localizeNumber(value, 'bn');
                if (localized != value) {
                  textController.text = localized;
                  textController.selection = TextSelection.fromPosition(
                    TextPosition(offset: textController.text.length),
                  );
                }
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
              : Text(
                  l10n.next,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
        ),
      ),
    );
  }

  void _localizeAllControllers(String locale) {
    controller.feedController.text = _localizeNumber(controller.feedController.text, locale);
    controller.waterController.text = _localizeNumber(controller.waterController.text, locale);
    controller.tempController.text = _localizeNumber(controller.tempController.text, locale);
    controller.humidityController.text = _localizeNumber(controller.humidityController.text, locale);
    controller.lightHoursController.text = _localizeNumber(controller.lightHoursController.text, locale);
    controller.weightController.text = _localizeNumber(controller.weightController.text, locale);
  }

  String _localizeNumber(String input, String locale) {
    if (locale == 'en') return controller.unlocalizeNumber(input);
    final english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const bengali = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
    String result = controller.unlocalizeNumber(input);
    for (int i = 0; i < 10; i++) {
      result = result.replaceAll(english[i], bengali[i]);
    }
    return result;
  }
}
