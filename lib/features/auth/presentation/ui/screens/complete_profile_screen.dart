import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../app/app_colors.dart';
import '../../../../../app/asset_paths.dart';
import '../../../../../app/controllers/language_controller.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../dashboard/presentation/ui/screens/dashboard.dart';
import '../controller/auth_controller.dart';
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  static const String name = '/register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  // GetX controller
  final c = Get.find<AuthControllerGetx>();

  // fields
  final _nameCtrl = TextEditingController();
  final _dobCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  final RxString sex = 'Male'.obs;
  final RxnString bloodGroup = RxnString();

  String get phone {
    final route = ModalRoute.of(context);
    if (route == null) return c.lastPhone.value;

    final args = route.settings.arguments;
    if (args is Map<String, dynamic>) {
      final p = args['phone'];
      if (p != null) return p.toString();
    }

    return c.lastPhone.value;
  }


  @override
  void dispose() {
    _nameCtrl.dispose();
    _dobCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final first = DateTime(1900, 1, 1);
    final initial = DateTime(now.year - 18, now.month, now.day);

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: now,
    );

    if (picked == null) return;

    final mm = picked.month.toString().padLeft(2, '0');
    final dd = picked.day.toString().padLeft(2, '0');
    _dobCtrl.text = "${picked.year}-$mm-$dd";
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final ok = await c.registerPatientErpnext(
      phone: phone,
      patientName: _nameCtrl.text.trim(),
      sex: sex.value,
      dob: _dobCtrl.text.trim().isEmpty ? null : _dobCtrl.text.trim(),
      email: _emailCtrl.text.trim().isEmpty ? null : _emailCtrl.text.trim(),
      bloodGroup: bloodGroup.value,
    );

    if (!ok) return;
    Navigator.pushReplacementNamed(
      context,
      Dashboard.name,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    const TextStyle kLangTextStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
    );

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Form(
            key: _formKey,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 420.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 24.h),

                  Text(
                    l10n.welcome,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    l10n.pleaseCompleteYourProfile,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                  ),

                  SizedBox(height: 14.h),

                  Text(
                    phone,
                    style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade600),
                  ),

                  SizedBox(height: 32.h),

                  /// FULL NAME
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(l10n.fullName, style: TextStyle(fontSize: 16.sp)),
                  ),
                  SizedBox(height: 8.h),
                  TextFormField(
                    controller: _nameCtrl,
                    textAlignVertical: TextAlignVertical.center,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return l10n.fullName;
                      if (v.trim().length < 3) return "Enter a valid name";
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: l10n.enterYourFullName,
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(12.w),
                        child: SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: SvgPicture.asset(
                            AssetPaths.profileLogo,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h),

                  /// SEX
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(l10n.sex, style: TextStyle(fontSize: 14.sp)),
                  ),
                  SizedBox(height: 8.h),

                  // ✅ reactive dropdown
                  Obx(() {
                    return DropdownButtonFormField<String>(
                      value: sex.value,
                      isExpanded: true,
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.grey.shade700,
                      ),
                      dropdownColor: Colors.white,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                      decoration: InputDecoration(
                        hintText: l10n.sex,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(color: AppColors.themeColor, width: 1.5),
                        ),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 'Male',
                          child: Text(l10n.male, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400)),
                        ),
                        DropdownMenuItem(
                          value: 'Female',
                          child: Text(l10n.female, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400)),
                        ),
                      ],
                      onChanged: (v) => sex.value = (v ?? 'Male'),
                    );
                  }),

                  SizedBox(height: 20.h),

                  /// DOB
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(l10n.dateOfBirth, style: TextStyle(fontSize: 14.sp)),
                  ),
                  SizedBox(height: 8.h),
                  TextFormField(
                    controller: _dobCtrl,
                    readOnly: true,
                    onTap: _pickDob,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.calendar_today_outlined),
                      hintText: "YYYY-MM-DD",
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                    ),
                  ),

                  SizedBox(height: 20.h),

                  /// EMAIL
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(l10n.emailOptional, style: TextStyle(fontSize: 14.sp)),
                  ),
                  SizedBox(height: 8.h),
                  TextFormField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return null;
                      final ok = RegExp(r"^[^@]+@[^@]+\.[^@]+").hasMatch(v.trim());
                      return ok ? null : l10n.invalidEmail;
                    },
                    decoration: InputDecoration(
                      hintText: "example@email.com",
                      prefixIcon: const Icon(Icons.email_outlined),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                    ),
                  ),

                  SizedBox(height: 20.h),

                  /// BLOOD GROUP
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(l10n.bloodGroupOptional, style: TextStyle(fontSize: 14.sp)),
                  ),
                  SizedBox(height: 8.h),

                  // ✅ reactive dropdown
                  Obx(() {
                    return DropdownButtonFormField<String>(
                      value: bloodGroup.value,
                      isExpanded: true,
                      icon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey.shade700),
                      dropdownColor: Colors.white,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                      decoration: InputDecoration(
                        hintText: l10n.bloodGroupOptional,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(color: AppColors.themeColor, width: 1.5),
                        ),
                      ),
                      hint: Text(
                        l10n.bloodGroupOptional,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'A+', child: Text('A+')),
                        DropdownMenuItem(value: 'A-', child: Text('A-')),
                        DropdownMenuItem(value: 'B+', child: Text('B+')),
                        DropdownMenuItem(value: 'B-', child: Text('B-')),
                        DropdownMenuItem(value: 'O+', child: Text('O+')),
                        DropdownMenuItem(value: 'O-', child: Text('O-')),
                        DropdownMenuItem(value: 'AB+', child: Text('AB+')),
                        DropdownMenuItem(value: 'AB-', child: Text('AB-')),
                      ],
                      onChanged: (v) => bloodGroup.value = v,
                    );
                  }),

                  SizedBox(height: 24.h),

                  /// LANGUAGE
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(l10n.preferredLanguage, style: TextStyle(fontSize: 14.sp)),
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
                        child: _LanguageCard(
                          text: l10n.english,
                          code: 'en',
                          theme: theme,
                          textStyle: kLangTextStyle,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _LanguageCard(
                          text: l10n.somali,
                          code: 'so',
                          theme: theme,
                          textStyle: kLangTextStyle,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 32.h),

                  /// BUTTON
                  Obx(() {
                    return SizedBox(
                      width: double.infinity,
                      height: 56.h,
                      child: ElevatedButton(
                        onPressed: c.loading.value ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: c.loading.value
                            ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                            : Text(l10n.completeRegistration, style: TextStyle(fontSize: 16.sp)),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageCard extends StatelessWidget {
  final String text;
  final String code; // 'en' | 'so'
  final ThemeData theme;
  final TextStyle textStyle;

  const _LanguageCard({
    required this.text,
    required this.code,
    required this.theme,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final c = Get.find<LanguageController>();

    return InkWell(
      onTap: () => c.setLanguage(code),
      borderRadius: BorderRadius.circular(12.r),
      child: Obx(() {
        final isSelected = c.isSelected(code);

        return Container(
          height: 56.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? theme.primaryColor.withOpacity(0.08) : Colors.transparent,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected ? theme.primaryColor : Colors.grey.shade300,
              width: 1.5,
            ),
          ),
          child: Text(
            text,
            style: textStyle.copyWith(
              color: isSelected ? theme.primaryColor : Colors.black87,
            ),
          ),
        );
      }),
    );
  }
}

