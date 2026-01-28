import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class NotificationPermission {
  static Future<bool> request() async {
    // permission_handler handles iOS + Android 13+ correctly
    if (!Platform.isAndroid && !Platform.isIOS) return true;

    final status = await Permission.notification.status;

    if (status.isGranted) return true;

    final result = await Permission.notification.request();

    if (result.isGranted) return true;

    // Optional: if permanently denied, open settings
    if (result.isPermanentlyDenied) {
      await openAppSettings();
    }

    return false;
  }
}
