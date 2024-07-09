import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GalleryScreen extends StatefulWidget {
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  List<String> imageUrls = [
    'https://dummyimage.com/300x200/000/fff',
    'https://dummyimage.com/400x300/00ff00/000',
    'https://dummyimage.com/600x400/0000ff/fff',
    'https://picsum.photos/id/237/200/300',
    'https://picsum.photos/id/237/200/300',
    'https://picsum.photos/id/237/200/300',
    'https://picsum.photos/id/237/200/300',
    'https://picsum.photos/id/237/200/300'
  ];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    isLoading = false;
    // Uncomment the following line to fetch images from an API
    // fetchImages();
  }

  Future<void> fetchImages() async {
    final response = await http.get(Uri.parse('YOUR_API_URL_HERE'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        imageUrls = data.map((item) => item['imageUrl'] as String).toList();
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load images');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: MasonryGridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 4,
                itemCount: imageUrls.length,
                itemBuilder: (context, index) {
                  return AnimatedOpacity(
                    duration: Duration(milliseconds: 2000),
                    opacity: 1,
                    child: Image.network(
                      imageUrls[index],
                      key: ValueKey<String>(imageUrls[index]),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
