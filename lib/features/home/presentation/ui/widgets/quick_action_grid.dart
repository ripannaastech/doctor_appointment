import 'package:doctor_appointment/features/home/presentation/ui/widgets/quick_card.dart';
import 'package:doctor_appointment/features/lab_test/presentation/ui/screens/lab_report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../app/app_colors.dart';
import '../../../../../app/asset_paths.dart';
import '../../../../appointment/presentation/ui/screens/book_appoinment.dart';
import '../../../../dashboard/presentation/ui/controller/dashboard_controller.dart';

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 110.h, // 👈 bigger card
                child: QuickCard(
                  title: l10n.bookAppointment,
                  bg: const Color(0xFFEAF1FF),
                  gradient: AppColors.cardGradient,
                  iconWidget: Icon(
                    Icons.calendar_month_rounded,
                    size: 28.sp, // 👈 bigger icon
                    color: const Color(0xFF2F63F3),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, SelectDoctorScreen.name);
                  },
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: SizedBox(
                height: 110.h,
                child: GestureDetector(
                  onTap: () {
                    Get.find<DashboardController>().changeTab(1);
                  },
                  child: QuickCard(
                    title: l10n.myAppointments,
                    bg: const Color(0xFFE9FBEE),
                    gradient: AppColors.cardGradient,
                    iconWidget: Icon(
                      Icons.description_rounded,
                      size: 28.sp,
                      color: const Color(0xFF2DBE60),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 110.h,
                child: QuickCard(
                  title: l10n.myResults,
                  gradient: AppColors.cardGradient,
                  bg: const Color(0xFFF2ECFF),
                  iconWidget: Icon(
                    Icons.assignment_rounded,
                    size: 28.sp,
                    color: const Color(0xFF9B6CFF),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, LabReportScreen.name);
                  },
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: SizedBox(
                height: 110.h,
                child: QuickCard(
                  title: l10n.doctor,
                  gradient: AppColors.cardGradient,
                  onTap: () {
                    Get.find<DashboardController>().changeTab(2);
                  },
                  iconWidget: SvgPicture.asset(
                    AssetPaths.doctor,
                    width: 28.w,
                    height: 28.w,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
