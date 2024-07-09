import 'dart:async';
import 'dart:convert';

import 'package:astro_app/Appointment/createAppointment.dart';
import 'package:astro_app/components/buttons.dart';
import 'package:astro_app/components/util.dart';
import 'package:astro_app/services/apiServices.dart';
import 'package:astro_app/services/servicesManeger.dart';
import 'package:astro_app/theme/style.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Appoinments extends StatefulWidget {
  const Appoinments({super.key});

  @override
  State<Appoinments> createState() => _AppoinmentsState();
}

class _AppoinmentsState extends State<Appoinments> {
  bool isLoading = false;
  final StreamController _streamController = StreamController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAppointments();
  }

  getAppointments() async {
    isLoading = true;
    String url = APIData.myAppointments;
    print(url);

    var res = await http.get(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${ServiceManager.tokenID}',
    });
    print(res.statusCode);
    if (res.statusCode == 200) {
      print(res.body);

      var data = jsonDecode(res.body);

      _streamController.add(data['data']['appointments']);
    }
    isLoading = false;
    return 'Success';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Appointments'),
          actions: [
            ArrowButton(
              onClick: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateAppointmentScreen()));
              },
              title: 'Book Now!',
            ),
          ],
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: kBackgroundDesign(context),
          child: StreamBuilder(
              stream: _streamController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var data = snapshot.data;
                  return data.isNotEmpty
                      ? Container(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: data.length,
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return const SizedBox(height: 15);
                                  },
                                  itemBuilder: (context, index) {
                                    DateTime startTime = DateFormat("HH:mm:ss")
                                        .parse(data[index]['slot_start']);
                                    DateTime endTime = DateFormat("HH:mm:ss")
                                        .parse(data[index]['slot_end']);
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 5.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          print("ssdd");
                                          // Handle on tap if necessary
                                        },
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 3000),
                                          padding: const EdgeInsets.all(10.0),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 5,
                                                blurRadius: 7,
                                                offset: Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  const Text(
                                                      "Appointment Id: "),
                                                  Text(data[index]['uid'])
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text("Date: "),
                                                  Text(
                                                    DateFormat('yyyy-MM-dd')
                                                        .format(DateTime.parse(
                                                            data[index][
                                                                'booking_date']))
                                                        .toString(),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text("Slot: "),
                                                  Text(
                                                      "From ${DateFormat("h:mm a").format(startTime)} to ${DateFormat("h:mm a").format(endTime)}")
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        )
                      : Center(
                          child: Text("No appointment yet!"),
                        );
                }
                return Center(child: const LoadingIcon());
              }),
        ));
  }
}
