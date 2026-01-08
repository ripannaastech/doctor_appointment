import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuickCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color iconColor;
  final Color bg;

  const QuickCard({
    super.key,
    required this.icon,
    required this.title,
    required this.iconColor,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 112.h,
      padding: EdgeInsets.fromLTRB(14.w, 16.h, 14.w, 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18.r,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// Icon background
          Container(
            height: 40.w, // square → use w
            width: 40.w,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              icon,
              size: 20.sp,
              color: iconColor,
            ),
          ),

          SizedBox(height: 12.h),

          /// Title
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w400,
              height: 1.15,
              color: const Color(0xFF141A2A),
            ),
          ),
        ],
      ),
    );
  }
}
