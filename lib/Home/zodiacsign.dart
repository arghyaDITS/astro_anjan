import 'package:flutter/material.dart';

class ZodiacSignDetailsSection extends StatelessWidget {
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
              'Zodiac Sign Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            // Zodiac details UI goes here
            Text('Aries: Courageous, determined, confident.'),
          ],
        ),
      ),
    );
  }
}
