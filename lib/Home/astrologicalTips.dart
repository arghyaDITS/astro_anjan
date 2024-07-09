import 'package:flutter/material.dart';

class AstrologicalTipsSection extends StatelessWidget {
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
              'Astrological Tips',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            // Tips UI goes here
            Text('Avoid major decisions today.'),
          ],
        ),
      ),
    );
  }
}
