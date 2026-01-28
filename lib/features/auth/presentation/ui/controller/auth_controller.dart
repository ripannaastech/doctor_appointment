import 'dart:convert';

import 'package:get/get.dart';
import '../../../../../app/app_snackbar.dart';
import '../../../../../core/services/api_service/api_service.dart';
import '../../../../../core/services/shared_preferance/shared_preferance.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../data/models/otp_send_response.dart';
import '../../../data/models/otp_verify_response.dart';




class AuthControllerGetx extends GetxController {
  final _net = NetworkService().client;
  final _prefs = SharedPrefs();

  RxBool loading = false.obs;

  // State for UI
  Rxn<OtpSendRes> otpSendRes = Rxn<OtpSendRes>();
  Rxn<OtpVerifyRes> otpVerifyRes = Rxn<OtpVerifyRes>();

  // Store last phone
  RxString lastPhone = ''.obs;

  AppLocalizations get l10n => AppLocalizations.of(Get.context!)!;

  String _normalizePhone(String input) => input.trim();

  //
  String _safeMsg(String? msg) =>
      (msg == null || msg.trim().isEmpty) ? l10n.somethingWentWrong : msg;

  //   
  void _setLoading(bool v) => loading.value = v;

  /// True if user has saved login state
  Future<bool> isLoggedIn() async {
    final b = await _prefs.getBool(SharedPrefs.isLoggedIn);
    if (b == true) return true;

    // fallback: token presence
    final token = await _prefs.getString(SharedPrefs.accessToken);
    return token != null && token.isNotEmpty;
  }

  /// Clear login state (logout)
  Future<void> logout() async {
    await SharedPrefs.clearAll();
  }

  /// POST /api/v1/auth/erpnext/request-otp?phone=...
  Future<bool> requestOtpErpnext(String phone) async {
    _setLoading(true);
    try {
      final p = _normalizePhone(phone);
      lastPhone.value = p;

      final path = '/api/v1/auth/erpnext/request-otp?phone=${Uri.encodeQueryComponent(p)}';

      final response = await _net.postRequest(path, body: null);

      _setLoading(false);

      if (response.isSuccess && response.statusCode == 200) {
        final data = Map<String, dynamic>.from(response.responseData);
        final res = OtpSendRes.fromJson(data);
        otpSendRes.value = res;


        AppSnackbar.success(l10n.success, res.message);

        // optional: persist phone returned by backend (formatted)
        if ((res.phone ?? '').isNotEmpty) {
          await _prefs.setString(SharedPrefs.lastPhone, res.phone!);
        } else {
          await _prefs.setString(SharedPrefs.lastPhone, p);
        }

        return true;
      } else {
        AppSnackbar.error(l10n.error, _safeMsg(response.errorMessage ?? l10n.otpRequestFailed));
        return false;
      }
    } catch (_) {
      _setLoading(false);
      AppSnackbar.error(l10n.error, l10n.somethingWentWrong);
      return false;
    }
  }

  /// Resend OTP (same endpoint)
  Future<bool> resendOtpErpnext(String phone) async {
    _setLoading(true);
    try {
      final p = _normalizePhone(phone);
      lastPhone.value = p;

      final path = '/api/v1/auth/erpnext/request-otp?phone=${Uri.encodeQueryComponent(p)}';

      final response = await _net.postRequest(path, body: null);

      _setLoading(false);

      if (response.isSuccess && response.statusCode == 200) {
        final data = Map<String, dynamic>.from(response.responseData);
        final res = OtpSendRes.fromJson(data);
        otpSendRes.value = res;

        AppSnackbar.success(l10n.success, l10n.otpResentSuccessfully);

        if ((res.phone ?? '').isNotEmpty) {
          await _prefs.setString(SharedPrefs.lastPhone, res.phone!);
        } else {
          await _prefs.setString(SharedPrefs.lastPhone, p);
        }

        return true;
      } else {
        AppSnackbar.error(l10n.error, _safeMsg(response.errorMessage ?? l10n.resendOtpFailed));
        return false;
      }
    } catch (_) {
      _setLoading(false);
      AppSnackbar.error(l10n.error, l10n.somethingWentWrong);
      return false;
    }
  }

  /// POST /api/v1/auth/erpnext/verify-otp?phone=...&otp=...
  Future<bool> verifyOtpErpnext({
    required String phone,
    required String otp,
  }) async {
    _setLoading(true);
    try {
      final p = _normalizePhone(phone);
      final o = otp.trim();

      final path =
          '/api/v1/auth/erpnext/verify-otp?phone=${Uri.encodeQueryComponent(p)}&otp=${Uri.encodeQueryComponent(o)}';

      final response = await _net.postRequest(path, body: null);

      _setLoading(false);

      if (response.isSuccess && response.statusCode == 200) {
        final data = Map<String, dynamic>.from(response.responseData);
        final res = OtpVerifyRes.fromJson(data);
        otpVerifyRes.value = res;

        if (res.success == true) {
          AppSnackbar.success(l10n.success, res.message);


          if ((res.accessToken ?? '').isNotEmpty) {
            await _prefs.setString(SharedPrefs.accessToken, res.accessToken!);
          }
          if ((res.tokenType ?? '').isNotEmpty) {
            await _prefs.setString(SharedPrefs.tokenType, res.tokenType!);
          }


          final pid = res.patient?.patientId;
          if ((pid ?? '').isNotEmpty) {
            await _prefs.setString(SharedPrefs.patientId, pid!);
          }

          if (res.patient != null) {
            await _prefs.setString(
              SharedPrefs.patientProfile,
              jsonEncode(res.patient!.toJson()),
            );
          }

          await _prefs.setBool(SharedPrefs.isLoggedIn, true);
          return true;
        } else {
          // server success=false case
          AppSnackbar.error(l10n.error, res.message);
          return false;
        }
      } else {
        AppSnackbar.error(l10n.error, _safeMsg(response.errorMessage ?? l10n.otpVerifyFailed));
        return false;
      }
    } catch (_) {
      _setLoading(false);
      AppSnackbar.error(l10n.error, l10n.somethingWentWrong);
      return false;
    }
  }

  /// POST /api/v1/auth/erpnext/patient/register?phone=...&patient_name=...
  Future<bool> registerPatientErpnext({
    required String phone,
    required String patientName,
    String sex = 'Male',
    String? dob, // YYYY-MM-DD
    String? email,
    String? bloodGroup, // A+, O-, etc
  }) async {
    _setLoading(true);
    try {
      final p = _normalizePhone(phone);

      final qp = <String, String>{
        'phone': p,
        'patient_name': patientName.trim(),
        'sex': sex,
        if (dob != null && dob.trim().isNotEmpty) 'dob': dob.trim(),
        if (email != null && email.trim().isNotEmpty) 'email': email.trim(),
        if (bloodGroup != null && bloodGroup.trim().isNotEmpty)
          'blood_group': bloodGroup.trim(),
      };

      final query = qp.entries
          .map((e) =>
      '${Uri.encodeQueryComponent(e.key)}=${Uri.encodeQueryComponent(e.value)}')
          .join('&');

      final path = '/api/v1/auth/erpnext/patient/register?$query';

      final response = await _net.postRequest(path, body: qp);

      _setLoading(false);

      if (response.isSuccess && response.statusCode == 200) {
        final data = Map<String, dynamic>.from(response.responseData ?? {});
        final patientMap = Map<String, dynamic>.from(data['patient'] ?? {});


        final patientId =
        (patientMap['patient_id'] ?? patientMap['patientId'])?.toString();

        if (patientId == null || patientId.isEmpty) {
          AppSnackbar.error(l10n.error, l10n.somethingWentWrong);
          return false;
        }

        await _prefs.setString(SharedPrefs.patientId, patientId);


        await _prefs.setString(SharedPrefs.patientProfile, jsonEncode(patientMap));


        await _prefs.setString(SharedPrefs.lastPhone, p);


        await _prefs.setBool(SharedPrefs.isLoggedIn, true);

        AppSnackbar.success(
          l10n.success,
          data['message']?.toString() ?? l10n.registrationCompleted,
        );

        return true;
      } else {
        AppSnackbar.error(
          l10n.error,
          _safeMsg(response.errorMessage ?? l10n.registrationFailed),
        );
        return false;
      }
    } catch (_) {
      _setLoading(false);
      AppSnackbar.error(l10n.error, l10n.somethingWentWrong);
      return false;
    }
  }

}
