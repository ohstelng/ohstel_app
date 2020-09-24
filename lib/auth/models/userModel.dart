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

  UserModel.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['uid'];
    this.email = mapData['email'];
    this.fullName = mapData['fullName'];
    this.userName = mapData['userName'];
    this.schoolLocation = mapData['schoolLocation'];
    this.phoneNumber = mapData['phoneNumber'];
    this.uniName = mapData['uniName'];
    this.uniDetails = mapData['uniDetails'];
    this.profilePicUrl = mapData['profilePicUrl'];
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

    return data;
  }
}
