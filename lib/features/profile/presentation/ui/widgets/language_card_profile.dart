import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../l10n/app_localizations.dart';
import '../screens/profile_screen.dart';

class LanguageCard extends StatelessWidget {
  const LanguageCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kCardRadius.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.language, color: kTextDark, size: 20.sp),
                SizedBox(width: 8.w),
                Text(
                  l10n.language,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: kTextDark,
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            _LanguageOption(l10n.english, selected: true),

            SizedBox(height: 12.h),

            _LanguageOption(l10n.somali),
          ],
        ),
      ),
    );
  }
}
class _LanguageOption extends StatelessWidget {
  final String text;
  final bool selected;

  const _LanguageOption(this.text, {this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 14.h,
        horizontal: 16.w,
      ),
      decoration: BoxDecoration(
        color: selected
            ? kPrimaryBlue.withOpacity(0.08)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: selected ? kPrimaryBlue : Colors.grey.shade300,
          width: selected ? 2.w : 1.w,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight:
              selected ? FontWeight.w600 : FontWeight.w500,
              color: selected ? kPrimaryBlue : kTextDark,
            ),
          ),
          if (selected)
            Icon(
              Icons.check,
              color: kPrimaryBlue,
              size: 20.sp,
            ),
        ],
      ),
    );
  }
}


