import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class PaidOrderModel {
  String buyerFullName;
  String buyerEmail;
  String buyerPhoneNumber;
  String buyerAddress;
  Timestamp timestamp;
  List<String> listOfShopsPurchasedFrom;
  List<Map> orders;
  String id = Uuid().v1().toString();

  PaidOrderModel({
    @required this.buyerFullName,
    @required this.buyerEmail,
    @required this.buyerPhoneNumber,
    @required this.buyerAddress,
    @required this.timestamp,
    @required this.listOfShopsPurchasedFrom,
    @required this.orders,
  });

  PaidOrderModel.fromMap(Map<String, dynamic> mapData) {
    this.buyerFullName = mapData['buyerFullName'];
    this.buyerEmail = mapData['buyerEmail'];
    this.buyerPhoneNumber = mapData['buyerPhoneNumber'];
    this.buyerAddress = mapData['buyerAddress'];
    this.timestamp = mapData['timestamp'];
    this.listOfShopsPurchasedFrom = mapData['listOfShopsPurchasedFrom'];
    this.orders = mapData['orders'];
    this.id = mapData['id'];
  }

  Map toMap() {
    Map data = Map<String, dynamic>();
    data['buyerFullName'] = this.buyerFullName;
    data['buyerEmail'] = this.buyerEmail;
    data['buyerPhoneNumber'] = this.buyerPhoneNumber;
    data['buyerAddress'] = this.buyerAddress;
    data['timestamp'] = this.timestamp;
    data['listOfShopsPurchasedFrom'] = this.listOfShopsPurchasedFrom;
    data['orders'] = this.orders;
    data['id'] = this.id;

    return data;
  }
}

class EachPaidOrderModel {
  String productName;
  List<String> imageUrls;
  String productCategory;
  int productPrice;
  String productShopName;
  String productShopOwnerEmail;
  int productShopOwnerPhoneNumber;
  int units;

  EachPaidOrderModel({
    @required this.productName,
    @required this.imageUrls,
    @required this.productCategory,
    @required this.productPrice,
    @required this.productShopName,
    @required this.productShopOwnerEmail,
    @required this.productShopOwnerPhoneNumber,
    @required this.units,
  });

  EachPaidOrderModel.fromMap(Map<String, dynamic> mapData) {
    this.productName = mapData['productName'];
    this.imageUrls = mapData['imageUrls'].cast<String>();
    this.productCategory = mapData['productCategory'];
    this.productPrice = mapData['productPrice'];
    this.productShopName = mapData['productShopName'];
    this.productShopOwnerEmail = mapData['productShopOwnerEmail'];
    this.units = mapData['units'];
    this.productShopOwnerPhoneNumber =
        int.parse(mapData['productShopOwnerPhoneNumber']);
  }

  Map toMap() {
    Map data = Map<String, dynamic>();

    data['productName'] = this.productName.toLowerCase();
    data['imageUrls'] = this.imageUrls;
    data['productCategory'] = this.productCategory.toLowerCase();
    data['productShopName'] = this.productShopName.toLowerCase();
    data['productShopOwnerEmail'] = this.productShopOwnerEmail;
    data['units'] = this.units;
    data['productShopOwnerPhoneNumber'] =
        this.productShopOwnerPhoneNumber.toString();
    data['productPrice'] = this.productPrice;

    return data;
  }
}
