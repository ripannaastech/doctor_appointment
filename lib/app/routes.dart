import 'package:doctor_appointment/features/auth/presentation/ui/screens/sign_in_screen.dart';
import 'package:doctor_appointment/features/language/presentation/ui/screens/language_select_screen.dart';
import 'package:flutter/material.dart';

import '../features/auth/presentation/ui/screens/complete_profile_screen.dart';
import '../features/auth/presentation/ui/screens/splash_screen.dart';
import '../features/auth/presentation/ui/screens/verify_otp.dart';

MaterialPageRoute onGenerateRoute(RouteSettings settings) {
  late Widget screen;

  if (settings.name == SplashScreen.name) {
    screen = SplashScreen();
  }

  else if (settings.name == LanguageSelectScreen.name) {
    screen = LanguageSelectScreen();
  }
  else if (settings.name == LoginScreen.name) {
    screen = LoginScreen();
  }else if (settings.name == OtpScreen.name) {
    screen = OtpScreen();
  }else if (settings.name == RegisterScreen.name) {
    screen = RegisterScreen();
  }

  return MaterialPageRoute(builder: (ctx) => screen);
}