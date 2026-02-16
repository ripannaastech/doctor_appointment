import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// import your controller + models
// import 'lab_report_controller.dart';
// import 'lab_test_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../l10n/app_localizations.dart';
import '../controller/lab_report_controller.dart';

// import your controller + models
// import 'lab_report_controller.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'lab_report_details_screen.dart';




class LabReportScreen extends StatefulWidget {
  const LabReportScreen({super.key});

  static const String name = '/labReports';

  @override
  State<LabReportScreen> createState() => _LabReportScreenState();
}

class _LabReportScreenState extends State<LabReportScreen> {
  late final LabReportController c;

  @override
  void initState() {
    super.initState();

    /// If already put somewhere, this will reuse it
    c = Get.isRegistered<LabReportController>()
        ? Get.find<LabReportController>()
        : Get.put(LabReportController());

    c.fetchLabTests();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.h),
        child: AppBar(
          backgroundColor: const Color(0xFF3F6DE0),
          elevation: 0,


          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
          ),

          title: Text(
            l10n.labReports,
            style: TextStyle(
              fontSize: 18.sp,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(16.r),
            ),
          ),
        ),      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            20.verticalSpace,
            Text(
              l10n.selectLabReport,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            12.verticalSpace,


            Expanded(
              child: Obx(() {
                if (c.loadingList.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (c.listError.value.isNotEmpty) {
                  return Center(
                    child: Text(
                      c.listError.value,
                      style: TextStyle(fontSize: 14.sp, color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                if (c.labTests.isEmpty) {
                  return Center(
                    child: Text(
                      l10n.noLabReportsFound,
                      style: TextStyle(fontSize: 14.sp, color: Colors.black54),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: c.refreshLabTests,
                  child: ListView.separated(
                    // Added padding so cards don't touch screen edges
                    itemCount: c.labTests.length,
                    // Using separated for cleaner spacing logic
                    separatorBuilder: (context, index) => 12.verticalSpace,
                    itemBuilder: (context, index) {
                      final t = c.labTests[index];

                      final title = (t.labTestName?.isNotEmpty ?? false)
                          ? t.labTestName!
                          : (t.template ?? l10n.test);

                      // Status-based coloring for better UX
                      final bool isCompleted = t.status?.toLowerCase() == 'completed';
                      final Color statusColor = isCompleted ? const Color(0xFF10B981) : const Color(0xFFF59E0B);

                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(color: const Color(0xFFF1F2F4)),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16.r),
                          onTap: () => Get.to(() => LabReportDetailsScreen(labTestId: t.name)),
                          child: Padding(
                            padding: EdgeInsets.all(16.w),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 1. Status Indicator (Visual cue)
                                Container(
                                  width: 4.w,
                                  height: 40.h,
                                  decoration: BoxDecoration(
                                    color: statusColor,
                                    borderRadius: BorderRadius.circular(2.r),
                                  ),
                                ),
                                12.horizontalSpace,

                                // 2. Content
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF111827),
                                          letterSpacing: -0.3,
                                        ),
                                      ),
                                      4.verticalSpace,

                                      // Icon-text pairs for better scannability
                                      Row(
                                        children: [
                                          Icon(Icons.calendar_today_outlined, size: 12.sp, color: const Color(0xFF6B7280)),
                                          4.horizontalSpace,
                                          Text(
                                            t.resultDate ?? 'Pending',
                                            style: TextStyle(fontSize: 13.sp, color: const Color(0xFF6B7280)),
                                          ),
                                          8.horizontalSpace,
                                          Icon(Icons.circle, size: 4.sp, color: const Color(0xFFD1D5DB)),
                                          8.horizontalSpace,
                                          Text(
                                            t.status ?? '',
                                            style: TextStyle(
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w600,
                                              color: statusColor,
                                            ),
                                          ),
                                        ],
                                      ),

                                      if ((t.department ?? '').isNotEmpty) ...[
                                        12.verticalSpace,
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFEEF2FF),
                                            borderRadius: BorderRadius.circular(100),
                                          ),
                                          child: Text(
                                            t.department!,
                                            style: TextStyle(
                                              fontSize: 11.sp,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xFF4F46E5),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),

                                // 3. Trailing Icon
                                Padding(
                                  padding: EdgeInsets.only(top: 10.h),
                                  child: Icon(
                                    Icons.chevron_right_rounded,
                                    color: const Color(0xFFD1D5DB),
                                    size: 20.r,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );              }),
            ),
          ],
        ),
      ),
    );
  }
}



