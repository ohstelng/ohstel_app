import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class InitHive {
  Future startHive({@required String boxName}) async {
    Directory documentDir = await getApplicationSupportDirectory();
    Hive.init(documentDir.path);
    await Hive.openBox<Map>(boxName);
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

    String uniName = userDataBox.get(0)['uniName'];
    return uniName;
  }

  Future<String> getAddress() async {
    Box<Map> userDataBox = await getOpenBox('userDataBox');

    String address = userDataBox.get(0)['address'];
    return address;
  }

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

  Future<void> updateUserAddress({@required Map map}) async {
    Box<Map> userDataBox = await getOpenBox('userDataBox');

    userDataBox.putAt(0, map);
    print('saved');
  }
}
