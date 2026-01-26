import 'package:doctor_appointment/app/app_colors.dart';
import 'package:doctor_appointment/features/appointment/presentation/ui/screens/my_appoinment.dart';
import 'package:doctor_appointment/features/dashboard/presentation/ui/controller/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../app/asset_paths.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../appointment/presentation/ui/screens/book_appoinment.dart';
import '../../../../doctor/ui/screens/doctor_screen.dart';
import '../../../../home/presentation/ui/screens/home_screen.dart';
import '../../../../profile/presentation/ui/screens/profile_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

// import your files:
// import 'main_controller.dart';
// import 'app_localizations.dart';
// import 'app_colors.dart';
// import 'asset_paths.dart';

class Dashboard extends StatelessWidget {
  static const String name = '/mainScreen';
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(DashboardController()); // or Get.find<MainController>()

    return Obx(() {
      return Scaffold(
        body: IndexedStack(
          index: c.currentIndex.value,
          children: c.screens,
        ),
        bottomNavigationBar: _bottomNavBar(context, c),
      );
    });
  }

  Widget _bottomNavBar(BuildContext context, DashboardController c) {
    final l10n = AppLocalizations.of(context)!;

    return BottomNavigationBar(
      currentIndex: c.currentIndex.value,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFF3F6DE0),
      unselectedItemColor: const Color(0xFFB8BCC8),
      onTap: c.changeTab,
      items: [
        _bottomNavItem(
          currentIndex: c.currentIndex.value,
          index: 0,
          label: l10n.home,
          iconWidget: Icon(
            Icons.home_outlined,
            size: 26.sp,
            color: c.currentIndex.value == 0
                ? const Color(0xFF3F6DE0)
                : const Color(0xFFB8BCC8),
          ),
        ),
        _bottomNavItem(
          currentIndex: c.currentIndex.value,
          index: 1,
          label: l10n.appointment,
          iconWidget: Icon(
            Icons.calendar_month,
            size: 26.sp,
            color: c.currentIndex.value == 1
                ? const Color(0xFF3F6DE0)
                : const Color(0xFFB8BCC8),
          ),
        ),
        _bottomNavItem(
          currentIndex: c.currentIndex.value,
          index: 2,
          label: l10n.doctor,
          iconWidget: SvgPicture.asset(
            AssetPaths.doctor,
            width: 26.sp,
            height: 26.sp,
            colorFilter: ColorFilter.mode(
              c.currentIndex.value == 2
                  ? const Color(0xFF3F6DE0)
                  : const Color(0xFFB8BCC8),
              BlendMode.srcIn,
            ),
          ),
        ),
        _bottomNavItem(
          currentIndex: c.currentIndex.value,
          index: 3,
          label: l10n.profile,
          iconWidget: Icon(
            Icons.person_outline,
            size: 26.sp,
            color: c.currentIndex.value == 3
                ? const Color(0xFF3F6DE0)
                : const Color(0xFFB8BCC8),
          ),
        ),
      ],
    );
  }

  BottomNavigationBarItem _bottomNavItem({
    required Widget iconWidget,
    required String label,
    required int index,
    required int currentIndex,
  }) {
    final bool isSelected = currentIndex == index;

    return BottomNavigationBarItem(
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Top indicator bar
          Container(
            height: 4.h,
            width: 32.w,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.themeColor : Colors.transparent,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(2.r),
                bottomRight: Radius.circular(2.r),
              ),
            ),
          ),
          SizedBox(height: 8.h),

          /// Icon / Image / SVG
          SizedBox(
            height: 26.sp,
            width: 26.sp,
            child: iconWidget,
          ),

          SizedBox(height: 4.h),
        ],
      ),
      label: label,
    );
  }
}

