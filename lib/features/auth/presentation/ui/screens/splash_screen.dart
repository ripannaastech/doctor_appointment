import 'package:doctor_appointment/features/auth/presentation/ui/screens/sign_in_screen.dart';
import 'package:doctor_appointment/features/dashboard/presentation/ui/screens/dashboard.dart';
import 'package:doctor_appointment/features/language/presentation/ui/screens/language_select_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:workmanager/workmanager.dart';

import '../../../../../app/asset_paths.dart';
import '../../../../../app/controllers/language_controller.dart';
import '../../../../../core/services/background/background_service.dart';
import '../../../../../core/services/notification/local_notification_service.dart';
import '../../../../../core/services/shared_preferance/shared_preferance.dart';
import '../../../../home/presentation/ui/screens/home_screen.dart';
import '../../../../notification/presentation/ui/controller/notification_controller.dart';

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
    final prefs = SharedPrefs();
    _initLoggedInOnly(); // ✅ init here

    startBackgroundNotifications();
    final id = await prefs.getString(SharedPrefs.patientId);

    if (!mounted) return;

    if (langController.lang.value.isEmpty) {
      Navigator.pushReplacementNamed(context, LanguageSelectScreen.name);
      return;
    }

    if (id != null && id.isNotEmpty) {
      Navigator.pushReplacementNamed(context, Dashboard.name);
    } else {
      Navigator.pushReplacementNamed(context, LoginScreen.name);
    }
  }

  void _initLoggedInOnly() {
    // init local notifications (safe)
    LocalNotificationService.instance.init();

    // create notifications controller only once
    Get.find<NotificationsController>(); // ✅ creates controller -> onInit runs

  }
  Future<void> startBackgroundNotifications() async {
    await Workmanager().registerPeriodicTask(
      "notifTaskUnique",
      kNotifTask,
      frequency: const Duration(minutes: 15),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );
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

