import 'package:astro_app/model/notificationModel.dart';
import 'package:astro_app/services/apiServices.dart';
import 'package:astro_app/services/servicesManeger.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NotificationListScreen extends StatefulWidget {
  @override
  _NotificationListScreenState createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  List<Notifications> notifications = [];

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    String url = APIData.getNotifications;

    print(url);

    var response = await http.get(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${ServiceManager.tokenID}',
    });
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['data']['notifications'] as List;
      setState(() {
        notifications =
            data.map((json) => Notifications.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to load notifications');
    }
  }

  void _onRefresh() async {
    await _fetchNotifications();
    _refreshController.refreshCompleted();
  }
   String formatDateTime(DateTime dateTime) {
 return DateFormat('yyyy-MM-dd – hh:mm a').format(dateTime);  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return Card(
              margin: EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(notification.heading,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(notification.description),
                    Text('Created at: ${formatDateTime(notification.createdAt)}'),
                    SizedBox(height: 8.0),
                    // Row(
                    //   children: [
                    //     ElevatedButton(
                    //       onPressed: () {
                    //         // Implement read functionality
                    //       },
                    //       child: Text('Read Now'),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
