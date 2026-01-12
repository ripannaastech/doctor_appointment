import 'package:doctor_appointment/app/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../l10n/app_localizations.dart';

class BannerCarousel extends StatelessWidget {
  const BannerCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Stack(
            children: [
              SizedBox(
                height: 148.h,
                width: double.infinity,
                child: Image.network(
                  'https://static.vecteezy.com/system/resources/thumbnails/026/375/249/small/ai-generative-portrait-of-confident-male-doctor-in-white-coat-and-stethoscope-standing-with-arms-crossed-and-looking-at-camera-photo.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                left: 16.w,
                bottom: 16.h,
                child: Text(
                  l10n.expertMedicalCare,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black45,
                        blurRadius: 16.r,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const _Dot(active: false),
            SizedBox(width: 6.w),
            const _Dot(active: true),
            SizedBox(width: 6.w),
            const _Dot(active: false),
          ],
        ),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  final bool active;
  const _Dot({required this.active});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 6.h,
      width: (active ? 22.w : 6.w),
      decoration: BoxDecoration(
        color: active ? AppColors.themeColor : const Color(0xFFD6DAE6),
        borderRadius: BorderRadius.circular(99.r),
      ),
    );
  }
}
