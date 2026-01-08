import 'package:doctor_appointment/features/appointment/presentation/ui/screens/confirm_appoinment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectDateTimeScreen extends StatefulWidget {
  static const String name = '/SelectDateTimeScreen';

  const SelectDateTimeScreen({super.key});

  @override
  State<SelectDateTimeScreen> createState() => _SelectDateTimeScreenState();
}

class _SelectDateTimeScreenState extends State<SelectDateTimeScreen> {
  int selectedDate = 2;
  int selectedTime = -1;

  final dates = [
    {'day': '8', 'label': 'Sun'},
    {'day': '9', 'label': 'Mon'},
    {'day': '10', 'label': 'Tue'},
    {'day': '11', 'label': 'Wed'},
    {'day': '12', 'label': 'Thu'},
  ];

  final times = [
    '09:00 AM to 10:00 AM',
    '02:00 PM to 03:00 PM',
    '04:00 PM to 05:00 PM',
    '07:00 PM to 08:00 PM',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            20.verticalSpace,

            /// Select Date
            _sectionTitle('Select Date'),
            12.verticalSpace,

            Row(
              children: List.generate(dates.length, (index) {
                final isSelected = selectedDate == index;
                return Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: GestureDetector(
                    onTap: () => setState(() => selectedDate = index),
                    child: Container(
                      width: 56.w,
                      height: 64.h,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF3F6DE0)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: isSelected
                              ? Colors.transparent
                              : const Color(0xFFE6E8EC),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            dates[index]['day']!,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color:
                              isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                          4.verticalSpace,
                          Text(
                            dates[index]['label']!,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: isSelected
                                  ? Colors.white
                                  : Colors.grey,
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

            /// Time Slots
            _sectionTitle('Select Time Slot'),
            12.verticalSpace,

            ...List.generate(times.length, (index) {
              final isSelected = selectedTime == index;
              return GestureDetector(
                onTap: () => setState(() => selectedTime = index),
                child: Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF3F6DE0)
                          : const Color(0xFFE6E8EC),
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

            /// Confirm Button
            SizedBox(
              width: double.infinity,
              height: 52.h,
              child: ElevatedButton(
                onPressed: selectedTime == -1 ? null : () {
                  Navigator.pushNamed(context, AppointmentConfirmedScreen.name);

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3F6DE0),
                  disabledBackgroundColor: const Color(0xFFDADDE2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'Confirm Booking',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            20.verticalSpace,
          ],
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: const Color(0xFF3F6DE0),
      elevation: 0,
      centerTitle: true,
      title: Text(
        'Book Appointment',
        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600,color: Colors.white),
      ),
      leading: const Icon(Icons.arrow_back_ios, color: Colors.white),
      shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.vertical(bottom: Radius.circular(20.r)),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
