import 'package:Ohstel_app/hostel_market_place/models/paid_market_orders_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MarketMethods {
  final CollectionReference marketCollection =
      Firestore.instance.collection('market');

  final CollectionReference marketOrderCollection =
      Firestore.instance.collection('marketOrders');

  Future<List<Map>> getAllCategories() async {
    List<Map> dataList = List<Map>();

    try {
      QuerySnapshot querySnapshot = await marketCollection
          .document('categories')
          .collection('productsList')
          .limit(8)
          .getDocuments();

      for (var i = 0; i < querySnapshot.documents.length; i++) {
        Map<String, dynamic> data = Map();
        String id = querySnapshot.documents[i].data['searchKey'];
        String imageUrl = querySnapshot.documents[i].data['imageUrl'];

        data['searchKey'] = id;
        data['imageUrl'] = imageUrl;
        dataList.add(data);
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '${e}');
    }

    return dataList;
  }

  Future<void> saveOrderToDataBase({@required PaidOrderModel data}) async {
    try {
      await marketOrderCollection.document(data.id).setData(data.toMap());
      Fluttertoast.showToast(msg: 'Order Complete!');
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '${e}');
    }
  }
}
