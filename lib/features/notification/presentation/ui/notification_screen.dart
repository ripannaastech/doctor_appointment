/* ---------------------------- NOTIFICATIONS ---------------------------- */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int tabIndex = 0;

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
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;

    final filtered =
    tabIndex == 0 ? items : items.where((e) => e.isUnread).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          /// ✅ Appointment-style AppBar (rounded)
          Container(
            height: statusBarHeight + 70.h,
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
                        icon: const Icon(Icons.arrow_back_ios,
                            color: Colors.white, size: 20),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Expanded(
                        child: Text(
                          'Notifications',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                      SizedBox(width: 48.w), // balance
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// ✅ Body like appointment (Stack + floating tabs)
          Expanded(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                /// List content pushed down
                Padding(
                  padding: EdgeInsets.only(top: 68.h),
                  child: ListView.separated(
                    padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
                    itemBuilder: (_, i) => _NotificationCard(item: filtered[i]),
                    separatorBuilder: (_, __) => SizedBox(height: 14.h),
                    itemCount: filtered.length,
                  ),
                ),

                /// Floating Tabs (same style as appointment)
                Positioned(
                  top: -28.h,
                  left: 20.w,
                  right: 20.w,
                  child: _notificationTabSwitcher(
                    allText: 'All(${items.length})',
                    unreadText:
                    'Unread(${items.where((e) => e.isUnread).length})',
                  ),
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
      child: Row(
        children: [
          _tabButton(allText, tabIndex == 0, () {
            setState(() => tabIndex = 0);
          }),
          _tabButton(unreadText, tabIndex == 1, () {
            setState(() => tabIndex = 1);
          }),
        ],
      ),
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
              fontSize: 15.sp,
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




class _NotificationCard extends StatefulWidget {
  final NotificationItem item;
  const _NotificationCard({required this.item});

  @override
  State<_NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<_NotificationCard> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final it = widget.item;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: it.details == null ? null : () => setState(() => expanded = !expanded),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TypeIcon(type: it.type),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                it.title,
                                style: const TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF141A2A),
                                ),
                              ),
                            ),
                            if (it.details != null)
                              Icon(
                                expanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                                color: const Color(0xFF9AA2B4),
                              ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          it.message,
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF7B8194),
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          it.timeAgo,
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFB0B6C6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (expanded && it.details != null) ...[
            const Divider(height: 1, color: Color(0xFFEEF0F6)),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: _DetailsCard(details: it.details!),
            ),
          ],
        ],
      ),
    );
  }
}

class _TypeIcon extends StatelessWidget {
  final NotificationType type;
  const _TypeIcon({required this.type});

  @override
  Widget build(BuildContext context) {
    late Color bg;
    late Color fg;
    late IconData icon;

    switch (type) {
      case NotificationType.appointmentConfirmed:
        bg = const Color(0xFFEAF1FF);
        fg = const Color(0xFF2F63F3);
        icon = Icons.calendar_month_rounded;
        break;
      case NotificationType.pharmacyNeeded:
        bg = const Color(0xFFFFF1E3);
        fg = const Color(0xFFFF8A1E);
        icon = Icons.local_pharmacy_rounded;
        break;
      case NotificationType.appointmentCancelled:
        bg = const Color(0xFFEAF1FF);
        fg = const Color(0xFF2F63F3);
        icon = Icons.calendar_month_rounded;
        break;
    }

    return Container(
      height: 44,
      width: 44,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: fg, size: 22),
    );
  }
}

class _DetailsCard extends StatelessWidget {
  final AppointmentDetails details;
  const _DetailsCard({required this.details});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F6FF),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Appointment Details',
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w800,
              color: Color(0xFF141A2A),
            ),
          ),
          const SizedBox(height: 10),

          if (details.doctor != null)
            _DetailRow(icon: Icons.person_rounded, text: details.doctor!),
          if (details.date != null) ...[
            const SizedBox(height: 8),
            _DetailRow(icon: Icons.calendar_today_rounded, text: details.date!),
          ],
          if (details.time != null) ...[
            const SizedBox(height: 8),
            _DetailRow(icon: Icons.access_time_rounded, text: details.time!),
          ],
          if (details.location != null) ...[
            const SizedBox(height: 8),
            _DetailRow(icon: Icons.location_on_rounded, text: details.location!),
          ],

          if (details.reason != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Text(
                    'Reason:  ',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF7B8194),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      details.reason!,
                      style: const TextStyle(
                        fontSize: 12.8,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF141A2A),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _DetailRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF7B8194)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF495067),
            ),
          ),
        ),
      ],
    );
  }
}

/* -------------------------------- MODELS ------------------------------- */

enum NotificationType { appointmentConfirmed, pharmacyNeeded, appointmentCancelled }

class NotificationItem {
  final NotificationType type;
  final String title;
  final String message;
  final String timeAgo;
  final bool isUnread;
  final AppointmentDetails? details;

  NotificationItem({
    required this.type,
    required this.title,
    required this.message,
    required this.timeAgo,
    required this.isUnread,
    this.details,
  });
}

class AppointmentDetails {
  final String? doctor;
  final String? date;
  final String? time;
  final String? location;
  final String? reason;

  AppointmentDetails({
    this.doctor,
    this.date,
    this.time,
    this.location,
    this.reason,
  });
}