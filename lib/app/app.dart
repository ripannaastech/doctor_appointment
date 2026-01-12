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
  AlIshanSpecialistHospital({super.key});

  final LanguageController languageController = Get.put(LanguageController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LanguageController>(
      builder: (controller) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          locale: controller.currentLocale,
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
          themeMode: ThemeMode.light,

          home: const SplashScreen(),
          initialRoute: SplashScreen.name,
          onGenerateRoute: onGenerateRoute,

          // 👇 ScreenUtil MUST go here
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
      },
    );
  }
}
