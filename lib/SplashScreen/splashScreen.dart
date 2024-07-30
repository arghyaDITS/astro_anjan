import 'dart:async';
import 'package:astro_app/Auth/login.dart';
import 'package:astro_app/Home/home.dart';
import 'package:astro_app/services/servicesManeger.dart';
import 'package:astro_app/theme/style.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    ServiceManager().getUserID();
    ServiceManager().getTokenID();
    // LocationService().fetchLocation();
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if(ServiceManager.userID != ''){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
            builder: (context) => Home()), (route) => false);
      } else {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
            builder: (context) => Login()), (route) => false);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    if(_timer!.isActive) _timer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: kBackgroundDesign(context),
      child: Scaffold(
       // backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: Image.asset('images/logo.jpg', height: 200)),
        ),
      ),
    );
  }
}
