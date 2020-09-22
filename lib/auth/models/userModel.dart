import 'package:flutter/cupertino.dart';

class UserModel {
  String uid;
  String email;
  String fullName;
  String userName;
  String schoolLocation;
  String phoneNumber;
  String uniName;
  String profilePicUrl;
  double walletBalance;
  double coinBalance;
  Map uniDetails;

  UserModel({
    @required this.uid,
    @required this.email,
    @required this.fullName,
    @required this.userName,
    @required this.schoolLocation,
    @required this.phoneNumber,
    @required this.uniName,
    @required this.uniDetails,
  });

  // TODO: i had to remove type Map<String, dynamic> from here, hope i didnt break something
  UserModel.fromMap(mapData) {
    this.uid = mapData['uid'];
    this.email = mapData['email'];
    this.fullName = mapData['fullName'];
    this.userName = mapData['userName'];
    this.schoolLocation = mapData['schoolLocation'];
    this.phoneNumber = mapData['phoneNumber'];
    this.uniName = mapData['uniName'];
    this.uniDetails = mapData['uniDetails'];
    this.profilePicUrl = mapData['profilePicUrl'];
    this.walletBalance = mapData['walletBalance'] != null
        ? double.parse(mapData['walletBalance'].toString())
        : 0.0;
    this.coinBalance = mapData['coinBalance'] != null
        ? double.parse(mapData['coinBalance'].toString())
        : 0.0;
  }

  Map toMap() {
    Map<String, dynamic> data = Map<String, dynamic>();
    data['uid'] = this.uid;
    data['email'] = this.email;
    data['fullName'] = this.fullName;
    data['userName'] = this.userName;
    data['schoolLocation'] = this.schoolLocation;
    data['phoneNumber'] = this.phoneNumber;
    data['uniName'] = this.uniName;
    data['uniDetails'] = this.uniDetails;
    data['profilePicUrl'] = this.profilePicUrl;
    data['coinBalance'] = this.coinBalance;
    data['walletBalance'] = this.walletBalance;

    return data;
  }
}
