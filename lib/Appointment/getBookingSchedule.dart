import 'dart:async';
import 'package:astro_app/Appointment/checkoutScreen.dart';
import 'package:astro_app/Appointment/paymentScreen.dart';
import 'package:astro_app/Home/home.dart';
import 'package:astro_app/services/apiServices.dart';
import 'package:astro_app/services/servicesManeger.dart';
import 'package:astro_app/theme/style.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class BookingSchedule extends StatefulWidget {
  final String? infoId;
  BookingSchedule({super.key, this.infoId});

  @override
  _BookingScheduleState createState() => _BookingScheduleState();
}

class _BookingScheduleState extends State<BookingSchedule> {
  DateTime? _selectedDate;
  List<dynamic> _availableSlots = [];
  bool isLoading = false;
  final StreamController _streamController = StreamController();
  dynamic _selectedSlot;
  String location='';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Appointment Date'),
      ),
      body: Container(
        decoration: kBackgroundDesign(context),
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            SizedBox(height: 10,),
            ElevatedButton(
              onPressed: _selectDate,
              child: Text(
                _selectedDate == null
                    ? 'Select Date'
                    : DateFormat('yyyy-MM-dd').format(_selectedDate!),
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: _streamController.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var data = snapshot.data as List<dynamic>;
                    return data.isNotEmpty
                        ? Column(
                          children: [
                            Text("For location ${location}"),
                            Expanded(
                              child: GridView.builder(
                                  padding: const EdgeInsets.all(8.0),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 2.0,
                                    mainAxisSpacing: 4.0,
                                    crossAxisSpacing: 4.0,
                                  ),
                                  itemCount: data.length,
                                  itemBuilder: (context, index) {
                                    var slot = data[index];
                                    String startTime = DateFormat.jm().format(DateFormat("HH:mm:ss").parse(slot['start']));
                                    String endTime = DateFormat.jm().format(DateFormat("HH:mm:ss").parse(slot['end']));
                                    return GestureDetector(
                                      onTap: () {
                                        if (slot['status'] == true) {
                                          setState(() {
                                            _selectedSlot = slot;
                                          });
                                        } else {
                                          null;
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: _selectedSlot == slot
                                              ? Color.fromARGB(255, 180, 105, 241)
                                              : slot['status'] == true
                                                  ? const Color.fromARGB(
                                                      255, 247, 201, 255)
                                                  : Color.fromARGB(
                                                      174, 183, 183, 184),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Center(
                                          child: Text(
                                            '$startTime - $endTime',
                                           // '${slot['start']} - ${slot['end']}',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                            ),
                          ],
                        )
                        : const Center(
                            child: Text("No Slots Available!"),
                          );
                  }
                  return Center(child: Container());
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_selectedSlot != null) {
                    print('Selected Slot: ${_selectedSlot['slot']}');
                    print('Start Time: ${_selectedSlot['start']}');
                    print('End Time: ${_selectedSlot['end']}');
                    print('Status: ${_selectedSlot['status']}');
                      _saveSlot(
                      context,
                      slotNo: _selectedSlot['slot'],
                      startTime: _selectedSlot['start'],
                      endTime: _selectedSlot['end'],
                    );
                     
                  
                  }
                },
                child: Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _fetchAvailableSlots();
      });
    }
  }

  _fetchAvailableSlots() async {
    print("Fetching available slots...");
    setState(() {
      isLoading = true;
    });
    String url = APIData.getAvailableSlot;
    print(url);
    var res = await http.post(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${ServiceManager.tokenID}',
    }, body: {
      'info_id': widget.infoId,
      'booking_date': DateFormat('yyyy-MM-dd').format(_selectedDate!).toString()
    });
    print(res.statusCode);
    if (res.statusCode == 200) {
      print(res.body);
      var data = jsonDecode(res.body);
      setState(() {
        location=data['location'];
      });
      _streamController.add(data['schedule']);
    }
    setState(() {
      isLoading = false;
    });
  }

  _saveSlot(context, {slotNo, startTime, endTime}) async {
    setState(() {
      isLoading = true;
    });
    String url = APIData.bookSlot;
    print(url);
    var res = await http.post(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${ServiceManager.tokenID}',
    }, body: {
      'info_id': widget.infoId.toString(),
      'booking_date':
          DateFormat('yyyy-MM-dd').format(_selectedDate!).toString(),
      'slot_no': slotNo.toString(),
      'slot_start': startTime,
      'slot_end': endTime,
      'pay_type': 'online',
      'coupon': 'TEST1',
      'location':'kolkata'
    });
    print(res.statusCode);
    print(res.body);
    if (res.statusCode == 200) {
      print(res.body);

      setState(() {
        isLoading = false;
      });
      Map<String, dynamic> decodedResponse = json.decode(res.body);
      print(decodedResponse['appointment_id']);
      print(decodedResponse['amount']);
      print("Booking successful");

  Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => CheckoutScreen(
            appoId: decodedResponse['appointment_id'],
            amount: decodedResponse['amount'],
          )), (route) => false);
      // Navigator.pushAndRemoveUntil(context,
      //     MaterialPageRoute(builder: (context) => PhonePePayment()), (route) => false);
    }
    setState(() {
      isLoading = false;
    });
    return 'Success';
  }
}



// _fetchAvailableSlots() async {
//     setState(() {
//       isLoading = true;
//     });
//     String url = APIData.getAvailableSlot;
//     print(url);
//     //await Future.delayed(Duration(seconds: 1));
//     var res = await http.post(Uri.parse(url), headers: {
//       'Accept': 'application/json',
//       'Authorization': 'Bearer ${ServiceManager.tokenID}',
//     }, body: {
//       'info_id': widget.infoId,
//       'booking_date': DateFormat('yyyy-MM-dd').format(_selectedDate!).toString()
//     });
//     print(res.statusCode);
//     if (res.statusCode == 200) {
//       print(res.body);
//       var data = jsonDecode(res.body);
//       _streamController.add(data['schedule']);

//       setState(() {
//         isLoading = false;
//       });
//     }
//     setState(() {
//       isLoading = false;
//     });
//     return 'Success';
//   }
