import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LocaleService extends GetxService {
  final _storage = GetStorage('locale_storage');
  final _key = 'locale';
  late Rx<Locale> _locale;

  Locale get locale => _locale.value;

  Future<LocaleService> init() async {
    String? langCode = _storage.read(_key);
    _locale = Locale(langCode ?? 'bn').obs;
    return this;
  }

  void updateLocale(String langCode) {
    _storage.write(_key, langCode);
    _locale.value = Locale(langCode);
    Get.updateLocale(_locale.value);
  }
}
