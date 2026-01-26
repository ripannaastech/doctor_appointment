import 'dart:developer';

import 'package:doctor_appointment/features/appointment/presentation/ui/screens/confirm_appoinment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../models/data/practitioner_model.dart';
import '../controller/booking_controller.dart';

class SelectDateTimeScreen extends StatefulWidget {
  static const String name = '/SelectDateTimeScreen';

  final Practitioner doctor;

  const SelectDateTimeScreen({
    super.key,
    required this.doctor,

  });

  @override
  State<SelectDateTimeScreen> createState() => _SelectDateTimeScreenState();
}


class _SelectDateTimeScreenState extends State<SelectDateTimeScreen> {
  late final BookingController c;

  int selectedDate = 2;
  int selectedTime = -1;

  // example times
  final times = [
    '09:00 AM to 10:00 AM',
    '02:00 PM to 03:00 PM',
    '04:00 PM to 05:00 PM',
    '07:00 PM to 08:00 PM',
  ];




  @override
  void initState() {
    super.initState();
    c = Get.isRegistered<BookingController>()
        ? Get.find<BookingController>()
        : Get.put(BookingController());
  }




  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // ✅ Make real dates (today + next days) instead of hardcoded "8,9,10"
    final base = DateTime.now();
    final dateList = List.generate(5, (i) => base.add(Duration(days: i)));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(l10n),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            20.verticalSpace,

            _sectionTitle(l10n.selectDate),
            12.verticalSpace,

            Row(
              children: List.generate(dateList.length, (index) {
                final d = dateList[index];
                final isSelected = selectedDate == index;

                final day = d.day.toString();
                final label = _weekdayLabel(l10n, d.weekday);

                return Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: GestureDetector(
                    onTap: () => setState(() => selectedDate = index),
                    child: Container(
                      width: 56.w,
                      height: 64.h,
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF3F6DE0) : Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: isSelected ? Colors.transparent : const Color(0xFFE6E8EC),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            day,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                          4.verticalSpace,
                          Text(
                            label,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: isSelected ? Colors.white : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),

            24.verticalSpace,

            _sectionTitle(l10n.selectTimeSlot),
            12.verticalSpace,

            ...List.generate(times.length, (index) {
              final isSelected = selectedTime == index;
              return GestureDetector(
                onTap: () => setState(() => selectedTime = index),
                child: Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF3F6DE0) : const Color(0xFFE6E8EC),
                    ),
                  ),
                  child: Text(
                    times[index],
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
              );
            }),

            const Spacer(),

            /// ✅ Confirm Button (CALL API)
            Obx(() {
              final canPress = selectedTime != -1 && !c.bookingAppointment.value;

              return SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  onPressed: !canPress
                      ? null
                      : () async {
                    // ✅ date
                    final selectedD = dateList[selectedDate];
                    final appointmentDate =
                        '${selectedD.year.toString().padLeft(4, '0')}-'
                        '${selectedD.month.toString().padLeft(2, '0')}-'
                        '${selectedD.day.toString().padLeft(2, '0')}';

                    // ✅ time
                    final appointmentTime =
                    _extractStartTimeHHmmss(times[selectedTime]);

                    // ✅ get all from model (required params)
                    final practitionerName = widget.doctor.fullName;
                    final department = widget.doctor.department;
                    final feeAmount = widget.doctor.inpatientVisitCharge;

                    // ✅ validate fee
                    if (feeAmount! <= 0) {
                      Get.snackbar('Error', 'Fee amount missing');
                      return;
                    }

                    final ok = await c.bookAppointment(
                      practitioner: practitionerName!,
                      department: department!,
                      appointmentDate: appointmentDate,
                      appointmentTime: appointmentTime,
                      feeAmount: feeAmount,
                      notes: null,
                    );

                    if (ok) {
                      // ✅ navigate with required constructor (NO arguments)
                      Get.off(() => AppointmentConfirmedScreen(
                        doctor: practitionerName,
                        department: department,
                        date: appointmentDate,
                        time: appointmentTime,
                        fee: feeAmount,
                      ));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3F6DE0),
                    disabledBackgroundColor: const Color(0xFFDADDE2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: c.bookingAppointment.value
                      ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                      : Text(
                    l10n.confirmBooking,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            }),

            20.verticalSpace,
          ],
        ),
      ),
    );
  }

  String _weekdayLabel(AppLocalizations l10n, int weekday) {
    switch (weekday) {
      case DateTime.monday: return l10n.mon;
      case DateTime.tuesday: return l10n.tue;
      case DateTime.wednesday: return l10n.wed;
      case DateTime.thursday: return l10n.thu;
      case DateTime.friday: return l10n.fri;
      case DateTime.saturday: return l10n.sat;
      default: return l10n.sun;
    }
  }

  /// "09:00 AM to 10:00 AM" -> "09:00:00"
  String _extractStartTimeHHmmss(String slot) {
    final start = slot.split('to').first.trim(); // "09:00 AM"
    // parse hour/min + AM/PM
    final parts = start.split(' ');
    final hm = parts[0]; // "09:00"
    final ampm = parts.length > 1 ? parts[1].toUpperCase() : 'AM';

    final hmp = hm.split(':');
    int hour = int.tryParse(hmp[0]) ?? 0;
    final minute = int.tryParse(hmp[1]) ?? 0;

    if (ampm == 'PM' && hour != 12) hour += 12;
    if (ampm == 'AM' && hour == 12) hour = 0;

    final hh = hour.toString().padLeft(2, '0');
    final mm = minute.toString().padLeft(2, '0');
    return '$hh:$mm:00';
  }

  AppBar _appBar(AppLocalizations l10n) {
    return AppBar(
      backgroundColor: const Color(0xFF3F6DE0),
      elevation: 0,
      centerTitle: true,
      title: Text(
        l10n.bookAppointment,
        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: Colors.white),
      ),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.r)),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
    );
  }
}

