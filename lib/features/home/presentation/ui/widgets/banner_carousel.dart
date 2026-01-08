import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BannerCarousel extends StatelessWidget {
  const BannerCarousel({super.key});

  @override
  Widget build(BuildContext context) {
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
                  'https://images.unsplash.com/photo-1580281658628-86f84f6e7f1b',
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                left: 16.w,
                bottom: 16.h,
                child: Text(
                  'Expert Medical Care',
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
        color: active ? const Color(0xFF2F63F3) : const Color(0xFFD6DAE6),
        borderRadius: BorderRadius.circular(99.r),
      ),
    );
  }
}
