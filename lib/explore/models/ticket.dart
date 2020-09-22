import 'package:flutter/material.dart';

class Ticket {
  final String id;
  final DateTime date;
  final String locationName;
  final int locationDuration;
  final int numberOfTickets;
  final DateTime scheduledDate;
  final DateTime scheduledTime;
  final int finalAmount;
  final String name;
  final String email;
  final String phone;
  final String university;
  final String department;
  final String userId;

  Ticket({
    @required this.id,
    @required this.date,
    @required this.locationName,
    @required this.locationDuration,
    @required this.numberOfTickets,
    @required this.scheduledDate,
    @required this.scheduledTime,
    @required this.finalAmount,
    @required this.name,
    @required this.email,
    @required this.phone,
    @required this.university,
    @required this.userId,
    this.department,
  });

  factory Ticket.fromDoc(Map<String, dynamic> doc) {
    return Ticket(
      id: doc['id'],
      date: DateTime.fromMillisecondsSinceEpoch(doc['date']),
      locationName: doc['locationName'],
      locationDuration: doc['locationDuration'],
      numberOfTickets: doc['numberOfTickets'],
      scheduledDate: DateTime.fromMillisecondsSinceEpoch(doc['scheduledDate']),
      scheduledTime: DateTime.fromMillisecondsSinceEpoch(doc['scheduledTime']),
      finalAmount: doc['finalAmount'],
      name: doc['name'],
      email: doc['email'],
      phone: doc['phone'],
      university: doc['university'],
      userId: doc['userId'],
    );
  }
}
