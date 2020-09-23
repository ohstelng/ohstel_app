import 'package:cloud_firestore/cloud_firestore.dart';

class CoinHistoryModel {
  double amount;
  double balance;
  DateTime date;
  String desc;
  //String ref;
  String type;

  CoinHistoryModel(
      {this.amount, this.balance, this.date, this.desc, this.type});

  CoinHistoryModel.fromMap(Map<String, dynamic> mapData) {
    this.amount = double.parse(mapData['amount'].toString());
    this.balance = double.parse(mapData['balance'].toString());
    this.date = mapData['date'].toDate();
    this.desc = mapData['desc'];
    //this.ref = mapData['ref'];
    this.type = mapData['type'];
  }

  Map toMap() {
    Map data = Map<String, dynamic>();
    data['amount'] = this.amount.toString();
    data['balance'] = this.balance.toString();
    data['date'] =
        Timestamp.fromMillisecondsSinceEpoch(this.date.millisecondsSinceEpoch);
    //data['ref'] = this.ref;
    data['type'] = this.type;

    return data;
  }
}
