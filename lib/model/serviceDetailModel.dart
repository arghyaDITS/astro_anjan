class ServiceDetail {
  final int id;
  final String title;
  final String logo;
  final String image;
  final String description;
  final String type;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  ServiceDetail({
    required this.id,
    required this.title,
    required this.logo,
    required this.image,
    required this.description,
    required this.type,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ServiceDetail.fromJson(Map<String, dynamic> json) {
    return ServiceDetail(
      id: json['id'],
      title: json['title'],
      logo: json['logo'],
      image: json['image'],
      description: json['description'],
      type: json['type'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
