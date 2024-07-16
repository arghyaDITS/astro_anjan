import 'package:astro_app/Home/bangla_calender_screen.dart';
import 'package:flutter/material.dart';

class BanglaCalendarSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (context) => BanglaCalenderScreen()));
      },
      child: Card(
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bangla Calendar',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              // Calendar UI goes here
              Text('14th Ashar, 1429'),
            ],
          ),
        ),
      ),
    );
  }
}
