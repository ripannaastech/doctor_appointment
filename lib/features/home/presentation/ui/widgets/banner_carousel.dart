import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../app/app_colors.dart';
import '../controller/home_controller.dart';
import '../model/home_slider_model.dart';

class BannerCarousel extends StatefulWidget {
  const BannerCarousel({
    super.key,
    this.onTapSlider, // optional
  });

  final void Function(String linkUrl)? onTapSlider;

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  final PageController _controller = PageController();
  Timer? _timer;

  final RxInt _index = 0.obs;

  late final HomeController c;
  Worker? _slidersWorker;

  @override
  void initState() {
    super.initState();

    // ✅ Use your HomeController (where loadSliders() lives)
    c = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>()
        : Get.put(HomeController());

    // ✅ ensure sliders are loaded (only if not already)
    if (c.sliders.isEmpty && !c.sliderLoading.value) {
      c.loadSliders();
    }

    _startAutoPlay();

    // ✅ when sliders load, reset to first page safely
    _slidersWorker = ever<List<HomeSliderModel>>(c.sliders, (items) {
      if (!mounted) return;
      if (items.isEmpty) return;

      _index.value = 0;

      if (_controller.hasClients) {
        _controller.jumpToPage(0);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    _slidersWorker?.dispose();
    _index.close();
    super.dispose();
  }

  void _startAutoPlay() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted) return;

      final items = c.sliders;
      if (items.isEmpty) return;

      final next = (_index.value + 1) % items.length;
      _index.value = next;

      if (_controller.hasClients) {
        _controller.animateToPage(
          next,
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final items = c.sliders;
      final isLoading = c.sliderLoading.value;

      // Loading skeleton
      if (isLoading && items.isEmpty) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Container(
            height: 148.h,
            width: double.infinity,
            color: const Color(0xFFF0F2F7),
          ),
        );
      }

      // Empty state
      if (items.isEmpty) return const SizedBox.shrink();

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
                  final s = items[i];
                  final subtitle = (s.subtitle ?? '').trim();
                  final link = (s.linkUrl ?? '').trim();
                  final img = (s.image ?? '').trim();
                  final title = (s.title ?? '').trim();

                  return InkWell(
                    onTap: (link.isEmpty || widget.onTapSlider == null)
                        ? null
                        : () => widget.onTapSlider?.call(link),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          img,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: const Color(0xFFF0F2F7),
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              size: 28.sp,
                              color: Colors.black38,
                            ),
                          ),
                        ),

                        // overlay
                        Container(color: Colors.black.withOpacity(0.25)),

                        Positioned(
                          left: 16.w,
                          right: 16.w,
                          bottom: 16.h,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black45,
                                      blurRadius: 16.r,
                                    ),
                                  ],
                                ),
                              ),
                              if (subtitle.isNotEmpty) ...[
                                SizedBox(height: 4.h),
                                Text(
                                  subtitle,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white.withOpacity(0.95),
                                    shadows: [
                                      Shadow(
                                        color: Colors.black45,
                                        blurRadius: 16.r,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
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
    });
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
