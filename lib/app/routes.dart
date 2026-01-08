import 'package:doctor_appointment/features/appointment/presentation/ui/screens/confirm_appoinment.dart';
import 'package:doctor_appointment/features/appointment/presentation/ui/screens/my_appoinment.dart';
import 'package:doctor_appointment/features/appointment/presentation/ui/screens/select_time_slot_appoinment.dart';
import 'package:doctor_appointment/features/auth/presentation/ui/screens/sign_in_screen.dart';
import 'package:doctor_appointment/features/dashboard/presentation/ui/screens/dashboard.dart';
import 'package:doctor_appointment/features/home/presentation/ui/screens/home_screen.dart';
import 'package:doctor_appointment/features/language/presentation/ui/screens/language_select_screen.dart';
import 'package:doctor_appointment/features/notification/presentation/ui/notification_screen.dart';
import 'package:doctor_appointment/features/profile/presentation/ui/screens/profile_screen.dart';
import 'package:flutter/material.dart';

import '../features/appointment/presentation/ui/screens/book_appoinment.dart';
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
  }else if (settings.name == AppointmentConfirmedScreen.name) {
    screen = AppointmentConfirmedScreen();
  }
  else if (settings.name == MyAppointmentScreen.name) {
    screen = MyAppointmentScreen();
  }else if (settings.name == SelectDateTimeScreen.name) {
    screen = SelectDateTimeScreen();
  }else if (settings.name == SelectDoctorScreen.name) {
    screen = SelectDoctorScreen();
  }else if (settings.name == ProfileScreen.name) {
    screen = ProfileScreen();
  }else if (settings.name == HomeScreen.name) {
    screen = HomeScreen();
  }else if (settings.name == MainScreen.name) {
    screen = MainScreen();
  }else if (settings.name == NotificationsScreen.name) {
    screen = NotificationsScreen();
  }

  return MaterialPageRoute(builder: (ctx) => screen);
}