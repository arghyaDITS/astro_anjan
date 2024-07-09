import 'package:flutter/material.dart';

class HoroscopeSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daily Horoscope',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            // Horoscope UI goes here
            Text('Today you will find peace and happiness in small things.'),
          ],
        ),
      ),
    );
  }
}
