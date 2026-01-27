import 'dart:convert';
import 'package:get/get.dart';

import '../../../../../core/services/shared_preferance/shared_preferance.dart';
import '../../../../profile/models/user_profile_model.dart';

class HomeController extends GetxController {
  final _prefs = SharedPrefs();

  final RxString name = '—'.obs;
  final RxBool loading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadName();
  }

  Future<void> loadName() async {
    loading.value = true;

    try {
      final raw = await _prefs.getString(SharedPrefs.patientProfile);

      if (raw == null || raw.trim().isEmpty) {
        name.value = '—';
        loading.value = false;
        return;
      }

      final map = jsonDecode(raw) as Map<String, dynamic>;
      final profile = UserProfile.fromJson(map);

      // ✅ Use patientName safely
      final patientName = (profile.patientName ?? '').trim();
      name.value = patientName.isNotEmpty ? patientName : '—';
    } catch (_) {
      name.value = '—';
    } finally {
      loading.value = false;
    }
  }
}
