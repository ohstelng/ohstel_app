import 'package:Ohstel_app/hostel_hire/model/hire_agent_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class LaundryBookingModel {
  String clothTypes; // either shirt trouser etc
//  int units;

  /// LaundryModeAndPrice is a Map is key laundryMode (e.g wash only  or wash and Iron) corresponding to a value Price(i.e the price for that particular laundryMode)
  /// Example: {wash only = 500, wash and Iron = 600}
  /// this is how the clothes will be washed which are 1. wash only 2. wash and Iron 3. dry clean
  Map laundryModeAndPrice;

//  int price;
  String imageUrl;

  LaundryBookingModel({
    @required this.clothTypes,
//    @required this.units,
    @required this.laundryModeAndPrice,
//    @required this.price,
    @required this.imageUrl,
  });

  LaundryBookingModel.fromMap(Map<String, dynamic> mapData) {
    this.clothTypes = mapData['clothTypes'];
//    this.units = mapData['units'];
    this.laundryModeAndPrice = mapData['laundryModeAndPrice'];
//    this.price = mapData['price'];
    this.imageUrl = mapData['imageUrl'];
  }

  Map toMap() {
    Map<String, dynamic> data = Map<String, dynamic>();
    data['clothTypes'] = this.clothTypes;
//    data['units'] = this.units;
    data['laundryModeAndPrice'] = this.laundryModeAndPrice;
//    data['price'] = this.price;
    data['imageUrl'] = this.imageUrl;

    return data;
  }
}

//Future<void> setPrice() async {
//  await FirebaseFirestore.instance
//      .collection('hire')
//      .doc('workers')
//      .collection('allWorkers')
//      .orderBy('dateJoined', descending: true)
//      .where('workType', isEqualTo: 'laundry')
//      .get()
//      .then((_value) async {
//    Map l = {'Wash Only': 500, 'Wash and Iron': 600, 'Dry Clean': 700};
//
//    for (var i = 0; i < _value.docs.length; i++) {
//      print(i);
//      await FirebaseFirestore.instance
//          .collection('hire')
//          .doc('workers')
//          .collection('allWorkers')
//          .doc(_value.docs[i].id)
//          .get()
//          .then((value) async {
//        print(value.data());
//        HireWorkerModel h = HireWorkerModel.fromMap(value.data());
//        List list = [];
//        String currentID = _value.docs[i].id;
//
//        for (Map i in h.laundryList) {
//          LaundryBookingModel laun = LaundryBookingModel.fromMap(i);
//          print(laun.toMap());
//          Map updateLaun = laun.toMap();
//          updateLaun['laundryModeAndPrice'] = l;
//          list.add(updateLaun);
//          print(updateLaun);
//          print(' ');
//        }
//        print(h.laundryList);
//        print(list);
//
//        Map data = h.toMap();
//        data['laundryList'] = list;
//        print(h.toMap());
//        print(data);
//
//        await FirebaseFirestore.instance
//            .collection('hire')
//            .doc('workers')
//            .collection('allWorkers')
//            .doc(currentID)
//            .update(data);
////        print(h);
//      });
//    }
//  });
//}
