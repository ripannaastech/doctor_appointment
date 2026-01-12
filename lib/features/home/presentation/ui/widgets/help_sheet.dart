import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../l10n/app_localizations.dart';
import 'help_row.dart';

class HelpSheet extends StatelessWidget {
  const HelpSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                children: [
                  Text(
                    l10n.needHelp,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    l10n.wereHereForYou247,
                    style: TextStyle(
                      fontSize: 13.5.sp,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 18.h),
          HelpRow(Icons.call_rounded, l10n.callUs, '6677'),
          SizedBox(height: 10.h),
          HelpRow(Icons.chat_bubble_rounded, l10n.whatsApp, '+465857474774'),
          SizedBox(height: 10.h),
          HelpRow(Icons.email_rounded, l10n.email, 'info@alihsanhospital.so'),
        ],
      ),
    );
  }
}
