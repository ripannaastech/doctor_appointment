import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppSnackbar {
  static void success(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF1E7E34), // green
      colorText: Colors.white,
      margin: EdgeInsets.all(16.r),
      borderRadius: 14.r,
      icon: const Icon(Icons.check_circle, color: Colors.white),
      duration: const Duration(seconds: 3),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }

  static void error(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFFC62828), // red
      colorText: Colors.white,
      margin: EdgeInsets.all(16.r),
      borderRadius: 14.r,
      icon: const Icon(Icons.error, color: Colors.white),
      duration: const Duration(seconds: 4),
      isDismissible: true,
    );
  }

  static void info(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF266FEF), // your brand blue
      colorText: Colors.white,
      margin: EdgeInsets.all(16.r),
      borderRadius: 14.r,
      icon: const Icon(Icons.info, color: Colors.white),
      duration: const Duration(seconds: 3),
    );
  }
}
