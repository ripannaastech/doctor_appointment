import 'package:doctor_appointment/features/auth/presentation/ui/screens/verify_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/or_divider.dart';
import 'complete_profile_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static const String name = '/login';

  @override
  Widget build(BuildContext context) {
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
                'Log in to your account',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,

                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 8.h),
            SizedBox(
              width: double.infinity,

              child: Text(
                'Welcome Back! Please enter your details.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16.sp,
                ),
                textAlign: TextAlign.center,

              ),
            ),
            SizedBox(height: 24.h),
            TextFormField(
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: 'Enter phone number',
              ),
            ),
            SizedBox(height: 24.h),
            SizedBox(
              width: double.infinity,
              height: 56.h,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, OtpScreen.name);
                },
                child: Text(
                  'Continue',
                  style: TextStyle(fontSize: 16.sp),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Center(
              child: Column(
                children: [
                  const OrDivider(), // keep const if no ScreenUtil inside
                  SizedBox(height: 16.h),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, RegisterScreen.name);
                    },
                    child: Text.rich(
                      TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(fontSize: 14.sp),
                        children: [
                          TextSpan(
                            text: 'Register',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
