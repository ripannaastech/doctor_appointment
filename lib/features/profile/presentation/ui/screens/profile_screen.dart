import 'package:doctor_appointment/app/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controller/profle_controller.dart';
import '../widgets/language_card_profile.dart';
import '../widgets/logout_button.dart';
import '../widgets/personal_information.dart';
import '../widgets/profile_header.dart';

const kPrimaryBlue = Color(0xFF2F80ED);
const kBackground = Color(0xFFF8F9FA);
const kTextDark = Color(0xFF2D3748);
const kTextGray = Color(0xFF718096);
const kCardRadius = 16.0;
const kPadding = 20.0;


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  static const String name = '/profileScreen';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isEditing = false;

  late final ProfileControllerGetx pc;

  @override
  void initState() {
    super.initState();

    pc = Get.put(ProfileControllerGetx(), permanent: true);

    // ✅ instant load then refresh
    pc.loadCachedProfile();
    pc.fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: Column(
        children: [
          ProfileHeader(isEditing: isEditing, onToggle: _toggleEdit),

          Expanded(
            child: Obx(() {
              // optional loading indicator
              if (pc.loading.value && pc.profile.value == null) {
                return const Center(child: CircularProgressIndicator());
              }

              return SingleChildScrollView(
                padding: EdgeInsets.all(kPadding.w),
                child: Column(
                  children: [
                    PersonalInfoCard(
                      isEditing: isEditing,
                      onToggleEdit: _toggleEdit,
                      // ✅ pass profile if your card supports it
                      // profile: pc.profile.value,
                    ),
                    SizedBox(height: 20.h),
                    LanguageCard(),
                    SizedBox(height: 20.h),
                    LogoutButton(),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  void _toggleEdit() {
    setState(() => isEditing = !isEditing);
  }
}








