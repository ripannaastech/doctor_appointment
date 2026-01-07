import 'package:doctor_appointment/features/auth/presentation/ui/screens/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/language_tile.dart';

class LanguageSelectScreen extends StatefulWidget {
  const LanguageSelectScreen({super.key});

  static const String name = '/language';

  @override
  State<LanguageSelectScreen> createState() => _LanguageSelectScreenState();
}

class _LanguageSelectScreenState extends State<LanguageSelectScreen> {
  String selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 64.h,
                  width: 64.w,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8F0FF),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.language,
                    size: 36,
                    color: Color(0xFF3F6EEB),
                  ),
                ),

                SizedBox(height: 24.sp),

                Text(
                  'Select Language',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: 40.h),

                languageTile(
                  title: 'English',
                  isSelected: selectedLanguage == 'English',
                  onTap: () {
                    setState(() => selectedLanguage = 'English');
                  },
                ),

                SizedBox(height: 16.h),

                languageTile(
                  title: 'Somali',
                  isSelected: selectedLanguage == 'Somali',
                  onTap: () {
                    setState(() => selectedLanguage = 'Somali');
                  },
                ),

                SizedBox(height: 40.h),

                SizedBox(
                  width: double.infinity,
                  height: 56.h,
                  child: ElevatedButton(

                    onPressed: () {
                      Navigator.pushNamed(context, LoginScreen.name);
                    },
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
