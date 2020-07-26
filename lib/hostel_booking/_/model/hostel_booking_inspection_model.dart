import 'package:flutter/cupertino.dart';

class HostelBookingInspectionModel {
  String fullName;
  String phoneNumber;
  String email;
  String date;
  String time;
  String id;
  Map hostelDetails;

  HostelBookingInspectionModel({
    @required this.fullName,
    @required this.phoneNumber,
    @required this.email,
    @required this.date,
    @required this.time,
    @required this.id,
    @required this.hostelDetails,
  });

  HostelBookingInspectionModel.fromMap(Map<String, dynamic> mapData) {
    this.fullName = mapData['fullName'];
    this.phoneNumber = mapData['phoneNumber'];
    this.email = mapData['email'];
    this.date = mapData['date'];
    this.time = mapData['time'];
    this.time = mapData['id'];
    this.hostelDetails = mapData['hostelDetails'];
  }

  Map toMap() {
    Map data = Map<String, dynamic>();
    data['fullName'] = this.fullName;
    data['phoneNumber'] = this.phoneNumber;
    data['email'] = this.email;
    data['date'] = this.date;
    data['time'] = this.time;
    data['id'] = this.id;
    data['hostelDetails'] = this.hostelDetails;

    return data;
  }
}
