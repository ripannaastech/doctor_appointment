import 'announcement_slider_model.dart';
import 'home_slider_model.dart';

enum HomeFeedType { slider, announcement }

class HomeFeedItem {
  final HomeFeedType type;

  final HomeSliderModel? slider;
  final AnnouncementModel? announcement;

  HomeFeedItem.slider(this.slider)
      : type = HomeFeedType.slider,
        announcement = null;

  HomeFeedItem.announcement(this.announcement)
      : type = HomeFeedType.announcement,
        slider = null;
}
