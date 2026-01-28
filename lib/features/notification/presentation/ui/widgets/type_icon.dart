import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/models/notification_item_model.dart';

class TypeIcon extends StatelessWidget {
  final NotificationType type;
  const TypeIcon({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    late Color bg;
    late Color fg;
    late IconData icon;

    switch (type) {
      case NotificationType.appointmentConfirmed:
        bg = const Color(0xFFEAF1FF);
        fg = const Color(0xFF2F63F3);
        icon = Icons.calendar_month_rounded;
        break;

      case NotificationType.doctorsAvailableToday:
        bg = const Color(0xFFE9FBEE);
        fg = const Color(0xFF2DBE60);
        icon = Icons.person_search_rounded; // modern & clear
        break;

      case NotificationType.departmentInfo:
        bg = const Color(0xFFF2ECFF);
        fg = const Color(0xFF9B6CFF);
        icon = Icons.apartment_rounded;
        break;

      case NotificationType.announcement:
        bg = const Color(0xFFFFEFE3);
        fg = const Color(0xFFFF8A1E);
        icon = Icons.campaign_rounded;
        break;

      case NotificationType.unknown:
        bg = const Color(0xFFF3F4F6);
        fg = const Color(0xFF6B7280);
        icon = Icons.notifications_rounded;
        break;
    }

    return Container(
      height: 44.r,
      width: 44.r,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12.r),
      ),
      alignment: Alignment.center,
      child: Icon(
        icon,
        color: fg,
        size: 22.sp,
      ),
    );
  }
}
