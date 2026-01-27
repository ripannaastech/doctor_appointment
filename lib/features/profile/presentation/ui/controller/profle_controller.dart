import 'dart:convert';
import 'package:get/get.dart';

import '../../../../../app/app_snackbar.dart';
import '../../../../../core/services/api_service/api_service.dart';
import '../../../../../core/services/shared_preferance/shared_preferance.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../models/user_profile_model.dart';

import 'dart:convert';
import 'package:get/get.dart';


class ProfileControllerGetx extends GetxController {
  final _net = NetworkService().client;
  final _prefs = SharedPrefs();

  RxBool loading = false.obs;

  // UI state
  Rxn<UserProfile> profile = Rxn<UserProfile>();

  // Optional: for forms
  RxString errorText = ''.obs;

  // ✅ Localization getter
  AppLocalizations get l10n => AppLocalizations.of(Get.context!)!;

  /// Resolve user_id from prefs (ERPNext patient id)
  Future<String?> _getUserId() async {
    return await _prefs.getString(SharedPrefs.patientId);
  }

  /// Optional: load cached profile instantly (before API)
  Future<void> loadCachedProfile() async {
    try {
      final cached = await _prefs.getString(SharedPrefs.patientProfile);
      if (cached != null && cached.isNotEmpty) {
        final jsonMap = jsonDecode(cached) as Map<String, dynamic>;
        profile.value = UserProfile.fromJson(jsonMap);
      }
    } catch (_) {}
  }

  /// GET /api/v1/auth/user/{user_id}
  Future<bool> fetchProfile() async {
    loading.value = true;
    errorText.value = '';
    try {
      final userId = await _getUserId();
      if (userId == null || userId.isEmpty) {
        loading.value = false;
        errorText.value = l10n.patientIdNotFoundPleaseLoginAgain;
        AppSnackbar.error(l10n.error, errorText.value);
        return false;
      }

      final path = '/api/v1/auth/user/$userId';
      final response = await _net.getRequest(path);

      loading.value = false;

      if (response.isSuccess && response.statusCode == 200) {
        final data = Map<String, dynamic>.from(response.responseData);
        final res = UserProfile.fromJson(data);
        profile.value = res;

        // cache in prefs
        await _prefs.setString(
          SharedPrefs.patientProfile,
          jsonEncode(res.toJson()),
        );

        return true;
      } else {
        errorText.value = response.errorMessage ?? l10n.failedToLoadProfile;
        AppSnackbar.error(l10n.error, errorText.value);
        return false;
      }
    } catch (_) {
      loading.value = false;
      errorText.value = l10n.somethingWentWrong;
      AppSnackbar.error(l10n.error, errorText.value);
      return false;
    }
  }

  /// PUT /api/v1/auth/user/{user_id}
  /// Send only fields that you want to update
  Future<bool> updateProfile({
    String? patientName,
    String? firstName,
    String? lastName,
    String? email,
    String? sex,
    String? dob, // YYYY-MM-DD
    String? bloodGroup,
    String? territory,
    String? language,
  }) async {
    loading.value = true;
    errorText.value = '';
    try {
      final userId = await _getUserId();
      if (userId == null || userId.isEmpty) {
        loading.value = false;
        errorText.value = l10n.patientIdNotFoundPleaseLoginAgain;
        AppSnackbar.error(l10n.error, errorText.value);
        return false;
      }

      final body = <String, dynamic>{
        if (patientName != null) 'patient_name': patientName.trim(),
        if (firstName != null) 'first_name': firstName.trim(),
        if (lastName != null) 'last_name': lastName.trim(),
        if (email != null) 'email': email.trim(),
        if (sex != null) 'sex': sex.trim(),
        if (dob != null) 'dob': dob.trim(),
        if (bloodGroup != null) 'blood_group': bloodGroup.trim(),
        if (territory != null) 'territory': territory.trim(),
        if (language != null) 'language': language.trim(),
      };

      if (body.isEmpty) {
        loading.value = false;
        AppSnackbar.info(l10n.info, l10n.nothingToUpdate);
        return false;
      }

      final path = '/api/v1/auth/user/$userId';
      final response = await _net.putRequest(path, body: body);

      loading.value = false;

      if (response.isSuccess && (response.statusCode == 200 || response.statusCode == 201)) {
        // Some backends return updated user object, some return message only
        if (response.responseData is Map<String, dynamic>) {
          final data = Map<String, dynamic>.from(response.responseData);
          final updated = UserProfile.fromJson(data);
          profile.value = updated;

          await _prefs.setString(
            SharedPrefs.patientProfile,
            jsonEncode(updated.toJson()),
          );
        } else {
          await fetchProfile();
        }

        AppSnackbar.success(l10n.success, l10n.profileUpdated);
        return true;
      } else {
        errorText.value = response.errorMessage ?? l10n.failedToUpdateProfile;
        AppSnackbar.error(l10n.error, errorText.value);
        return false;
      }
    } catch (_) {
      loading.value = false;
      errorText.value = l10n.somethingWentWrong;
      AppSnackbar.error(l10n.error, errorText.value);
      return false;
    }
  }
}
