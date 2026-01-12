import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../app/asset_paths.dart';
import '../../../../../l10n/app_localizations.dart';
import '../widgets/info_row_widget.dart';

class AppointmentConfirmedScreen extends StatelessWidget {
  static const String name = '/confirmAppointmentDoctor';

  const AppointmentConfirmedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF3F6DE0),
        elevation: 0,
        centerTitle: true,
        title: Text(
          l10n.bookAppointment,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600,color: Colors.white),
        ),
        leading:  IconButton( onPressed: () {
          Navigator.pop(context);

        }, icon: Icon(Icons.arrow_back_ios, color: Colors.white,),),
        shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.vertical(bottom: Radius.circular(20.r)),
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
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
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
              width: 260.w, // 👈 key for perfect centering
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InfoRow(
                      title: l10n.department,
                      text: l10n.cardiology,
                    ),
                    InfoRow(
                      title: l10n.doctor,
                      text: 'Dr. Ahmed Hossain',
                    ),

                    InfoRow(
                      title: l10n.date,
                      text: 'Fri, Jan 2, 2025',
                    ),
                    InfoRow(
                      title: l10n.time,
                      text: '02:30 PM',
                    ),


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
                onPressed: () {},
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

}
