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

      case NotificationType.pharmacyNeeded:
        bg = const Color(0xFFFFF1E3);
        fg = const Color(0xFFFF8A1E);
        icon = Icons.local_pharmacy_rounded;
        break;

      case NotificationType.appointmentCancelled:
        bg = const Color(0xFFEAF1FF);
        fg = const Color(0xFF2F63F3);
        icon = Icons.calendar_month_rounded;
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
