import 'dart:developer';

import 'package:get/get.dart';

import '../../../../../app/app_snackbar.dart';
import '../../../../../core/services/api_service/api_service.dart';
import '../../../../../core/services/notification/local_notification_service.dart';
import '../../../../../core/services/shared_preferance/shared_preferance.dart';
import '../../../data/models/notification_item_model.dart';

import 'dart:async';
import 'package:get/get.dart';

class NotificationsController extends GetxController {
  final _net = NetworkService().client;
  final _prefs = SharedPrefs();

  final tabIndex = 0.obs;
  final loading = false.obs;
  final errorText = ''.obs;

  final items = <NotificationItem>[].obs;

  Timer? _pollTimer;

  List<NotificationItem> get filtered =>
      tabIndex.value == 0 ? items : items.where((e) => e.isUnread).toList();

  int get unreadCount => items.where((e) => e.isUnread).length;

  static const String _kLastNotifTs = 'last_notif_ts';
  static const String _kLastShownNotifId = 'last_shown_notif_id';

  @override
  void onInit() {
    super.onInit();
    LocalNotificationService.instance.init();

    // 1) call once immediately
    fetchNotifications();

    // 2) then repeat every 10 minutes
    _startPolling();
  }

  @override
  void onClose() {
    _pollTimer?.cancel();
    _pollTimer = null;
    super.onClose();
  }

  void _startPolling() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(minutes: 10), (_) async {
      if (loading.value) return;
      await fetchNotifications();
    });
  }

  // ✅ Safe string from Object?/String?/anything
  String _s(dynamic v) => (v ?? '').toString().trim();

  String _notifTitle(NotificationItem n) {
    final t = _s(n.title);
    if (t.isNotEmpty) return t;

    final ty = _s(n.type);
    if (ty.isNotEmpty) return ty;

    return 'New notification';
  }

  String _notifBody(NotificationItem n) {
    final msg = _s(n.message);
    if (msg.isNotEmpty) return msg;
    return 'You have a new update';
  }

  Future<bool> fetchNotifications({int limit = 10}) async {
    loading.value = true;
    errorText.value = '';
    log("called");

    try {


      final lastTsStr = await _prefs.getString(_kLastNotifTs);
      final lastTs = DateTime.tryParse(lastTsStr ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0);

      final lastShownId = await _prefs.getString(_kLastShownNotifId);

      // final path =
      //     '/api/v1/notifications/all-notifications?patient_id=$pid&limit=$limit';
      final path =
          '/api/v1/notifications/all-notifications?limit=$limit';
      final response = await _net.getRequest(path);

      if (!(response.isSuccess && response.statusCode == 200)) {
        errorText.value = _extractError(response) ?? 'Failed to load notifications';
        AppSnackbar.error('Error', errorText.value);
        return false;
      }

      final body = Map<String, dynamic>.from(response.responseData);

      final list = (body['notifications'] as List? ?? [])
          .map((e) => NotificationItem.fromJson(Map<String, dynamic>.from(e)))
          .toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

      items.assignAll(list);

      if (list.isNotEmpty) {
        final latest = list.first;

        final latestIdStr = latest.id.toString();
        final isSameAsLastShown = lastShownId == latestIdStr;
        final isNewByTime = latest.timestamp.isAfter(lastTs);

        // ✅ Show only if it’s new AND not already shown
        if (!isSameAsLastShown && isNewByTime) {
          await LocalNotificationService.instance.showInstant(
            id: latest.id.hashCode,
            title: _notifTitle(latest),
            body: _notifBody(latest),
            payload: {
              'notifId': latestIdStr,
              'type': latest.type.toString(),
            },
          );

          // ✅ Save last shown so it never repeats
          await _prefs.setString(_kLastShownNotifId, latestIdStr);
        }

        // ✅ Always update last fetch timestamp to newest item
        await _prefs.setString(_kLastNotifTs, latest.timestamp.toIso8601String());
      }

      return true;
    } catch (e) {
      errorText.value = 'Something went wrong: $e';
      AppSnackbar.error('Error', errorText.value);
      return false;
    } finally {
      loading.value = false;
    }
  }

  String? _extractError(dynamic res) {
    try {
      final d = res.data;
      if (d is Map && d['message'] != null) return d['message'].toString();
      if (d is String && d.isNotEmpty) return d;
      return null;
    } catch (_) {
      return null;
    }
  }
}
