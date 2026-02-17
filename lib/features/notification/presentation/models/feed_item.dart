import '../../data/models/notification_item_model.dart';
import 'advertisement_item_model.dart';

enum FeedType { notification, advertisement }

class FeedItem {
  final FeedType type;

  // common
  final String title;
  final String body;
  final DateTime timestamp;
  bool isUnread;

  // notification-only
  final NotificationItem? notif;

  // ad-only
  final AdvertisementItem? ad;

  FeedItem.notification({
    required this.title,
    required this.body,
    required this.timestamp,
    required this.isUnread,
    required this.notif,
  })  : type = FeedType.notification,
        ad = null;

  FeedItem.advertisement({
    required this.title,
    required this.body,
    required this.timestamp,
    required this.isUnread,
    required this.ad,
  })  : type = FeedType.advertisement,
        notif = null;
}
