import 'package:astro_app/Home/astrologicalTips.dart';
import 'package:astro_app/Home/banglaCalender.dart';
import 'package:astro_app/Home/bookAppointment.dart';
import 'package:astro_app/Home/chatwithAdmin.dart';
import 'package:astro_app/Home/horoscope.dart';
import 'package:astro_app/Home/zodiacsign.dart';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';


class AstrologyDashboard extends StatefulWidget {
  const AstrologyDashboard({super.key});
  @override
  _AstrologyDashboardState createState() => _AstrologyDashboardState();
}

class _AstrologyDashboardState extends State<AstrologyDashboard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Astrology Dashboard'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              BanglaCalendarSection(),
              // AppointmentBookingSection(animation: _animation),
              // ChatWithSastrijiSection(),
              // HoroscopeSection(),
              // AstrologicalTipsSection(),
              // ZodiacSignDetailsSection(),
            ],
          ),
        ),
      ),
    );
  }
}
