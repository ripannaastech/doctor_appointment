/* ---------------------------- NOTIFICATIONS ---------------------------- */
import 'package:doctor_appointment/features/notification/presentation/ui/widgets/notification_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../data/models/appoinment_model.dart';
import '../../data/models/notification_item_model.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});
  static const String name = '/notification';

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {

  final RxInt tabIndex = 0.obs;

  // replace with your real list
  final items = <NotificationItem>[
    NotificationItem(
      type: NotificationType.appointmentConfirmed,
      title: 'Appointment Confirmed',
      message: 'Your appointment with Dr. Fatima Ahmed on Jan 5 has been confirmed',
      timeAgo: '1 days ago',
      isUnread: true,
      details: AppointmentDetails(
        doctor: 'Dr. Fatima Ahmed',
        date: 'Jan 5, 2026',
        time: '2:30 PM',
        location: 'Building B, Room 205',
      ),
    ),
    NotificationItem(
      type: NotificationType.pharmacyNeeded,
      title: 'Pharmacy Needed',
      message: 'Your Lisinopril prescription has 2 refills remaining',
      timeAgo: '1 day ago',
      isUnread: false,
    ),
    NotificationItem(
      type: NotificationType.appointmentCancelled,
      title: 'Appointment Cancelled',
      message: 'Your appointment scheduled for Dec 30 has been cancelled by the doctor',
      timeAgo: '1 week ago',
      isUnread: true,
      details: AppointmentDetails(
        doctor: 'Dr. Ahmed Hassan',
        date: 'Dec 30, 2025',
        reason: 'Doctor unavailable',
      ),
    ),
  ];

  @override
  void dispose() {
    tabIndex.close();
    super.dispose();
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
                      SizedBox(width: 48.w),
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
                    final filtered = tabIndex.value == 0
                        ? items
                        : items.where((e) => e.isUnread).toList();

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
                    final unreadCount = items.where((e) => e.isUnread).length;

                    return _notificationTabSwitcher(
                      allText: '${l10n.all}(${items.length})',
                      unreadText: '${l10n.unread}($unreadCount)',
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
    required String allText,
    required String unreadText,
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
            _tabButton(allText, tabIndex.value == 0, () {
              tabIndex.value = 0;
            }),
            _tabButton(unreadText, tabIndex.value == 1, () {
              tabIndex.value = 1;
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
