import 'package:flutter/cupertino.dart';

class PaidHostelModel {
  String fullName;
  String phoneNumber;
  String email;
  int price;
  String id;
  Map hostelDetails;

  PaidHostelModel({
    @required this.fullName,
    @required this.phoneNumber,
    @required this.email,
    @required this.price,
    @required this.id,
    @required this.hostelDetails,
  });

  PaidHostelModel.fromMap(Map<String, dynamic> mapData) {
    this.fullName = mapData['fullName'];
    this.phoneNumber = mapData['phoneNumber'];
    this.email = mapData['email'];
    this.price = mapData['price'];
    this.id = mapData['id'];
    this.hostelDetails = mapData['hostelDetails'];
  }

  Map toMap() {
    Map data = Map<String, dynamic>();
    data['fullName'] = this.fullName;
    data['phoneNumber'] = this.phoneNumber;
    data['email'] = this.email;
    data['price'] = this.price;
    data['id'] = this.id;
    data['hostelDetails'] = this.hostelDetails;

    return data;
  }
}
