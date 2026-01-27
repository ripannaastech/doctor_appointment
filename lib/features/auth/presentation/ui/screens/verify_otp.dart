import 'package:doctor_appointment/app/app_colors.dart';
import 'package:doctor_appointment/features/auth/presentation/ui/controller/auth_controller.dart';
import 'package:doctor_appointment/features/home/presentation/ui/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../../app/app_snackbar.dart';
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

  Timer? _timer;

  // ✅ Reactive timer (10 minutes)
  final RxInt remainingSeconds = 600.obs;

  String get phone {
    final route = ModalRoute.of(context);
    if (route == null) return c.lastPhone.value;

    final args = route.settings.arguments;
    if (args is Map<String, dynamic>) {
      final p = args['phone'];
      if (p != null) return p.toString();
    }

    return c.lastPhone.value;
  }


  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    remainingSeconds.value = 600;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value <= 0) {
        timer.cancel();
      } else {
        remainingSeconds.value--;
      }
    });
  }

  String get timerText {
    final min = (remainingSeconds.value ~/ 60).toString().padLeft(2, '0');
    final sec = (remainingSeconds.value % 60).toString().padLeft(2, '0');
    return "$min:$sec";
  }

  bool get otpExpired => remainingSeconds.value <= 0;

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

            /// OTP FIELD
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
                  inactiveColor: Colors.grey.shade400,
                  activeColor: theme.primaryColor,
                  selectedColor: theme.primaryColor,
                ),
                onChanged: (v) => otp = v,
              ),
            ),

            SizedBox(height: 16.h),

            /// RESEND BUTTON
            Obx(() {
              final disabled = c.loading.value || remainingSeconds.value > 0;

              return TextButton(
                onPressed: disabled
                    ? null
                    : () async {
                  await c.resendOtpErpnext(phone);
                  _startTimer();
                },
                child: Text(
                  remainingSeconds.value > 0
                      ? "${l10n.resendIn} $timerText"
                      : l10n.resendOtp,
                ),
              );
            }),

            SizedBox(height: 16.h),

            /// CONFIRM BUTTON
            Obx(() {
              return SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: c.loading.value
                      ? null
                      : () async {
                    if (otpExpired) {
                      AppSnackbar.error(
                        l10n.error,
                        l10n.otpExpiredPleaseResend,
                      );
                      return;
                    }

                    if (otp.trim().length != 6) {
                      AppSnackbar.error(
                        l10n.error,
                        l10n.enter6DigitOtp,
                      );
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
                      Get.offAllNamed(Dashboard.name);
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
