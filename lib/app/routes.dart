import 'package:doctor_appointment/features/appointment/presentation/ui/screens/confirm_appoinment.dart';
import 'package:doctor_appointment/features/appointment/presentation/ui/screens/my_appoinment.dart';
import 'package:doctor_appointment/features/appointment/presentation/ui/screens/select_time_slot_appoinment.dart';
import 'package:doctor_appointment/features/auth/presentation/ui/screens/sign_in_screen.dart';
import 'package:doctor_appointment/features/dashboard/presentation/ui/screens/dashboard.dart';
import 'package:doctor_appointment/features/home/presentation/ui/screens/home_screen.dart';
import 'package:doctor_appointment/features/lab_test/presentation/ui/screens/lab_report.dart';
import 'package:doctor_appointment/features/language/presentation/ui/screens/language_select_screen.dart';
import 'package:doctor_appointment/features/notification/presentation/ui/notification_screen.dart';
import 'package:doctor_appointment/features/profile/presentation/ui/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import '../features/appointment/models/data/practitioner_model.dart';
import '../features/appointment/presentation/ui/screens/book_appoinment.dart';
import '../features/auth/presentation/ui/screens/complete_profile_screen.dart';
import '../features/auth/presentation/ui/screens/splash_screen.dart';
import '../features/auth/presentation/ui/screens/verify_otp.dart';
import '../features/lab_test/presentation/ui/screens/lab_report_details_screen.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case SplashScreen.name:
      return MaterialPageRoute(builder: (_) => const SplashScreen());

    case LanguageSelectScreen.name:
      return MaterialPageRoute(builder: (_) => const LanguageSelectScreen());

    case LoginScreen.name:
      return MaterialPageRoute(builder: (_) => const LoginScreen());

    case OtpScreen.name:
      return MaterialPageRoute(builder: (_) => const OtpScreen());

    case RegisterScreen.name:
      return MaterialPageRoute(builder: (_) => const RegisterScreen());

    case LabReportScreen.name:
      return MaterialPageRoute(builder: (_) => const LabReportScreen());

    case LabReportDetailsScreen.name: {
      final arg = settings.arguments;


      final labTestId = (arg is String) ? arg : '';

      return MaterialPageRoute(
        builder: (_) => LabReportDetailsScreen(labTestId: labTestId),
      );
    }

    case MyAppointmentScreen.name:
      return MaterialPageRoute(builder: (_) => const MyAppointmentScreen());

    case SelectDateTimeScreen.name: {
      final arg = settings.arguments;


      final model = (arg is Practitioner) ? arg : null;

      if (model == null) {
        return _errorRoute('Practitioner missing for SelectDateTimeScreen');
      }

      return MaterialPageRoute(
        builder: (_) => SelectDateTimeScreen(doctor: model),
      );
    }

    case SelectDoctorScreen.name:
      return MaterialPageRoute(builder: (_) => const SelectDoctorScreen());

    case ProfileScreen.name:
      return MaterialPageRoute(builder: (_) => const ProfileScreen());

    case HomeScreen.name:
      return MaterialPageRoute(builder: (_) => const HomeScreen());

    case Dashboard.name:
      return MaterialPageRoute(builder: (_) => const Dashboard());

    case NotificationsScreen.name:
      return MaterialPageRoute(builder: (_) => const NotificationsScreen());

    case AppointmentConfirmedScreen.name: {
      final args = settings.arguments;

      final map = (args is Map<String, dynamic>) ? args : const {};

      return MaterialPageRoute(
        builder: (_) => const AppointmentConfirmedScreen(),
        settings: RouteSettings(
          name: AppointmentConfirmedScreen.name,
          arguments: map, // pass through safely
        ),
      );
    }

    default:
      return _errorRoute('No route defined for ${settings.name}');
  }
}

Route<dynamic> _errorRoute(String message) {
  return MaterialPageRoute(
    builder: (_) => Scaffold(
      appBar: AppBar(title: const Text('Route Error')),
      body: Center(child: Text(message)),
    ),
  );
}
