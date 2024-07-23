// certificate_model.dart

class Certificate {
  final int id;
  final String title;
  final String image;

  Certificate({required this.id, required this.title, required this.image});

  factory Certificate.fromJson(Map<String, dynamic> json) {
    return Certificate(
      id: json['id'],
      title: json['title'],
      image: json['image'],
    );
  }
}
