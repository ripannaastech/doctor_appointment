import 'package:doctor_appointment/app/app_colors.dart';
import 'package:doctor_appointment/features/home/presentation/ui/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../dashboard/presentation/ui/screens/dashboard.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  static const String name = '/otp';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.otpVerification,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w500
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              l10n.authenticationCodeSent,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16.sp,
              ),
            ),
            SizedBox(height: 32.h),

            /// PIN CODE FIELD
            SizedBox(
              width: 240.w,
              child: PinCodeTextField(
                appContext: context,
                length: 4,
                keyboardType: TextInputType.number,
                animationType: AnimationType.fade,
                enableActiveFill: false,
                textStyle: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                ),
                cursorColor: AppColors.themeColor,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  fieldHeight: 40.h,
                  fieldWidth: 40.w,
                  fieldOuterPadding: EdgeInsets.zero,
                  inactiveColor: Colors.grey.shade400,
                  activeColor: theme.primaryColor,
                  selectedColor: theme.primaryColor,

                  inactiveBorderWidth: 1,
                  activeBorderWidth: 2,
                  selectedBorderWidth: 2,
                ),
                onChanged: (value) {},
              ),
            ),

            SizedBox(height: 24.h),
            Text(
              l10n.didNotReceiveCode,
              style: TextStyle(fontSize: 14.sp),
            ),
            SizedBox(height: 24.h),

            SizedBox(
              width: double.infinity,
              height: 56.h,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, MainScreen.name);
                },
                child: Text(
                  l10n.confirm,
                  style: TextStyle(fontSize: 16.sp),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
