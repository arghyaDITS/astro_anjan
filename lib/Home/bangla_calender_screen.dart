// bengali_calendar_screen.dart

import 'package:astro_app/model/bengaliDates.dart';
import 'package:flutter/material.dart';

class BengaliCalendarScreen extends StatefulWidget {
  @override
  _BengaliCalendarScreenState createState() => _BengaliCalendarScreenState();
}

class _BengaliCalendarScreenState extends State<BengaliCalendarScreen> {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    BengaliDate bengaliDate = gregorianToBengali(now);

    return Scaffold(
      appBar: AppBar(
        title: Text('Bengali Calendar'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "${bengaliDate.day} ${bengaliDate.month} ${bengaliDate.year}",
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 20),
          CalendarGrid(),
        ],
      ),
    );
  }
}

class CalendarGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Widget> days = [];
    for (int i = 1; i <= 31; i++) {
      days.add(
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
          child: Text(
            i.toString(),
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      children: days,
    );
  }
}
