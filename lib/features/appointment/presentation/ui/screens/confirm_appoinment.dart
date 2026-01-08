import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../app/asset_paths.dart';
import '../widgets/info_row_widget.dart';

class AppointmentConfirmedScreen extends StatelessWidget {
  static const String name = '/confirmAppointmentDoctor';

  const AppointmentConfirmedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF3F6DE0),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Book Appointment',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600,color: Colors.white),
        ),
        leading: const Icon(Icons.arrow_back_ios, color: Colors.white),
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
              'Appointment Confirmed!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),

            10.verticalSpace,

            Text(
              'Your appointment has been\nsuccessfully booked',
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
                      title: 'Department:',
                      text: 'Cardiology',
                    ),
                    InfoRow(
                      title: 'Doctor',
                      text: 'Dr. Ahmed Hossain',
                    ),

                    InfoRow(
                      title: 'Date:',
                      text: 'Fri, Jan 2, 2025',
                    ),
                    InfoRow(
                      title: 'Time:',
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
                  'Back To Home',
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
