import 'package:flutter/cupertino.dart';

class WalletModel {
  double walletBalance;
  double coinBalance;

  WalletModel({
    @required this.walletBalance,
    @required this.coinBalance,
  });

  WalletModel.fromMap(Map<String, dynamic> mapData) {
    this.walletBalance = mapData['walletBalance'] != null
        ? double.parse(mapData['walletBalance'].toString())
        : 0.0;
    this.coinBalance = mapData['coinBalance'] != null
        ? double.parse(mapData['coinBalance'].toString())
        : 0.0;
  }

  Map toMap() {
    Map<String, dynamic> data = Map();

    data['walletBalance'] = this.walletBalance;
    data['coinBalance'] = this.coinBalance;

    return data;
  }
}
