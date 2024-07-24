class Service {
  final int id;
  final String title;
  final String logo;

  Service({required this.id, required this.title, required this.logo});

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      title: json['title'],
      logo: json['logo'],
    );
  }
}
