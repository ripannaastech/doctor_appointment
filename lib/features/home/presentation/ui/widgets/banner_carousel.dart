import 'dart:async';

import 'package:doctor_appointment/app/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../l10n/app_localizations.dart';
import '../../../../../app/asset_paths.dart';

// Example model for banner items
class BannerItem {
  final String imageUrl;
  final String title;
  const BannerItem({required this.imageUrl, required this.title});
}

class BannerCarousel extends StatefulWidget {
  const BannerCarousel({super.key});

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  final PageController _controller = PageController();
  Timer? _timer;


  final RxInt _index = 0.obs;

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    _index.close();
    super.dispose();
  }

  void _startAutoPlay() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted) return;

      final items = _banners(context);
      if (items.isEmpty) return;

      final next = (_index.value + 1) % items.length;


      _index.value = next;

      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    });
  }

  List<BannerItem> _banners(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      BannerItem(
        imageUrl: AssetPaths.slider1,
        title: l10n.healthBannerText,
      ),
      BannerItem(
        imageUrl: AssetPaths.slider2,
        title: l10n.healthBannerText, // change to your key
      ),
      BannerItem(
        imageUrl: AssetPaths.slider3,
        title: l10n.healthBannerText, // change to your key
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final items = _banners(context);

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: SizedBox(
            height: 148.h,
            width: double.infinity,
            child: PageView.builder(
              controller: _controller,
              itemCount: items.length,
              onPageChanged: (i) => _index.value = i,
              itemBuilder: (_, i) {
                final b = items[i];
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(b.imageUrl, fit: BoxFit.cover),
                    Container(color: Colors.black.withOpacity(0.18)),
                    Positioned(
                      left: 16.w,
                      right: 16.w,
                      bottom: 16.h,
                      child: Text(
                        b.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
                );
              },
            ),
          ),
        ),
        SizedBox(height: 12.h),


        Obx(() {
          final current = _index.value;
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(items.length, (i) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: _Dot(active: i == current),
              );
            }),
          );
        }),
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
      width: active ? 22.w : 6.w,
      decoration: BoxDecoration(
        color: active ? AppColors.themeColor : const Color(0xFFD6DAE6),
        borderRadius: BorderRadius.circular(99.r),
      ),
    );
  }
}
