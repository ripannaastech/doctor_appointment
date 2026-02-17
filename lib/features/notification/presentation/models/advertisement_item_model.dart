class AdvertisementItem {
  final int id;
  final String title;
  final String description;
  final String image;
  final String linkUrl;
  final String category;
  final String priority; // high / normal
  final bool clickable;

  AdvertisementItem({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.linkUrl,
    required this.category,
    required this.priority,
    required this.clickable,
  });

  factory AdvertisementItem.fromJson(Map<String, dynamic> json) {
    return AdvertisementItem(
      id: (json['id'] ?? 0) is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      image: (json['image'] ?? '').toString(),
      linkUrl: (json['link_url'] ?? '').toString(),
      category: (json['category'] ?? '').toString(),
      priority: (json['priority'] ?? 'normal').toString(),
      clickable: (json['clickable'] ?? false) == true,
    );
  }
}
