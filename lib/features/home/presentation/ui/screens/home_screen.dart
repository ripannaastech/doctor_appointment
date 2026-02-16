import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/services/notification/notification_permission.dart';
import '../../../../profile/presentation/ui/controller/profle_controller.dart';
import '../widgets/appoinment_card.dart';
import '../widgets/banner_carousel.dart';
import '../widgets/help_sheet.dart';
import '../widgets/home_top_bar.dart';
import '../widgets/quick_action_grid.dart';
import '../widgets/section_header_home.dart';

class HomeScreen extends StatefulWidget {
  static const String name = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int bottomIndex = 0;
  final pc = Get.isRegistered<ProfileControllerGetx>()
      ? Get.find<ProfileControllerGetx>()
      : Get.put(ProfileControllerGetx());
  @override
  void initState() {
    super.initState();

    () async {
      await NotificationPermission.request(); // ✅ ask permission
      pc.loadCachedProfile(); // instant
      pc.fetchProfile();      // refresh from server
    }();
  }


  void _openHelpSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,

      builder: (context) {
        return  HelpSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 8.h),
             HomeTopBar(),
            SizedBox(height: 14.h),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 18.w),
                children: [
                  const BannerCarousel(),
                  SizedBox(height: 16.h),
                  const QuickActionsGrid(),
                  SizedBox(height: 18.h),


                ],
              ),
            ),
          ],
        ),
      ),

      /// Floating Help Button
      floatingActionButton: GestureDetector(
        onTap: _openHelpSheet,

        child: Container(
          height: 56.w, // use w for circular widgets
          width: 56.w,

          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF2F63F3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.16),
                blurRadius: 20.r,
                offset: Offset(0, 10.h),
              ),
            ],
          ),
          child: Icon(
            Icons.headset_mic_rounded,
            color: Colors.white,
            size: 26.sp,
          ),
        ),
      ),
    );
  }
}












