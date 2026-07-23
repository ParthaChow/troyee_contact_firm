import 'package:get/get.dart';
import '../../../app/services/locale_service.dart';
import '../../../app/services/theme_service.dart';

class SettingsController extends GetxController {
  final ThemeService _themeService = Get.find<ThemeService>();
  final LocaleService _localeService = Get.find<LocaleService>();

  bool get isDarkMode => _themeService.isDarkMode;
  String get currentLanguage => _localeService.locale.languageCode;

  void toggleTheme() {
    _themeService.switchTheme();
  }

  void changeLanguage(String langCode) {
    _localeService.updateLocale(langCode);
  }
}
