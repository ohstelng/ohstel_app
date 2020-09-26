import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

class PaidLaundryBookingModel {
  String clothesOwnerName;
  String clothesOwnerEmail;
  String clothesOwnerPhoneNumber;
  Map clothesOwnerAddressDetails;
  List listOfLaundry;
  bool doneWith;
  String status;
  Timestamp timestamp;

  PaidLaundryBookingModel({
    @required this.clothesOwnerName,
    @required this.clothesOwnerEmail,
    @required this.clothesOwnerAddressDetails,
    @required this.clothesOwnerPhoneNumber,
    @required this.listOfLaundry,
  });

  PaidLaundryBookingModel.fromMap(Map<String, dynamic> mapData) {
    this.clothesOwnerName = mapData['clothesOwnerName'];
    this.clothesOwnerEmail = mapData['clothesOwnerEmail'];
    this.clothesOwnerAddressDetails = mapData['clothesOwnerAddressDetails'];
    this.clothesOwnerPhoneNumber = mapData['clothesOwnerPhoneNumber'];
    this.listOfLaundry = mapData['listOfLaundry'];
    this.doneWith = mapData['doneWith'];
    this.status = mapData['status'];
    this.timestamp = mapData['timestamp'];
  }

  Map toMap() {
    Map<String, dynamic> data = Map<String, dynamic>();
    data['clothesOwnerName'] = this.clothesOwnerName;
    data['clothesOwnerAddressDetails'] = this.clothesOwnerAddressDetails;
    data['clothesOwnerEmail'] = this.clothesOwnerEmail;
    data['clothesOwnerPhoneNumber'] = this.clothesOwnerPhoneNumber;
    data['listOfLaundry'] = this.listOfLaundry;
    data['timestamp'] = Timestamp.now();
//    data['listOfLaundryShop'] = this.listOfLaundry;
    data['doneWith'] = false;
    data['status'] = 'Awaitng PickUp...';
    data['id'] = Uuid().v1().toString();

    return data;
  }
}
