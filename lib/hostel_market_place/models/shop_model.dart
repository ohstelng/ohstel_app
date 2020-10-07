import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ShopModel {
  String shopName;
  String address;
  String email;
  int phoneNumber;
  String fullName;
  String uniName;
  int numberOfProducts;
  Timestamp dateJoined;
  String imageUrl;

  ShopModel({
    @required this.shopName,
    @required this.address,
    @required this.email,
    @required this.phoneNumber,
    @required this.fullName,
    @required this.uniName,
    this.numberOfProducts,
    this.imageUrl,
  });

  ShopModel.fromMap(Map<String, dynamic> mapData) {
    this.shopName = mapData['shopName'];
    this.address = mapData['address'];
    this.email = mapData['email'];
    this.phoneNumber = int.parse(mapData['phoneNumber'].toString());
    this.fullName = mapData['fullName'];
    this.uniName = mapData['uniName'];
    this.dateJoined = mapData['dateJoined'];
    this.numberOfProducts = mapData['numberOfProducts'];
    this.imageUrl = mapData['imageUrl'];
  }

  Map toMap() {
    Map data = Map<String, dynamic>();
    data['shopName'] = this.shopName;
    data['address'] = this.address;
    data['email'] = this.email;
    data['phoneNumber'] = this.phoneNumber.toString();
    data['fullName'] = this.fullName;
    data['uniName'] = this.uniName;
    data['numberOfProducts'] = this.numberOfProducts;
    data['imageUrl'] = this.imageUrl;
    data['dateJoined'] = Timestamp.now();

    return data;
  }
}

//List<ShopModel> list = [
//  ShopModel(
//    shopName: 'ola',
//    address: 'this will contain shop address ',
//    email: 'olashop123@gmail.com',
//    phoneNumber: 08099776655,
//    fullName: 'ola shoping',
//  ),
//  ShopModel(
//    shopName: 'teni',
//    address: 'this will contain shop address ',
//    email: 'teniShop123@gmail.com',
//    phoneNumber: 08011223344,
//    fullName: 'teni ola',
//  ),
//];
//
//Future<void> saveShop() async {
//  for (ShopModel shopModel in list) {
//    await Firestore.instance
//        .collection('shopOwnersData')
//        .document()
//        .setData(shopModel.toMap());
//  }
//}
