import 'package:doctor_appointment/app/controllers/language_controller.dart';
import 'package:doctor_appointment/features/auth/presentation/ui/screens/sign_in_screen.dart';
import 'package:doctor_appointment/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../widgets/language_tile.dart';

class LanguageSelectScreen extends StatelessWidget {
  const LanguageSelectScreen({super.key});

  static const String name = '/language';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: GetBuilder<LanguageController>(
              builder: (controller) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 64.h,
                      width: 64.w,
                      child: Icon(
                        Icons.language,
                        size: 64,
                        color: Color(0xFF3F6EEB),
                      ),
                    ),
                    SizedBox(height: 24.sp),
                    Text(
                      l10n.selectLanguage,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 40.h),
                    languageTile(
                      title: l10n.english,
                      isSelected: controller.currentLocale.languageCode == 'en',
                      onTap: () {
                        controller.setLocale(const Locale('en'));
                      },
                    ),
                    SizedBox(height: 16.h),
                    languageTile(
                      title: l10n.somali,
                      isSelected: controller.currentLocale.languageCode == 'so',
                      onTap: () {
                        controller.setLocale(const Locale('so'));
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
                          l10n.continueButton,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
