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
  /// GET /api/v1/medical-records/erpnext/lab-test/{lab_test_id}
  /// + if missing test names/ranges, fetch template and merge by idx
  Future<void> fetchLabTestDetails(String labTestId) async {
    loadingDetails.value = true;
    detailsError.value = '';
    selectedLabTest.value = null;

    try {
      // 1) fetch lab test details
      final path = '/api/v1/medical-records/erpnext/lab-test/$labTestId';
      final res = await _net.getRequest(path);

      if (!(res.isSuccess && res.statusCode == 200)) {
        detailsError.value = 'Failed to load lab test details';
        return;
      }

      final root = Map<String, dynamic>.from(res.responseData);
      final data = Map<String, dynamic>.from(root['data'] ?? {});
      var detail = LabTestDetail.fromJson(data);

      // 2) detect if result rows are missing metadata (name/range/unit)
      final needsTemplate = detail.normalItems.isNotEmpty &&
          detail.normalItems.every((e) {
            final hasName = (e.labTestName ?? '').trim().isNotEmpty;
            final hasUom = (e.uom ?? '').trim().isNotEmpty;
            final hasRange = (e.normalRange ?? '').trim().isNotEmpty;
            return !(hasName || hasUom || hasRange);
          });

      // 3) get template name from detail JSON (ERPNext uses "template")
      final templateName = (data['template'] ?? '').toString().trim();

      if (needsTemplate && templateName.isNotEmpty) {
        final merged = await _mergeWithTemplate(
          detail: detail,
          templateName: templateName,
        );
        detail = merged;
      }

      selectedLabTest.value = detail;
    } catch (e) {
      detailsError.value = 'Failed to load lab test details';
    } finally {
      loadingDetails.value = false;
    }
  }

  Future<LabTestDetail> _mergeWithTemplate({
    required LabTestDetail detail,
    required String templateName,
  }) async {
    try {
      // ✅ adjust this endpoint if your backend wraps template under another route
      final tPath =
          '/api/v1/medical-records/erpnext/lab-test-template/$templateName';
      final tRes = await _net.getRequest(tPath);

      if (!(tRes.isSuccess && tRes.statusCode == 200)) return detail;

      final tRoot = Map<String, dynamic>.from(tRes.responseData);
      final tData = Map<String, dynamic>.from(tRoot['data'] ?? {});

      final tItemsRaw = (tData['normal_test_items'] as List?) ?? const [];
      final templateItems = tItemsRaw
          .whereType<Map>()
          .map((e) => LabTestTemplateItem.fromJson(Map<String, dynamic>.from(e)))
          .toList();

      final templateByIdx = {for (final t in templateItems) t.idx: t};

      final mergedItems = detail.normalItems.map((r) {
        final t = templateByIdx[r.idx];
        if (t == null) return r;

        return r.copyWith(
          labTestName: (r.labTestName ?? '').trim().isNotEmpty
              ? r.labTestName
              : t.labTestName,
          uom: (r.uom ?? '').trim().isNotEmpty ? r.uom : t.uom,
          normalRange: (r.normalRange ?? '').trim().isNotEmpty
              ? r.normalRange
              : t.normalRange,
        );
      }).toList();

      return LabTestDetail(
        name: detail.name,
        status: detail.status,
        patient: detail.patient,
        patientName: detail.patientName,
        patientAge: detail.patientAge,
        patientSex: detail.patientSex,
        practitionerName: detail.practitionerName,
        department: detail.department,
        company: detail.company,
        resultDate: detail.resultDate,
        normalItems: mergedItems,
      );
    } catch (_) {
      return detail; // fail silently, still show raw result values
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
