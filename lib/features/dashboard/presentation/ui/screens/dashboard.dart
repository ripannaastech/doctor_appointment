import 'package:doctor_appointment/app/app_colors.dart';
import 'package:doctor_appointment/features/appointment/presentation/ui/screens/my_appoinment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../appointment/presentation/ui/screens/book_appoinment.dart';
import '../../../../home/presentation/ui/screens/home_screen.dart';
import '../../../../profile/presentation/ui/screens/profile_screen.dart';

class MainScreen extends StatefulWidget {
  static const String name = '/mainScreen';

  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    MyAppointmentScreen(),
    HomeScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: _bottomNavBar(),
    );
  }

  Widget _bottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFF3F6DE0),
      unselectedItemColor: const Color(0xFFB8BCC8),
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      items: [
        _bottomNavItem(
          icon: Icons.home_outlined,
          label: 'Home',
          index: 0,
        ),
        _bottomNavItem(
          icon: Icons.calendar_month,
          label: 'Appointment',
          index: 1,
        ),
        _bottomNavItem(
          icon: Icons.medication_outlined,
          label: 'Pharmacy',
          index: 2,
        ),
        _bottomNavItem(
          icon: Icons.person_outline,
          label: 'Profile',
          index: 3,
        ),
      ],
    );
  }

  BottomNavigationBarItem _bottomNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool isSelected = _currentIndex == index;

    return BottomNavigationBarItem(
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 4.h,
            width: 32.w,
            decoration: BoxDecoration(
              color: isSelected
                  ?  AppColors.themeColor
                  : Colors.transparent,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(2.r),
                bottomRight: Radius.circular(2.r),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Icon(icon, size: 26.sp),
          SizedBox(height: 4.h),
        ],
      ),
      label: label,
    );
  }

}
