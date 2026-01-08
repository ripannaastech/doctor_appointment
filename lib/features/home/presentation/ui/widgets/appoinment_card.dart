import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppointmentCard extends StatelessWidget {
  const AppointmentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFFAEC7FA),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Doctor Image
          ClipRRect(
            borderRadius: BorderRadius.circular(14.r),
            child: Image.network(
              'https://i.pravatar.cc/150?img=5',
              height: 90.h,
              width: 70.w,
              fit: BoxFit.cover,
            ),
          ),

          SizedBox(width: 14.w),

          /// Right Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Name + More icon
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        'Dr. Dianne Russell',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF2D3A5F),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.more_vert,
                      color: const Color(0xFF2D3A5F),
                      size: 20.sp,
                    ),
                  ],
                ),

                SizedBox(height: 4.h),

                Text(
                  'Psychiatrist',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF2D3A5F),
                  ),
                ),

                SizedBox(height: 12.h),

                /// Date & Time pill
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6E92F2),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 12.sp,
                        color: Colors.white,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Tue, 29 Jun, 2025',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Icon(
                        Icons.access_time,
                        size: 12.sp,
                        color: Colors.white,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Morning 08:00 AM',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
