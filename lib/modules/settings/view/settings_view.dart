import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../l10n/app_localizations.dart';
import '../controller/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Theme Toggle
          Card(
            child: ListTile(
              leading: const Icon(Icons.brightness_6),
              title: Text(l10n.dark_mode),
              trailing: Obx(() => Switch(
                value: controller.isDarkMode,
                onChanged: (_) => controller.toggleTheme(),
              )),
            ),
          ),
          const SizedBox(height: 16),
          // Language Toggle
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.language),
                  title: Text(l10n.language),
                ),
                const Divider(height: 1),
                RadioListTile<String>(
                  title: const Text('English'),
                  value: 'en',
                  groupValue: controller.currentLanguage,
                  onChanged: (val) {
                    if (val != null) controller.changeLanguage(val);
                  },
                ),
                RadioListTile<String>(
                  title: const Text('বাংলা (Bangla)'),
                  value: 'bn',
                  groupValue: controller.currentLanguage,
                  onChanged: (val) {
                    if (val != null) controller.changeLanguage(val);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
