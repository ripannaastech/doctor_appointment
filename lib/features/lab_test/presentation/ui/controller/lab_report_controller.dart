import 'package:get/get.dart';

// import your network + shared prefs
// import 'network_service.dart';
// import 'shared_prefs.dart';

import '../../../../../core/services/api_service/api_service.dart';
import '../../../../../core/services/shared_preferance/shared_preferance.dart';
import '../../../data/models/lab_test_models.dart';

class LabReportController extends GetxController {
  final _net = NetworkService().client;
  final _prefs = SharedPrefs();

  // List screen state
  RxBool loadingList = false.obs;
  RxString listError = ''.obs;
  RxList<LabTestSummary> labTests = <LabTestSummary>[].obs;
  RxInt totalCount = 0.obs;

  // Details screen state
  RxBool loadingDetails = false.obs;
  RxString detailsError = ''.obs;
  Rxn<LabTestDetail> selectedLabTest = Rxn<LabTestDetail>();

  // You can keep last used patient id for refresh
  String? _lastPatientId;

  /// Optional: if you store patient id in prefs
  Future<String?> getPatientIdFromPrefs() async {
    return await _prefs.getString(SharedPrefs.patientId);
  }

  /// GET /api/v1/medical-records/erpnext/lab-tests/{patient_id}
  Future<void> fetchLabTests({String? patientId}) async {
    loadingList.value = true;
    listError.value = '';

    try {
      final pid = patientId ?? _lastPatientId ?? await getPatientIdFromPrefs();
      if (pid == null || pid.isEmpty) {
        labTests.clear();
        totalCount.value = 0;
        listError.value = 'Patient ID not found';
        return;
      }

      _lastPatientId = pid;

      final path = '/api/v1/medical-records/erpnext/lab-tests/$pid';
      final res = await _net.getRequest(path);

      if (res.isSuccess && res.statusCode == 200) {
        final root = Map<String, dynamic>.from(res.responseData);

        final data = (root['data'] as List?) ?? const [];
        final parsed = data
            .whereType<Map>()
            .map((e) => LabTestSummary.fromJson(Map<String, dynamic>.from(e)))
            .toList();

        labTests.assignAll(parsed);
        totalCount.value = _intOrZero(root['count']);
      } else {
        listError.value =  'Failed to load lab tests';
      }
    } catch (e) {
      listError.value = 'Failed to load lab tests';
    } finally {
      loadingList.value = false;
    }
  }

  /// GET /api/v1/medical-records/erpnext/lab-test/{lab_test_id}
  Future<void> fetchLabTestDetails(String labTestId) async {
    loadingDetails.value = true;
    detailsError.value = '';
    selectedLabTest.value = null;

    try {
      final path = '/api/v1/medical-records/erpnext/lab-test/$labTestId';
      final res = await _net.getRequest(path);

      if (res.isSuccess && res.statusCode == 200) {
        final root = Map<String, dynamic>.from(res.responseData);
        final data = Map<String, dynamic>.from(root['data'] ?? {});
        selectedLabTest.value = LabTestDetail.fromJson(data);
      } else {
        detailsError.value = 'Failed to load lab test details';
      }
    } catch (e) {
      detailsError.value = 'Failed to load lab test details';
    } finally {
      loadingDetails.value = false;
    }
  }

  /// For pull-to-refresh
  Future<void> refreshLabTests() async {
    await fetchLabTests(patientId: _lastPatientId);
  }

  int _intOrZero(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    return int.tryParse(v.toString()) ?? 0;
  }
}
