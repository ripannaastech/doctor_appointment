import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../features/notification/data/models/notification_item_model.dart';
import '../api_service/api_service.dart';
import '../notification/local_notification_service.dart';
import 'dart:developer' as dev;

const String kNotifTask = "notifTask";

const String _kLastNotifTs = 'last_notif_ts';
const String _kLastShownNotifId = 'last_shown_notif_id';
const String _kPatientIdKey = 'patient_id'; // ensure matches your SharedPrefs key



@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task != kNotifTask) return true;

    try {
      final sp = await SharedPreferences.getInstance();

      final lastTsStr = sp.getString(_kLastNotifTs);
      final lastTs = DateTime.tryParse(lastTsStr ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0);
      final lastShownId = sp.getString(_kLastShownNotifId);

      final net = NetworkService().client;
      const limit = 10;

      final path = '/api/v1/notifications/all-notifications?limit=$limit';
      final response = await net.getRequest(path);

      if (!(response.isSuccess && response.statusCode == 200)) return true;

      final body = Map<String, dynamic>.from(response.responseData);
      final list = (body['notifications'] as List? ?? [])
          .map((e) => NotificationItem.fromJson(Map<String, dynamic>.from(e)))
          .toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

      if (list.isEmpty) return true;

      final latest = list.first;
      final latestIdStr = latest.id.toString();

      final isSameAsLastShown = lastShownId == latestIdStr;
      final isNewByTime = latest.timestamp.isAfter(lastTs);

      if (!isSameAsLastShown && isNewByTime) {
        await LocalNotificationService.instance.showInstant(
          id: latest.id.hashCode,
          title: (latest.title ?? '').toString().trim().isNotEmpty
              ? latest.title.toString().trim()
              : 'New notification',
          body: (latest.message ?? '').toString().trim().isNotEmpty
              ? latest.message.toString().trim()
              : 'You have a new update',
          payload: {
            'notifId': latestIdStr,
            'type': latest.type.toString(),
          },
        );

        await sp.setString(_kLastShownNotifId, latestIdStr);
      }

      await sp.setString(_kLastNotifTs, latest.timestamp.toIso8601String());
      return true;
    } catch (_) {
      return true;
    }
  });
}



