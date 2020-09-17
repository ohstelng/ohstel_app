import 'package:flutter/cupertino.dart';

class LaundryBookingModel {
  String clothTypes; // either shirt trouser etc
  int units;
  int price;

  /// LaundryModeAndPrice is a Map is key laundryMode (e.g wash only  or wash and Iron) corresponding to a value Price(i.e the price for that particular laundryMode)
  /// Example: {wash only = 500, wash and Iron = 600}
  /// this is how the clothes will be washed which are 1. wash only 2. wash and Iron 3. dry clean
  String laundryMode;

  LaundryBookingModel({
    @required this.clothTypes,
    @required this.units,
    @required this.laundryMode,
    @required this.price,
  });

  LaundryBookingModel.fromMap(Map<String, dynamic> mapData) {
    this.clothTypes = mapData['clothTypes'];
    this.units = mapData['units'];
    this.laundryMode = mapData['laundryMode'];
    this.price = mapData['price'];
  }

  Map toMap() {
    Map<String, dynamic> data = Map<String, dynamic>();
    data['clothTypes'] = this.clothTypes;
    data['units'] = this.units;
    data['laundryMode'] = this.laundryMode;
    data['price'] = this.price;

    return data;
  }
}
