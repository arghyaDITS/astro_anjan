import 'package:astro_app/chat/chatscreen.dart';
import 'package:astro_app/services/apiServices.dart';
import 'package:astro_app/services/servicesManeger.dart';
import 'package:astro_app/theme/style.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class AppointmentDetailsScreen extends StatefulWidget {
  String? uid;
  AppointmentDetailsScreen({super.key, this.uid});
  @override
  _AppointmentDetailsScreenState createState() =>
      _AppointmentDetailsScreenState();
}

class _AppointmentDetailsScreenState extends State<AppointmentDetailsScreen> {
  Map<String, dynamic>? appointmentDetails;
  bool isLoading = true;
  bool isTimeValid=false;

  @override
  void initState() {
    super.initState();
    getAppointments();
  }

  getAppointments() async {
    isLoading = true;
    String url = "${APIData.appointmentDetail}/${widget.uid}";
    print(url);

    var res = await http.get(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${ServiceManager.tokenID}',
    });
    print(res.statusCode);
    print(res.body);
    if (res.statusCode == 200) {
      print(res.body);

      var data = jsonDecode(res.body);
       setState(() {
        appointmentDetails = json.decode(res.body)['data'];
        isLoading = false;
      });

      // _streamController.add(data['data']['appointments']);
    }
    isLoading = false;
    return 'Success';
  }

  // Future<void> fetchAppointmentDetails() async {
  //   final response = await http.get(Uri.parse('YOUR_API_ENDPOINT'));

  //   if (response.statusCode == 200) {
  //     setState(() {
  //       appointmentDetails = json.decode(response.body)['data'];
  //       isLoading = false;
  //     });
  //   } else {
  //     // Handle the error
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }
 isCurrentTimeValid(String bookingDate, String slotStart, String slotEnd) {
  // Parse the booking date and slot times
  DateTime bookingDateTime = DateTime.parse(bookingDate);
  DateFormat timeFormat = DateFormat.Hms();
  DateTime slotStartTime = timeFormat.parse(slotStart);
  DateTime slotEndTime = timeFormat.parse(slotEnd);

  // Get the current date and time
  DateTime now = DateTime.now();

  // Combine the booking date with slot times to get complete DateTime objects
  DateTime slotStartDateTime = DateTime(
    bookingDateTime.year,
    bookingDateTime.month,
    bookingDateTime.day,
    slotStartTime.hour,
    slotStartTime.minute,
    slotStartTime.second,
  );

  DateTime slotEndDateTime = DateTime(
    bookingDateTime.year,
    bookingDateTime.month,
    bookingDateTime.day,
    slotEndTime.hour,
    slotEndTime.minute,
    slotEndTime.second,
  );

  // Check if the current time is within the slot interval
  if (now.isAfter(slotStartDateTime) && now.isBefore(slotEndDateTime)) {
    setState(() {
      isTimeValid=true;
    });
   // return true;
  } else {
    setState(() {
      isTimeValid=false;
    });
    //return false;
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment Details'),
        backgroundColor: const Color.fromARGB(255, 234, 146, 250),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
            decoration: kBackgroundDesign(context),
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      curve: Curves.easeInOut,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name: ${appointmentDetails!['name']}',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text('Email: ${appointmentDetails!['email']}'),
                          const SizedBox(height: 8),
                          Text('Phone: ${appointmentDetails!['phone']}'),
                          const SizedBox(height: 8),
                          Text(
                              'Booking Date: ${appointmentDetails!['booking_date']}'),
                          const SizedBox(height: 8),
                          Text(
                              'Slot: ${appointmentDetails!['slot_start']} - ${appointmentDetails!['slot_end']}'),
                          const SizedBox(height: 8),
                          Text('Amount: ${appointmentDetails!['amount']}'),
                          const SizedBox(height: 8),
                          Text(
                              'Payment Status: ${appointmentDetails!['pay_status']}'),
                          const SizedBox(height: 8),
                          Text('Status: ${appointmentDetails!['status']}'),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                       isTimeValid==false?Container():    ElevatedButton.icon(
                          onPressed: () {
                            // Implement share link functionality
                          },
                          icon: const Icon(Icons.share),
                          label: const Text('Request Video call'),
                          style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.teal),
                        ),
                      isTimeValid==false?Container():  ElevatedButton.icon(
                          onPressed: () {
                           Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatScreen(uid: widget.uid,)));
            
                            // Implement chat functionality
                          },
                          icon: const FaIcon(FontAwesomeIcons.comments),
                          label: const Text('Chat'),
                          style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.teal),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ),
    );
  }
}
