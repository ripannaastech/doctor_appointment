import 'dart:developer';

import 'package:get/get.dart';

import '../../../../../app/app_snackbar.dart';
import '../../../../../core/services/api_service/api_service.dart';
import '../../../../../core/services/notification/local_notification_service.dart';
import '../../../../../core/services/shared_preferance/shared_preferance.dart';
import '../../../data/models/notification_item_model.dart';

import 'dart:async';
import 'package:get/get.dart';

import '../../models/advertisement_item_model.dart';
import '../../models/feed_item.dart';


class NotificationsController extends GetxController {
  final _net = NetworkService().client;
  final _prefs = SharedPrefs();

  final tabIndex = 0.obs;
  final loading = false.obs;
  final errorText = ''.obs;

  // ✅ merged feed
  final feedItems = <FeedItem>[].obs;

  // raw lists
  final notifItems = <NotificationItem>[].obs;
  final adItems = <AdvertisementItem>[].obs;

  Timer? _pollTimer;

  static const String _kLastNotifTs = 'last_notif_ts';
  static const String _kLastShownNotifId = 'last_shown_notif_id';
  static const String _kLastShownAdId = 'last_shown_ad_id';

  List<FeedItem> get filtered =>
      tabIndex.value == 0 ? feedItems : feedItems.where((e) => e.isUnread).toList();

  int get unreadCount => feedItems.where((e) => e.isUnread).length;

  @override
  void onInit() {
    super.onInit();
    LocalNotificationService.instance.init();

    fetchAll();
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
      await fetchAll();
    });
  }

  String _s(dynamic v) => (v ?? '').toString().trim();

  // ✅ Public refresh (use this everywhere)
  Future<void> fetchAll({int limit = 10}) async {
    loading.value = true;
    errorText.value = '';
    log("fetchAll called");

    try {
      final results = await Future.wait<bool>([
        _fetchNotificationsOnly(limit: limit),
        _fetchAdsOnly(),
      ]);

      final okNotif = results[0];
      final okAds = results[1];

      if (!okNotif && !okAds) return;

      _buildMergedFeed();
    } catch (e) {
      errorText.value = 'Something went wrong: $e';
      AppSnackbar.error('Error', errorText.value);
    } finally {
      loading.value = false;
    }
  }

  // ✅ Must be clickable requirement: marking as read on tap
  void markAsRead(FeedItem f) {
    if (!f.isUnread) return;
    f.isUnread = false;
    feedItems.refresh();
  }

  // ✅ Called by UI tap always
  void onTapFeedItem(FeedItem f) {
    markAsRead(f);

    // Handle advertisement click navigation
    if (f.type == FeedType.advertisement) {
      final link = (f.ad?.linkUrl ?? '').trim();
      if (link.isEmpty) return;

      // ✅ If your app routes accept "/appointments" or "/doctors?dept=..."
      Get.toNamed(link);
    }

    // Notification click: UI handles expand if details exists
    // You can also route based on type/payload here if you want.
  }

  void _buildMergedFeed() {
    final merged = <FeedItem>[];

    // 1️⃣ Add ads first
    for (final a in adItems) {
      merged.add(
        FeedItem.advertisement(
          title: _s(a.title).isEmpty ? 'Advertisement' : a.title,
          body: _s(a.description).isEmpty ? 'New offer available' : a.description,
          timestamp: DateTime.fromMillisecondsSinceEpoch(a.id * 1000), // stable
          isUnread: false,
          ad: a,
        ),
      );
    }

    // 2️⃣ Add notifications after ads
    for (final n in notifItems) {
      merged.add(
        FeedItem.notification(
          title: _notifTitle(n),
          body: _notifBody(n),
          timestamp: n.timestamp,
          isUnread: n.isUnread,
          notif: n,
        ),
      );
    }

    int rank(FeedItem f) {
      if (f.type == FeedType.advertisement) {
        final p = (f.ad?.priority ?? '').toLowerCase();
        if (p == 'high') return 0; // 🔥 top
        return 1; // normal ads
      }
      return 2; // notifications last
    }

    merged.sort((a, b) {
      final ra = rank(a);
      final rb = rank(b);

      // group priority first
      if (ra != rb) return ra.compareTo(rb);

      // inside same group → newest first
      return b.timestamp.compareTo(a.timestamp);
    });

    feedItems.assignAll(merged);
  }

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

  // ---------------------------
  // ✅ Notifications only
  // ---------------------------
  Future<bool> _fetchNotificationsOnly({int limit = 10}) async {
    try {
      final lastTsStr = await _prefs.getString(_kLastNotifTs);
      final lastTs = DateTime.tryParse(lastTsStr ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0);

      final lastShownId = await _prefs.getString(_kLastShownNotifId);

      final path = '/api/v1/notifications/all-notifications?limit=$limit';
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

      notifItems.assignAll(list);

      // ✅ local push: only newest once
      if (list.isNotEmpty) {
        final latest = list.first;
        final latestIdStr = latest.id.toString();

        final isSameAsLastShown = lastShownId == latestIdStr;
        final isNewByTime = latest.timestamp.isAfter(lastTs);

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

          await _prefs.setString(_kLastShownNotifId, latestIdStr);
        }

        await _prefs.setString(_kLastNotifTs, latest.timestamp.toIso8601String());
      }

      return true;
    } catch (e) {
      errorText.value = 'Notifications error: $e';
      return false;
    }
  }

  // ---------------------------
  // ✅ Ads only
  // ---------------------------
  Future<bool> _fetchAdsOnly() async {
    try {
      final path = '/api/v1/notifications/advertisements';
      final response = await _net.getRequest(path);

      if (!(response.isSuccess && response.statusCode == 200)) {
        errorText.value = _extractError(response) ?? 'Failed to load advertisements';
        return false;
      }

      final body = Map<String, dynamic>.from(response.responseData);

      final list = (body['data'] as List? ?? [])
          .map((e) => AdvertisementItem.fromJson(Map<String, dynamic>.from(e)))
          .toList();

      // Optional: sort high priority first
      list.sort((a, b) {
        int p(String s) => s.toLowerCase() == 'high' ? 0 : 1;
        return p(a.priority).compareTo(p(b.priority));
      });

      adItems.assignAll(list);

      // optional local push (only once)
      await _maybeShowAdPush(list);

      return true;
    } catch (e) {
      errorText.value = 'Advertisements error: $e';
      return false;
    }
  }

  Future<void> _maybeShowAdPush(List<AdvertisementItem> ads) async {
    if (ads.isEmpty) return;

    final best = ads.firstWhere(
          (a) => a.priority.toLowerCase() == 'high',
      orElse: () => ads.first,
    );

    final lastShownAdId = await _prefs.getString(_kLastShownAdId);
    final bestIdStr = best.id.toString();

    if (lastShownAdId == bestIdStr) return;

    await LocalNotificationService.instance.showInstant(
      id: ('ad_${best.id}').hashCode,
      title: _s(best.title).isEmpty ? 'New offer' : best.title,
      body: _s(best.description).isEmpty ? 'Tap to view details' : best.description,
      payload: {
        'adId': bestIdStr,
        'type': 'advertisement',
        'linkUrl': best.linkUrl,
      },
    );

    await _prefs.setString(_kLastShownAdId, bestIdStr);
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
