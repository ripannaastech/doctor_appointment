import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'help_row.dart';

class HelpSheet extends StatelessWidget {
  const HelpSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3367FF), Color(0xFF1E44C6)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.22),
            blurRadius: 28.r,
            offset: Offset(0, 14.h),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const HelpRow(Icons.call_rounded, 'Call Us', '6677'),
          SizedBox(height: 10.h),
          const HelpRow(Icons.chat_bubble_rounded, 'WhatsApp', '+465857474774'),
          SizedBox(height: 10.h),
          const HelpRow(Icons.email_rounded, 'Email', 'info@alihsanhospital.so'),
        ],
      ),
    );
  }
}
