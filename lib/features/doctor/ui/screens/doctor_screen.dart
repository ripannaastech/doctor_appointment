import 'package:doctor_appointment/app/app_colors.dart';
import 'package:doctor_appointment/app/asset_paths.dart';
import 'package:doctor_appointment/features/appointment/presentation/ui/screens/select_time_slot_appoinment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../l10n/app_localizations.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../appointment/models/data/practitioner_model.dart';
import '../../../appointment/presentation/ui/controller/booking_controller.dart';


class DoctorScreen extends StatefulWidget {
  const DoctorScreen({super.key});
  static const String name = '/selectDoctor';

  @override
  State<DoctorScreen> createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> {
  late final BookingController c;

  @override
  void initState() {
    super.initState();

    c = Get.isRegistered<BookingController>()
        ? Get.find<BookingController>()
        : Get.put(BookingController());

    // Load departments + practitioners first time
    c.initBookingData();
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
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            l10n.doctorList,
            style: TextStyle(
              fontSize: 18.sp,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(16.r)),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            20.verticalSpace,
            Text(
              l10n.doctorList,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            12.verticalSpace,

            /// ✅ Search + Filter (same design)
            Container(
              height: 48.h,
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF6F7F9),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    AssetPaths.search,
                    height: 20.sp,
                    color: Colors.grey,
                  ),
                  10.horizontalSpace,

                  /// Search input (real)
                  Expanded(
                    child: TextField(
                      onChanged: c.setSearchQuery,
                      decoration: InputDecoration(
                        hintText: l10n.searchDoctor,
                        hintStyle:
                        TextStyle(fontSize: 14.sp, color: Colors.grey),
                        border: InputBorder.none,
                        isCollapsed: true,
                      ),
                      style: TextStyle(fontSize: 14.sp, color: Colors.black),
                    ),
                  ),

                  /// Clear search (only if typing)
                  Obx(() {
                    final showClear = c.searchQuery.value.trim().isNotEmpty;
                    if (!showClear) return const SizedBox.shrink();
                    return IconButton(
                      onPressed: () => c.clearSearch(),
                      icon: const Icon(Icons.close, color: Colors.grey),
                    );
                  }),

                  /// ✅ Filter icon (department)
                  Obx(() {
                    final active = c.selectedDepartment.value.trim().isNotEmpty;
                    return InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => _showDepartmentFilter(context, l10n),
                      child: Padding(
                        padding: EdgeInsets.all(6.w),
                        child: Icon(
                          Icons.filter_list,
                          size: 22.sp,
                          color: active
                              ? const Color(0xFF3F6DE0)
                              : Colors.grey,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),

            16.verticalSpace,

            /// ✅ Doctor list (API)
            Expanded(
              child: Obx(() {
                if (c.loadingPractitioners.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (c.errorText.value.isNotEmpty) {
                  return Center(
                    child: Text(
                      c.errorText.value,
                      style: TextStyle(fontSize: 14.sp, color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                if (c.practitioners.isEmpty) {
                  return Center(
                    child: Text(
                      l10n.noDoctorsFound,
                      style: TextStyle(fontSize: 14.sp, color: Colors.black54),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await c.fetchDepartments(offset: 0);
                    await c.fetchPractitioners();
                  },
                  child: ListView.builder(
                    itemCount: c.practitioners.length,
                    itemBuilder: (context, index) {
                      final p = c.practitioners[index];

                      final name =
                      (p.fullName  ?? l10n.doctor)
                          .toString();

                      final dept = (p.department ?? '').toString();
                      final specialty = dept.isNotEmpty ? dept : l10n.department;

                      return InkWell(
                        borderRadius: BorderRadius.circular(12.r),
                        onTap: () {
                          showDoctorDetailsDialogFromMap(context, p.toJson(), l10n);
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
                                name,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              6.verticalSpace,
                              Text(
                                specialty,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: Colors.grey.withOpacity(.5),
                                ),
                              ),
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
  Widget _infoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120.w,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showDoctorDetailsDialogFromMap(
      BuildContext context,
      Map<String, dynamic> d,
      AppLocalizations l10n,
      ) {
    String val(dynamic v) {
      final s = (v ?? '').toString().trim();
      return s.isEmpty || s == 'null' ? 'N/A' : s;
    }

    final name = val(d['full_name'] ?? d['practitionerName'] ?? d['name'] ?? l10n.doctor);

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Text(
          name,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _infoRow(l10n.department, val(d['department'])),
              _infoRow('Designation', val(d['designation'])),
              _infoRow('Doctor Hall', val(d['doctor_hall'])),
              _infoRow('Doctor Room', val(d['doctor_room'])),
              _infoRow('Mobile', val(d['mobile'])),
              _infoRow('Phone (Residence)', val(d['phone_residence'])),
              _infoRow('Phone (Office)', val(d['phone_office'])),
              _infoRow('Status', val(d['status'])),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Close')),
        ],
      ),
    );
  }


  /// ✅ BottomSheet: Department filter
  void _showDepartmentFilter(BuildContext context, AppLocalizations l10n) {
    final TextEditingController searchCtrl = TextEditingController();
    final RxString localSearch = ''.obs;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) {
        return Obx(() {
          if (c.loadingDepartments.value) {
            return const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          // 🔍 local filtered list
          final filteredDepartments = c.departments.where((d) {
            final name = (d.department ?? d.name ?? '').toLowerCase();
            final q = localSearch.value.toLowerCase();
            return name.contains(q);
          }).toList();

          return SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                20.w,
                20.h,
                20.w,
                20.h + MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.65,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Title
                    Text(
                      l10n.selectDepartment,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    12.verticalSpace,

                    /// 🔍 Search field
                    Container(
                      height: 44.h,
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6F7F9),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: Colors.grey),
                          8.horizontalSpace,
                          Expanded(
                            child: TextField(
                              controller: searchCtrl,
                              onChanged: (v) => localSearch.value = v,
                              decoration: InputDecoration(
                                hintText: l10n.searchDepartment,
                                border: InputBorder.none,
                                isCollapsed: true,
                              ),
                              style: TextStyle(fontSize: 14.sp),
                            ),
                          ),
                          Obx(() {
                            if (localSearch.value.isEmpty) {
                              return const SizedBox.shrink();
                            }
                            return GestureDetector(
                              onTap: () {
                                searchCtrl.clear();
                                localSearch.value = '';
                              },
                              child: const Icon(Icons.close,
                                  size: 18, color: Colors.grey),
                            );
                          }),
                        ],
                      ),
                    ),

                    12.verticalSpace,

                    /// List
                    Expanded(
                      child: ListView(
                        children: [
                          /// All departments
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(l10n.allDepartments),
                            trailing: c.selectedDepartment.value.isEmpty
                                ? const Icon(Icons.check,
                                color: Color(0xFF3F6DE0))
                                : null,
                            onTap: () {
                              c.setDepartment('');
                              Navigator.pop(context);
                            },
                          ),

                          Divider(height: 1.h),

                          /// Filtered department list
                          if (filteredDepartments.isEmpty)
                            Padding(
                              padding: EdgeInsets.only(top: 20.h),
                              child: Center(
                                child: Text(
                                  l10n.noDepartmentsFound,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ),

                          ...filteredDepartments.map((d) {
                            final depName =
                            (d.department ?? d.name ?? '').toString();
                            final selected =
                                c.selectedDepartment.value == depName;

                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(depName),
                              trailing: selected
                                  ? const Icon(Icons.check,
                                  color: Color(0xFF3F6DE0))
                                  : null,
                              onTap: () {
                                c.setDepartment(depName);
                                Navigator.pop(context);
                              },
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }
}

