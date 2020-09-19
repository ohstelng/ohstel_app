import 'dart:convert';
import 'dart:io';

import 'package:Ohstel_app/auth/methods/auth_methods.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class InitHive {
  Future startHive({@required String boxName}) async {
    Directory documentDir = await getApplicationSupportDirectory();
    Hive.init(documentDir.path);
    await Hive.openBox<Map>(boxName);
  }

  Future startLocationHive() async {
    Directory documentDir = await getApplicationSupportDirectory();
    Hive.init(documentDir.path);
    await Hive.openBox<Map>('locationBox');
  }

  Future startFoodAddressDetailHive() async {
    Directory documentDir = await getApplicationSupportDirectory();
    Hive.init(documentDir.path);
    await Hive.openBox<Map>('addressBox');
  }

  Future startLaundryBasketHive() async {
    Directory documentDir = await getApplicationSupportDirectory();
    Hive.init(documentDir.path);
    await Hive.openBox<Map>('laundryBox');
  }

  Future startLaundryAddressDetailHive() async {
    Directory documentDir = await getApplicationSupportDirectory();
    Hive.init(documentDir.path);
    await Hive.openBox<Map>('laundryAddressBox');
  }

  Future startCartHiveDb() async {
    Directory documentDir = await getApplicationSupportDirectory();
    Hive.init(documentDir.path);
    await Hive.openBox<Map>('cart');
  }

  Future startMarketCartHiveDb() async {
    Directory documentDir = await getApplicationSupportDirectory();
    Hive.init(documentDir.path);
    await Hive.openBox<Map>('marketCart');
  }
}

class HiveMethods {
  Future<Box<Map>> getOpenBox(String boxName) async {
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox(boxName);
    }
    return Hive.box(boxName);
  }

  Future<String> getUniName() async {
    Box<Map> userDataBox = await getOpenBox('userDataBox');

    Map uniDetails = userDataBox.get(0)['uniDetails'];
    print(uniDetails);
    String uniName = uniDetails['abbr'].toString().toLowerCase();
    return uniName;
  }

  Future<String> getAddress() async {
    Box<Map> userDataBox = await getOpenBox('userDataBox');

    String address = userDataBox.get(0)['address'];
    return address;
  }

  Future<String> getUid() async {
    Box<Map> userDataBox = await getOpenBox('userDataBox');

    String uid = userDataBox.get(0)['uid'];
    return uid;
  }

  Future<Map> getUserData() async {
    Box<Map> userDataBox = await getOpenBox('userDataBox');

    if (userDataBox.isEmpty) {
      AuthService().signOut();
    }
    print(userDataBox.toMap());
    print('ooooooooooooooooooooooooooooooooooooo');
    Map userData = userDataBox.getAt(0);
    print(userDataBox.isEmpty);
    return userData;
  }

  Future<Box> getCartData() async {
    Box<Map> cartDataBox = await getOpenBox('cart');

    print(cartDataBox.isEmpty);
    return cartDataBox;
  }

  Future<void> saveFoodCartToDb({@required Map map}) async {
    Box<Map> cartDataBox = await getOpenBox('cart');

    cartDataBox.add(map);
//    cartDataBox.put('laste', value)
    Fluttertoast.showToast(msg: 'Added To Cart');
    print('saved');
  }

  Future<void> saveMarketCartToDb({@required Map map}) async {
    Box<Map> cartDataBox = await getOpenBox('marketCart');

    cartDataBox.add(map);
    Fluttertoast.showToast(msg: 'Added To Cart');
    print('saved');
  }

  //Todo: implement update address
  //Todo: implement update address
  //Todo: implement update address
  //Todo: implement update address

  Future<void> updateUserAddress({@required Map map}) async {
    Box<Map> userDataBox = await getOpenBox('userDataBox');

    userDataBox.putAt(0, map);
    print('saved');
  }

  Future<void> saveLocationToDb({@required Map map}) async {
    Box<Map> locationDataBox = await getOpenBox('locationBox');

    locationDataBox.put(0, map);
    print('saved');
  }

  Future intiLocationData() async {
    Box<Map> locationDataBox = await getOpenBox('locationBox');
    print('checking loction Db');

    if (locationDataBox.isEmpty) {
      await getLocationDateFromApi();
    } else {
      int lastUpdate = locationDataBox.values.toList()[0]['lastUpdate'];
      int lastUpdateInMilliseconds =
          Duration(milliseconds: lastUpdate).inMilliseconds -
              DateTime.now().millisecondsSinceEpoch;

      int daysSinceLastUpdate =
          Duration(milliseconds: lastUpdateInMilliseconds.abs()).inDays;

      print(daysSinceLastUpdate);

      if (daysSinceLastUpdate > 4) {
        getLocationDateFromApi();
      }
    }
  }

  Future<void> getLocationDateFromApi() async {
    try {
      String url =
          "https://quiz-demo-de79d.appspot.com/hostel_api/all_sub_locations";
      var response = await http.get(url);
      Map data = json.decode(response.body);
      data['lastUpdate'] = DateTime.now().millisecondsSinceEpoch;

      saveLocationToDb(map: data);
    } catch (e) {
      print(e);
      return;
    }
  }

  Future<Map> getLocationDataFromDb() async {
    Box<Map> locationDataBox = await getOpenBox('locationBox');

    Map locationData = locationDataBox.get(0);

    return locationData;
  }

  Future<void> saveFoodLocationDetailsToDb({@required Map map}) async {
    Box<Map> cartDataBox = await getOpenBox('addressBox');

    cartDataBox.put(0, map);
    print('saved');
  }

  Future<Map> getFoodLocationDetails() async {
    Box<Map> addressDetailsDataBox = await getOpenBox('addressBox');

    Map addressDetails = addressDetailsDataBox.get(0);
    return addressDetails;
  }

  Future<void> saveLaundryToBasketCart({@required Map data}) async {
    Box<Map> laundryBasket = await getOpenBox('laundryBox');

    laundryBasket.add(data);
    print('saved');
    Fluttertoast.showToast(msg: 'Added To Basket');
  }

  Future<void> saveToLaundryPickUpBox({@required Map data}) async {
    Box<Map> laundryBasket = await getOpenBox('laundryAddressBox');
    String key = 'pickUp';

    laundryBasket.put(key, data);
    print('saved');
    Fluttertoast.showToast(msg: 'Added To pickUp');
  }

  Future<void> saveToLaundryDropBox({@required Map data}) async {
    Box<Map> laundryBasket = await getOpenBox('laundryAddressBox');
    String key = 'dropOff';

    laundryBasket.put(key, data);
    print('saved');
    Fluttertoast.showToast(msg: 'Added To dropOff');
  }

  Future<Map> getLaundryPickUpDetails() async {
    Box<Map> addressDetailsDataBox = await getOpenBox('laundryAddressBox');

    Map addressDetails = addressDetailsDataBox.get('pickUp');
    return addressDetails;
  }

  Future<Map> getLaundryDropOffDetails() async {
    Box<Map> addressDetailsDataBox = await getOpenBox('laundryAddressBox');

    Map addressDetails = addressDetailsDataBox.get('dropOff');
    return addressDetails;
  }
}
