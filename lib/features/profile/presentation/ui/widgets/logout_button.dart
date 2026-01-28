import 'package:doctor_appointment/features/auth/presentation/ui/screens/splash_screen.dart';
import 'package:doctor_appointment/features/dashboard/presentation/ui/controller/dashboard_controller.dart';
import 'package:doctor_appointment/features/home/presentation/ui/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../l10n/app_localizations.dart';
import '../../../../../core/services/shared_preferance/shared_preferance.dart';
import '../../../../auth/presentation/ui/controller/auth_controller.dart';
import '../../../../auth/presentation/ui/screens/sign_in_screen.dart';
import '../controller/profle_controller.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  Future<void> _logout(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.logout),
        content: Text(l10n.logoutConfirmMessage ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.logout),
          ),
        ],
      ),
    );

    if (ok != true) return;

    await SharedPrefs.clearAll();

    Navigator.pushReplacementNamed(context,SplashScreen.name); // or AuthScreen.name
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      height: 48.h,
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TextButton.icon(
        style: TextButton.styleFrom(
          foregroundColor: Colors.red.shade600,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        onPressed: () => _logout(context),
        icon: Icon(Icons.logout, size: 20.sp),
        label: Text(
          l10n.logout,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
