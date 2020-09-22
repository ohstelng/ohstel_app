import 'package:Ohstel_app/explore/models/ticket.dart';
import 'package:Ohstel_app/explore/pages/ticket.dart';
import 'package:Ohstel_app/utilities/app_style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserTicket extends StatelessWidget {
  final Ticket ticket;
  UserTicket(this.ticket);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => TicketScreen(ticket))),
      child: Card(
        child: ListTile(
          title: Text(
            ticket.locationName,
            style: body1,
          ),
          leading: ImageIcon(
            AssetImage('asset/ticket.png'),
            color: Theme.of(context).primaryColor,
          ),
          subtitle: Text(
            DateFormat('d/M/y').add_jm().format(ticket.date),
            style: TextStyle(
              fontFamily: 'Lato',
            ),
          ),
        ),
      ),
    );
  }
}
