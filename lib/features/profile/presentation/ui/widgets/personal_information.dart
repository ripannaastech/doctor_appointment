import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../../l10n/app_localizations.dart';
import '../../../../../app/app_snackbar.dart';
import '../../../models/user_profile_model.dart';
import '../controller/profle_controller.dart';
import '../screens/profile_screen.dart';

class PersonalInfoCard extends StatefulWidget {
  final bool isEditing;
  final VoidCallback onToggleEdit;

  const PersonalInfoCard({
    super.key,
    required this.isEditing,
    required this.onToggleEdit,
  });

  @override
  State<PersonalInfoCard> createState() => _PersonalInfoCardState();
}

class _PersonalInfoCardState extends State<PersonalInfoCard> {
  late final ProfileControllerGetx pc;

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();

  final RxString selectedGender = "Male".obs;

  final _addressController = TextEditingController();

  bool _filledOnce = false;

  @override
  void initState() {
    super.initState();
    pc = Get.find<ProfileControllerGetx>();

    final p = pc.profile.value;
    if (p != null) _fillFromProfile(p);
  }

  void _fillFromProfile(UserProfile p) {
    final name = (p.patientName?.trim().isNotEmpty ?? false)
        ? p.patientName!.trim()
        : ((p.firstName ?? '') + ' ' + (p.lastName ?? '')).trim();

    _fullNameController.text = name;
    _emailController.text = p.email ?? '';
    _phoneController.text = p.phone ?? p.mobileNo ?? '';

    selectedGender.value =
    (p.sex?.trim().isNotEmpty ?? false) ? p.sex!.trim() : selectedGender.value;

    _dobController.text = p.dob ?? '';

    _filledOnce = true;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Obx(() {
      final p = pc.profile.value;

      if (p != null && !_filledOnce && !widget.isEditing) {
        _fillFromProfile(p);
      }

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(kCardRadius.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.personalInformation,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: kTextDark,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (widget.isEditing && p != null) {
                        _fillFromProfile(p); // restore
                      }
                      widget.onToggleEdit();
                    },
                    child: Row(
                      children: [
                        Icon(
                          widget.isEditing ? Icons.close : Icons.edit_outlined,
                          color: kPrimaryBlue,
                          size: 18.sp,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          widget.isEditing ? l10n.cancel : l10n.edit,
                          style: TextStyle(
                            color: kPrimaryBlue,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20.h),

              _buildField(
                l10n,
                Icons.person_outline,
                l10n.fullName,
                _fullNameController,
                false,
              ),
              _buildField(
                l10n,
                Icons.email_outlined,
                l10n.emailAddress,
                _emailController,
                widget.isEditing,
              ),
              _buildField(
                l10n,
                Icons.phone_outlined,
                l10n.phoneNumber,
                _phoneController,
                false,
              ),
              _buildDateField(
                l10n,
                Icons.cake_outlined,
                l10n.dateOfBirth,
                _dobController,
                widget.isEditing,
              ),
              _buildGenderField(
                l10n,
                Icons.person_outline,
                l10n.gender,
                widget.isEditing,
              ),

              if (widget.isEditing) ...[
                SizedBox(height: 20.h),
                SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryBlue,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    onPressed: pc.loading.value ? null : () => _onSavePressed(context),
                    child: pc.loading.value
                        ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : Text(
                      l10n.save,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    });
  }

  Future<void> _onSavePressed(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;

    final full = _fullNameController.text.trim();
    String first = full;
    String last = '';
    final parts = full.split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
    if (parts.length >= 2) {
      first = parts.first;
      last = parts.sublist(1).join(' ');
    }

    final dob = _dobController.text.trim(); // YYYY-MM-DD

    final ok = await pc.updateProfile(
      patientName: full,
      firstName: first,
      lastName: last,
      email: _emailController.text.trim(),
      sex: selectedGender.value,
      dob: dob.isEmpty ? null : dob,
    );

    if (ok) {
      AppSnackbar.success('Success', l10n.profileUpdated ?? 'Profile updated');

      widget.onToggleEdit();
      _filledOnce = false;
      await pc.fetchProfile();
    }
  }

  // -------------------- fields --------------------

  Widget _buildField(
      AppLocalizations l10n,
      IconData icon,
      String label,
      TextEditingController controller,
      bool editable, {
        bool isLast = false,
      }) {
    return Padding(
      padding: EdgeInsets.only(bottom: (isLast ? 0 : 16).h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: kTextGray, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: kTextGray,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          editable
              ? TextFormField(
            controller: controller,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: kTextDark,
            ),
          )
              : Text(
            controller.text,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: kTextDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(
      AppLocalizations l10n,
      IconData icon,
      String label,
      TextEditingController controller,
      bool editable, {
        bool isLast = false,
      }) {
    return Padding(
      padding: EdgeInsets.only(bottom: (isLast ? 0 : 16).h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: kTextGray, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: kTextGray,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          editable
              ? TextFormField(
            controller: controller,
            readOnly: true,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: kTextDark,
            ),
            onTap: () => _pickDob(context),
          )
              : Text(
            controller.text,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: kTextDark,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDob(BuildContext context) async {
    DateTime initial = DateTime(2000, 1, 1);
    try {
      final txt = _dobController.text.trim();
      if (txt.isNotEmpty) initial = DateTime.parse(txt);
    } catch (_) {}

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      final yyyyMmDd = DateFormat('yyyy-MM-dd').format(picked);
      _dobController.text = yyyyMmDd;
    }
  }

  Widget _buildGenderField(
      AppLocalizations l10n,
      IconData icon,
      String label,
      bool editable, {
        bool isLast = false,
      }) {
    final items = <String>['Male', 'Female', 'Other'];

    return Padding(
      padding: EdgeInsets.only(bottom: (isLast ? 0 : 16).h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: kTextGray, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: kTextGray,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),

          // ✅ reactive dropdown/text
          editable
              ? Obx(() {
            final v = items.contains(selectedGender.value)
                ? selectedGender.value
                : 'Male';
            return DropdownButtonFormField<String>(
              value: v,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: kTextDark,
              ),
              decoration: InputDecoration(
                isDense: true,
                contentPadding:
                EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide:
                  const BorderSide(color: kPrimaryBlue, width: 2),
                ),
              ),
              items: items
                  .map((g) =>
                  DropdownMenuItem<String>(value: g, child: Text(g)))
                  .toList(),
              onChanged: (value) {
                if (value != null) selectedGender.value = value;
              },
            );
          })
              : Obx(() {
            return Text(
              selectedGender.value,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: kTextDark,
              ),
            );
          }),
        ],
      ),
    );
  }
}


