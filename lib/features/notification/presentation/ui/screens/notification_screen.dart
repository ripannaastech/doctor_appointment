/* ---------------------------- NOTIFICATIONS ---------------------------- */
import 'package:doctor_appointment/features/notification/presentation/ui/widgets/notification_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../l10n/app_localizations.dart';
import '../../../data/models/notification_item_model.dart';
import '../controller/notification_controller.dart';

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
                      // keep same spacing, and add refresh on tap if you want
                      SizedBox(
                        width: 48.w,
                        child: IconButton(
                          onPressed: () => c.fetchNotifications(),
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
                /// List content pushed down
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 20.h,
                  ),
                  child: Obx(() {
                    // loading state (minimal, doesn’t change design)
                    if (c.loading.value && c.items.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // error state (minimal)
                    if (c.errorText.value.isNotEmpty && c.items.isEmpty) {
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

                    return ListView.separated(
                      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
                      itemBuilder: (_, i) => NotificationCard(item: filtered[i]),
                      separatorBuilder: (_, __) => SizedBox(height: 14.h),
                      itemCount: filtered.length,
                    );
                  }),
                ),

                /// Floating Tabs (same style as appointment)
                Positioned(
                  top: -28.h,
                  left: 20.w,
                  right: 20.w,
                  child: Obx(() {
                    return _notificationTabSwitcher(
                      l10n: l10n,
                      allCount: c.items.length,
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
