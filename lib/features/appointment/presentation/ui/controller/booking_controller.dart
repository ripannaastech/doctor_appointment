import 'package:get/get.dart';

import '../../../../../core/services/api_service/api_service.dart';
import '../../../../../core/services/shared_preferance/shared_preferance.dart';

import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';

import '../../../models/data/appoinment_model.dart';
import '../../../models/data/department_model.dart';
import '../../../models/data/practitioner_model.dart';




class BookingController extends GetxController {
  final _net = NetworkService().client;
  final _prefs = SharedPrefs();

  // -------------------------
  // Loading + error
  // -------------------------
  final RxBool loadingDepartments = false.obs;
  final RxBool loadingPractitioners = false.obs;

  RxBool loading = false.obs;

  // Appointments
  final RxBool loadingAppointments = false.obs;
  final RxBool bookingAppointment = false.obs;
  final RxBool cancelingAppointment = false.obs;

  final RxString errorText = ''.obs;

  // -------------------------
  // Data (UI state)
  // -------------------------
  final RxList<Department> departments = <Department>[].obs;
  final RxList<Practitioner> practitioners = <Practitioner>[].obs;

  // Appointments
  final RxList<AppointmentSummary> appointments = <AppointmentSummary>[].obs;
  final RxInt appointmentCount = 0.obs;

  // -------------------------
  // Filters / Search
  // -------------------------
  final RxString selectedDepartment = ''.obs; // department name
  final RxString searchQuery = ''.obs; // doctor name search
  Worker? _searchDebounce;
// selection
  RxInt selectedPractitionerIndex = (-1).obs;
  Rxn<Practitioner> selectedPractitioner = Rxn<Practitioner>();







  @override
  void onInit() {
    super.onInit();

    _searchDebounce = debounce(
      searchQuery,
          (_) => fetchPractitioners(),
      time: const Duration(milliseconds: 400),
    );
  }

  @override
  void onClose() {
    _searchDebounce?.dispose();
    super.onClose();
  }

  // -------------------------
  // Pref helpers
  // -------------------------
  Future<String?> _getUserId() async {
    return await _prefs.getString(SharedPrefs.patientId);
  }

  // -------------------------
  // Departments
  // -------------------------
  Future<bool> fetchDepartments({int offset = 0}) async {
    loadingDepartments.value = true;
    errorText.value = '';

    try {
      final path = '/api/v1/doctors/erpnext/departments?offset=$offset';
      final response = await _net.getRequest(path);

      if (response.isSuccess && response.statusCode == 200) {
        final body = Map<String, dynamic>.from(response.responseData);

        final list = (body['data'] as List? ?? [])
            .map((e) => Department.fromJson(Map<String, dynamic>.from(e)))
            .toList();

        list.sort((a, b) {
          final ad = (a.department ?? a.name ?? '').toLowerCase();
          final bd = (b.department ?? b.name ?? '').toLowerCase();
          return ad.compareTo(bd);
        });

        departments.assignAll(list);
        return true;
      } else {
        errorText.value = _extractError(response) ?? 'Failed to load departments';
        Get.snackbar('Error', errorText.value);
        return false;
      }
    } catch (e) {
      errorText.value = 'Something went wrong: $e';
      Get.snackbar('Error', errorText.value);
      return false;
    } finally {
      loadingDepartments.value = false;
    }
  }

  // -------------------------
  // Practitioners
  // -------------------------
  Future<bool> fetchPractitioners({int offset = 0}) async {
    loadingPractitioners.value = true;
    errorText.value = '';

    try {
      final dep = selectedDepartment.value.trim();
      final q = searchQuery.value.trim();

      String path;

      // ✅ If user typed something, use your search endpoint
      if (q.isNotEmpty) {
        // NOTE: If your search endpoint also supports department,
        // you can append &department=$dep (only if backend supports).
        path =
        '/api/v1/doctors/erpnext/search/by-name?name=${Uri.encodeQueryComponent(q)}';
      } else {
        // ✅ Normal list endpoint (department filter)
        final params = <String, String>{};
        if (dep.isNotEmpty) params['department'] = dep;

        final queryString = params.entries
            .map((e) => '${e.key}=${Uri.encodeQueryComponent(e.value)}')
            .join('&');

        path = queryString.isEmpty
            ? '/api/v1/doctors/erpnext/practitioners'
            : '/api/v1/doctors/erpnext/practitioners?$queryString';
      }

      final response = await _net.getRequest(path);

      if (response.isSuccess && response.statusCode == 200) {
        final body = Map<String, dynamic>.from(response.responseData);

        final list = (body['data'] as List? ?? [])
            .map((e) => Practitioner.fromJson(Map<String, dynamic>.from(e)))
            .toList();

        // Optional: Active first
        list.sort((a, b) {
          final aActive = (a.status ?? '').toLowerCase() == 'active';
          final bActive = (b.status ?? '').toLowerCase() == 'active';
          if (aActive == bActive) return 0;
          return aActive ? -1 : 1;
        });

        practitioners.assignAll(list);
        return true;
      } else {
        practitioners.clear();
        errorText.value = _extractError(response) ?? 'Failed to load practitioners';
        return false;
      }
    } catch (e) {
      practitioners.clear();
      errorText.value = 'Something went wrong: $e';
      Get.snackbar('Error', errorText.value);
      return false;
    } finally {
      loadingPractitioners.value = false;
    }
  }

  // -------------------------
  // Appointments (ERPNext)
  // -------------------------

  /// GET /api/v1/appointments/erpnext/all
  Future<bool> fetchAllAppointments() async {
    loadingAppointments.value = true;
    errorText.value = '';

    try {
      final path = '/api/v1/appointments/erpnext/all';
      final response = await _net.getRequest(path);

      if (response.isSuccess && response.statusCode == 200) {
        final body = Map<String, dynamic>.from(response.responseData);

        final list = (body['data'] as List? ?? [])
            .map((e) => AppointmentSummary.fromJson(Map<String, dynamic>.from(e)))
            .toList();

        // Optional: sort by date+time DESC (latest first)
        list.sort((a, b) {
          final aKey = '${a.appointmentDate} ${a.appointmentTime}';
          final bKey = '${b.appointmentDate} ${b.appointmentTime}';
          return bKey.compareTo(aKey);
        });

        appointments.assignAll(list);
        appointmentCount.value = _intOrZero(body['count']);
        return true;
      } else {
        errorText.value =
            _extractError(response) ?? 'Failed to load appointments';
        return false;
      }
    } catch (e) {
      errorText.value = 'Something went wrong: $e';
      Get.snackbar('Error', errorText.value);
      return false;
    } finally {
      loadingAppointments.value = false;
    }
  }

  /// POST /api/v1/appointments/erpnext/{appointment_id}/cancel
  Future<bool> cancelAppointment(String appointmentId) async {
    cancelingAppointment.value = true;
    errorText.value = '';

    try {
      final path = '/api/v1/appointments/erpnext/$appointmentId/cancel';
      final response = await _net.postRequest(path, body: {});

      if (response.isSuccess && (response.statusCode == 200 || response.statusCode == 201)) {
        // Refresh list
        await fetchAllAppointments();
        return true;
      } else {
        errorText.value =
            _extractError(response) ?? 'Failed to cancel appointment';
        Get.snackbar('Error', errorText.value);
        return false;
      }
    } catch (e) {
      errorText.value = 'Something went wrong: $e';
      Get.snackbar('Error', errorText.value);
      return false;
    } finally {
      cancelingAppointment.value = false;
    }
  }

  /// POST /api/v1/appointments/erpnext/book
  ///
  /// This uses patientId from prefs automatically unless you pass payload.patient yourself.
  Future<bool> bookAppointment({
    required String practitioner,
    required String department,
    required String appointmentDate, // "YYYY-MM-DD"
    required String appointmentTime, // "HH:mm:ss"
    required double feeAmount,       // ✅ REQUIRED by API
    String? notes,
    String? patientIdOverride,
  }) async {
    bookingAppointment.value = true;
    errorText.value = '';

    try {
      final pid = patientIdOverride ?? await _getUserId();
      if (pid == null || pid.isEmpty) {
        errorText.value = 'Patient ID not found';
        Get.snackbar('Error', errorText.value);
        return false;
      }

      // ✅ Correct endpoint from your docs
      const path = '/api/v1/payments/erpnext/book-appointment';

      // ✅ API expects QUERY params
      final query = <String, dynamic>{
        'patient_id': pid,
        'practitioner': practitioner,
        'appointment_date': appointmentDate,
        'appointment_time': appointmentTime,
        'fee_amount': feeAmount.toString(), // double/number
        'department': department,
        if (notes != null && notes.trim().isNotEmpty) 'notes': notes.trim(),
      };

      // ✅ If your postRequest supports queryParameters, use this:
      final response = await _net.postRequest(path, body: query);

      // If your client DOES NOT support queryParameters, use fallback below (commented):
      // final uri = Uri(path: path, queryParameters: query.map((k, v) => MapEntry(k, '$v')));
      // final response = await _net.postRequest(uri.toString());

      if (response.isSuccess && (response.statusCode == 200 || response.statusCode == 201)) {
        await fetchAllAppointments(); // refresh list
        return true;
      } else {
        errorText.value = _extractError(response) ?? 'Failed to book appointment';
        Get.snackbar('Error', errorText.value);
        return false;
      }
    } catch (e) {
      errorText.value = 'Something went wrong: $e';
      Get.snackbar('Error', errorText.value);
      return false;
    } finally {
      bookingAppointment.value = false;
    }
  }

  Future<bool> payAppointment({
    required String appointmentId,
    required String paymentMethod, // "cash" or "online"
  }) async {
    loading.value = true;
    errorText.value = '';

    try {
      final path = '/api/v1/payments/erpnext/pay-appointment/$appointmentId';
      final query = {'payment_method': paymentMethod};

      final response = await _net.postRequest(path, body: query);

      if (response.isSuccess && (response.statusCode == 200 || response.statusCode == 201)) {
        await fetchAllAppointments();
        return true;
      } else {
        errorText.value = _extractError(response) ?? 'Payment failed';
        Get.snackbar('Error', errorText.value);
        return false;
      }
    } catch (e) {
      errorText.value = 'Something went wrong: $e';
      Get.snackbar('Error', errorText.value);
      return false;
    } finally {
      loading.value = false;
    }
  }

  // -------------------------
  // UI handlers
  // -------------------------
  Future<void> setDepartment(String? departmentName) async {
    selectedDepartment.value = (departmentName ?? '').trim();
    await fetchPractitioners();
  }

  void setSearchQuery(String value) {
    searchQuery.value = value;
  }

  Future<void> clearSearch() async {
    searchQuery.value = '';
    await fetchPractitioners();
  }

  Future<void> initBookingData() async {
    await fetchDepartments(offset: 0);
    await fetchPractitioners();
    await fetchAllAppointments();
  }

  // -------------------------
  // Helpers
  // -------------------------
  int _intOrZero(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    return int.tryParse(v.toString()) ?? 0;
  }

  /// Works with many backends:
  /// {message: "..."} or {error: "..."} or {detail: "..."}
  String? _extractError(dynamic response) {
    try {
      final data = response.responseData;
      if (data is Map) {
        if (data['message'] != null) return data['message'].toString();
        if (data['errorMessage'] != null) return data['errorMessage'].toString();
        if (data['error'] != null) return data['error'].toString();
        if (data['detail'] != null) return data['detail'].toString();
      }
      // if your NetworkResponse has errorMessage field, keep this safe:
      final em = response.errorMessage;
      if (em != null && em.toString().trim().isNotEmpty) return em.toString();
    } catch (_) {}
    return null;
  }
}




