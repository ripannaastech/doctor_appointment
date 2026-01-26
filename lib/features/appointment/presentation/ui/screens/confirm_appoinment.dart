import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../app/asset_paths.dart';
import '../../../../../l10n/app_localizations.dart';
import '../widgets/info_row_widget.dart';

// class AppointmentConfirmedScreen extends StatelessWidget {
//   static const String name = '/confirmAppointmentDoctor';
//
//   const AppointmentConfirmedScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final l10n = AppLocalizations.of(context)!;
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF3F6DE0),
//         elevation: 0,
//         centerTitle: true,
//         title: Text(
//           l10n.bookAppointment,
//           style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600,color: Colors.white),
//         ),
//         leading:  IconButton( onPressed: () {
//           Navigator.pop(context);
//
//         }, icon: Icon(Icons.arrow_back_ios, color: Colors.white,),),
//         shape: RoundedRectangleBorder(
//           borderRadius:
//           BorderRadius.vertical(bottom: Radius.circular(20.r)),
//         ),
//       ),
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 20.w),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             60.verticalSpace,
//
//             /// Success Icon
//             SizedBox(
//               width: 187.w,
//               height: 187.w,
//               child: SvgPicture.asset(AssetPaths.confirmIcon),
//             ),
//
//             28.verticalSpace,
//
//             Text(
//               l10n.appointmentConfirmed,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 20.sp,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//
//             10.verticalSpace,
//
//             Text(
//               l10n.appointmentSuccessfullyBooked,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 14.sp,
//                 color: Colors.grey,
//                 height: 1.5,
//               ),
//             ),
//
//             28.verticalSpace,
//
//             /// Centered Info Section
//             SizedBox(
//               width: 260.w, // 👈 key for perfect centering
//               child: Center(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     InfoRow(
//                       title: l10n.department,
//                       text: l10n.cardiology,
//                     ),
//                     InfoRow(
//                       title: l10n.doctor,
//                       text: 'Dr. Ahmed Hossain',
//                     ),
//
//                     InfoRow(
//                       title: l10n.date,
//                       text: 'Fri, Jan 2, 2025',
//                     ),
//                     InfoRow(
//                       title: l10n.time,
//                       text: '02:30 PM',
//                     ),
//
//
//                   ],
//                 ),
//               ),
//             ),
//
//             const Spacer(),
//
//             /// Back Button
//             SizedBox(
//               width: double.infinity,
//               height: 52.h,
//               child: ElevatedButton(
//                 onPressed: () {},
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF3F6DE0),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12.r),
//                   ),
//                 ),
//                 child: Text(
//                   l10n.backToHome,
//                   style: TextStyle(
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//
//             20.verticalSpace,
//           ],
//         ),
//       ),
//     );
//   }
//
// }
class AppointmentConfirmedScreen extends StatelessWidget {
  static const String name = '/confirmAppointmentDoctor';

  final String doctor;
  final String department;
  final String date; // YYYY-MM-DD
  final String time; // HH:mm:ss
  final double fee;

  const AppointmentConfirmedScreen({
    super.key,
    required this.doctor,
    required this.department,
    required this.date,
    required this.time,
    required this.fee,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // ✅ Nice readable formats (simple + safe)
    final prettyDate = _formatDatePretty(date);      // e.g., "Fri, Jan 2, 2026"
    final prettyTime = _formatTimePretty(time);      // e.g., "02:30 PM"

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

            /// Success Icon
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

            /// Centered Info Section
            SizedBox(
              width: 260.w,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InfoRow(
                      title: l10n.department,
                      text: department,
                    ),
                    InfoRow(
                      title: l10n.doctor,
                      text: doctor,
                    ),
                    InfoRow(
                      title: l10n.date,
                      text: prettyDate,
                    ),
                    InfoRow(
                      title: l10n.time,
                      text: prettyTime,
                    ),
                    // Optional: show fee if you want
                    // InfoRow(
                    //   title: l10n.fee,
                    //   text: fee.toStringAsFixed(2),
                    // ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            /// Back Button
            SizedBox(
              width: double.infinity,
              height: 52.h,
              child: ElevatedButton(
                onPressed: () {
                  // ✅ Example: go home/root
                  Get.offAllNamed('/home');
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

  /// "2026-01-02" -> "Fri, Jan 2, 2026"
  String _formatDatePretty(String yyyyMmDd) {
    try {
      final parts = yyyyMmDd.split('-');
      if (parts.length != 3) return yyyyMmDd;

      final y = int.parse(parts[0]);
      final m = int.parse(parts[1]);
      final d = int.parse(parts[2]);

      final dt = DateTime(y, m, d);

      const w = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      const months = [
        'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'
      ];

      final weekday = w[dt.weekday - 1];
      final month = months[dt.month - 1];

      return '$weekday, $month ${dt.day}, ${dt.year}';
    } catch (_) {
      return yyyyMmDd;
    }
  }

  /// "14:30:00" -> "02:30 PM"
  String _formatTimePretty(String hhMmSs) {
    try {
      final parts = hhMmSs.split(':');
      if (parts.length < 2) return hhMmSs;

      int h = int.parse(parts[0]);
      final m = int.parse(parts[1]);

      final isPm = h >= 12;
      final hour12 = (h % 12 == 0) ? 12 : (h % 12);

      final hh = hour12.toString().padLeft(2, '0');
      final mm = m.toString().padLeft(2, '0');
      final ap = isPm ? 'PM' : 'AM';

      return '$hh:$mm $ap';
    } catch (_) {
      return hhMmSs;
    }
  }
}
