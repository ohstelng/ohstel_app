import 'package:flutter/material.dart';

class NoConnection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(25),
          topLeft: Radius.circular(25),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.signal_wifi_off,
            color: Colors.grey,
            size: 80,
          ),
          Text(
            'No Internet Connection Found',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w300,
            ),
          )
        ],
      ),
    ));
  }
}
