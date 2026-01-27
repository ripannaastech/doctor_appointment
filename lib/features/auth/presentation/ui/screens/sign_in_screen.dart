import 'package:doctor_appointment/app/app_colors.dart';
import 'package:doctor_appointment/features/auth/presentation/ui/controller/auth_controller.dart';
import 'package:doctor_appointment/features/auth/presentation/ui/screens/verify_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../app/app_snackbar.dart';
import '../../../../../l10n/app_localizations.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  static const String name = '/login';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final c = Get.find<AuthControllerGetx>();

    final phoneCtrl = TextEditingController();

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Text(
                l10n.logInToYourAccount,
                style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 8.h),
            SizedBox(
              width: double.infinity,
              child: Text(
                l10n.welcomeBackPleaseEnterYourDetails,
                style: TextStyle(color: Colors.grey, fontSize: 16.sp),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 24.h),

            TextFormField(
              controller: phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(hintText: l10n.enterPhoneNumber),
            ),

            SizedBox(height: 24.h),

            Obx(() {
              return SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: c.loading.value
                      ? null
                      : () async {
                    final phone = phoneCtrl.text.trim();

                    if (phone.isEmpty) {
                      AppSnackbar.error(l10n.error, l10n.enterPhoneNumber);
                      return;
                    }

                    final ok = await c.requestOtpErpnext(phone);
                    if (!ok) return;

                    Navigator.pushNamed(
                      context,
                      OtpScreen.name,
                      arguments: {'phone': phone},
                    );

                  },
                  child: c.loading.value
                      ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : Text(
                    l10n.continueButton,
                    style: TextStyle(fontSize: 16.sp),
                  ),
                ),
              );
            }),

            SizedBox(height: 24.h),

            // Center(
            //   child: Column(
            //     children: [
            //       const OrDivider(),
            //       SizedBox(height: 16.h),
            //       GestureDetector(
            //         onTap: () => Navigator.pushNamed(context, RegisterScreen.name),
            //         child: Text.rich(
            //           TextSpan(
            //             text: "${l10n.dontHaveAnAccount} ",
            //             style: TextStyle(fontSize: 14.sp, color: Colors.grey),
            //             children: [
            //               TextSpan(
            //                 text: l10n.register,
            //                 style: TextStyle(
            //                   color: AppColors.themeColor,
            //                   fontWeight: FontWeight.w600,
            //                   fontSize: 14.sp,
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

