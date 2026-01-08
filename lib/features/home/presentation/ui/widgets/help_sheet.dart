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
          begin: Alignment.centerLeft,   // ⬅️ 0%
          end: Alignment.centerRight,    // ➡️ 100%
          colors: [
            Color(0xFF266FEF), // #266FEF
            Color(0xFF1B4FAA), // #1B4FAA
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.22),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 44.r,
                height: 44.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.18),
                ),
                child: const Icon(
                  Icons.headphones_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              SizedBox(width: 14.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Need Help?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "We're here for you 24/7",
                    style: TextStyle(
                      fontSize: 13.5,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 18.h),
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
