import 'package:flutter/cupertino.dart';

class FastFoodModel {
  String fastFoodName;
  String address;
  String openTime;
  String logoImageUrl;
  List itemDetails;
  List extraItems;
  bool haveExtras;
  String uniName;

  FastFoodModel({
    @required this.fastFoodName,
    @required this.address,
    @required this.openTime,
    @required this.logoImageUrl,
    @required this.itemDetails,
    @required this.extraItems,
    @required this.haveExtras,
    @required this.uniName,
  });

//  List<ItemDetails> getItemDetails(List<Map> data) {
//    List<ItemDetails> _itemDetails = List<ItemDetails>();
//
//    for (var d in data) {
//      _itemDetails.add(ItemDetails.formMap(d));
//    }
//
//    return _itemDetails;
//  }
//
//  List<ExtraItemDetails> getExtraItemDetails(List<Map> data) {
//    List<ExtraItemDetails> _extraItemDetails = List<ExtraItemDetails>();
//
//    for (var d in data) {
//      _extraItemDetails.add(ItemDetails.formMap(d));
//    }
//
//    return _extraItemDetails;
//  }

  FastFoodModel.fromMap(Map<String, dynamic> mapData) {
    this.fastFoodName = mapData['fastFood'];
    this.address = mapData['address'];
    this.openTime = mapData['openTime'];
    this.logoImageUrl = mapData['logoImageUrl'];
    this.itemDetails = mapData['itemsDetails'];
    this.extraItems = mapData['extraItems'];
    this.haveExtras = mapData['haveExtras'];
    this.uniName = mapData['uniName'];
  }

  Map toMap() {
    Map data = Map<String, dynamic>();
    data['fastFood'] = this.fastFoodName;
    data['address'] = this.address;
    data['openTime'] = this.openTime;
    data['logoImageUrl'] = this.logoImageUrl;
    data['itemDetails'] = this.itemDetails;
    data['extraItems'] = this.extraItems;
    data['haveExtras'] = this.haveExtras;
    data['uniName'] = this.uniName;

    return data;
  }
}
