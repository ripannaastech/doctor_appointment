import 'package:doctor_appointment/app/app_colors.dart';
import 'package:doctor_appointment/app/asset_paths.dart';
import 'package:doctor_appointment/features/appointment/presentation/ui/screens/select_time_slot_appoinment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../doctor/ui/widgets/doctor_card.dart';
import '../../../../doctor/ui/widgets/doctor_details_sheet.dart';
import '../controller/booking_controller.dart';

class SelectDateTimeArgs {
  final Map<String, dynamic> doctorJson;
  final String department;
  final double feeAmount;

  const SelectDateTimeArgs({
    required this.doctorJson,
    required this.department,
    required this.feeAmount,
  });

  factory SelectDateTimeArgs.from(dynamic raw) {
    final m = (raw as Map?) ?? const {};

    final doctor = Map<String, dynamic>.from((m['doctor'] ?? {}) as Map);
    final dept = (m['department'] ?? '').toString();

    final feeRaw = m['feeAmount'];
    final fee = feeRaw is num
        ? feeRaw.toDouble()
        : double.tryParse(feeRaw?.toString() ?? '') ?? 0.0;

    return SelectDateTimeArgs(
      doctorJson: doctor,
      department: dept,
      feeAmount: fee,
    );
  }
}

class SelectDoctorScreen extends StatefulWidget {
  const SelectDoctorScreen({super.key});

  static const String name = '/selectDoctor';

  @override
  State<SelectDoctorScreen> createState() => _SelectDoctorScreenState();
}

class _SelectDoctorScreenState extends State<SelectDoctorScreen> {
  late final BookingController c;

  @override
  void initState() {
    super.initState();

    c = Get.isRegistered<BookingController>()
        ? Get.find<BookingController>()
        : Get.put(BookingController());

    // Load doctors + departments
    // c.initBookingData();

    // reset selection when opening screen (optional)
    c.selectedPractitionerIndex.value = -1;
    c.selectedPractitioner.value = null;
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
              size: 24,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            l10n.bookAppointment,
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
              l10n.selectDoctor,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            12.verticalSpace,

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

                  Expanded(
                    child: TextField(
                      onChanged: c.setSearchQuery,
                      decoration: InputDecoration(
                        hintText: l10n.searchDoctor,
                        hintStyle: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey,
                        ),
                        border: InputBorder.none,
                        isCollapsed: true,
                      ),
                      style: TextStyle(fontSize: 14.sp, color: Colors.black),
                    ),
                  ),

                  /// Clear
                  Obx(() {
                    final showClear = c.searchQuery.value.trim().isNotEmpty;
                    if (!showClear) return const SizedBox.shrink();
                    return IconButton(
                      onPressed: () => c.clearSearch(),
                      icon: const Icon(Icons.close, color: Colors.grey),
                    );
                  }),

                  /// Filter
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
                          color: active ? const Color(0xFF3F6DE0) : Colors.grey,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),

            16.verticalSpace,

            Expanded(
              child: Obx(() {
                if (c.loadingPractitioners.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (c.practitioners.isEmpty) {
                  return Center(
                    child: Text(
                      l10n.noDoctorsFound,
                      style: TextStyle(fontSize: 14.sp, color: Colors.black54),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: c.practitioners.length,
                  itemBuilder: (context, index) {
                    final p = c.practitioners[index];

                    return Obx(() {
                      final isSelected =
                          c.selectedPractitionerIndex.value == index;

                      return DoctorCard(
                        doctor: p,
                        isSelected: isSelected,
                        showBookButton: false,
                        onTap: () {
                          c.selectedPractitionerIndex.value = index;
                          c.selectedPractitioner.value = p;
                        },
                        onViewProfile: () {
                          DoctorDetailsSheet.show(
                            context,
                            doctor: p,
                            l10n: l10n,
                          );
                        },
                      );
                    });
                  },
                );
              }),
            ),

            Padding(
              padding: EdgeInsets.only(bottom: 20.h),
              child: Obx(() {
                final enabled = c.selectedPractitioner.value != null;
                final isLoading = c.loadingDoctorAppointments.value;

                return SizedBox(
                  width: double.infinity,
                  height: 52.h,
                  child: ElevatedButton(
                    onPressed: (!enabled || isLoading)
                        ? null
                        : () async {
                            final p = c.selectedPractitioner.value!;

                            final practitionerName = (p.fullName ?? '').trim();

                            if (practitionerName.isNotEmpty) {
                              final ok = await c.fetchDoctorBookedAppointments(
                                practitionerName: practitionerName,
                              );

                              if (!ok) return;
                            }

                            Navigator.pushNamed(
                              context,
                              SelectDateTimeScreen.name,
                              arguments: p,
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3F6DE0),
                      disabledBackgroundColor: const Color(0xFFDADDE2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: isLoading
                        ? SizedBox(
                            height: 20.h,
                            width: 20.h,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            l10n.next,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

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
                    Text(
                      l10n.selectDepartment,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    12.verticalSpace,

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
                            if (localSearch.value.isEmpty)
                              return const SizedBox.shrink();
                            return GestureDetector(
                              onTap: () {
                                searchCtrl.clear();
                                localSearch.value = '';
                              },
                              child: const Icon(
                                Icons.close,
                                size: 18,
                                color: Colors.grey,
                              ),
                            );
                          }),
                        ],
                      ),
                    ),

                    12.verticalSpace,

                    Expanded(
                      child: ListView(
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(l10n.allDepartments),
                            trailing: c.selectedDepartment.value.isEmpty
                                ? const Icon(
                                    Icons.check,
                                    color: Color(0xFF3F6DE0),
                                  )
                                : null,
                            onTap: () {
                              c.setDepartment('');
                              Navigator.pop(context);
                            },
                          ),
                          Divider(height: 1.h),

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
                            final depName = (d.department ?? d.name ?? '')
                                .toString();
                            final selected =
                                c.selectedDepartment.value == depName;

                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(depName),
                              trailing: selected
                                  ? const Icon(
                                      Icons.check,
                                      color: Color(0xFF3F6DE0),
                                    )
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
