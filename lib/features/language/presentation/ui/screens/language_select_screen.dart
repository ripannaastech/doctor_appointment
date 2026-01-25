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
    final controller = Get.find<LanguageController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Obx(() {
              final selected = controller.lang.value;

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 64.h,
                    width: 64.w,
                    child: const Icon(
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
                    isSelected: selected == 'en',
                    onTap: () => controller.setLanguage('en'),
                  ),

                  SizedBox(height: 16.h),

                  languageTile(
                    title: l10n.somali,
                    isSelected: selected == 'so',
                    onTap: () => controller.setLanguage('so'),
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
            }),
          ),
        ),
      ),
    );
  }
}
