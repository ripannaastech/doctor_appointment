import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../l10n/app_localizations.dart';
import '../widgets/info_row_widget.dart';

class MyAppointmentScreen extends StatefulWidget {
  static const String name = '/myAppointment';

  const MyAppointmentScreen({super.key});

  @override
  State<MyAppointmentScreen> createState() => _MyAppointmentScreenState();
}

class _MyAppointmentScreenState extends State<MyAppointmentScreen> {
  bool isUpcoming = true;

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          /// Custom AppBar
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
                          l10n.myAppointment,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                      SizedBox(width: 48.w), // Balance the back button
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// Body with Tabs and Content
          Expanded(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                /// Main Content
                Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top+20.h),
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 0.h),
                    children: isUpcoming
                        ? _upcomingAppointments(l10n)
                        : _pastAppointments(l10n),
                  ),
                ),

                /// Floating Tabs
                Positioned(
                  top: -28.h,
                  left: 20.w,
                  right: 20.w,
                  child: _tabSwitcher(l10n),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabSwitcher(AppLocalizations l10n) {
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
          _tabButton(l10n.upcoming, isUpcoming, () {
            setState(() => isUpcoming = true);
          }),
          _tabButton(l10n.past, !isUpcoming, () {
            setState(() => isUpcoming = false);
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

  Widget _appointmentCard({
    required String name,
    required String role,
    required String date,
    required String time,
    required String location,
    required String status,
    required Color statusColor,
    required AppLocalizations l10n,
    bool showActions = true,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F2937),
                        letterSpacing: 0.1,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      role,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: const Color(0xFF9CA3AF),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          InfoRow(icon: Icons.calendar_today_outlined, text: date),
          SizedBox(height: 8.h),
          InfoRow(icon: Icons.access_time, text: time),
          SizedBox(height: 8.h),
          InfoRow(icon: Icons.location_on_outlined, text: location),
          if (showActions) ...[
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: _actionButton(
                    l10n.viewDetails,
                    const Color(0xFFEFF4FF),
                    const Color(0xFF3F6DE0),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _actionButton(
                    l10n.cancel,
                    const Color(0xFFFEF2F2),
                    const Color(0xFFEF4444),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  List<Widget> _upcomingAppointments(AppLocalizations l10n) {
    return [
      _appointmentCard(
        l10n: l10n,
        name: l10n.doctor1Name,
        role: l10n.doctor1Specialty,
        date: 'Jan 2, 2026',
        time: '10:00 AM To 11:00 AM',
        location: 'Building A, Room 301',
        status: l10n.confirmed,
        statusColor: const Color(0xFF10B981),
      ),
      _appointmentCard(
        l10n: l10n,
        name: l10n.doctor2Name,
        role: l10n.dermatologist,
        date: 'Jan 5, 2026',
        time: '10:00 AM To 11:00 AM',
        location: 'Building B, Room 205',
        status: l10n.confirmed,
        statusColor: const Color(0xFF10B981),
      ),
      _appointmentCard(
        l10n: l10n,
        name: l10n.drHassanOmar,
        role: l10n.pediatrician,
        date: 'Jan 8, 2026',
        time: '10:00 AM To 11:00 AM',
        location: 'Building C, Room 102',
        status: l10n.pending,
        statusColor: const Color(0xFFF59E0B),
      ),
    ];
  }

  List<Widget> _pastAppointments(AppLocalizations l10n) {
    return [
      _appointmentCard(
        l10n: l10n,
        name: l10n.drAhmedHassan,
        role: l10n.generalPhysician,
        date: 'Dec 28, 2025',
        time: '10:00 AM To 11:00 AM',
        location: 'Building A, Room 101',
        status: l10n.completed,
        statusColor: const Color(0xFF6B7280),
        showActions: false,
      ),
      _appointmentCard(
        l10n: l10n,
        name: l10n.drKhadijaYusuf,
        role: l10n.dermatologist,
        date: 'Dec 20, 2025',
        time: '10:00 AM To 11:00 AM',
        location: 'Building B, Room 202',
        status: l10n.completed,
        statusColor: const Color(0xFF6B7280),
        showActions: false,
      ),
    ];
  }

  Widget _actionButton(String text, Color bg, Color fg) {
    return Container(
      height: 44.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: fg,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
