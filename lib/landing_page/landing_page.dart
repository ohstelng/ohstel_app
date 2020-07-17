import 'package:Ohstel_app/auth/methods/auth_methods.dart';
import 'package:flutter/material.dart';

class MainHomePage extends StatefulWidget {
  @override
  _MainHomePageState createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('home Page'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.phonelink_erase),
            onPressed: () async {
              await AuthService().signOut();
            },
          )
        ],
      ),
    );
  }
}
