import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../models/data/appoinment_model.dart';
import '../controller/booking_controller.dart';
import '../widgets/info_row_widget.dart';
//
// class MyAppointmentScreen extends StatefulWidget {
//   static const String name = '/myAppointment';
//
//   const MyAppointmentScreen({super.key});
//
//   @override
//   State<MyAppointmentScreen> createState() => _MyAppointmentScreenState();
// }
//
// class _MyAppointmentScreenState extends State<MyAppointmentScreen> {
//   bool isUpcoming = true;
//
//   @override
//   Widget build(BuildContext context) {
//     final double statusBarHeight = MediaQuery.of(context).padding.top;
//     final l10n = AppLocalizations.of(context)!;
//
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FA),
//       body: Column(
//         children: [
//           /// Custom AppBar
//           Container(
//             height: statusBarHeight + 90.h,
//             decoration: BoxDecoration(
//               color: const Color(0xFF3F6DE0),
//               borderRadius: BorderRadius.vertical(
//                 bottom: Radius.circular(24.r),
//               ),
//             ),
//             child: Column(
//               children: [
//                 SizedBox(height: statusBarHeight),
//                 SizedBox(
//                   height: 56.h,
//                   child: Row(
//                     children: [
//                       IconButton(
//                         icon: const Icon(
//                           Icons.arrow_back_ios,
//                           color: Colors.white,
//                           size: 20,
//                         ),
//                         onPressed: () => Navigator.of(context).pop(),
//                       ),
//                       Expanded(
//                         child: Text(
//                           l10n.myAppointment,
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontSize: 18.sp,
//                             color: Colors.white,
//                             fontWeight: FontWeight.w600,
//                             letterSpacing: 0.2,
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 48.w), // Balance the back button
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           /// Body with Tabs and Content
//           Expanded(
//             child: Stack(
//               clipBehavior: Clip.none,
//               children: [
//                 /// Main Content
//                 Padding(
//                   padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top+20.h),
//                   child: ListView(
//                     padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 0.h),
//                     children: isUpcoming
//                         ? _upcomingAppointments(l10n)
//                         : _pastAppointments(l10n),
//                   ),
//                 ),
//
//                 /// Floating Tabs
//                 Positioned(
//                   top: -28.h,
//                   left: 20.w,
//                   right: 20.w,
//                   child: _tabSwitcher(l10n),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _tabSwitcher(AppLocalizations l10n) {
//     return Container(
//       margin: EdgeInsets.only(top: 12.h),
//       padding: EdgeInsets.all(4.w),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 12,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           _tabButton(l10n.upcoming, isUpcoming, () {
//             setState(() => isUpcoming = true);
//           }),
//           _tabButton(l10n.past, !isUpcoming, () {
//             setState(() => isUpcoming = false);
//           }),
//         ],
//       ),
//     );
//   }
//
//   Widget _tabButton(String title, bool active, VoidCallback onTap) {
//     return Expanded(
//       child: GestureDetector(
//         onTap: onTap,
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 200),
//           height: 44.h,
//           decoration: BoxDecoration(
//             color: active ? const Color(0xFF3F6DE0) : Colors.transparent,
//             borderRadius: BorderRadius.circular(10.r),
//           ),
//           alignment: Alignment.center,
//           child: Text(
//             title,
//             style: TextStyle(
//               fontSize: 15.sp,
//               fontWeight: FontWeight.w600,
//               color: active ? Colors.white : const Color(0xFF6B7280),
//               letterSpacing: 0.2,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _appointmentCard({
//     required String name,
//     required String role,
//     required String date,
//     required String time,
//     required String location,
//     required String status,
//     required Color statusColor,
//     required AppLocalizations l10n,
//     bool showActions = true,
//   }) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 16.h),
//       padding: EdgeInsets.all(16.w),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.06),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       name,
//                       style: TextStyle(
//                         fontSize: 16.sp,
//                         fontWeight: FontWeight.w600,
//                         color: const Color(0xFF1F2937),
//                         letterSpacing: 0.1,
//                       ),
//                     ),
//                     SizedBox(height: 4.h),
//                     Text(
//                       role,
//                       style: TextStyle(
//                         fontSize: 14.sp,
//                         color: const Color(0xFF9CA3AF),
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(width: 12.w),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
//                 decoration: BoxDecoration(
//                   color: statusColor.withOpacity(0.12),
//                   borderRadius: BorderRadius.circular(20.r),
//                 ),
//                 child: Text(
//                   status,
//                   style: TextStyle(
//                     fontSize: 12.sp,
//                     color: statusColor,
//                     fontWeight: FontWeight.w600,
//                     letterSpacing: 0.2,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 16.h),
//           InfoRow(icon: Icons.calendar_today_outlined, text: date),
//           SizedBox(height: 8.h),
//           InfoRow(icon: Icons.access_time, text: time),
//           SizedBox(height: 8.h),
//           InfoRow(icon: Icons.location_on_outlined, text: location),
//           if (showActions) ...[
//             SizedBox(height: 16.h),
//             Row(
//               children: [
//                 Expanded(
//                   child: _actionButton(
//                     l10n.viewDetails,
//                     const Color(0xFFEFF4FF),
//                     const Color(0xFF3F6DE0),
//                   ),
//                 ),
//                 SizedBox(width: 12.w),
//                 Expanded(
//                   child: _actionButton(
//                     l10n.cancel,
//                     const Color(0xFFFEF2F2),
//                     const Color(0xFFEF4444),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ],
//       ),
//     );
//   }
//
//   List<Widget> _upcomingAppointments(AppLocalizations l10n) {
//     return [
//       _appointmentCard(
//         l10n: l10n,
//         name: l10n.doctor1Name,
//         role: l10n.doctor1Specialty,
//         date: 'Jan 2, 2026',
//         time: '10:00 AM To 11:00 AM',
//         location: 'Building A, Room 301',
//         status: l10n.confirmed,
//         statusColor: const Color(0xFF10B981),
//       ),
//       _appointmentCard(
//         l10n: l10n,
//         name: l10n.doctor2Name,
//         role: l10n.dermatologist,
//         date: 'Jan 5, 2026',
//         time: '10:00 AM To 11:00 AM',
//         location: 'Building B, Room 205',
//         status: l10n.confirmed,
//         statusColor: const Color(0xFF10B981),
//       ),
//       _appointmentCard(
//         l10n: l10n,
//         name: l10n.drHassanOmar,
//         role: l10n.pediatrician,
//         date: 'Jan 8, 2026',
//         time: '10:00 AM To 11:00 AM',
//         location: 'Building C, Room 102',
//         status: l10n.pending,
//         statusColor: const Color(0xFFF59E0B),
//       ),
//     ];
//   }
//
//   List<Widget> _pastAppointments(AppLocalizations l10n) {
//     return [
//       _appointmentCard(
//         l10n: l10n,
//         name: l10n.drAhmedHassan,
//         role: l10n.generalPhysician,
//         date: 'Dec 28, 2025',
//         time: '10:00 AM To 11:00 AM',
//         location: 'Building A, Room 101',
//         status: l10n.completed,
//         statusColor: const Color(0xFF6B7280),
//         showActions: false,
//       ),
//       _appointmentCard(
//         l10n: l10n,
//         name: l10n.drKhadijaYusuf,
//         role: l10n.dermatologist,
//         date: 'Dec 20, 2025',
//         time: '10:00 AM To 11:00 AM',
//         location: 'Building B, Room 202',
//         status: l10n.completed,
//         statusColor: const Color(0xFF6B7280),
//         showActions: false,
//       ),
//     ];
//   }
//
//   Widget _actionButton(String text, Color bg, Color fg) {
//     return Container(
//       height: 44.h,
//       alignment: Alignment.center,
//       decoration: BoxDecoration(
//         color: bg,
//         borderRadius: BorderRadius.circular(10.r),
//       ),
//       child: Text(
//         text,
//         style: TextStyle(
//           fontSize: 14.sp,
//           fontWeight: FontWeight.w600,
//           color: fg,
//           letterSpacing: 0.2,
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';



// If you already have InfoRow widget, keep using yours.
// Otherwise use this simple one:
class InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const InfoRow({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18.sp, color: const Color(0xFF6B7280)),
        10.horizontalSpace,
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13.sp,
              color: const Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class MyAppointmentScreen extends StatefulWidget {
  static const String name = '/myAppointment';
  const MyAppointmentScreen({super.key});

  @override
  State<MyAppointmentScreen> createState() => _MyAppointmentScreenState();
}

class _MyAppointmentScreenState extends State<MyAppointmentScreen> {
  bool isUpcoming = true;

  late final BookingController c;

  @override
  void initState() {
    super.initState();

    c = Get.isRegistered<BookingController>()
        ? Get.find<BookingController>()
        : Get.put(BookingController());

    c.fetchAllAppointments();
  }

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
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.r)),
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
                      SizedBox(width: 48.w),
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
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 20.h,
                  ),
                  child: Obx(() {
                    if (c.loadingAppointments.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (c.errorText.value.isNotEmpty) {
                      return Center(
                        child: Text(
                          c.errorText.value,
                          style: TextStyle(fontSize: 14.sp, color: Colors.black54),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }

                    final all = c.appointments.toList();

                    final upcoming = _filterUpcoming(all);
                    final past = _filterPast(all);

                    final list = isUpcoming ? upcoming : past;

                    if (list.isEmpty) {
                      return Center(
                        child: Text(
                          isUpcoming ? l10n.noUpcoming : l10n.noPast,
                          style: TextStyle(fontSize: 14.sp, color: Colors.black54),
                        ),
                      );
                    }

                    return ListView(
                      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 0.h),
                      children: list
                          .map((a) => _appointmentCard(
                        appointment: a,
                        l10n: l10n,
                        showActions: isUpcoming,
                      ))
                          .toList(),
                    );
                  }),
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

  // ----------------------------
  // Tabs
  // ----------------------------
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

  // ----------------------------
  // Card (ERPNext data)
  // ----------------------------
  Widget _appointmentCard({
    required AppointmentSummary appointment,
    required AppLocalizations l10n,
    required bool showActions,
  }) {
    final statusColor = _statusColor(appointment.status);

    final dateText = _formatDatePretty(appointment.appointmentDate);
    final timeText = _formatTimePretty(appointment.appointmentTime);
    final locationText = appointment.department.isNotEmpty
        ? appointment.department
        : l10n.department;

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.practitionerName,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F2937),
                        letterSpacing: 0.1,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      appointment.department,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: const Color(0xFF9CA3AF),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if ((appointment.notes ?? '').trim().isNotEmpty) ...[
                      8.verticalSpace,
                      Text(
                        appointment.notes!.trim(),
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: const Color(0xFF6B7280),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
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
                  appointment.status,
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
          InfoRow(icon: Icons.calendar_today_outlined, text: dateText),
          SizedBox(height: 8.h),
          InfoRow(icon: Icons.access_time, text: timeText),
          SizedBox(height: 8.h),
          InfoRow(icon: Icons.location_on_outlined, text: locationText),

          if (showActions) ...[
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: _actionButton(
                    l10n.viewDetails,
                    const Color(0xFFEFF4FF),
                    const Color(0xFF3F6DE0),
                    onTap: () => _showAppointmentDetailsDialog(appointment, l10n),

                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _actionButton(
                    l10n.cancel,
                    const Color(0xFFFEF2F2),
                    const Color(0xFFEF4444),
                    onTap: () async {
                      final ok = await _confirmCancel(l10n);
                      if (!ok) return;

                      final success = await c.cancelAppointment(appointment.name);
                      if (success) {
                        Get.snackbar('Success', l10n.appointmentCanceled);
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _actionButton(
      String text,
      Color bg,
      Color fg, {
        required VoidCallback onTap,
      }) {
    return InkWell(
      borderRadius: BorderRadius.circular(10.r),
      onTap: onTap,
      child: Container(
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
      ),
    );
  }


  void _showAppointmentDetailsDialog(
      AppointmentSummary a,
      AppLocalizations l10n,
      ) {
    final dateText = _formatDatePretty(a.appointmentDate);
    final timeText = _formatTimePretty(a.appointmentTime);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r),
        ),
        title: Text(
          l10n.appointmentDetails,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _dRow(l10n.appointmentId, a.name),
            10.verticalSpace,
            _dRow(l10n.patientName, a.patientName),
            10.verticalSpace,
            _dRow(l10n.doctor, a.practitionerName),
            10.verticalSpace,
            _dRow(l10n.department, a.department),
            10.verticalSpace,
            _dRow(l10n.date, dateText),
            10.verticalSpace,
            _dRow(l10n.time, timeText),
            10.verticalSpace,
            _dRow(l10n.status, a.status),
            10.verticalSpace,
            _dRow(l10n.appointmentType, a.appointmentType),
            10.verticalSpace,
            _dRow(l10n.billingItem, a.billingItem),
            if ((a.notes ?? '').trim().isNotEmpty) ...[
              10.verticalSpace,
              _dRow(l10n.notes, a.notes!.trim()),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  Widget _dRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110.w,
          child: Text(
            "$label:",
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF374151),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value.isEmpty ? "-" : value,
            style: TextStyle(
              fontSize: 13.sp,
              color: const Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  // ----------------------------
  // Filtering helpers
  // ----------------------------
  List<AppointmentSummary> _filterUpcoming(List<AppointmentSummary> all) {
    final now = DateTime.now();
    return all.where((a) {
      final dt = _parseAppointmentDateTime(a.appointmentDate, a.appointmentTime);
      if (dt == null) return false;
      return dt.isAfter(now) || _isSameMinute(dt, now);
    }).toList()
      ..sort((a, b) {
        final da = _parseAppointmentDateTime(a.appointmentDate, a.appointmentTime) ?? DateTime(1970);
        final db = _parseAppointmentDateTime(b.appointmentDate, b.appointmentTime) ?? DateTime(1970);
        return da.compareTo(db); // soonest first
      });
  }

  List<AppointmentSummary> _filterPast(List<AppointmentSummary> all) {
    final now = DateTime.now();
    return all.where((a) {
      final dt = _parseAppointmentDateTime(a.appointmentDate, a.appointmentTime);
      if (dt == null) return false;
      return dt.isBefore(now) && !_isSameMinute(dt, now);
    }).toList()
      ..sort((a, b) {
        final da = _parseAppointmentDateTime(a.appointmentDate, a.appointmentTime) ?? DateTime(1970);
        final db = _parseAppointmentDateTime(b.appointmentDate, b.appointmentTime) ?? DateTime(1970);
        return db.compareTo(da); // latest past first
      });
  }

  bool _isSameMinute(DateTime a, DateTime b) =>
      a.year == b.year &&
          a.month == b.month &&
          a.day == b.day &&
          a.hour == b.hour &&
          a.minute == b.minute;

  DateTime? _parseAppointmentDateTime(String date, String time) {
    try {
      // date: "2026-01-29", time: "11:00:00"
      final d = DateTime.parse(date);
      final parts = time.split(':');
      final h = int.tryParse(parts[0]) ?? 0;
      final m = int.tryParse(parts[1]) ?? 0;
      final s = parts.length > 2 ? (int.tryParse(parts[2]) ?? 0) : 0;
      return DateTime(d.year, d.month, d.day, h, m, s);
    } catch (_) {
      return null;
    }
  }

  // ----------------------------
  // Formatting helpers
  // ----------------------------
  String _formatDatePretty(String yyyyMmDd) {
    try {
      final dt = DateTime.parse(yyyyMmDd);
      return DateFormat('MMM d, yyyy').format(dt);
    } catch (_) {
      return yyyyMmDd;
    }
  }

  String _formatTimePretty(String hhmmss) {
    try {
      final parts = hhmmss.split(':');
      final h = int.tryParse(parts[0]) ?? 0;
      final m = int.tryParse(parts[1]) ?? 0;
      final dt = DateTime(2000, 1, 1, h, m);
      return DateFormat('h:mm a').format(dt);
    } catch (_) {
      return hhmmss;
    }
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'scheduled':
      case 'confirmed':
        return const Color(0xFF10B981);
      case 'pending':
        return const Color(0xFFF59E0B);
      case 'cancelled':
      case 'canceled':
        return const Color(0xFFEF4444);
      case 'completed':
        return const Color(0xFF6B7280);
      default:
        return const Color(0xFF6B7280);
    }
  }

  Future<bool> _confirmCancel(AppLocalizations l10n) async {
    return await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.cancelAppointmentTitle),
        content: Text(l10n.cancelAppointmentBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.no),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.yesCancel),
          ),
        ],
      ),
    ) ??
        false;
  }
}
