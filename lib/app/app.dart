import 'package:doctor_appointment/app/routes.dart';
import 'package:doctor_appointment/features/auth/presentation/ui/screens/splash_screen.dart';
import 'package:doctor_appointment/features/dashboard/presentation/ui/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../l10n/app_localizations.dart';
import 'app_theme.dart';
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
              home: SplashScreen(),
              initialRoute: SplashScreen.name,
              onGenerateRoute: onGenerateRoute,
              // initialBinding: ControllerBinding(),
            );
          },
        );
      },
    );
  }

}