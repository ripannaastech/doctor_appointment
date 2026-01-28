import 'package:doctor_appointment/features/dashboard/presentation/ui/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../app/asset_paths.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../notification/presentation/ui/controller/notification_controller.dart';
import '../widgets/info_row_widget.dart';

class AppointmentConfirmedScreen extends StatelessWidget {
  static const String name = '/confirmAppointmentDoctor';

  const AppointmentConfirmedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;


    final args = ModalRoute.of(context)?.settings.arguments;

    final map = (args is Map) ? args : const <String, dynamic>{};

    final doctor = (map['doctor'] ?? '').toString();
    final department = (map['department'] ?? '').toString();
    final date = (map['date'] ?? '').toString(); // YYYY-MM-DD
    final time = (map['time'] ?? '').toString(); // HH:mm:ss
    final fee = (map['fee'] is num) ? (map['fee'] as num).toDouble() : 0.0;


    final prettyDate = _formatDatePretty(date);
    final prettyTime = _formatTimePretty(time);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF3F6DE0),
        elevation: 0,
        centerTitle: true,
        title: Text(
          l10n.bookAppointment,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.r)),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            60.verticalSpace,

            SizedBox(
              width: 187.w,
              height: 187.w,
              child: SvgPicture.asset(AssetPaths.confirmIcon),
            ),

            28.verticalSpace,

            Text(
              l10n.appointmentConfirmed,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600),
            ),

            10.verticalSpace,

            Text(
              l10n.appointmentSuccessfullyBooked,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey,
                height: 1.5,
              ),
            ),

            28.verticalSpace,

            SizedBox(
              width: 260.w,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InfoRow(title: l10n.department, text: department.isEmpty ? "-" : department),
                    InfoRow(title: l10n.doctor, text: doctor.isEmpty ? "-" : doctor),
                    InfoRow(title: l10n.date, text: prettyDate),
                    InfoRow(title: l10n.time, text: prettyTime),
                    // InfoRow(title: l10n.fee, text: fee > 0 ? fee.toStringAsFixed(2) : "-"),
                  ],
                ),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 52.h,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    Dashboard.name,
                        (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3F6DE0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  l10n.backToHome,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            20.verticalSpace,
          ],
        ),
      ),
    );
  }

  String _formatDatePretty(String yyyyMmDd) {
    try {
      final dt = DateTime.parse(yyyyMmDd);
      const w = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
      return '${w[dt.weekday - 1]}, ${months[dt.month - 1]} ${dt.day}, ${dt.year}';
    } catch (_) {
      return yyyyMmDd.isEmpty ? "-" : yyyyMmDd;
    }
  }

  String _formatTimePretty(String hhMmSs) {
    try {
      final parts = hhMmSs.split(':');
      if (parts.length < 2) return hhMmSs.isEmpty ? "-" : hhMmSs;

      final h = int.parse(parts[0]);
      final m = int.parse(parts[1]);

      final isPm = h >= 12;
      final hour12 = (h % 12 == 0) ? 12 : (h % 12);

      final hh = hour12.toString().padLeft(2, '0');
      final mm = m.toString().padLeft(2, '0');

      return '$hh:$mm ${isPm ? 'PM' : 'AM'}';
    } catch (_) {
      return hhMmSs.isEmpty ? "-" : hhMmSs;
    }
  }
}
