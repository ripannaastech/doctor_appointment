import 'package:doctor_appointment/app/asset_paths.dart';
import 'package:doctor_appointment/features/notification/presentation/ui/notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../l10n/app_localizations.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/services/shared_preferance/shared_preferance.dart';
import '../../../../profile/models/user_profile_model.dart';

class HomeTopBar extends StatefulWidget {
  const HomeTopBar({super.key});

  @override
  State<HomeTopBar> createState() => _HomeTopBarState();
}

class _HomeTopBarState extends State<HomeTopBar> {
  final _prefs = SharedPrefs();

  String _name = '—';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadName();
  }

  String timeGreeting(AppLocalizations l10n) {
    final h = DateTime.now().hour;

    if (h >= 5 && h < 12) return l10n.goodMorning;
    if (h >= 12 && h < 17) return l10n.goodAfternoon;
    if (h >= 17 && h < 21) return l10n.goodEvening;
    return l10n.goodNight;
  }

  Future<void> _loadName() async {
    try {
      final raw = await _prefs.getString(SharedPrefs.patientProfile);

      if (raw == null || raw.trim().isEmpty) {
        if (!mounted) return;
        setState(() {
          _name = '—';
          _loading = false;
        });
        return;
      }

      final map = jsonDecode(raw) as Map<String, dynamic>;
      final profile = UserProfile.fromJson(map);

      final first = profile.firstName?.trim() ?? '';
      final last = profile.lastName?.trim() ?? '';

      final fullName = [first, last]
          .where((e) => e.isNotEmpty)
          .join(' ');

      if (!mounted) return;
      setState(() {
        _name = fullName.isNotEmpty ? fullName : '—';
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _name = '—';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Row(
        children: [
          /// Profile Image
          Container(
            height: 44.w,
            width: 44.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12.r,
                  offset: Offset(0, 6.h),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(
              AssetPaths.profilePicture,
              fit: BoxFit.cover,
            ),
          ),

          SizedBox(width: 12.w),

          /// Greeting + Name
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    timeGreeting(l10n), // ✅ dynamic greeting
                    style: TextStyle(
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF7B8194),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    _loading ? l10n.loading : _name, // ✅ name from prefs
                    style: TextStyle(
                      fontSize: 16.5.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF141A2A),
                      height: 1.15,
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// Notification Button
          Container(
            height: 44.w,
            width: 44.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12.r,
                  offset: Offset(0, 6.h),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, NotificationsScreen.name);
              },
              icon: Icon(
                Icons.notifications_none_rounded,
                size: 22.sp,
                color: const Color(0xFF141A2A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

