import 'package:get/get.dart';
import '../../../../../app/app_snackbar.dart';
import '../../../../../core/services/api_service/api_service.dart';
import '../../../../../core/services/shared_preferance/shared_preferance.dart';
import 'dart:async';
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
        AppSnackbar.error('Error', errorText.value);

        return false;
      }
    } catch (e) {
      errorText.value = 'Something went wrong: $e';
      AppSnackbar.error('Error', errorText.value);
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

      if (q.isNotEmpty) {
        // NOTE: If your search endpoint also supports department,
        // you can append &department=$dep (only if backend supports).
        path =
        '/api/v1/doctors/erpnext/search/by-name?name=${Uri.encodeQueryComponent(q)}';
      } else {

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
      AppSnackbar.error('Error', errorText.value);
      return false;
    } finally {
      loadingPractitioners.value = false;
    }
  }
// inside BookingController

  final RxBool loadingDoctorAppointments = false.obs;

  /// date -> set of booked times (HH:mm:ss)
  final RxMap<String, Set<String>> bookedSlotsByDate = <String, Set<String>>{}.obs;

  /// GET /api/v1/appointments/erpnext/all?practitioner=...&offset=0
  Future<bool> fetchDoctorBookedAppointments({
    required String practitionerName,
    int offset = 0,
  }) async {
    loadingDoctorAppointments.value = true;
    errorText.value = '';

    try {
      final p = practitionerName.trim();
      if (p.isEmpty) return false;

      final path =
          '/api/v1/appointments/erpnext/all?practitioner=${Uri.encodeQueryComponent(p)}&offset=$offset';

      final response = await _net.getRequest(path);

      if (response.isSuccess && response.statusCode == 200) {
        final body = Map<String, dynamic>.from(response.responseData);

        final list = (body['data'] as List? ?? [])
            .map((e) => Map<String, dynamic>.from(e))
            .toList();

        final Map<String, Set<String>> map = {};

        for (final a in list) {
          final date = (a['appointment_date'] ?? '').toString(); // yyyy-MM-dd
          final time = (a['appointment_time'] ?? '').toString(); // HH:mm:ss (sometimes H:mm:ss)
          final status = (a['status'] ?? '').toString().toLowerCase();


          final isActive = status != 'cancelled' && status != 'closed';
          if (!isActive) continue;

          if (date.isEmpty || time.isEmpty) continue;

          // normalize time to HH:mm:ss
          final fixedTime = _normalizeHHmmss(time);

          map.putIfAbsent(date, () => <String>{}).add(fixedTime);
        }

        bookedSlotsByDate.assignAll(map);
        return true;
      } else {
        errorText.value = _extractError(response) ?? 'Failed to load doctor appointments';
        return false;
      }
    } catch (e) {
      errorText.value = 'Something went wrong: $e';
      return false;
    } finally {
      loadingDoctorAppointments.value = false;
    }
  }

  String _normalizeHHmmss(String t) {
    // handles "9:00:00" -> "09:00:00"
    final parts = t.split(':');
    if (parts.length < 2) return t;
    final h = parts[0].padLeft(2, '0');
    final m = parts[1].padLeft(2, '0');
    final s = (parts.length >= 3 ? parts[2] : '00').padLeft(2, '0');
    return '$h:$m:$s';
  }

  // -------------------------
  // Appointments (ERPNext)
  // -------------------------

  /// GET /api/v1/appointments/erpnext/all
  Future<bool> fetchAllAppointments() async {
    loadingAppointments.value = true;
    errorText.value = '';

    try {
      final pid = await _getUserId();
      if (pid == null || pid.isEmpty) {
        errorText.value = 'Patient ID not found';
        AppSnackbar.error('Error', errorText.value);
        return false;
      }

      final path = '/api/v1/appointments/erpnext/all?patient=$pid';
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
      AppSnackbar.error('Error', errorText.value);
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
        AppSnackbar.error('Error', errorText.value);
        return false;
      }
    } catch (e) {
      errorText.value = 'Something went wrong: $e';
      AppSnackbar.error('Error', errorText.value);
      return false;
    } finally {
      cancelingAppointment.value = false;
    }
  }

  /// POST /api/v1/appointments/erpnext/book
  ///
  /// This uses patientId from prefs automatically unless you pass payload.patient yourself.
  Future<String?> bookAppointment({
    required String practitioner,
    required String department,
    required String appointmentDate,
    required String appointmentTime,
    required double feeAmount,
    String? notes,
    String? patientIdOverride,
  }) async {
    loading.value = true;
    errorText.value = '';

    try {
      final pid = patientIdOverride ?? await _getUserId();
      if (pid == null || pid.isEmpty) {
        errorText.value = 'Patient ID not found';
        AppSnackbar.error('Error', errorText.value);
        return null;
      }

      const path = '/api/v1/payments/erpnext/book-appointment';

      final query = <String, dynamic>{
        'patient_id': pid,
        'practitioner': practitioner,
        'appointment_date': appointmentDate,
        'appointment_time': appointmentTime,
        'fee_amount': feeAmount.toString(),
        'department': department,
        if (notes != null && notes.trim().isNotEmpty) 'notes': notes.trim(),
      };

      final response = await _net.postRequest(path, query: query,body: query);

      if (response.isSuccess && (response.statusCode == 200 || response.statusCode == 201)) {
        final data = Map<String, dynamic>.from(response.responseData ?? {});
        final appt = Map<String, dynamic>.from(data['appointment'] ?? {});
        final id = appt['appointment_id']?.toString();

        if (id == null || id.isEmpty) {
          errorText.value = 'Booked but appointment_id missing';
          AppSnackbar.error('Error', errorText.value);
          return null;
        }

        await fetchAllAppointments();
        return id;
      } else {
        errorText.value = _extractError(response) ?? 'Failed to book appointment';
        AppSnackbar.error('Error', errorText.value);
        return null;
      }
    } catch (e) {
      errorText.value = 'Something went wrong: $e';
      AppSnackbar.error('Error', errorText.value);
      return null;
    } finally {
      loading.value = false;
    }
  }



  Future<bool> payAppointment({
    required String appointmentId,
    required String paymentMethod, // "cash" or "online"
    String? phoneNumber,
    String? pin,
  }) async {
    loading.value = true;
    errorText.value = '';

    try {
      final method = paymentMethod.trim().toLowerCase();
      if (method == 'cash') {
        final path = '/api/v1/payments/erpnext/pay-appointment/$appointmentId';
        final query = {'payment_method': 'cash'};

        final response = await _net.postRequest(path, query: query, body: query);

        if (response.isSuccess &&
            (response.statusCode == 200 || response.statusCode == 201)) {
          await fetchAllAppointments();
          return true;
        } else {
          errorText.value = _extractError(response) ?? 'Cash payment failed';
          AppSnackbar.error('Error', errorText.value);
          return false;
        }
      }

      if (method == 'online') {
        final phone = (phoneNumber ?? '').trim();
        final p = (pin ?? '').trim();

        if (phone.isEmpty || p.isEmpty) {
          errorText.value = 'Phone number and PIN are required for online payment';
          AppSnackbar.error('Error', errorText.value);
          return false;
        }

        final path = '/api/v1/payments/mobile/evc/pay-appointment/$appointmentId';
        final query = {
          'phone_number': phone,
          'pin': p,
        };

        // some servers accept GET, but safest is POST (your client uses postRequest)
        final response = await _net.postRequest(path, query: query, body: {});

        if (response.isSuccess &&
            (response.statusCode == 200 || response.statusCode == 201)) {
          await fetchAllAppointments();
          return true;
        } else {
          errorText.value = _extractError(response) ?? 'Online payment failed';
          AppSnackbar.error('Error', errorText.value);
          return false;
        }
      }

      errorText.value = 'Invalid payment method: $paymentMethod';
      AppSnackbar.error('Error', errorText.value);
      return false;
    } catch (e) {
      errorText.value = 'Something went wrong: $e';
      AppSnackbar.error('Error', errorText.value);
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




