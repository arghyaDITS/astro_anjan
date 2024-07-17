import 'package:flutter/material.dart';

class AppointmentBookingSection extends StatelessWidget {
  final Animation<double> animation;

  AppointmentBookingSection({required this.animation});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Book an Appointment!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              // const SizedBox(height: 10),
              // Text(
              //   'Schedule your appointment with our experts today.',
              //   style: TextStyle(
              //     fontSize: 16,
              //     color: Colors.grey[700],
              //   ),
              // ),
              // const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.deepPurple, // Text color
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 5,
                    shadowColor: Colors.deepPurpleAccent,
                  ),
                  onPressed: () {
                    // Booking logic goes here
                  },
                  child: const Text(
                    'Book Now',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
        // gradient: const LinearGradient(
        //   colors: [Colors.purpleAccent, Colors.deepPurple],
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        // ),
      ),
    );
  }
}

class GradientCard extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final double elevation;
  final ShapeBorder shape;

  GradientCard({
    required this.child,
    required this.gradient,
    this.elevation = 4.0,
    this.shape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12.0)),
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: elevation,
            offset: Offset(0, elevation),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Material(
          color: Colors.transparent,
          child: child,
        ),
      ),
    );
  }
}
