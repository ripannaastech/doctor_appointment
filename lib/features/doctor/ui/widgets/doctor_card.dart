import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../appointment/models/data/practitioner_model.dart';
class DoctorCard extends StatelessWidget {
  final Practitioner doctor;

  /// selection UI
  final bool isSelected;
  final VoidCallback? onTap;

  /// actions
  final VoidCallback? onViewProfile;
  final VoidCallback? onBook;

  /// hide book button easily
  final bool showBookButton;

  /// ✅ NEW: show loading only for this card's book button
  final bool isBookingLoading;

  const DoctorCard({
    super.key,
    required this.doctor,
    this.isSelected = false,
    this.onTap,
    this.onViewProfile,
    this.onBook,
    this.showBookButton = true,
    this.isBookingLoading = false, // ✅ NEW default
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final name = (doctor.fullName?.trim().isNotEmpty ?? false)
        ? doctor.fullName!.trim()
        : l10n.unknownDoctor;

    final specialty = (doctor.specialization?.trim().isNotEmpty ?? false)
        ? doctor.specialization!.trim()
        : (doctor.department?.trim().isNotEmpty ?? false)
        ? doctor.department!.trim()
        : "—";

    final experience = doctor.experienceYears != null
        ? l10n.yearsExperience(doctor.experienceYears!)
        : l10n.experienceNA;

    final hospital = (doctor.doctorRoom?.trim().isNotEmpty ?? false)
        ? doctor.doctorRoom!.trim()
        : l10n.hospitalNA;

    final language = (doctor.languages?.trim().isNotEmpty ?? false)
        ? doctor.languages!.trim()
        : l10n.na;

    final charge = doctor.opConsultingCharge != null
        ? l10n.moneyAmount(doctor.opConsultingCharge!.toStringAsFixed(2))
        : l10n.na;

    // ✅ If loading, the book button must be disabled
    final bookEnabled = showBookButton && onBook != null && !isBookingLoading;

    return InkWell(
      borderRadius: BorderRadius.circular(24.r),
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h, left: 16.w, right: 16.w),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEFF4FF) : Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: isSelected ? AppColors.themeColor : const Color(0xFFE6E8EC),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: AppColors.themeColor.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ]
              : [
            BoxShadow(
              color: Colors.blueGrey.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _avatar(doctor.image),
                16.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1A1C1E),
                          height: 1.2,
                        ),
                      ),
                      4.verticalSpace,
                      Text(
                        specialty,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        experience,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            20.verticalSpace,
            _dashedDivider(),
            16.verticalSpace,

            _feeTile(charge),

            16.verticalSpace,
            _infoTile(Icons.location_on_outlined, hospital),
            12.verticalSpace,
            _infoTile(Icons.translate_rounded, language),

            if (onViewProfile != null || (showBookButton && onBook != null)) ...[
              24.verticalSpace,
              Row(
                children: [
                  if (onViewProfile != null)
                    Expanded(
                      flex: showBookButton ? 2 : 1,
                      child: OutlinedButton(
                        onPressed: onViewProfile,
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                        ),
                        child: Text(
                          l10n.profile,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                  if (onViewProfile != null && showBookButton && onBook != null)
                    12.horizontalSpace,

                  if (showBookButton && onBook != null)
                    Expanded(
                      flex: 4,
                      child: ElevatedButton(
                        onPressed: bookEnabled ? onBook : null, // ✅ disable if loading
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4DA3FF),
                          disabledBackgroundColor: const Color(0xFFBFD9FF),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                        ),
                        child: isBookingLoading
                            ? SizedBox(
                          width: 18.w,
                          height: 18.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                            : Text(
                          l10n.bookAppointment,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _feeTile(String charge) {
    return Row(
      children: [
        Icon(Icons.payments_outlined, size: 18.sp, color: Colors.grey.shade400),
        12.horizontalSpace,
        Text(
          charge,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF4DA3FF),
          ),
        ),
      ],
    );
  }

  Widget _infoTile(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 18.sp, color: Colors.grey.shade400),
        12.horizontalSpace,
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13.sp,
              color: const Color(0xFF444444),
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _avatar(String? imageUrl) {
    final hasImage = imageUrl != null && imageUrl.trim().isNotEmpty;

    return Stack(
      children: [
        Container(
          width: 64.w,
          height: 64.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.r),
            color: Colors.transparent,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18.r),
            child: hasImage
                ? Image.network(
              imageUrl.trim(),
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Container(
                  color: const Color(0xFFF2F4F7),
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 18.w,
                    height: 18.w,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              },
              errorBuilder: (_, __, ___) => _avatarPlaceholder(),
            )
                : _avatarPlaceholder(),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            padding: EdgeInsets.all(2.w),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 18.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _avatarPlaceholder() {
    return Container(
      color: const Color(0xFFF2F4F7),
      alignment: Alignment.center,
      child: Icon(
        Icons.person,
        size: 30.sp,
        color: Colors.grey.shade400,
      ),
    );
  }

  Widget _dashedDivider() {
    return Row(
      children: List.generate(
        30,
            (index) => Expanded(
          child: Container(
            color: index % 2 == 0 ? Colors.transparent : const Color(0xFFE6E8EC),
            height: 1,
          ),
        ),
      ),
    );
  }}

