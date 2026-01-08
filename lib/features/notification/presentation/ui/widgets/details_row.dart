import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const DetailRow({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18.sp, // responsive icon size
          color: const Color(0xFF7B8194),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF495067),
            ),
          ),
        ),
      ],
    );
  }
}
