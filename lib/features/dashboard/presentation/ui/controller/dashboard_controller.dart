import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../appointment/presentation/ui/screens/my_appoinment.dart';
import '../../../../doctor/ui/screens/doctor_screen.dart';
import '../../../../home/presentation/ui/screens/home_screen.dart';
import '../../../../profile/presentation/ui/screens/profile_screen.dart';

class DashboardController extends GetxController {
  /// current tab index
  final RxInt currentIndex = 0.obs;

  /// screens list (keep as fields so they don't recreate)
  final List<Widget> screens = const [
    HomeScreen(),
    MyAppointmentScreen(),
    DoctorScreen(),
    ProfileScreen(),
  ];

  void changeTab(int index) {
    currentIndex.value = index;
  }
}
