import 'package:doctor_appointment/features/notification/presentation/ui/widgets/type_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../data/models/notification_item_model.dart';
import 'details_card.dart';

class NotificationCard extends StatefulWidget {
  final NotificationItem item;
  const NotificationCard({super.key, required this.item});

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {

  final RxBool expanded = false.obs;

  @override
  void dispose() {
    expanded.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final it = widget.item;

    return Obx(() {
      final isExpanded = expanded.value;

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 18.r,
              offset: Offset(0, 10.h),
            ),
          ],
        ),
        child: Column(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(16.r),
              onTap: it.details == null
                  ? null
                  : () => expanded.value = !expanded.value,
              child: Padding(
                padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 12.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TypeIcon(type: it.type),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  it.title,
                                  style: TextStyle(
                                    fontSize: 14.5.sp,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF141A2A),
                                  ),
                                ),
                              ),
                              if (it.details != null)
                                Icon(
                                  isExpanded
                                      ? Icons.keyboard_arrow_up_rounded
                                      : Icons.keyboard_arrow_down_rounded,
                                  size: 22.sp,
                                  color: const Color(0xFF9AA2B4),
                                ),
                            ],
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            it.message,
                            style: TextStyle(
                              fontSize: 12.5.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF7B8194),
                              height: 1.25,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            it.timeAgo,
                            style: TextStyle(
                              fontSize: 11.5.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFB0B6C6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (isExpanded && it.details != null) ...[
              const Divider(height: 1, color: Color(0xFFEEF0F6)),
              Padding(
                padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 14.h),
                child: DetailsCard(details: it.details!),
              ),
            ],
          ],
        ),
      );
    });
  }
}
