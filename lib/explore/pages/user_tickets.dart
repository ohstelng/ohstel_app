import 'package:Ohstel_app/explore/models/ticket.dart';
import 'package:Ohstel_app/explore/widgets/circular_progress.dart';
import 'package:Ohstel_app/explore/widgets/user_ticket.dart';
import 'package:Ohstel_app/utilities/app_style.dart';
import 'package:Ohstel_app/utilities/shared_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserTickets extends StatefulWidget {
  final Map userDetails;
  UserTickets(this.userDetails);
  @override
  _UserTicketsState createState() => _UserTicketsState();
}

class _UserTicketsState extends State<UserTickets> {
  var userTicketsRef;

  @override
  void initState() {
    super.initState();
    userTicketsRef = FirebaseFirestore.instance
        .collection('explore')
        .doc('userTickets')
        .collection(widget.userDetails['uid'])
        .orderBy('date', descending: true);
  }

  _buildTicketsListView() {
    return FutureBuilder(
      future: userTicketsRef.get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CustomCircularProgress();
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
            : buildNoItem(
                context,
                text: 'You don\'t have any ticket',
              );
      },
    );
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
