import 'package:doctor_appointment/app/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../l10n/app_localizations.dart';

class AppointmentCard extends StatelessWidget {
  const AppointmentCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.themeColor.withOpacity(.2),
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
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2D3A5F),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.more_vert,
                      color: const Color(0xFF2D3A5F),
                      size: 24.sp,
                    ),
                  ],
                ),

                SizedBox(height: 4.h),

                Text(
                  l10n.psychiatrist,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF2D3A5F),
                  ),
                ),

                SizedBox(height: 12.h),

                /// Date & Time pill
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6E92F2),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Wrap(
                    spacing: 12.w,
                    runSpacing: 4.h,
                    alignment: WrapAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.calendar_today, size: 10.sp, color: Colors.white),
                          SizedBox(width: 4.w),
                          Text(
                            l10n.appointmentDate,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 7.5.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.access_time, size: 10.sp, color: Colors.white),
                          SizedBox(width: 4.w),
                          Text(
                            l10n.morningTime,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 7.5.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )              ],
            ),
          ),
        ],
      ),
    );
  }
}
