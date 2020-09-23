import 'package:Ohstel_app/auth/models/userModel.dart';
import 'package:Ohstel_app/explore/models/location.dart';
import 'package:Ohstel_app/explore/models/ticket.dart';
import 'package:Ohstel_app/explore/pages/ticket.dart';
import 'package:Ohstel_app/utilities/app_style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

final formKey = GlobalKey<FormState>();
String email;
String name;
String phone;
String university;
String department = "";

bool isLoading = false;

showUserDetailsBottomSheet(
  BuildContext context, {
  @required UserModel user,
  @required int finalAmount,
  @required ExploreLocation location,
  @required DateTime scheduledDate,
  @required DateTime scheduledTime,
  @required int numberOfTickets,
}) {
  return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20.0,
                right: 20.0,
                top: 20.0,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Ticket Details',
                      style: heading2,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 15,
                        right: 15,
                      ),
                      color: Colors.green[50],
                      child: TextFormField(
                        initialValue: user.fullName,
                        validator: (value) {
                          if (value.trim().isEmpty) {
                            return 'Name Can\'t Be Empty';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          labelText: "Name",
                          suffixIcon: Icon(Icons.person),
                          border: InputBorder.none,
                        ),
                        onSaved: (value) => name = value.trim(),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      padding: EdgeInsets.only(
                        left: 15,
                        right: 15,
                      ),
                      color: Colors.green[50],
                      child: TextFormField(
                        initialValue: user.email,
                        validator: (value) {
                          if (value.trim().isEmpty) {
                            return 'Email Can\'t Be Empty';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          labelText: "Email",
                          suffixIcon: Icon(Icons.email),
                          border: InputBorder.none,
                        ),
                        onSaved: (value) => email = value.trim(),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      padding: EdgeInsets.only(
                        left: 15,
                        right: 15,
                      ),
                      color: Colors.green[50],
                      child: TextFormField(
                        initialValue: user.phoneNumber,
                        validator: (value) {
                          if (value.trim().isEmpty) {
                            return 'Phone No. Can\'t Be Empty';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          labelText: "Phone No.",
                          suffixIcon: Icon(Icons.phone),
                          border: InputBorder.none,
                        ),
                        onSaved: (value) => phone = value.trim(),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      padding: EdgeInsets.only(
                        left: 15,
                        right: 15,
                      ),
                      color: Colors.green[50],
                      child: TextFormField(
                        initialValue: user.uniDetails['name'],
                        validator: (value) {
                          if (value.trim().isEmpty) {
                            return 'University Can\'t Be Empty';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          labelText: "University",
                          suffixIcon: Icon(Icons.school),
                          border: InputBorder.none,
                        ),
                        onSaved: (value) => university = value.trim(),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      padding: EdgeInsets.only(
                        left: 15,
                        right: 15,
                      ),
                      color: Colors.green[50],
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Department (Optional)",
                          suffixIcon: Icon(Icons.school),
                          border: InputBorder.none,
                        ),
                        onSaved: (value) => department = value.trim(),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      width: double.infinity,
                      height: 50.0,
                      child: isLoading
                          ? Center(child: CircularProgressIndicator())
                          : FlatButton(
                              onPressed: () async {
                                setModalState(() {
                                  isLoading = true;
                                });
                                await createTicket(context,
                                    userId: user.uid,
                                    scheduledDate: scheduledDate,
                                    scheduledTime: scheduledTime,
                                    numberOfTickets: numberOfTickets,
                                    finalAmount: finalAmount,
                                    location: location);
                                setModalState(() {
                                  isLoading = false;
                                });
                              },
                              color: Theme.of(context).primaryColor,
                              child: Text(
                                'Pay Now',
                                style: body1.copyWith(color: Colors.white),
                              ),
                            ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      });
}

addTicketToFirestore(Ticket ticket) async {
  CollectionReference userTicketsRef = FirebaseFirestore.instance
      .collection('explore')
      .doc('userTickets')
      .collection('allTickets');

  await userTicketsRef.add({
    'id': ticket.id,
    'date': ticket.date.millisecondsSinceEpoch,
    'name': ticket.name,
    'email': ticket.email,
    'phone': ticket.phone,
    'university': ticket.university,
    'department': ticket.department ?? '',
    'locationName': ticket.locationName,
    'locationDuration': ticket.locationDuration,
    'scheduledDate': ticket.scheduledDate.millisecondsSinceEpoch,
    'scheduledTime': ticket.scheduledTime.millisecondsSinceEpoch,
    'numberOfTickets': ticket.numberOfTickets,
    'finalAmount': ticket.finalAmount,
    'userId': ticket.userId,
  });
}

createTicket(
  context, {
  @required ExploreLocation location,
  @required DateTime scheduledDate,
  @required DateTime scheduledTime,
  @required int numberOfTickets,
  @required int finalAmount,
  @required String userId,
}) async {
  final form = formKey.currentState;
  if (form.validate()) {
    form.save();
    // TODO: TAKE USER TO PAYMENT SCREEN TO PAY FINAL AMOUNT
    Ticket ticket = Ticket(
      id: Uuid().v4(),
      date: DateTime.now(),
      name: name,
      email: email,
      phone: phone,
      university: university,
      department: department ?? '',
      locationName: location.name,
      locationDuration: location.duration,
      scheduledDate: scheduledDate,
      scheduledTime: scheduledTime,
      numberOfTickets: numberOfTickets,
      finalAmount: finalAmount,
      userId: userId,
    );

    await addTicketToFirestore(ticket);

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TicketScreen(ticket)));
  }
}
