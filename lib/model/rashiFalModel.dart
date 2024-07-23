class Rashi {
  final int id;
  final String title;
  final String logo;

  Rashi({required this.id, required this.title, required this.logo});

  factory Rashi.fromJson(Map<String, dynamic> json) {
    return Rashi(
      id: json['id'],
      title: json['title'],
      logo: json['logo'],
    );
  }
}
