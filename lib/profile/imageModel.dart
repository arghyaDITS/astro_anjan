class ImageItem {
  final int id;
  final String title;
  final String imageUrl;

  ImageItem({required this.id, required this.title, required this.imageUrl});

  factory ImageItem.fromJson(Map<String, dynamic> json) {
    return ImageItem(
      id: json['id'],
      title: json['title'],
      imageUrl: json['image'],
    );
  }
}