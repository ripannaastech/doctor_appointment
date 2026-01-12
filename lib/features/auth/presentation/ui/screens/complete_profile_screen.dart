import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../app/asset_paths.dart';
import '../../../../../l10n/app_localizations.dart';
import '../widgets/or_divider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  static const String name = '/register';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Form(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 420.w, // keeps layout clean on tablets
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 24.h),

                  /// HEADER
                  Text(
                    l10n.welcome,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    l10n.pleaseCompleteYourProfile,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey,
                    ),
                  ),

                  SizedBox(height: 32.h),

                  /// FULL NAME
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      l10n.fullName,
                      style: TextStyle(fontSize: 16.sp),
                    ),
                  ),
                  SizedBox(height: 8.h),

                  TextFormField(
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      hintText: l10n.enterYourFullName,
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(12.w),
                        child: SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: SvgPicture.asset(
                            AssetPaths.profileLogo,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h),

                  /// DOB
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      l10n.dateOfBirth,
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      prefixIcon:
                      const Icon(Icons.calendar_today_outlined),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 14.h,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),

                  SizedBox(height: 24.h),

                  /// LANGUAGE
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      l10n.preferredLanguage,
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  ),
                  SizedBox(height: 12.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: _LanguageCard(
                          text: l10n.english,
                          isSelected: true,
                          theme: theme,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _LanguageCard(
                          text: l10n.somali,
                          isSelected: false,
                          theme: theme,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 32.h),

                  /// BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        l10n.completeRegistration,
                        style: TextStyle(fontSize: 16.sp),
                      ),
                    ),
                  ),

                  SizedBox(height: 28.h),

                  /// OR
                  const OrDivider(), // keep const if no ScreenUtil inside
                  SizedBox(height: 20.h),

                  /// LOGIN
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text.rich(
                      TextSpan(
                        text: "${l10n.alreadyHaveAnAccount} ",
                        style: TextStyle(fontSize: 14.sp),
                        children: [
                          TextSpan(
                            text: l10n.logIn,
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageCard extends StatelessWidget {
  final String text;
  final bool isSelected;
  final ThemeData theme;

  const _LanguageCard({
    required this.text,
    required this.isSelected,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected
            ? theme.primaryColor.withOpacity(0.08)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isSelected
              ? theme.primaryColor
              : Colors.grey.shade300,
          width: 1.5,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14.sp,
          color:
          isSelected ? theme.primaryColor : Colors.black87,
          fontWeight:
          isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }
}
