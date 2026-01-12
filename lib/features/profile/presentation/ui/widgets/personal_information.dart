import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../l10n/app_localizations.dart';
import '../screens/profile_screen.dart';

class PersonalInfoCard extends StatefulWidget {
  final bool isEditing;
  final VoidCallback onToggleEdit;

  const PersonalInfoCard({
    required this.isEditing,
    required this.onToggleEdit,
  });

  @override
  State<PersonalInfoCard> createState() => _PersonalInfoCardState();
}

class _PersonalInfoCardState extends State<PersonalInfoCard> {
  final _fullNameController = TextEditingController(text: "Ahmed Hassan Mohamed");
  final _emailController = TextEditingController(text: "ahmed.hassan@example.com");
  final _phoneController = TextEditingController(text: "+252 61 234 5678");
  final _dobController = TextEditingController(text: "15-May-1990");
  String _selectedGender = "Male";
  final _addressController = TextEditingController(text: "Mogadishu, Somalia");

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

                if (!widget.isEditing)
                  GestureDetector(
                    onTap: widget.onToggleEdit,
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

                if (widget.isEditing)
                  GestureDetector(
                    onTap: widget.onToggleEdit, // ✅ keep same behavior
                    child: Row(
                      children: [
                        Icon(Icons.close, color: kPrimaryBlue, size: 18.sp),
                        SizedBox(width: 6.w),
                        Text(
                          l10n.cancel,
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
              widget.isEditing,
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
              widget.isEditing,
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
            _buildField(
              l10n,
              Icons.location_on_outlined,
              l10n.address,
              _addressController,
              widget.isEditing,
              isLast: true,
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
                  onPressed: () {
                    widget.onToggleEdit();
                  },
                  child: Text(
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
  }

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
            onTap: () {
              // Date picker logic
            },
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

  Widget _buildGenderField(
      AppLocalizations l10n,
      IconData icon,
      String label,
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
              ? DropdownButtonFormField<String>(
            value: _selectedGender,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: kTextDark,
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 12.h,
              ),
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
                borderSide: const BorderSide(
                  color: kPrimaryBlue,
                  width: 2,
                ),
              ),
            ),
            items: [l10n.male, l10n.female, l10n.other]
                .map(
                  (gender) => DropdownMenuItem<String>(
                value: gender,
                child: Text(gender),
              ),
            )
                .toList(),
            onChanged: (value) {
              if (value != null) setState(() => _selectedGender = value);
            },
          )
              : Text(
            _selectedGender,
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
}
