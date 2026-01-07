import 'package:doctor_appointment/features/language/presentation/ui/screens/language_select_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/asset_paths.dart';

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
    await Future.delayed(Duration(seconds: 1));
    // bool isUserLoggedIn = await Get.find<AuthController>().isUserAlreadyLoggedIn();
    // if (isUserLoggedIn) {
    //   await Get.find<AuthController>().loadUserData();
    // }
    Navigator.pushReplacementNamed(context, LanguageSelectScreen.name);
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
