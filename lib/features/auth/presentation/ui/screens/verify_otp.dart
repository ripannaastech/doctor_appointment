import 'package:doctor_appointment/app/app_colors.dart';
import 'package:doctor_appointment/features/auth/presentation/ui/controller/auth_controller.dart';
import 'package:doctor_appointment/features/home/presentation/ui/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../dashboard/presentation/ui/screens/dashboard.dart';
import 'complete_profile_screen.dart';

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';



class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});
  static const String name = '/otp';

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final c = Get.find<AuthControllerGetx>();

  String otp = '';

  // ✅ 10 min timer
  Timer? _timer;
  int _remainingSeconds = 600; // 10 minutes = 600 seconds

  String get phone {
    final arg = Get.arguments;
    if (arg is Map && arg['phone'] != null) return arg['phone'].toString();
    return c.lastPhone.value;
  }

  @override
  void initState() {
    super.initState();
    _startTimer(); // ✅ start timer when screen opens
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _remainingSeconds = 600;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      if (_remainingSeconds <= 0) {
        timer.cancel();
      } else {
        setState(() => _remainingSeconds--);
      }
    });
  }

  String get _timerText {
    final min = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final sec = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return "$min:$sec";
  }

  bool get _otpExpired => _remainingSeconds <= 0;

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
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8.h),

            Text(
              "${l10n.authenticationCodeSent}\n$phone",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 16.sp),
            ),

            SizedBox(height: 24.h),

            /// PIN CODE FIELD (6 digits)
            SizedBox(
              width: 260.w,
              child: PinCodeTextField(
                appContext: context,
                length: 6,
                keyboardType: TextInputType.number,
                animationType: AnimationType.fade,
                enableActiveFill: false,
                textStyle: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600),
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
                onChanged: (value) => otp = value,
              ),
            ),



            /// RESEND (disabled until timer ends)
            Obx(() {
              final disabled = c.loading.value || !_otpExpired;

              return TextButton(
                onPressed: disabled
                    ? null
                    : () async {
                  await c.resendOtpErpnext(phone);
                  _startTimer(); // ✅ reset 10 min timer
                },
                child: c.loading.value
                    ? const Text("Sending...")
                    : Text(
                  !_otpExpired
                      ? "${l10n.resendIn} $_timerText"
                      : l10n.resendOtp,
                ),
              );
            }),

            SizedBox(height: 16.h),

            /// CONFIRM
            Obx(() {
              return SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: c.loading.value
                      ? null
                      : () async {
                    // ✅ optional: block confirm if expired
                    if (_otpExpired) {
                      Get.snackbar('Error', l10n.otpExpiredPleaseResend);
                      return;
                    }

                    if (otp.trim().length != 6) {
                      Get.snackbar('Error', 'Enter 6 digit OTP');
                      return;
                    }

                    final ok = await c.verifyOtpErpnext(
                      phone: phone,
                      otp: otp.trim(),
                    );
                    if (!ok) return;

                    final res = c.otpVerifyRes.value;

                    if (res != null && res.isNewPatient) {
                      Get.offAllNamed(
                        RegisterScreen.name,
                        arguments: {'phone': phone},
                      );
                    } else {
                      Get.offAllNamed(MainScreen.name);
                    }
                  },
                  child: c.loading.value
                      ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : Text(l10n.confirm, style: TextStyle(fontSize: 16.sp)),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
