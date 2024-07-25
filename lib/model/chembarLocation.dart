class Location {
  final int id;
  final String state;
  final String district;
  final String address;
  final String contact;
  final String email;
  final String location;

  Location({
    required this.id,
    required this.state,
    required this.district,
    required this.address,
    required this.contact,
    required this.email,
    required this.location,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      state: json['state'],
      district: json['district'],
      address: json['address'],
      contact: json['contact'],
      email: json['email'],
      location: json['location'],
    );
  }
}
