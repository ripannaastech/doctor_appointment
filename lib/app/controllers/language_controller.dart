import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    _loadLocale();
  }

  Locale get currentLocale => Get.locale ?? const Locale('en');

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('languageCode');

    Locale locale;
    if (languageCode == 'so') {
      locale = const Locale('so');
    } else {
      locale = const Locale('en');
    }

    Get.updateLocale(locale);   // 🔥 single source of truth
  }

  Future<void> setLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', locale.languageCode);

    Get.updateLocale(locale);   // 🔥 rebuilds the whole app
  }
}
