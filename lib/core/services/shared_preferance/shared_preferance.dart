import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../session/session.dart';

class SharedPrefs {
  static const _kAccess = 'token';
  static const _kRefreshToken = 'refresh_token';
  static const _kUser = 'user';
  static const _kUserId = 'user_id';
  static const _kTypeSpecificId = 'type_specific_id';
  static const _kbookingID = 'booking_id';
  static const accessToken = 'access_token';
  static const tokenType = 'token_type';
  static const patientId = 'patient_id';
  static const patientProfile = 'patient_profile_json';
  static const isLoggedIn = 'is_logged_in';
  static const lastPhone = 'last_phone';

  Future<void> saveToken(String token) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_kAccess, token);
    Session.setToken(token);          // <- keep cache in sync
  }

  static const _kLanguage = 'app_language';

  Future<void> saveLanguage(String code) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_kLanguage, code); // e.g. 'en', 'so'
  }

  Future<String?> getLanguage() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(_kLanguage);
  }

  Future<void> setString(String key, String value) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(key, value);
  }

  Future<String?> getString(String key) async {
    final p = await SharedPreferences.getInstance();
    return p.getString(key);
  }

  Future<String?> getToken() async {
    final p = await SharedPreferences.getInstance();
    final t = p.getString(_kAccess);
    Session.setToken(t);              // <- prime cache if needed
    return t;
  }

  Future<void> saveBookingID(int booking) async {
    final p = await SharedPreferences.getInstance();
    await p.setInt(_kbookingID, booking);

  }

  Future<int?> getBookingID() async {
    final p = await SharedPreferences.getInstance();
    final t = p.getInt(_kbookingID); // <- prime cache if needed
    return t;
  }

  // if you need a sync getter for already-primed cache:
  String? get tokenSync => Session.accessToken;

  Future<void> saveRefreshToken(String refreshToken) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_kRefreshToken, refreshToken);
  }

  Future<String?> getRefreshToken() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(_kRefreshToken);
  }

  // Save user ID separately so it's not overwritten by profile data
  Future<void> saveUserId(String? userId) async {
    if (userId == null || userId.isEmpty) return;
    final p = await SharedPreferences.getInstance();
    await p.setString(_kUserId, userId);
  }

  Future<String?> getUserId() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(_kUserId);
  }

  // Save typeSpecificId separately
  Future<void> saveTypeSpecificId(String? typeSpecificId) async {
    if (typeSpecificId == null || typeSpecificId.isEmpty) return;
    final p = await SharedPreferences.getInstance();
    await p.setString(_kTypeSpecificId, typeSpecificId);
  }

  Future<String?> getTypeSpecificId() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(_kTypeSpecificId);
  }

  Future<void> saveUser(Map<String, dynamic> user) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_kUser, jsonEncode(user));
  }

  Future<Map<String, dynamic>?> getUser() async {
    final p = await SharedPreferences.getInstance();
    final s = p.getString(_kUser);
    return s == null ? null : jsonDecode(s);
  }

  Future<void> clear() async {
    final p = await SharedPreferences.getInstance();
    await p.clear();
    Session.clear();                   // <- clear cache
  }

  Future<void> setBool(String key, bool value) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(key, value);
  }

  Future<bool?> getBool(String key) async {
    final p = await SharedPreferences.getInstance();
    return p.getBool(key);
  }

}