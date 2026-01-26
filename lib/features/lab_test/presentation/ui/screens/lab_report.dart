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

// ✅ Your imports (adjust paths)
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

    /// ✅ IMPORTANT: avoid multiple instances
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

          // ✅ iOS back button
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

            /// ✅ Lab report list
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
                  child: ListView.builder(
                    itemCount: c.labTests.length,
                    itemBuilder: (context, index) {
                      final t = c.labTests[index];

                      final title = (t.labTestName?.isNotEmpty ?? false)
                          ? t.labTestName!
                          : (t.template ?? l10n.test);

                      final subtitleParts = <String>[];
                      if ((t.resultDate ?? '').isNotEmpty) {
                        subtitleParts.add(t.resultDate!);
                      }
                      if ((t.status ?? '').isNotEmpty) {
                        subtitleParts.add(t.status!);
                      }
                      final subtitle =
                      subtitleParts.isEmpty ? "—" : subtitleParts.join(" • ");

                      return InkWell(
                        borderRadius: BorderRadius.circular(12.r),
                        onTap: () {
                          Get.to(
                                () => LabReportDetailsScreen(labTestId: t.name),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 12.h),
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: const Color(0xFFE6E8EC)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              6.verticalSpace,
                              Text(
                                subtitle,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: Colors.grey.withOpacity(.6),
                                ),
                              ),
                              if ((t.department ?? '').isNotEmpty) ...[
                                8.verticalSpace,
                                Text(
                                  t.department!,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey.withOpacity(.7),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}



