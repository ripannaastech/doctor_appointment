
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:doctor_appointment/l10n/app_localizations.dart';
import 'package:get/get.dart';

import 'app/app.dart';
import 'app/controllers/language_controller.dart';
import 'app/utils/app_version_service.dart';
import 'package:device_preview/device_preview.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppVersionService.getCurrentAppVersion();
  runApp(
    DevicePreview(
      enabled: !bool.fromEnvironment('dart.vm.product'),
      builder: (context) =>  AlIshanSpecialistHospital(),
    ),
  );
}