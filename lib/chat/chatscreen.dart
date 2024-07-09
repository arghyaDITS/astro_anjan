import 'dart:convert';
import 'dart:io';
import 'package:astro_app/services/apiServices.dart';
import 'package:astro_app/services/servicesManeger.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  String? uid;
  ChatScreen({super.key, this.uid});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  late Stream<List<ChatMessage>> _chatStream;

  @override
  void initState() {
    super.initState();
    _chatStream = fetchChatMessages();
  }

  Stream<List<ChatMessage>> fetchChatMessages() async* {
    while (true) {
      String url = "${APIData.getChatData}/${widget.uid}";
      print(url);
      final response = await http.get(Uri.parse(url), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${ServiceManager.tokenID}',
      });
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
        yield data.map((json) => ChatMessage.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load chat messages');
      }
      await Future.delayed(Duration(seconds: 30)); // Poll every 2 seconds
    }
  }

Future<void> sendMessage({String? text, File? image}) async {
  String url = APIData.sendMessage;
  print(url);

  var request = http.MultipartRequest('POST', Uri.parse(url));
  request.headers.addAll({
    'Accept': 'application/json',
    'Authorization': 'Bearer ${ServiceManager.tokenID}',
  });
request.fields['uid'] = widget.uid!;
  if (text != null) {
    request.fields['message'] = text;
    
  }

  if (image != null) {
    // Convert the image file to bytes and add to the request
    request.files.add(http.MultipartFile(
      'media',
      image.readAsBytes().asStream(),
      image.lengthSync(),
      filename: image.path.split('/').last,
    ));
  }

  try {
    final response = await request.send();
    print('Response status: ${response.statusCode}');
    final responseBody = await response.stream.bytesToString();
    print('Response body: $responseBody');
    
    if (response.statusCode == 200) {
      _controller.clear();
      setState(() {
        _chatStream = fetchChatMessages();
      });
    } else {
      print('Failed to send message: $responseBody');
      throw Exception('Failed to send message');
    }
  } catch (e) {
    print('Error sending message: $e');
  }
}


  Future<void> sendMessage2({String? text, File? image}) async {
    String url = APIData.sendMessage;
    print(url);
    // final uri = Uri.parse('https://thecityofjoy.in/anjan/api/send-message');
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll({
      'Accept': 'application/json',
      'Authorization': 'Bearer ${ServiceManager.tokenID}',
    });
    if (text != null) {
      request.fields['message'] = text;
      request.fields['uid'] = widget.uid!;
    }
    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('media', image.path));
    }
    final response = await request.send();
    print(response.statusCode);
    print(response.toString());
    if (response.statusCode == 200) {
      _controller.clear();
      setState(() {
        _chatStream = fetchChatMessages();
      });
    } else {
      throw Exception('Failed to send message');
    }
  }

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      sendMessage(image: File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<ChatMessage>>(
              stream: _chatStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No messages'));
                }
                final messages = snapshot.data!;
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isClientMessage = message.type == 'c';
                    return Align(
                      alignment: isClientMessage
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        margin: EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 8.0),
                        decoration: BoxDecoration(
                          color: isClientMessage
                              ? Colors.blue[100]
                              : Colors.green[100],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (message.image != null)
                              Image.network(
                                message.image!,
                                width: 150,
                                height: 150,
                              ),
                            if (message.message.isNotEmpty)
                              Text(message.message),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: 'Type a message'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.image),
                  onPressed: pickImage,
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    final text = _controller.text.trim();
                    if (text.isNotEmpty) {
                      sendMessage(text: text);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final int id;
  final String message;
  final String? image;
  final String type;
  final String createdAt;

  ChatMessage({
    required this.id,
    required this.message,
    this.image,
    required this.type,
    required this.createdAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      message: json['message'],
      image: json['image'],
      type: json['type'],
      createdAt: json['created_at'],
    );
  }
}
