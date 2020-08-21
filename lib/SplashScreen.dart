import 'dart:async';
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
            MaterialPageRoute(builder: (BuildContext context) => Wrapper())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
            child: Stack(children: [
          Image.asset('asset/Doodle.jpg'),
          Center(
              child: Container(
                  width: 150,
                  height: 150,
                  child: Image.asset('asset/OHstel.png',)))
        ])),
      ),
    );
  }
}
