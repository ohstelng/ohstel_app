import 'package:Ohstel_app/auth/models/userModel.dart';
import 'package:Ohstel_app/explore/models/location.dart';
import 'package:flutter/material.dart';

class Ticket {
  final String id;
  final DateTime date;
  final ExploreLocation location;
  final UserModel user;
  final int numberOfTickets;
  final DateTime plannedDate;
  final DateTime plannedTime;
  final int finalAmount;

  Ticket({
    @required this.id,
    @required this.date,
    @required this.location,
    @required this.user,
    @required this.numberOfTickets,
    @required this.plannedDate,
    @required this.plannedTime,
    @required this.finalAmount,
  });
}
