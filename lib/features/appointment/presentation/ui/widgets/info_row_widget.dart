import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InfoRow extends StatelessWidget {
  final String? title;        // for title–value row
  final String text;          // value or main text
  final IconData? icon;       // optional icon

  final double labelWidth;
  final double spacing;
  final double bottomPadding;

  final Color titleColor;
  final Color textColor;
  final Color iconColor;

  final FontWeight textWeight;
  final double lineHeight;

  const InfoRow({
    super.key,
    this.title,
    required this.text,
    this.icon,
    this.labelWidth = 90,
    this.spacing = 10,
    this.bottomPadding = 12,
    this.titleColor = Colors.grey,
    this.textColor = Colors.black,
    this.iconColor = const Color(0xFF9CA3AF),
    this.textWeight = FontWeight.w500,
    this.lineHeight = 1.4,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 ICON (if provided)
          if (icon != null) ...[
            Icon(
              icon,
              size: 16.sp,
              color: iconColor,
            ),
            SizedBox(width: spacing.w),
          ],

          // 🔹 TITLE (if provided)
          if (title != null) ...[
            SizedBox(
              width: labelWidth.w,
              child: Text(
                title!,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: titleColor,
                ),
              ),
            ),
          ],

          // 🔹 VALUE / TEXT
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: textWeight,
                color: textColor,
                height: lineHeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
