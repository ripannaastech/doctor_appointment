class AnnouncementModel {
  final String id;
  final String type; // announcement / alert / info
  final String title;
  final String message;
  final String image;
  final String priority; // high / normal
  final bool clickable;
  final String actionUrl; // "/home" or "tel:+252..."
  final DateTime? createdAt;

  AnnouncementModel({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.image,
    required this.priority,
    required this.clickable,
    required this.actionUrl,
    required this.createdAt,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    final created = (json['created_at'] ?? '') as String;
    DateTime? dt;
    try {
      if (created.trim().isNotEmpty) dt = DateTime.parse(created);
    } catch (_) {}

    return AnnouncementModel(
      id: (json['id'] ?? '') as String,
      type: (json['type'] ?? '') as String,
      title: (json['title'] ?? '') as String,
      message: (json['message'] ?? '') as String,
      image: (json['image'] ?? '') as String,
      priority: (json['priority'] ?? 'normal') as String,
      clickable: (json['clickable'] ?? false) as bool,
      actionUrl: (json['action_url'] ?? '') as String,
      createdAt: dt,
    );
  }
}
