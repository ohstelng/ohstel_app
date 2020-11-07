import 'package:Ohstel_app/hostel_food/_/models/extras_food_details.dart';
import 'package:Ohstel_app/hostel_food/_/models/food_details_model.dart';
import 'package:flutter/cupertino.dart';

class FoodCartModel {
  ItemDetails itemDetails;
  int totalPrice;
  int numberOfPlates;
  List<ExtraItemDetails> extraItems;
  String itemFastFoodLocation;
  String fastFoodStateLocation;
  String fastFoodMainArea;

  FoodCartModel({
    @required this.itemDetails,
    @required this.totalPrice,
    @required this.numberOfPlates,
    @required this.extraItems,
    @required this.itemFastFoodLocation,
    @required this.fastFoodStateLocation,
    @required this.fastFoodMainArea,
  });

  FoodCartModel.fromMap(mapData) {
    List<ExtraItemDetails> extralist = [];
    for (Map map in mapData['extraItems'] ?? []) {
      extralist.add(ExtraItemDetails.fromMap(map));
    }

    this.itemDetails = ItemDetails.formMap(mapData['itemDetails']);
    this.totalPrice = mapData['totalPrice'];
    this.numberOfPlates = mapData['numberOfPlates'];
    this.itemFastFoodLocation = mapData['itemFastFoodLocation'];
    this.fastFoodStateLocation = mapData['fastFoodStateLocation'];
    this.fastFoodMainArea = mapData['fastFoodMainArea'];
    this.extraItems = extralist;
  }

  Map toMap() {
    List extraItemsMapList = [];

    if (this.extraItems != null) {
      this.extraItems.toList().forEach((element) {
        extraItemsMapList.add(element.toMap());
      });
    }

    Map data = Map<String, dynamic>();
    data['itemDetails'] = this.itemDetails.toMap();
    data['totalPrice'] = this.totalPrice;
    data['numberOfPlates'] = this.numberOfPlates;
    data['itemFastFoodLocation'] = this.itemFastFoodLocation;
    data['fastFoodStateLocation'] = this.fastFoodStateLocation;
    data['fastFoodMainArea'] = this.fastFoodMainArea;
    data['extraItems'] = extraItemsMapList;
    return data;
  }
}
