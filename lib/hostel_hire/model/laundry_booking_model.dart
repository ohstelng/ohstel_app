import 'package:flutter/cupertino.dart';

class LaundryBookingModel {
  String clothTypes; // either shirt trouser etc
//  int units;
//  String
//      laundryMode; // this is how the clothes will be washed which are 1. wash only 2. wash only 3. dry clean
  int price;
  String imageUrl;

  LaundryBookingModel({
    @required this.clothTypes,
//    @required this.units,
//    @required this.laundryMode,
    @required this.price,
    @required this.imageUrl,
  });

  LaundryBookingModel.fromMap(Map<String, dynamic> mapData) {
    this.clothTypes = mapData['clothTypes'];
//    this.units = mapData['units'];
//    this.laundryMode = mapData['laundryMode'];
    this.price = mapData['price'];
    this.imageUrl = mapData['imageUrl'];
  }

  Map toMap() {
    Map<String, dynamic> data = Map<String, dynamic>();
    data['clothTypes'] = this.clothTypes;
//    data['units'] = this.units;
//    data['laundryMode'] = this.laundryMode;
    data['price'] = this.price;
    data['imageUrl'] = this.imageUrl;

    return data;
  }
}
