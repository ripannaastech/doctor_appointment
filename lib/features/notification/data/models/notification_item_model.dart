import 'appoinment_model.dart';

enum NotificationType { appointmentConfirmed, pharmacyNeeded, appointmentCancelled }

class NotificationItem {
  final NotificationType type;
  final String title;
  final String message;
  final String timeAgo;
  final bool isUnread;
  final AppointmentDetails? details;

  NotificationItem({
    required this.type,
    required this.title,
    required this.message,
    required this.timeAgo,
    required this.isUnread,
    this.details,
  });
}
