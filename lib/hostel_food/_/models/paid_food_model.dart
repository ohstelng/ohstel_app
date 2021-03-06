import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class PaidFood {
  Timestamp timestamp;
  String phoneNumber;
  String email;
  String buyerFullName;
  String address;
  String orderState;
  List fastFoodNames;
  List orders;
  String uniName;
  String id = Uuid().v1().toString();
  String buyerID;
  bool doneWith;
  int amountPaid;

  // this will be a map of area name and address
  Map addressDetails;

  PaidFood({
    @required this.address,
    @required this.buyerFullName,
    @required this.buyerID,
    @required this.phoneNumber,
    @required this.email,
    @required this.fastFoodNames,
    @required this.orders,
    @required this.uniName,
    @required this.addressDetails,
    @required this.amountPaid,
    @required this.orderState,
  });

  PaidFood.fromMap(mapData) {
    this.timestamp = mapData['timestamp'];
    this.phoneNumber = mapData['phoneNumber'];
    this.buyerFullName = mapData['buyerFullName'];
    this.fastFoodNames = mapData['fastFoodName'];
    this.email = mapData['email'];
    this.address = mapData['address'];
    this.orders = mapData['orders'];
    this.uniName = mapData['uniName'];
    this.addressDetails = mapData['addressDetails'];
    this.id = mapData['id'];
    this.buyerID = mapData['buyerID'];
    this.amountPaid = mapData['amountPaid'];
    this.orderState = mapData['orderState'];
  }

  Map toMap() {
    Map<String, dynamic> data = Map<String, dynamic>();
    data['timestamp'] = Timestamp.now();
    data['address'] = this.address;
    data['buyerFullName'] = this.buyerFullName;
    data['phoneNumber'] = this.phoneNumber;
    data['fastFoodName'] = this.fastFoodNames;
    data['email'] = this.email;
    data['orders'] = this.orders;
    data['uniName'] = this.uniName;
    data['addressDetails'] = this.addressDetails;
    data['id'] = this.id;
    data['doneWith'] = false;
    data['buyerID'] = this.buyerID;
    data['amountPaid'] = this.amountPaid;
    data['orderState'] = this.orderState;

    return data;
  }
}

class EachOrder {
  String fastFoodName;
  String status;
  String mainItem;
  List extraItems;
  int numberOfPlates;

  EachOrder({
    @required this.fastFoodName,
    @required this.mainItem,
    @required this.extraItems,
    @required this.numberOfPlates,
  });

  EachOrder.fromMap(mapData) {
    this.mainItem = mapData['mainItem'];
    this.fastFoodName = mapData['fastFoodName'];
    this.extraItems = mapData['extraItems'];
    this.numberOfPlates = mapData['numberOfPlates'];
    this.status = mapData['status'];
  }

  Map toMap() {
    Map data = Map<String, dynamic>();
    data['fastFoodName'] = this.fastFoodName;
    data['mainItem'] = this.mainItem;
    data['extraItems'] = this.extraItems;
    data['numberOfPlates'] = this.numberOfPlates;
    data['status'] = 'Awaiting Delivery';

    return data;
  }
}
