import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController extends GetxController {
  Locale _currentLocale = const Locale('en');

  @override
  void onInit() {
    super.onInit();
    _loadLocale();
  }

  Locale get currentLocale => _currentLocale;

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('languageCode');
    if (languageCode != null && languageCode.isNotEmpty) {
      if(languageCode == 'so'){
        _currentLocale = const Locale('so');
      } else {
        _currentLocale = const Locale('en');
      }
    }
    update();
    Get.updateLocale(_currentLocale);
  }


  Future<void> setLocale(Locale locale) async {
    _currentLocale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', locale.languageCode);
    update();
    Get.updateLocale(locale);
  }
}
