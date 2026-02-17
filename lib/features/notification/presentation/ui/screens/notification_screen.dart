import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../l10n/app_localizations.dart';
import '../../../data/models/appoinment_model.dart';
import '../../../data/models/notification_item_model.dart';
import '../../models/advertisement_item_model.dart';
import '../../models/feed_item.dart';
import '../controller/notification_controller.dart';


import '../widgets/details_card.dart';
import '../widgets/type_icon.dart';


class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});
  static const String name = '/notification';

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late final NotificationsController c;

  @override
  void initState() {
    super.initState();
    c = Get.isRegistered<NotificationsController>()
        ? Get.find<NotificationsController>()
        : Get.put(NotificationsController());
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          Container(
            height: statusBarHeight + 90.h,
            decoration: BoxDecoration(
              color: const Color(0xFF3F6DE0),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(24.r),
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: statusBarHeight),
                SizedBox(
                  height: 56.h,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Expanded(
                        child: Text(
                          l10n.notifications,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 48.w,
                        child: IconButton(
                          onPressed: () => c.fetchAll(),
                          icon: const Icon(Icons.refresh, color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 20.h,
                  ),
                  child: Obx(() {
                    if (c.loading.value && c.feedItems.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (c.errorText.value.isNotEmpty && c.feedItems.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Text(
                            c.errorText.value,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14.sp, color: const Color(0xFF6B7280)),
                          ),
                        ),
                      );
                    }

                    final filtered = c.filtered;

                    if (filtered.isEmpty) {
                      return Center(
                        child: Text(
                          'No notifications',
                          style: TextStyle(fontSize: 14.sp, color: const Color(0xFF6B7280)),
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
                      itemBuilder: (_, i) => FeedCard(item: filtered[i]),
                      separatorBuilder: (_, __) => SizedBox(height: 14.h),
                      itemCount: filtered.length,
                    );
                  }),
                ),

                Positioned(
                  top: -28.h,
                  left: 20.w,
                  right: 20.w,
                  child: Obx(() {
                    return _notificationTabSwitcher(
                      l10n: l10n,
                      allCount: c.feedItems.length,
                      unreadCount: c.unreadCount,
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _notificationTabSwitcher({
    required AppLocalizations l10n,
    required int allCount,
    required int unreadCount,
  }) {
    return Container(
      margin: EdgeInsets.only(top: 12.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Obx(() {
        return Row(
          children: [
            _tabButton('${l10n.all}($allCount)', c.tabIndex.value == 0, () {
              c.tabIndex.value = 0;
            }),
            _tabButton('${l10n.unread}($unreadCount)', c.tabIndex.value == 1, () {
              c.tabIndex.value = 1;
            }),
          ],
        );
      }),
    );
  }

  Widget _tabButton(String title, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 44.h,
          decoration: BoxDecoration(
            color: active ? const Color(0xFF3F6DE0) : Colors.transparent,
            borderRadius: BorderRadius.circular(10.r),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: active ? Colors.white : const Color(0xFF6B7280),
              letterSpacing: 0.2,
            ),
          ),
        ),
      ),
    );
  }
}

class FeedCard extends StatefulWidget {
  final FeedItem item;
  const FeedCard({super.key, required this.item});

  @override
  State<FeedCard> createState() => _FeedCardState();
}

class _FeedCardState extends State<FeedCard> {
  final RxBool expanded = false.obs;

  @override
  void dispose() {
    expanded.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<NotificationsController>();
    final f = widget.item;

    final bool isAd = f.type == FeedType.advertisement;
    final AdvertisementItem? ad = f.ad;

    final NotificationItem? notif = isAd ? null : f.notif;

    return Obx(() {
      final isExpanded = expanded.value;

      final AppointmentDetails? det = notif?.details;

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 18.r,
              offset: Offset(0, 10.h),
            ),
          ],
        ),
        child: Column(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(16.r),
              onTap: () {
                // ✅ Always clickable (marks read etc.)
                // c.onTapFeedItem(f);
                c.markAsRead(f);

                // ✅ Expand rules:
                // - Notifications expand only if details exist
                // - Ads always expand to show more info
                if (isAd) {
                  expanded.value = !expanded.value;
                } else {
                  if (det != null) expanded.value = !expanded.value;
                }
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 12.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _leadingIcon(isAd: isAd, notifType: notif?.type),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  f.title,
                                  style: TextStyle(
                                    fontSize: 14.5.sp,
                                    fontWeight: f.isUnread ? FontWeight.w700 : FontWeight.w500,
                                    color: const Color(0xFF141A2A),
                                  ),
                                ),
                              ),

                              // ✅ show arrow for both ad + expandable notification
                              if (isAd || det != null)
                                Icon(
                                  isExpanded
                                      ? Icons.keyboard_arrow_up_rounded
                                      : Icons.keyboard_arrow_down_rounded,
                                  size: 22.sp,
                                  color: const Color(0xFF9AA2B4),
                                ),
                            ],
                          ),

                          SizedBox(height: 6.h),

                          // short body line
                          Text(
                            f.body,
                            maxLines: isExpanded ? 3 : 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12.5.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF7B8194),
                              height: 1.25,
                            ),
                          ),

                          SizedBox(height: 8.h),

                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  isAd ? '' : (notif?.timeAgo ?? ''),
                                  style: TextStyle(
                                    fontSize: 11.5.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFFB0B6C6),
                                  ),
                                ),
                              ),
                              if (isAd) _badge('Ad'),
                              if (!isAd && f.isUnread) ...[
                                SizedBox(width: 10.w),
                                Container(
                                  width: 8.w,
                                  height: 8.w,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF3F6DE0),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ],
                          ),

                          // small image preview always visible for ads
                          if (isAd && (ad?.image ?? '').trim().isNotEmpty) ...[
                            SizedBox(height: 12.h),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: Image.network(
                                (ad!.image).trim(),
                                height: 120.h,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ✅ Expand section for Notification details
            if (!isAd && isExpanded && det != null) ...[
              const Divider(height: 1, color: Color(0xFFEEF0F6)),
              Padding(
                padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 14.h),
                child: DetailsCard(details: det),
              ),
            ],

            // ✅ Expand section for Advertisement details
            if (isAd && isExpanded && ad != null) ...[
              const Divider(height: 1, color: Color(0xFFEEF0F6)),
              Padding(
                padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 14.h),
                child: _adDetails(ad, c),
              ),
            ],
          ],
        ),
      );
    });
  }

  Widget _adDetails(AdvertisementItem ad, NotificationsController c) {
    String clean(String s) => s.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [


        Text(
          clean(ad.description).isEmpty ? 'No description' : ad.description,
          style: TextStyle(
            fontSize: 12.8.sp,
            color: const Color(0xFF475569),
            height: 1.3,
            fontWeight: FontWeight.w500,
          ),
        ),

        SizedBox(height: 14.h),

        // ✅ button to open link (better UX than auto-navigate)
        if (ad.clickable && clean(ad.linkUrl).isNotEmpty)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3F6DE0),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                padding: EdgeInsets.symmetric(vertical: 12.h),
              ),
              onPressed: () => Get.toNamed(clean(ad.linkUrl)),
              child: Text(
                'View Offer',
                style: TextStyle(fontSize: 13.5.sp, fontWeight: FontWeight.w700),
              ),
            ),
          ),
      ],
    );
  }

  Widget _infoRow(String k, String v) {
    return Row(
      children: [
        Text(
          '$k: ',
          style: TextStyle(
            fontSize: 12.sp,
            color: const Color(0xFF94A3B8),
            fontWeight: FontWeight.w700,
          ),
        ),
        Expanded(
          child: Text(
            v,
            style: TextStyle(
              fontSize: 12.sp,
              color: const Color(0xFF334155),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _leadingIcon({required bool isAd, dynamic notifType}) {
    if (isAd) {
      return Container(
        width: 42.w,
        height: 42.w,
        decoration: BoxDecoration(
          color: const Color(0xFFF2F6FF),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(Icons.campaign_outlined, size: 22.sp, color: const Color(0xFF3F6DE0)),
      );
    }
    return TypeIcon(type: notifType);
  }

  Widget _badge(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F6FF),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF3F6DE0),
        ),
      ),
    );
  }
}

