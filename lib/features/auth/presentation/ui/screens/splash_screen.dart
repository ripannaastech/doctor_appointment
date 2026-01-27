import 'package:doctor_appointment/features/auth/presentation/ui/screens/sign_in_screen.dart';
import 'package:doctor_appointment/features/dashboard/presentation/ui/screens/dashboard.dart';
import 'package:doctor_appointment/features/language/presentation/ui/screens/language_select_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../app/asset_paths.dart';
import '../../../../../app/controllers/language_controller.dart';
import '../../../../../core/services/shared_preferance/shared_preferance.dart';
import '../../../../home/presentation/ui/screens/home_screen.dart';

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
    _moveToNextScreen(context);
  }

  Future<void> _moveToNextScreen(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 1));

    final langController = Get.find<LanguageController>(); // OK to keep GetX for state
    final prefs = SharedPrefs();

    final id = await prefs.getString(SharedPrefs.patientId);

    if (langController.lang.value.isEmpty) {
      Navigator.pushReplacementNamed(
        context,
        LanguageSelectScreen.name,
      );
      return;
    }

    if (id != null && id.isNotEmpty) {
      Navigator.pushReplacementNamed(
        context,
        Dashboard.name,
      );
    } else {
      Navigator.pushReplacementNamed(
        context,
        LoginScreen.name,
      );
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
