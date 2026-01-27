import 'package:doctor_appointment/app/controller_binder.dart';
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
import 'extensions/somalian_extension.dart';
class AlIshanSpecialistHospital extends StatelessWidget {
  const AlIshanSpecialistHospital({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: ControllerBinding(),
      debugShowCheckedModeBanner: false,

      locale: Get.locale,   // 👈 GetX manages this
      fallbackLocale: const Locale('en'),

      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: [
        ...AppLocalizations.localizationsDelegates,
        SomaliMaterialLocalizations.delegate,
        SomaliCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      theme: AppTheme.lightThemeData,
      darkTheme: AppTheme.darkThemeData,

      home: const SplashScreen(),
      onGenerateRoute: onGenerateRoute,

      builder: (context, child) {
        return ScreenUtilInit(
          designSize: const Size(375, 844),
          minTextAdapt: true,
          splitScreenMode: true,
          ensureScreenSize: true,
          builder: (context, _) => child!,
        );
      },
    );
  }
}


