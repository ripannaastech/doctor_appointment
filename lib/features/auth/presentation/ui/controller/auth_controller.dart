import 'dart:convert';

import 'package:get/get.dart';
import '../../../../../core/services/api_service/api_service.dart';
import '../../../../../core/services/shared_preferance/shared_preferance.dart';
import '../../../data/models/otp_send_response.dart';
import '../../../data/models/otp_verify_response.dart';

class AuthControllerGetx extends GetxController {
  final _net = NetworkService().client;
  final _prefs = SharedPrefs();

  RxBool loading = false.obs;

  // State for UI
  Rxn<OtpSendRes> otpSendRes = Rxn<OtpSendRes>();
  Rxn<OtpVerifyRes> otpVerifyRes = Rxn<OtpVerifyRes>();

  // You may want to store last phone
  RxString lastPhone = ''.obs;

  String _normalizePhone(String input) {
    // Your backend returned +88061789374 from input 61789374
    // If you want, keep input and let backend normalize
    return input.trim();
  }

  /// POST /api/v1/auth/erpnext/request-otp?phone=...
  Future<bool> requestOtpErpnext(String phone) async {
    loading.value = true;
    try {
      final p = _normalizePhone(phone);
      lastPhone.value = p;

      // ✅ Query param endpoint
      final path = '/api/v1/auth/erpnext/request-otp?phone=$p';

      final response = await _net.postRequest(
        path,
        body: null, // ✅ no body
      );

      loading.value = false;

      if (response.isSuccess && response.statusCode == 200) {
        final data = Map<String, dynamic>.from(response.responseData);
        final res = OtpSendRes.fromJson(data);
        otpSendRes.value = res;

        Get.snackbar('Success', res.message);

        // optional: store phone formatted from backend
        await _prefs.setString('last_phone', res.phone);

        return true;
      } else {
        Get.snackbar('Error', response.errorMessage ?? 'OTP request failed');
        return false;
      }
    } catch (e) {
      loading.value = false;
      Get.snackbar('Error', 'Something went wrong: $e');
      return false;
    }
  }

  /// Resend OTP (ERPNext-only mode)
  /// Same endpoint as request OTP, just called again from OTP screen.
  Future<bool> resendOtpErpnext(String phone) async {
    loading.value = true;
    try {
      final p = phone.trim();
      lastPhone.value = p;

      final path = '/api/v1/auth/erpnext/request-otp?phone=$p';

      final response = await _net.postRequest(
        path,
        body: null, // ✅ no body
      );

      loading.value = false;

      if (response.isSuccess && response.statusCode == 200) {
        final data = Map<String, dynamic>.from(response.responseData);
        final res = OtpSendRes.fromJson(data);
        otpSendRes.value = res;

        Get.snackbar('Success', 'OTP resent successfully');

        // optional: persist phone returned by backend
        await _prefs.setString('last_phone', res.phone);

        return true;
      } else {
        Get.snackbar('Error', response.errorMessage ?? 'Resend OTP failed');
        return false;
      }
    } catch (e) {
      loading.value = false;
      Get.snackbar('Error', 'Something went wrong: $e');
      return false;
    }
  }


  /// POST /api/v1/auth/erpnext/verify-otp?phone=...&otp=...
  Future<bool> verifyOtpErpnext({
    required String phone,
    required String otp,
  }) async {
    loading.value = true;
    try {
      final p = _normalizePhone(phone);
      final o = otp.trim();

      final path = '/api/v1/auth/erpnext/verify-otp?phone=$p&otp=$o';

      final response = await _net.postRequest(
        path,
        body: null,
      );

      loading.value = false;

      if (response.isSuccess && response.statusCode == 200) {
        final data = Map<String, dynamic>.from(response.responseData);
        final res = OtpVerifyRes.fromJson(data);
        otpVerifyRes.value = res;

        Get.snackbar('Success', res.message);

        // ✅ If verified + login successful, save everything
        if (res.success == true) {
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
        }

        // ✅ Route based on new patient
        if (res.isNewPatient) {
          // Get.toNamed(RegisterScreen.route, arguments: {'phone': p});
        } else {
          // Get.offAllNamed(HomeScreen.route);
        }

        return res.success;
      } else {
        Get.snackbar('Error', response.errorMessage ?? 'OTP verify failed');
        return false;
      }
    } catch (e) {
      loading.value = false;
      Get.snackbar('Error', 'Something went wrong: $e');
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
    loading.value = true;
    try {
      final p = _normalizePhone(phone);

      final qp = <String, String>{
        'phone': p,
        'patient_name': patientName.trim(),
        'sex': sex,
        if (dob != null && dob.trim().isNotEmpty) 'dob': dob.trim(),
        if (email != null && email.trim().isNotEmpty) 'email': email.trim(),
        if (bloodGroup != null && bloodGroup.trim().isNotEmpty) 'blood_group': bloodGroup.trim(),
      };

      // If your client supports queryParameters, use it.
      // Otherwise build URL manually:
      final query = qp.entries.map((e) => '${Uri.encodeQueryComponent(e.key)}=${Uri.encodeQueryComponent(e.value)}').join('&');
      final path = '/api/v1/auth/erpnext/patient/register?$query';

      final response = await _net.postRequest(path, body: null);

      loading.value = false;

      if (response.isSuccess && response.statusCode == 200) {
        // backend might return patient doc / token etc
        Get.snackbar('Success', 'Registration completed');

        // optional: persist phone
        await _prefs.setString('last_phone', p);

        return true;
      } else {
        Get.snackbar('Error', response.errorMessage ?? 'Registration failed');
        return false;
      }
    } catch (e) {
      loading.value = false;
      Get.snackbar('Error', 'Something went wrong: $e');
      return false;
    }
  }
}
