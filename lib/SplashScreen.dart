import 'dart:async';
import 'package:Ohstel_app/introduction_screen.dart';
import 'package:flutter/material.dart';
import 'auth/wrapper.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
        () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => Splash())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Image.asset(
                'asset/Doodle.jpg',
                fit: BoxFit.fill,
              ),
            ),
            Center(
              child: Container(
                width: 126,
                height: 126,
                child: Image.asset(
                  'asset/OHstel.png',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
