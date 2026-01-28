

import 'appoinment_model.dart';

class NotificationsResponse {
  final bool success;
  final int count;
  final List<NotificationItem> notifications;
  final int unreadCount;
  final Map<String, dynamic> categories;

  NotificationsResponse({
    required this.success,
    required this.count,
    required this.notifications,
    required this.unreadCount,
    required this.categories,
  });

  factory NotificationsResponse.fromJson(Map<String, dynamic> json) {
    final list = (json['notifications'] as List? ?? [])
        .map((e) => NotificationItem.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    return NotificationsResponse(
      success: json['success'] == true,
      count: (json['count'] ?? 0) is int ? (json['count'] ?? 0) : int.tryParse('${json['count']}') ?? 0,
      notifications: list,
      unreadCount: (json['unread_count'] ?? 0) is int ? (json['unread_count'] ?? 0) : int.tryParse('${json['unread_count']}') ?? 0,
      categories: Map<String, dynamic>.from(json['categories'] ?? {}),
    );
  }
}

enum NotificationType {
  appointmentConfirmed,
  doctorsAvailableToday,
  departmentInfo,
  announcement,
  unknown,
}

NotificationType _typeFromApi(String? t) {
  switch (t) {
    case 'appointment_confirmed':
      return NotificationType.appointmentConfirmed;
    case 'doctors_available_today':
      return NotificationType.doctorsAvailableToday;
    case 'department_info':
      return NotificationType.departmentInfo;
    case 'announcement':
      return NotificationType.announcement;
    default:
      return NotificationType.unknown;
  }
}

class NotificationItem {
  final String id;
  final NotificationType type;
  final String title;
  final String message;
  final String timeAgo;
  final bool isUnread;
  final AppointmentDetails? details;
  final String? actionUrl;
  final DateTime timestamp;

  NotificationItem({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.timeAgo,
    required this.isUnread,
    required this.timestamp,
    this.details,
    this.actionUrl,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    final typeStr = json['type']?.toString();
    final read = json['read'] == true;

    final ts = _parseDate(json['timestamp']);
    final data = (json['data'] is Map) ? Map<String, dynamic>.from(json['data']) : <String, dynamic>{};

    AppointmentDetails? details;
    if (typeStr == 'appointment_confirmed') {
      details = AppointmentDetails.fromAppointmentConfirmedData(data);
    }

    return NotificationItem(
      id: json['id']?.toString() ?? '',
      type: _typeFromApi(typeStr),
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      timestamp: ts,
      timeAgo: _timeAgo(ts),
      isUnread: !read,
      details: details,
      actionUrl: json['action_url']?.toString(),
    );
  }
}



DateTime _parseDate(dynamic v) {
  if (v == null) return DateTime.now();
  final s = v.toString();
  return DateTime.tryParse(s) ?? DateTime.now();
}

String _timeAgo(DateTime dt) {
  final now = DateTime.now();
  final diff = now.difference(dt);

  if (diff.inSeconds < 60) return '${diff.inSeconds}s ago';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  if (diff.inDays < 7) return '${diff.inDays}d ago';

  final weeks = (diff.inDays / 7).floor();
  if (weeks < 4) return '${weeks}w ago';

  final months = (diff.inDays / 30).floor();
  if (months < 12) return '${months}mo ago';

  final years = (diff.inDays / 365).floor();
  return '${years}y ago';
}

