import 'dart:convert';
import 'dart:io';

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
    String uniName =
        uniDetails.values.toList()[0]['abbr'].toString().toLowerCase();
    return uniName;
  }

  Future<String> getAddress() async {
    Box<Map> userDataBox = await getOpenBox('userDataBox');

    String address = userDataBox.get(0)['address'];
    return address;
  }

  //TODO: implement userData checker
  //TODO: implement userData checker
  //TODO: implement userData checker
  //TODO: implement userData checker
  Future<Map> getUserData() async {
    Box<Map> userDataBox = await getOpenBox('userDataBox');

    Map userData = userDataBox.getAt(0);
    return userData;
  }

  Future<void> saveFoodCartToDb({@required Map map}) async {
    Box<Map> cartDataBox = await getOpenBox('cart');

    cartDataBox.add(map);
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
      String url = "http://ohstel.pythonanywhere.com/get_all_locations";
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
}
