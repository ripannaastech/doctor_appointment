import 'dart:convert';
import 'package:get/get.dart';

import '../../../../../core/services/api_service/api_service.dart';
import '../../../../../core/services/shared_preferance/shared_preferance.dart';
import '../../../../profile/models/user_profile_model.dart';
import '../model/announcement_slider_model.dart';
import '../model/home_feed_item.dart';
import '../model/home_slider_model.dart';

class HomeController extends GetxController {
  final _prefs = SharedPrefs();
  final _net = NetworkService();

  final RxString name = '—'.obs;
  final RxBool loading = true.obs;

  final sliders = <HomeSliderModel>[].obs;
  final announcements = <AnnouncementModel>[].obs;

  /// 🔥 merged feed
  final feed = <HomeFeedItem>[].obs;

  final sliderLoading = false.obs;
  final announcementLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadName();
    refreshHome();
  }

  Future<void> loadName() async {
    loading.value = true;
    try {
      final raw = await _prefs.getString(SharedPrefs.patientProfile);
      if (raw == null || raw.trim().isEmpty) {
        name.value = '—';
        loading.value = false;
        return;
      }
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final profile = UserProfile.fromJson(map);
      final patientName = (profile.patientName ?? '').trim();
      name.value = patientName.isNotEmpty ? patientName : '—';
    } catch (_) {
      name.value = '—';
    } finally {
      loading.value = false;
    }
  }

  Future<void> refreshHome() async {
    await Future.wait([loadSliders(), loadAnnouncements()]);
    _mergeFeed();
  }

  void _mergeFeed() {
    final merged = <HomeFeedItem>[];

    // Example merge strategy:
    // 1 slider → 1 announcement → repeat
    final maxLen = sliders.length > announcements.length
        ? sliders.length
        : announcements.length;

    for (int i = 0; i < maxLen; i++) {
      if (i < sliders.length) {
        merged.add(HomeFeedItem.slider(sliders[i]));
      }
      if (i < announcements.length) {
        merged.add(HomeFeedItem.announcement(announcements[i]));
      }
    }

    feed.assignAll(merged);
  }

  Future<void> loadSliders() async {
    sliderLoading.value = true;

    try {
      final res = await _net.getRequest('/api/v1/content/home-sliders');

      if (!res.isSuccess || res.responseData == null) {
        sliders.clear();
        return;
      }

      final map = res.responseData is String
          ? jsonDecode(res.responseData)
          : res.responseData;

      if (map['success'] != true) {
        sliders.clear();
        return;
      }

      final list = (map['data'] as List)
          .map((e) => HomeSliderModel.fromJson(e))
          .toList();

      list.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
      sliders.assignAll(list);
    } catch (e) {
      sliders.clear();
    } finally {
      sliderLoading.value = false;
    }
  }

  Future<void> loadAnnouncements() async {
    announcementLoading.value = true;

    try {
      final res = await _net.getRequest('/api/v1/content/announcements');

      if (!res.isSuccess || res.responseData == null) {
        announcements.clear();
        return;
      }

      final map = res.responseData is String
          ? jsonDecode(res.responseData)
          : res.responseData;

      if (map['success'] != true) {
        announcements.clear();
        return;
      }

      final list = (map['data'] as List)
          .map((e) => AnnouncementModel.fromJson(e))
          .toList();

      announcements.assignAll(list);
    } catch (e) {
      announcements.clear();
    } finally {
      announcementLoading.value = false;
    }
  }
}
