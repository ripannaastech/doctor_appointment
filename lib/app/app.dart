import 'package:doctor_appointment/app/routes.dart';
import 'package:doctor_appointment/features/appointment/presentation/ui/screens/book_appoinment.dart';
import 'package:doctor_appointment/features/appointment/presentation/ui/screens/my_appoinment.dart';
import 'package:doctor_appointment/features/dashboard/presentation/ui/screens/dashboard.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../features/auth/presentation/ui/screens/splash_screen.dart';
import '../features/home/presentation/ui/screens/home.dart';
import '../features/profile/presentation/ui/screens/profile_screen.dart';
import '../l10n/app_localizations.dart';
import 'app_theme.dart';
import 'controller_binder.dart';
import 'controllers/language_controller.dart';

class AlIshanSpecialistHospital extends StatefulWidget {
  const AlIshanSpecialistHospital({super.key});

  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();
  static final LanguageController languageController = LanguageController();

  @override
  State<AlIshanSpecialistHospital> createState() => _AlIshanSpecialistHospitalState();
}

class _AlIshanSpecialistHospitalState extends State<AlIshanSpecialistHospital> {
  // static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  // static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(
  //   analytics: analytics,
  // );

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      ensureScreenSize: true,
      builder: (context, child) {
        return GetBuilder(
          init: AlIshanSpecialistHospital.languageController,
          builder: (languageController) {
            return GetMaterialApp(
              navigatorKey: AlIshanSpecialistHospital.navigatorKey,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              // navigatorObservers: [observer],
              locale: languageController.currentLocale,
              supportedLocales: languageController.supportedLocales,
              theme: AppTheme.lightThemeData,
              darkTheme: AppTheme.darkThemeData,
              themeMode: ThemeMode.light,
              home: MainScreen(),
              initialRoute: MainScreen.name,
              onGenerateRoute: onGenerateRoute,
              // initialBinding: ControllerBinding(),
            );
          },
        );
      },
    );
  }

}