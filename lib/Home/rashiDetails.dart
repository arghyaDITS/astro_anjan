import 'package:astro_app/services/apiServices.dart';
import 'package:astro_app/services/servicesManeger.dart';
import 'package:astro_app/theme/style.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:animate_do/animate_do.dart';

class RashiDetailScreen extends StatefulWidget {
  String? rashiId;
  RashiDetailScreen({super.key, this.rashiId});

  @override
  _RashiDetailScreenState createState() => _RashiDetailScreenState();
}

class _RashiDetailScreenState extends State<RashiDetailScreen> {
  bool isLoading = true;
  late Map<String, dynamic> rashiData;

  @override
  void initState() {
    super.initState();
    fetchRashiDetails();
  }

  Future<void> fetchRashiDetails() async {
    String url = "${APIData.rashiDetails}/${widget.rashiId}";
    print(url);

    var response = await http.get(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${ServiceManager.tokenID}',
    });
    //final response = await http.get(Uri.parse('https://api.example.com/rashi-details'));
    if (response.statusCode == 200) {
      setState(() {
        rashiData = json.decode(response.body)['data'];
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       // title: Text('Rashi Details'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
            decoration: kBackgroundDesign(context),
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CachedNetworkImage(
                          imageUrl: rashiData['logo'],
                          width: 50,
                          height: 50,
                          placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                        SizedBox(width: 16),
                        Text(
                          rashiData['title'],
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        itemCount: rashiData['info_image'].length,
                        itemBuilder: (context, index) {
                          return FadeIn(
                            duration: Duration(seconds: 1),
                            child: CachedNetworkImage(
                              imageUrl: rashiData['info_image'][index]['info_image'],
                              placeholder: (context, url) => CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
          ),
    );
  }
}
