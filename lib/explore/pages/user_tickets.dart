import 'package:Ohstel_app/explore/models/ticket.dart';
import 'package:Ohstel_app/explore/widgets/user_ticket.dart';
import 'package:Ohstel_app/hive_methods/hive_class.dart';
import 'package:Ohstel_app/utilities/app_style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserTickets extends StatefulWidget {
  @override
  _UserTicketsState createState() => _UserTicketsState();
}

class _UserTicketsState extends State<UserTickets> {
  String userId;
  var userTicketsRef;

  _buildTicketsListView() {
    return FutureBuilder(
      future: userTicketsRef.get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(30.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error,
                    size: 60.0,
                  ),
                  SizedBox(height: 20.0),
                  Text('Error Loading Tickets, Try again.', style: heading2),
                ],
              ),
            ),
          );
        }

        List<UserTicket> _userTickets = [];

        snapshot.data.docs.forEach((doc) {
          _userTickets.add(UserTicket(Ticket.fromDoc(doc.data())));
        });

        return _userTickets.length > 0
            ? ListView(
                padding: EdgeInsets.all(20.0),
                children: _userTickets,
              )
            : Center(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('asset/OHstel.png'),
                      SizedBox(
                        height: 30.0,
                      ),
                      Text(
                        'You don\'t have any ticket',
                        style: heading1,
                      ),
                    ],
                  ),
                ),
              );
      },
    );
  }

  @override
  void initState() {
    getUserId();
    super.initState();
    userTicketsRef = FirebaseFirestore.instance
        .collection('explore')
        .doc('userTickets')
        .collection('allTickets')
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true);
  }

  getUserId() async {
    var userDetails = await HiveMethods().getUserData();
    userId = userDetails['uid'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBackground,
      appBar: AppBar(
        title: Text(
          'My Tickets',
          style: TextStyle(
            fontFamily: 'Lato',
          ),
        ),
        centerTitle: true,
      ),
      body: _buildTicketsListView(),
    );
  }
}
