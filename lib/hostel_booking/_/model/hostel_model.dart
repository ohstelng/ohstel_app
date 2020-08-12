import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

class HostelModel {
  String hostelName;
  String hostelLocation;
  String hostelAreaName;
  int price;
  double distanceFromSchoolInKm;
  bool isRoomMateNeeded;
  int bedSpace;
  bool isSchoolHostel;
  String description;
  String extraFeatures;
  List<dynamic> imageUrl;
  int dateAdded;
  double ratings;
  String searchKey;
  String dormType;
  String uniName;
  String hostelAccommodationType;
  String landMark;
  String id = Uuid().v1().toString();

  HostelModel({
    @required this.hostelName,
    @required this.hostelLocation,
    @required this.hostelAreaName,
    @required this.price,
    @required this.distanceFromSchoolInKm,
    @required this.isRoomMateNeeded,
    @required this.bedSpace,
    @required this.isSchoolHostel,
    @required this.description,
    @required this.extraFeatures,
    @required this.imageUrl,
    @required this.dormType,
    @required this.landMark,
    @required this.hostelAccommodationType,
    @required this.ratings,
    @required this.uniName,
  });

  HostelModel.fromMap(Map<String, dynamic> mapData) {
    this.hostelName = mapData['hostelName'];
    this.hostelLocation = mapData['hostelLocation'];
    this.hostelAreaName = mapData['hostelAreaName'];
    this.price = mapData['price'];
    this.distanceFromSchoolInKm = mapData['distanceFromSchoolInKm'];
    this.isRoomMateNeeded = mapData['isRoomMateNeeded'];
    this.bedSpace = mapData['bedSpace'];
    this.isSchoolHostel = mapData['isSchoolHostel'];
    this.description = mapData['description'];
    this.extraFeatures = mapData['extraFeatures'];
    this.imageUrl = mapData['imageUrl'];
    this.dateAdded = mapData['dateAdded'];
    this.ratings = mapData['ratings'];
    this.searchKey = mapData['searchKey'];
    this.dormType = mapData['hostelType'];
    this.landMark = mapData['landMark'];
    this.uniName = mapData['uniName'];
    this.hostelAccommodationType = mapData['hostelAccommodationType'];
    this.id = mapData['id'];
  }

  Map toMap() {
    Map data = Map<String, dynamic>();
    data['hostelName'] = this.hostelName;
    data['hostelLocation'] = this.hostelLocation;
    data['hostelAreaName'] = this.hostelAreaName;
    data['hostelLocation'] = this.hostelLocation;
    data['price'] = this.price;
    data['distanceFromSchoolInKm'] = this.distanceFromSchoolInKm;
    data['isRoomMateNeeded'] = this.isRoomMateNeeded;
    data['bedSpace'] = this.bedSpace;
    data['isSchoolHostel'] = this.isSchoolHostel;
    data['description'] = this.description;
    data['extraFeatures'] = this.extraFeatures;
    data['imageUrl'] = this.imageUrl;
    data['uniName'] = this.uniName;
    data['dateAdded'] = Timestamp.now().microsecondsSinceEpoch;
    data['ratings'] = this.ratings;

    data['dormType'] =
        ['boys only', 'girls only', 'mixed'][Random().nextInt(3)];
    data['landMark'] = 'this will be a name of any land mark near the hostel';
    data['hostelAccommodationType'] =
        'accoomdation type one room, self contain, 2 bedroom(for off campus) while two, three or 4 to a room(for school hoste)';

    data['searchKey'] = this.hostelName[0].toLowerCase();
    data['id'] = this.id;

    return data;
  }
}
