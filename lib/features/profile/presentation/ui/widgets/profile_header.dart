import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../l10n/app_localizations.dart';
import '../../../../../app/app_colors.dart';
import '../screens/profile_screen.dart';

class ProfileHeader extends StatelessWidget {
  final bool isEditing;
  final VoidCallback onToggle;

  const ProfileHeader({
    super.key,
    required this.isEditing,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: 32.h),
      decoration: BoxDecoration(
        color: AppColors.themeColor,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(32.r),
        ),
      ),
      child: Column(
        children: [
          // Status bar safe spacing (keep native)
          SizedBox(height: MediaQuery.of(context).padding.top),

          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 20.sp,
                ),
                onPressed: () {},
              ),
              Expanded(
                child: Text(
                  l10n.profile,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: 48.w),
            ],
          ),

          SizedBox(height: 16.h),

          Container(
            width: 80.r,
            height: 80.r,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 12.r,
                  offset: Offset(0, 4.h),
                ),
              ],
            ),
            child: Icon(
              Icons.person_outline,
              color: kPrimaryBlue,
              size: 40.sp,
            ),
          ),

          SizedBox(height: 16.h),

          Text(
            "Ahmed Hassan Mohamed",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),

          SizedBox(height: 6.h),

          Text(
            "ahmed.hassan@example.com",
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14.sp,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}
