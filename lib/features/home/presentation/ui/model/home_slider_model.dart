class HomeSliderModel {
  final int id;
  final String title;
  final String subtitle;
  final String image;
  final String linkUrl;
  final int displayOrder;

  HomeSliderModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.linkUrl,
    required this.displayOrder,
  });

  factory HomeSliderModel.fromJson(Map<String, dynamic> json) {
    return HomeSliderModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      image: json['image'] ?? '',
      linkUrl: json['link_url'] ?? '',
      displayOrder: json['display_order'] ?? 0,
    );
  }
}
