import 'dart:developer';

import 'package:doctor_appointment/features/appointment/presentation/ui/screens/confirm_appoinment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../app/app_snackbar.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../models/data/doctor_slot_model.dart';
import '../../../models/data/practitioner_model.dart';
import '../controller/booking_controller.dart';

enum PaymentMethod { cash, online }

class PaymentSelection {
  final PaymentMethod method;
  final String? phoneNumber;

  const PaymentSelection({required this.method, this.phoneNumber});
}

class SelectDateTimeScreen extends StatefulWidget {
  static const String name = '/SelectDateTimeScreen';

  final Practitioner doctor;

  const SelectDateTimeScreen({super.key, required this.doctor});

  @override
  State<SelectDateTimeScreen> createState() => _SelectDateTimeScreenState();
}

class _SelectDateTimeScreenState extends State<SelectDateTimeScreen> {
  late final BookingController c;

  final RxInt selectedDate = 0.obs; // TODAY
  final RxInt selectedTime = (-1).obs;
  final RxList<DoctorSlot> times = <DoctorSlot>[].obs;

  @override
  void initState() {
    super.initState();

    c = Get.isRegistered<BookingController>()
        ? Get.find<BookingController>()
        : Get.put(BookingController());

    // initial load for selectedDate default
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadForSelectedDate(selectedDate.value);
    });

    ever<int>(selectedDate, (idx) {
      selectedTime.value = -1;
      _loadForSelectedDate(idx);
    });
  }

  Future<void> _loadForSelectedDate(int idx) async {
    final practitionerName = (widget.doctor.fullName ?? '').trim();
    if (practitionerName.isEmpty) return;

    final base = DateTime.now();
    final dateList = List.generate(5, (i) => base.add(Duration(days: i)));

    if (idx < 0 || idx >= dateList.length) return;

    final d = dateList[idx];
    final dateKey =
        '${d.year.toString().padLeft(4, '0')}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';

    // fetch availability + booked
    await c.fetchDoctorAvailability(practitionerName: practitionerName, date: dateKey);
    await c.fetchDoctorBookedAppointments(practitionerName: practitionerName);

    times.assignAll(c.availabilitySlotsByDate[dateKey] ?? <DoctorSlot>[]);
  }

  bool _isSameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _isPastTimeSlot({
    required DateTime selectedDay,
    required String slotHHmmss,
  }) {
    // only disable past slots for today
    final now = DateTime.now();
    if (!_isSameDate(selectedDay, now)) return false;

    final parts = slotHHmmss.split(':');
    final h = int.tryParse(parts[0]) ?? 0;
    final m = int.tryParse(parts[1]) ?? 0;

    final slotTime = DateTime(now.year, now.month, now.day, h, m);
    return slotTime.isBefore(now); // if already passed, disable
  }


  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final base = DateTime.now();
    final dateList = List.generate(5, (i) => base.add(Duration(days: i)));

    final screenW = MediaQuery.of(context).size.width;
    final itemWidth = (screenW - (20.w * 2) - 12.w) / 2;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(l10n),


      bottomNavigationBar: Obx(() {
        final canPress =
            selectedTime.value != -1 && !c.loading.value;

        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
            child: SizedBox(
              width: double.infinity,
              height: 52.h,
              child: ElevatedButton(
                onPressed: !canPress
                    ? null
                    : () async {
                        if (c.loading.value) return;

                        try {
                          final sd = selectedDate.value;
                          final st = selectedTime.value;

                          if (sd < 0 || sd >= dateList.length) {
                            AppSnackbar.error(
                              l10n.error,
                              l10n.somethingWentWrong,
                            );
                            return;
                          }
                          if (st < 0 || st >= times.length) {
                            AppSnackbar.error(
                              l10n.error,
                              l10n.somethingWentWrong,
                            );
                            return;
                          }

                          final selectedD = dateList[sd];

                          final appointmentDate =
                              '${selectedD.year.toString().padLeft(4, '0')}-'
                              '${selectedD.month.toString().padLeft(2, '0')}-'
                              '${selectedD.day.toString().padLeft(2, '0')}';

                          final appointmentTime = _normalizeHHmmss(times[st].time);


                          final practitionerName =
                              (widget.doctor.fullName ?? '').trim();
                          final department = (widget.doctor.department ?? '')
                              .trim();
                          final feeAmount =
                              (widget.doctor.inpatientVisitCharge ?? 0);

                          if (practitionerName.isEmpty || department.isEmpty) {
                            AppSnackbar.error(
                              l10n.error,
                              l10n.doctorInfoMissing,
                            );
                            return;
                          }

                          if (feeAmount <= 0) {
                            AppSnackbar.error(
                              l10n.error,
                              l10n.feeAmountMissing,
                            );
                            return;
                          }

                          final selection = await _showPaymentDialog(
                            l10n,
                            feeAmount: feeAmount,
                          );
                          if (selection == null) return;

                          final appointmentId = await c.bookAppointment(
                            practitioner: practitionerName,
                            department: department,
                            appointmentDate: appointmentDate,
                            appointmentTime: appointmentTime,
                            feeAmount: feeAmount,
                            notes: null,
                          );

                          if (appointmentId == null || appointmentId.isEmpty) {
                            AppSnackbar.error(l10n.error, l10n.bookingFailed);
                            return;
                          }

                          final paymentOk = await c.payAppointment(
                            appointmentId: appointmentId,
                            paymentMethod: selection.method == PaymentMethod.cash ? 'cash' : 'online',
                            phoneNumber: selection.method == PaymentMethod.online
                                ? selection.phoneNumber
                                : null,
                          );

                          if (!paymentOk) return;

                          if (!context.mounted) return;

                          Navigator.pushReplacementNamed(
                            context,
                            AppointmentConfirmedScreen.name,
                            arguments: {
                              'doctor': practitionerName,
                              'department': department,
                              'date': appointmentDate,
                              'time': appointmentTime,
                              'fee': feeAmount,
                            },
                          );

                        } catch (e) {
                          AppSnackbar.error(
                            l10n.error,
                            '${l10n.somethingWentWrong}: $e',
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3F6DE0),
                  disabledBackgroundColor: const Color(0xFFDADDE2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: c.loading.value
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
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
            ),
          ),
        );
      }),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            20.verticalSpace,

            /// DATE TITLE
            _sectionTitle(l10n.selectDate),
            12.verticalSpace,

            /// DATE ROW (FIXED)
            Obx(() {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: List.generate(dateList.length, (index) {
                    final d = dateList[index];
                    final isSelected = selectedDate.value == index;

                    return Padding(
                      padding: EdgeInsets.only(right: 10.w),
                      child: GestureDetector(
                        onTap: () {
                          selectedDate.value = index;
                          selectedTime.value = -1;
                        },
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
                                d.day.toString(),
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected ? Colors.white : Colors.black,
                                ),
                              ),
                              4.verticalSpace,
                              Text(
                                _weekdayLabel(l10n, d.weekday),
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
              );
            }),

            24.verticalSpace,

            /// TIME SLOT TITLE
            _sectionTitle(l10n.selectTimeSlot),
            12.verticalSpace,


            Expanded(
              child: Obx(() {

                final sd = selectedDate.value < 0 ? 0 : selectedDate.value;
                final d = dateList[sd];

                final selectedDateKey =
                    '${d.year.toString().padLeft(4, '0')}-'
                    '${d.month.toString().padLeft(2, '0')}-'
                    '${d.day.toString().padLeft(2, '0')}';


                final booked =
                    c.bookedSlotsByDate[selectedDateKey] ?? <String>{};

                return SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: Wrap(
                    spacing: 12.w,
                    runSpacing: 12.h,
                    children: List.generate(times.length, (index) {
                    final isSelected = selectedTime.value == index;

                    final slot = times[index];
                    final slotStart = _normalizeHHmmss(slot.time);

                    final isBooked = booked.contains(slotStart);
                    final apiNotAvailable = !slot.available || slot.disabled;

                    final isPast = _isPastTimeSlot(
                      selectedDay: d,
                      slotHHmmss: slotStart,
                    );

                    final isDisabled = isBooked || apiNotAvailable || isPast;

                    final label = slot.displayTime.isNotEmpty ? slot.displayTime : slotStart;

                    return GestureDetector(
                      onTap: isDisabled ? null : () => selectedTime.value = index,
                      child: Opacity(
                        opacity: isDisabled ? 0.45 : 1,
                        child: Container(
                          width: itemWidth,
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                          decoration: BoxDecoration(
                            color: isDisabled
                                ? const Color(0xFFF3F4F6)
                                : (isSelected ? const Color(0xFF3F6DE0) : Colors.white),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: isDisabled
                                  ? const Color(0xFFE5E7EB)
                                  : (isSelected ? Colors.transparent : const Color(0xFFE6E8EC)),
                            ),
                          ),
                          child: Text(
                            isBooked
                                ? '$label (Booked)'
                                : isPast
                                ? '$label (Passed)'
                                : (apiNotAvailable && (slot.reason?.isNotEmpty ?? false)
                                ? '$label (${slot.reason})'
                                : label),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12.5.sp,
                              fontWeight: FontWeight.w600,
                              color: isDisabled
                                  ? const Color(0xFF9CA3AF)
                                  : (isSelected ? Colors.white : Colors.black),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),


                ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  String _weekdayLabel(AppLocalizations l10n, int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return l10n.mon;
      case DateTime.tuesday:
        return l10n.tue;
      case DateTime.wednesday:
        return l10n.wed;
      case DateTime.thursday:
        return l10n.thu;
      case DateTime.friday:
        return l10n.fri;
      case DateTime.saturday:
        return l10n.sat;
      default:
        return l10n.sun;
    }
  }

  Future<PaymentSelection?> _showPaymentDialog(
    AppLocalizations l10n, {
    required double feeAmount,
    String currency = '\$',
  }) {
    return showDialog<PaymentSelection>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          contentPadding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 16.h),
          titlePadding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),

          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: const Color(0xFF3F6DE0).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: const Icon(
                  Icons.payments_outlined,
                  color: Color(0xFF3F6DE0),
                ),
              ),
              12.verticalSpace,
              Text(
                l10n.selectPaymentMethod,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
              ),
              6.verticalSpace,
              Text(
                '${l10n.feeAmount}: $currency${feeAmount.toStringAsFixed(2)}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF3F6DE0),
                ),
              ),
            ],
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              12.verticalSpace,
              Text(
                l10n.choosePaymentMethodDesc,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
              ),
              16.verticalSpace,

              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF3F6DE0).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: const Color(0xFF3F6DE0).withOpacity(0.12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.receipt_long_outlined,
                      color: Color(0xFF3F6DE0),
                    ),
                    8.horizontalSpace,
                    Text(
                      '${l10n.totalPayable}: $currency${feeAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF141A2A),
                      ),
                    ),
                  ],
                ),
              ),


              12.verticalSpace,
              _paymentOptionTile(
                title: l10n.onlinePayment,
                subtitle: l10n.onlinePaymentDesc,
                icon: Icons.credit_card_outlined,
                onTap: () async {
                  final evc = await _showEvcDialog(l10n);
                  if (!mounted) return;

                  if (evc == null) return;

                  Navigator.pop(
                    ctx,
                    PaymentSelection(
                      method: PaymentMethod.online,
                      phoneNumber: evc, // ← direct string
                    ),
                  );
                },
              ),


            ],
          ),

          actionsPadding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 14.h),
          actions: [
            SizedBox(
              width: double.infinity,
              height: 46.h,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(ctx, null),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFE6E8EC)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  l10n.cancel,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<String?> _showEvcDialog(AppLocalizations l10n) {
    final phoneCtrl = TextEditingController();

    return showDialog<String?>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          contentPadding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 16.h),
          titlePadding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),

          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: const Color(0xFF3F6DE0).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: const Icon(Icons.phone_iphone, color: Color(0xFF3F6DE0)),
              ),
              12.verticalSpace,
              Text(
                l10n.onlinePayment,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
              ),
              6.verticalSpace,
              Text(
                l10n.enterPhoneAndPin,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade600),
              ),
            ],
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              16.verticalSpace,
              TextField(
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: l10n.phoneNumber,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ],
          ),

          actionsPadding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 14.h),
          actions: [
            SizedBox(
              width: double.infinity,
              height: 46.h,
              child: ElevatedButton(
                onPressed: () {
                  final phone = phoneCtrl.text.trim();

                  if (phone.isEmpty) {
                    AppSnackbar.error(l10n.error, l10n.pleaseFillAllFields);
                    return;
                  }

                  Navigator.pop(ctx, phone);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3F6DE0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  l10n.confirm,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            10.verticalSpace,
            SizedBox(
              width: double.infinity,
              height: 46.h,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(ctx, null),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFE6E8EC)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  l10n.cancel,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    ).then((result) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        phoneCtrl.dispose();
      });
      return result;
    });
  }

  Widget _paymentOptionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: const Color(0xFFE6E8EC)),
        ),
        child: Row(
          children: [
            Container(
              width: 42.w,
              height: 42.w,
              decoration: BoxDecoration(
                color: const Color(0xFF3F6DE0).withOpacity(0.10),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: const Color(0xFF3F6DE0)),
            ),
            12.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  4.verticalSpace,
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFFB8BCC8)),
          ],
        ),
      ),
    );
  }

  /// "09:00 AM to 10:00 AM" -> "09:00:00"
  String _normalizeHHmmss(String t) {
    // handles "8:00:00" -> "08:00:00"
    final parts = t.split(':');
    if (parts.length < 2) return t;
    final h = (int.tryParse(parts[0]) ?? 0).toString().padLeft(2, '0');
    final m = (int.tryParse(parts[1]) ?? 0).toString().padLeft(2, '0');
    final s = (parts.length > 2 ? (int.tryParse(parts[2]) ?? 0).toString().padLeft(2, '0') : '00');
    return '$h:$m:$s';
  }

  AppBar _appBar(AppLocalizations l10n) {
    return AppBar(
      backgroundColor: const Color(0xFF3F6DE0),
      elevation: 0,
      centerTitle: true,
      title: Text(
        l10n.bookAppointment,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
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
