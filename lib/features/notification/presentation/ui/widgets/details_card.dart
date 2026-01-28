import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../l10n/app_localizations.dart';
import '../../../data/models/appoinment_model.dart';
import '../../../data/models/notification_item_model.dart';
import 'details_row.dart';

class DetailsCard extends StatelessWidget {
  final AppointmentDetails details;
  const DetailsCard({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F6FF),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.appointmentDetails,
            style: TextStyle(
              fontSize: 13.5.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF141A2A),
            ),
          ),
          SizedBox(height: 10.h),

          if (details.doctor != null)
            DetailRow(
              icon: Icons.person_rounded,
              text: details.doctor!,
            ),

          if (details.date != null) ...[
            SizedBox(height: 8.h),
            DetailRow(
              icon: Icons.calendar_today_rounded,
              text: details.date!,
            ),
          ],

          if (details.time != null) ...[
            SizedBox(height: 8.h),
            DetailRow(
              icon: Icons.access_time_rounded,
              text: details.time!,
            ),
          ],

          if (details.location != null) ...[
            SizedBox(height: 8.h),
            DetailRow(
              icon: Icons.location_on_rounded,
              text: details.location!,
            ),
          ],

          if (details.reason != null) ...[
            SizedBox(height: 10.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.reason,
                    style: TextStyle(
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF7B8194),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    details.reason!,
                    style: TextStyle(
                      fontSize: 12.8.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF141A2A),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
