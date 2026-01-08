import 'package:doctor_appointment/features/notification/presentation/ui/notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeTopBar extends StatelessWidget {
  const HomeTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Row(
        children: [
          /// Profile Image
          Container(
            height: 44.w, // circle → use w
            width: 44.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12.r,
                  offset: Offset(0, 6.h),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.network(
              'https://i.pravatar.cc/100?img=12',
              fit: BoxFit.cover,
            ),
          ),

          SizedBox(width: 12.w),

          /// Greeting + Name
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good Morning!',
                    style: TextStyle(
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF7B8194),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Brooklyn Simmons',
                    style: TextStyle(
                      fontSize: 16.5.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF141A2A),
                      height: 1.15,
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// Notification Button
          Container(
            height: 44.w,
            width: 44.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12.r,
                  offset: Offset(0, 6.h),
                ),
              ],
            ),
            child: IconButton(onPressed: (
            ){
              Navigator.pushNamed(context, NotificationsScreen.name);
            }, icon: Icon(
              Icons.notifications_none_rounded,
              size: 22.sp,
              color: const Color(0xFF141A2A),
            ),)
          ),
        ],
      ),
    );
  }
}
