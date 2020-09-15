import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class WalletHistoryModel {
  String amount;
  dynamic balance;
  dynamic previousAmount;
  String desc;
  Timestamp date;
  String type;
  String ref;
  String uid;

  WalletHistoryModel({
    @required this.amount,
    @required this.balance,
    @required this.previousAmount,
    @required this.desc,
    @required this.type,
    @required this.ref,
    @required this.uid,
  });

  WalletHistoryModel.fromMap(Map<String, dynamic> mapData) {
    this.amount = mapData['amount'];
    this.balance = mapData['balance'];
    this.previousAmount = mapData['previousAmount'];
    this.desc = mapData['desc'];
    this.date = mapData['date'];
    this.type = mapData['type'];
    this.ref = mapData['ref'];
    this.uid = mapData['uid'];
  }

  Map toMap() {
    Map<String, dynamic> data = Map();

    data['amount'] = this.amount;
    data['balance'] = this.balance;
    data['previousAmount'] = this.previousAmount;
    data['desc'] = this.desc;
    data['date'] = Timestamp.now();
    data['type'] = this.type;
    data['ref'] = this.ref;
    data['uid'] = this.uid;

    return data;
  }
}
