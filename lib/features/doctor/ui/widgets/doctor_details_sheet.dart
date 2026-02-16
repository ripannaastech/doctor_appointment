import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../appointment/models/data/practitioner_model.dart';



class DoctorDetailsSheet {
  DoctorDetailsSheet._();

  /// Public API: show bottom sheet
  static void show(
      BuildContext context, {
        required Practitioner doctor,
        required AppLocalizations l10n,
      }) {
    Get.bottomSheet(
      DoctorDetailsBottomSheet(
        doctor: doctor,
        l10n: l10n,
      ),
      isScrollControlled: true,
    );
  }
}

class DoctorDetailsBottomSheet extends StatelessWidget {
  final Practitioner doctor;
  final AppLocalizations l10n;

  const DoctorDetailsBottomSheet({
    super.key,
    required this.doctor,
    required this.l10n,
  });

  // Helper to handle null strings safely
  String val(String? v) {
    final s = (v ?? '').trim();
    return (s.isEmpty || s.toLowerCase() == 'null') ? l10n.na : s;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _SheetDragHandle(),

            DoctorSheetHeader(
              imageUrl: doctor.image,
              name: val(doctor.fullName),
              subtitle: val(doctor.specialization ?? doctor.department),
              onClose: () => Get.back(),
            ),

            Divider(height: 24.h),

            Flexible(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DoctorInfoCard(
                      title: l10n.details,
                      children: [
                        DoctorInfoRow(
                          icon: Icons.account_balance,
                          label: l10n.department,
                          value: val(doctor.department),
                        ),
                        DoctorInfoRow(
                          icon: Icons.work_outline,
                          label: l10n.designation,
                          value: val(doctor.designation),
                        ),
                        DoctorInfoRow(
                          icon: Icons.school,
                          label: l10n.degree,
                          value: val(doctor.degree),
                        ),
                        DoctorInfoRow(
                          icon: Icons.local_hospital,
                          label: l10n.specialization,
                          value: val(doctor.specialization),
                        ),
                        DoctorInfoRow(
                          icon: Icons.history_edu,
                          label: l10n.experience,
                          value: doctor.experienceYears == null
                              ? l10n.experienceNA
                              : l10n.yearsExperience(doctor.experienceYears!),
                        ),
                      ],
                    ),

                    DoctorInfoCard(
                      title: l10n.contact,
                      children: [
                        DoctorInfoRow(
                          icon: Icons.phone_android,
                          label: l10n.mobile,
                          value: val(doctor.mobile),
                        ),
                        DoctorInfoRow(
                          icon: Icons.phone,
                          label: l10n.phoneResidence,
                          value: val(doctor.phoneResidence),
                        ),
                        DoctorInfoRow(
                          icon: Icons.phone_in_talk,
                          label: l10n.phoneOffice,
                          value: val(doctor.phoneOffice),
                        ),
                      ],
                    ),

                    DoctorInfoCard(
                      title: l10n.clinicInfo,
                      children: [
                        DoctorInfoRow(
                          icon: Icons.location_on_outlined,
                          label: l10n.doctorHall,
                          value: val(doctor.doctorHall),
                        ),
                        DoctorInfoRow(
                          icon: Icons.meeting_room_outlined,
                          label: l10n.doctorRoom,
                          value: val(doctor.doctorRoom),
                        ),
                        DoctorInfoRow(
                          icon: Icons.calendar_month,
                          label: l10n.availableDays,
                          value: val(doctor.availableDays),
                        ),
                      ],
                    ),

                    DoctorInfoCard(
                      title: l10n.fees,
                      children: [
                        DoctorInfoRow(
                          icon: Icons.payments_outlined,
                          label: l10n.opConsultingCharge,
                          value: doctor.opConsultingCharge == null
                              ? l10n.na
                              : l10n.moneyAmount(
                            doctor.opConsultingCharge!.toStringAsFixed(2),
                          ),
                        ),
                        DoctorInfoRow(
                          icon: Icons.bedroom_parent_outlined,
                          label: l10n.inpatientVisitCharge,
                          value: doctor.inpatientVisitCharge == null
                              ? l10n.na
                              : l10n.moneyAmount(
                            doctor.inpatientVisitCharge!.toStringAsFixed(2),
                          ),
                        ),
                      ],
                    ),

                    DoctorOptionalSection(
                      title: l10n.languages,
                      content: doctor.languages,
                      emptyValueText: l10n.na,
                    ),

                    DoctorOptionalSection(
                      title: l10n.bio,
                      content: doctor.bio,
                      emptyValueText: l10n.na,
                    ),

                    DoctorOptionalSection(
                      title: l10n.education,
                      content: doctor.education,
                      emptyValueText: l10n.na,
                    ),

                    20.verticalSpace,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetDragHandle extends StatelessWidget {
  const _SheetDragHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 12.h),
        width: 40.w,
        height: 4.h,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

class DoctorSheetHeader extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final String subtitle;
  final VoidCallback onClose;

  const DoctorSheetHeader({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.subtitle,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DoctorDialogAvatar(imageUrl: imageUrl, size: 65.r),
          16.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onClose,
            icon: Icon(Icons.close, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}

class DoctorInfoCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const DoctorInfoCard({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          Divider(height: 24.h, thickness: 0.5),
          ...children,
        ],
      ),
    );
  }
}

class DoctorInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const DoctorInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18.sp, color: Colors.blueGrey),
          10.horizontalSpace,
          Text(
            "$label:",
            style: TextStyle(fontSize: 13.sp, color: Colors.grey[600]),
          ),
          8.horizontalSpace,
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DoctorOptionalSection extends StatelessWidget {
  final String title;
  final String? content;
  final String emptyValueText;

  const DoctorOptionalSection({
    super.key,
    required this.title,
    required this.content,
    required this.emptyValueText,
  });

  String _val(String? v) {
    final s = (v ?? '').trim();
    return (s.isEmpty || s.toLowerCase() == 'null') ? emptyValueText : s;
  }

  @override
  Widget build(BuildContext context) {
    final cleaned = (content ?? '').trim();
    if (cleaned.isEmpty || cleaned.toLowerCase() == 'null') {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DoctorSectionTitle(title: title),
        DoctorSimpleTextCard(content: _val(content)),
        16.verticalSpace,
      ],
    );
  }
}

class DoctorSectionTitle extends StatelessWidget {
  final String title;

  const DoctorSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h, left: 4.w),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
}

class DoctorSimpleTextCard extends StatelessWidget {
  final String content;

  const DoctorSimpleTextCard({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Text(
        content,
        style: TextStyle(fontSize: 13.sp, height: 1.4, color: Colors.black87),
      ),
    );
  }
}

class DoctorDialogAvatar extends StatelessWidget {
  final String? imageUrl;
  final double? size;

  const DoctorDialogAvatar({
    super.key,
    required this.imageUrl,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final double dimension = size ?? 56.r;

    return Container(
      width: dimension,
      height: dimension,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F7),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14.r),
        child: (imageUrl == null || imageUrl!.trim().isEmpty)
            ? _placeholderIcon(dimension)
            : Image.network(
          imageUrl!.trim(),
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: SizedBox(
                width: 20.w,
                height: 20.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
          },
          errorBuilder: (_, __, ___) => _placeholderIcon(dimension),
        ),
      ),
    );
  }

  Widget _placeholderIcon(double dimension) {
    return Center(
      child: Icon(
        Icons.person_outline,
        size: dimension * 0.45,
        color: Colors.black26,
      ),
    );
  }
}
