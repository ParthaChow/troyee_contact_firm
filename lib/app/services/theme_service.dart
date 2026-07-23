import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeService extends GetxController {
  final _storage = GetStorage();
  final _key = 'isDarkMode';

  late RxBool _isDarkMode;

  ThemeService() {
    _isDarkMode = _loadThemeFromBox().obs;
  }

  ThemeMode get theme => _isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  bool _loadThemeFromBox() => _storage.read(_key) ?? false;

  _saveThemeToBox(bool isDarkMode) => _storage.write(_key, isDarkMode);

  void switchTheme() {
    _isDarkMode.value = !_isDarkMode.value;
    Get.changeThemeMode(_isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    _saveThemeToBox(_isDarkMode.value);
    update();
  }
  
  bool get isDarkMode => _isDarkMode.value;
}
