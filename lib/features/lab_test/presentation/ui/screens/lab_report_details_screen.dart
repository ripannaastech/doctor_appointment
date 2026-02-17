import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Assuming you use ScreenUtil
import 'package:get/get.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../data/models/lab_test_models.dart';
import '../controller/lab_report_controller.dart';
// Add your localization and controller imports here

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

  // Helper to determine status color
  Color _getStatusColor(String? status) {
    final s = (status ?? '').toLowerCase();
    if (s.contains('final') || s.contains('completed')) return const Color(0xFF00C853); // Green
    if (s.contains('cancel')) return const Color(0xFFFF5252); // Red
    return const Color(0xFFFFAB00); // Amber/Orange for pending
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F8), // Slightly more clinical grey-blue
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
        ),      ),

      body: Obx(() {
        if (c.loadingDetails.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (c.detailsError.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48.sp, color: Colors.red[300]),
                12.verticalSpace,
                Text(
                  c.detailsError.value,
                  style: TextStyle(fontSize: 14.sp, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
              ],
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
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          children: [
            // ✅ 1. Header Card (Patient & Doctor Info)
            _buildHeaderCard(d, l10n),

            24.verticalSpace,

            // ✅ 2. Results Section Title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                children: [
                  Icon(Icons.analytics_outlined, size: 20.sp, color: const Color(0xFF3F6DE0)),
                  8.horizontalSpace,
                  Text(
                    l10n.results,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF2D3A52),
                    ),
                  ),
                  const Spacer(),
                  if (d.normalItems.isNotEmpty)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3F6DE0).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        "${d.normalItems.length} items",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xFF3F6DE0),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            12.verticalSpace,

            if (d.normalItems.isEmpty)
              _buildEmptyState(l10n),

            // ✅ 3. Enhanced Result Tiles
            ...d.normalItems.map((it) => _buildResultTile(context, it, l10n)),

            30.verticalSpace,
          ],
        );
      }),
    );
  }

  Widget _buildHeaderCard(dynamic d, AppLocalizations l10n) {
    Color statusColor = _getStatusColor(d.status);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3F6DE0).withOpacity(0.08),
            offset: const Offset(0, 8),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        children: [
          // Top part: Test Name and Status
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    d.name,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF2D3A52),
                      height: 1.2,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: statusColor.withOpacity(0.2)),
                  ),
                  child: Text(
                    (d.status ?? "-").toUpperCase(),
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      color: statusColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFF0F0F0)),

          // Bottom part: Details with Icons
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                _infoRow(Icons.person_outline, d.patientName ?? l10n.patient),
                10.verticalSpace,
                _infoRow(Icons.calendar_today_outlined, "${l10n.resultDate}: ${d.resultDate ?? '-'}"),
                10.verticalSpace,
                _infoRow(Icons.medical_services_outlined, d.practitionerName ?? l10n.doctor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: Colors.grey[400]),
        10.horizontalSpace,
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13.sp,
              color: const Color(0xFF555F71),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultTile(BuildContext context, NormalTestItem it, AppLocalizations l10n) {
    final title = (it.labTestName ?? '').trim().isNotEmpty ? it.labTestName!.trim() : l10n.test;
    final value = (it.resultValue ?? "-").toString().trim();
    final uom = (it.uom ?? "").toString().trim();
    final range = (it.normalRange ?? "-").toString().trim();

    // ---------------------------------------------------------------------------
    // 1. ABNORMAL LOGIC
    // ---------------------------------------------------------------------------
    // TODO: Replace this with your actual model logic.
    // APIs usually send a flag like 'H' (High), 'L' (Low), or 'A' (Abnormal).
    // Example: bool isAbnormal = it.flag == 'H' || it.flag == 'L';

    // For demonstration, let's assume if the model has an 'isAbnormal' field
    // or purely for UI testing, set this to true to see the red style.
    bool isAbnormal = false;

    // Dynamic Colors
    final Color statusColor = isAbnormal ? const Color(0xFFFF4842) : const Color(0xFF3F6DE0); // Red vs Blue
    final Color valueColor = isAbnormal ? const Color(0xFFFF4842) : const Color(0xFF2D3A52); // Red vs Dark Blue
    // ---------------------------------------------------------------------------

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: IntrinsicHeight( // Ensures the colored strip matches height
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 2. Dynamic Accent Strip (Left side)
              Container(
                width: 6.w,
                color: statusColor,
              ),

              // Main Content
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Row(
                    children: [
                      // Test Name and Range
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF2D3A52),
                              ),
                            ),
                            6.verticalSpace,
                            // Range Badge
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F6FA),
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Text(
                                "${l10n.normalRange}: $range",
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      12.horizontalSpace,

                      // Value, Unit, and Warning Icon
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // 3. Warning Icon (Only if abnormal)
                                if (isAbnormal)
                                  Padding(
                                    padding: EdgeInsets.only(right: 6.w),
                                    child: Icon(
                                      Icons.warning_amber_rounded,
                                      color: statusColor,
                                      size: 18.sp,
                                    ),
                                  ),
                                // Result Value
                                Flexible(
                                  child: Text(
                                    value,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w900,
                                      color: valueColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (uom.isNotEmpty) ...[
                              2.verticalSpace,
                              Text(
                                uom,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildEmptyState(AppLocalizations l10n) {
    return Container(
      padding: EdgeInsets.all(30.w),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Icon(Icons.feed_outlined, size: 40.sp, color: Colors.grey[300]),
          10.verticalSpace,
          Text(
            l10n.noResultItemsFound,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}