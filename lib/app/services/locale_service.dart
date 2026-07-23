import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LocaleService extends GetxService {
  final _storage = GetStorage('locale_storage');
  final _key = 'locale';

  Locale get locale {
    String? langCode = _storage.read(_key);
    if (langCode != null) {
      return Locale(langCode);
    }
    return const Locale('bn'); // Default to Bangla
  }

  Future<LocaleService> init() async {
    return this;
  }

  void updateLocale(String langCode) {
    _storage.write(_key, langCode);
    Get.updateLocale(Locale(langCode));
  }
}
