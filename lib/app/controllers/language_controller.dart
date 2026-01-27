import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';



class LanguageController extends GetxController {
  static const _kLanguageCode = 'languageCode';

  final RxString lang = 'en'.obs;

  bool isSelected(String code) => lang.value == code;

  @override
  void onInit() {
    super.onInit();
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_kLanguageCode);

    lang.value = (saved == 'so') ? 'so' : 'en';
    Get.updateLocale(Locale(lang.value));
  }

  Future<void> setLanguage(String code) async {
    if (code != 'en' && code != 'so') return;
    if (lang.value == code) return;

    lang.value = code;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kLanguageCode, code);

    Get.updateLocale(Locale(code));
  }
}
