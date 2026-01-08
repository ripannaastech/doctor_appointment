import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Appointment',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF141A2A),
          ),
        ),
        const Spacer(),
        Text(
          'See all',
          style: TextStyle(
            fontSize: 12.5.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF2F63F3),
          ),
        ),
      ],
    );
  }
}
