import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../controller/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Obx(() {
        final isDark = controller.isDarkMode;
        final bgColor = isDark ? const Color(0xff0a1b15) : const Color(0xffF8FAF8);
        final textColor = isDark ? Colors.white : AppColors.primary;

        return Container(
          color: bgColor,
          child: SafeArea(
            child: Column(
              children: [
                _buildAppBar(context, textColor, l10n.settings),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    children: [
                      _buildSectionLabel(l10n.preferences),
                      const SizedBox(height: 8),
                      _buildSettingsTile(
                        icon: Icons.contrast_rounded,
                        title: l10n.appearance,
                        value: isDark ? l10n.dark_mode : l10n.light_mode,
                        onTap: () => _showAppearanceBottomSheet(context, isDark, l10n),
                        isDark: isDark,
                      ),
                      _buildDivider(isDark),
                      _buildSettingsTile(
                        icon: Icons.translate_rounded,
                        title: l10n.language,
                        value: controller.currentLanguage == 'en' ? "English" : "বাংলা",
                        onTap: () => _showLanguageBottomSheet(context, isDark, l10n),
                        isDark: isDark,
                      ),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildAppBar(BuildContext context, Color textColor, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: textColor, size: 20),
            onPressed: () => Get.back(),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              color: textColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, top: 16),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDark ? Colors.white70 : Colors.black54,
              size: 22,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white.withOpacity(0.9) : Colors.black87,
                ),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white38 : Colors.black38,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: isDark ? Colors.white24 : Colors.black12,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(
      height: 1,
      thickness: 0.5,
      indent: 42,
      color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
    );
  }

  void _showAppearanceBottomSheet(BuildContext context, bool isDark, AppLocalizations l10n) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xff1a2b25) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.white12 : Colors.black12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.appearance,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            _buildSelectionTile(
              title: l10n.light_mode,
              isSelected: !isDark,
              onTap: () {
                if (isDark) controller.toggleTheme();
                Get.back();
              },
              isDark: isDark,
            ),
            _buildSelectionTile(
              title: l10n.dark_mode,
              isSelected: isDark,
              onTap: () {
                if (!isDark) controller.toggleTheme();
                Get.back();
              },
              isDark: isDark,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showLanguageBottomSheet(BuildContext context, bool isDark, AppLocalizations l10n) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xff1a2b25) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.white12 : Colors.black12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.language,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            _buildSelectionTile(
              title: "English",
              isSelected: controller.currentLanguage == 'en',
              onTap: () {
                controller.changeLanguage('en');
                Get.back();
              },
              isDark: isDark,
            ),
            _buildSelectionTile(
              title: "বাংলা",
              isSelected: controller.currentLanguage == 'bn',
              onTap: () {
                controller.changeLanguage('bn');
                Get.back();
              },
              isDark: isDark,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionTile({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: AppColors.primary)
          : null,
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }


}
