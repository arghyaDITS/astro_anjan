class Notifications {
  final int id;
  final int userId;
  final String heading;
  final String description;
  final String slug;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Notifications({
    required this.id,
    required this.userId,
    required this.heading,
    required this.description,
    required this.slug,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Notifications.fromJson(Map<String, dynamic> json) {
    return Notifications(
      id: json['id'],
      userId: json['user_id'],
      heading: json['heading'],
      description: json['description'],
      slug: json['slug'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
