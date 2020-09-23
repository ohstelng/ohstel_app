import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class FastFoodModel {
  String fastFoodName;
  String address;
  String openTime;
  String logoImageUrl;
  List itemDetails;
  List extraItems;
  List itemCategoriesList;
  bool haveExtras;
  String uniName;
  String locationName;

  FastFoodModel({
    @required this.fastFoodName,
    @required this.address,
    @required this.openTime,
    @required this.logoImageUrl,
    @required this.itemDetails,
    @required this.extraItems,
    @required this.itemCategoriesList,
    @required this.haveExtras,
    @required this.uniName,
    @required this.locationName,
  });

  FastFoodModel.fromMap(Map<String, dynamic> mapData) {
    this.fastFoodName = mapData['fastFood'];
    this.address = mapData['address'];
    this.openTime = mapData['openTime'];
    this.logoImageUrl = mapData['logoImageUrl'];
    this.itemDetails = mapData['itemDetails'];
    this.extraItems = mapData['extraItems'];
    this.itemCategoriesList = mapData['itemCategoriesList'];
    this.haveExtras = mapData['haveExtras'];
    this.uniName = mapData['uniName'];
    this.locationName = mapData['locationName'];
  }

  Map toMap() {
    Map data = Map<String, dynamic>();
    data['fastFood'] = this.fastFoodName;
    data['address'] = this.address;
    data['openTime'] = this.openTime;
    data['logoImageUrl'] = this.logoImageUrl;
    data['itemDetails'] = this.itemDetails;
    data['extraItems'] = this.extraItems;
    data['itemCategoriesList'] = this.itemCategoriesList;
    data['haveExtras'] = this.haveExtras;
    data['uniName'] = this.uniName;
    data['locationName'] = this.locationName;

    return data;
  }
}

void setIt() async {
  await FirebaseFirestore.instance.collection('food').get().then((value) {
    value.docs.forEach((element) async {
      print(element.id);
      await FirebaseFirestore.instance
          .collection('food')
          .doc(element.id)
          .update({
        'locationName': ['tanke', 'oke ode', 'mark'][Random().nextInt(3)],
      });
    });
  });
}
