import 'package:doctor_appointment/features/home/presentation/ui/widgets/quick_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: QuickCard(
                icon: Icons.calendar_month_rounded,
                title: 'Book Appointment',
                iconColor: const Color(0xFF2F63F3),
                bg: const Color(0xFFEAF1FF),
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: QuickCard(
                icon: Icons.description_rounded,
                title: 'My Appointments',
                iconColor: const Color(0xFF2DBE60),
                bg: const Color(0xFFE9FBEE),
              ),
            ),
          ],
        ),
        SizedBox(height: 14.h),
        Row(
          children: [
            Expanded(
              child: QuickCard(
                icon: Icons.assignment_rounded,
                title: 'My Results',
                iconColor: const Color(0xFF9B6CFF),
                bg: const Color(0xFFF2ECFF),
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: QuickCard(
                icon: Icons.medication_rounded,
                title: 'Pharmacy',
                iconColor: const Color(0xFFFF8A34),
                bg: const Color(0xFFFFEFE3),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
