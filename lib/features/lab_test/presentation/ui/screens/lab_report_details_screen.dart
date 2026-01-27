import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../l10n/app_localizations.dart';
import '../controller/lab_report_controller.dart';

class LabReportDetailsScreen extends StatefulWidget {
  final String labTestId;
  const LabReportDetailsScreen({super.key, required this.labTestId});

  static const String name = '/labReportDetails';

  @override
  State<LabReportDetailsScreen> createState() => _LabReportDetailsScreenState();
}

class _LabReportDetailsScreenState extends State<LabReportDetailsScreen> {
  late final LabReportController c;

  @override
  void initState() {
    super.initState();

    c = Get.isRegistered<LabReportController>()
        ? Get.find<LabReportController>()
        : Get.put(LabReportController());

    c.fetchLabTestDetails(widget.labTestId);
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
            l10n.labReportDetails,
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
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Obx(() {
          if (c.loadingDetails.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (c.detailsError.value.isNotEmpty) {
            return Center(
              child: Text(
                c.detailsError.value,
                style: TextStyle(fontSize: 14.sp, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            );
          }

          final d = c.selectedLabTest.value;
          if (d == null) {
            return Center(
              child: Text(
                l10n.noDetailsFound,
                style: TextStyle(fontSize: 14.sp, color: Colors.black54),
              ),
            );
          }

          return ListView(
            children: [
              20.verticalSpace,


              Container(
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
                      d.name,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    6.verticalSpace,
                    Text(
                      "${d.patientName ?? ''} • ${d.patientSex ?? ''} • ${d.patientAge ?? ''}"
                          .trim(),
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.grey.withOpacity(.6),
                      ),
                    ),
                    6.verticalSpace,
                    Text(
                      "${l10n.resultDate}: ${d.resultDate ?? '-'}",
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.grey.withOpacity(.6),
                      ),
                    ),
                    6.verticalSpace,
                    Text(
                      "${l10n.doctor}: ${d.practitionerName ?? '-'}",
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.grey.withOpacity(.6),
                      ),
                    ),
                  ],
                ),
              ),

              16.verticalSpace,
              Text(
                l10n.results,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              12.verticalSpace,

              if (d.normalItems.isEmpty)
                Text(
                  l10n.noResultItemsFound,
                  style: TextStyle(fontSize: 14.sp, color: Colors.black54),
                ),

              ...d.normalItems.map((it) {
                final title = (it.labTestName?.isNotEmpty ?? false)
                    ? it.labTestName!
                    : l10n.test;

                final value = (it.resultValue ?? "-").toString();
                final uom = (it.uom ?? "").toString();
                final range = (it.normalRange ?? "-").toString();

                return Container(
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
                        "${l10n.value}: $value ${uom.isEmpty ? '' : uom}",
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.grey.withOpacity(.6),
                        ),
                      ),
                      6.verticalSpace,
                      Text(
                        "${l10n.normalRange}: $range",
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.grey.withOpacity(.6),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          );
        }),
      ),
    );
  }
}
