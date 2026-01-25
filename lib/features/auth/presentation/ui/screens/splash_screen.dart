import 'package:doctor_appointment/features/auth/presentation/ui/screens/sign_in_screen.dart';
import 'package:doctor_appointment/features/language/presentation/ui/screens/language_select_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../app/asset_paths.dart';
import '../../../../../app/controllers/language_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String name = '/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {
    super.initState();
    _moveToNextScreen();
  }

  Future<void> _moveToNextScreen() async {
    await Future.delayed(const Duration(seconds: 1));

    final langController = Get.find<LanguageController>();

    // if language already chosen → go login
    if (langController.lang.value.isNotEmpty) {
      Get.offNamed(LoginScreen.name);
    } else {
      Get.offNamed(LanguageSelectScreen.name);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          AssetPaths.logoPng,
          width: 200.w,
          height: 200.h,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
