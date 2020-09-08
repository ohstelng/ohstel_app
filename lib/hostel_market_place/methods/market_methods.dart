import 'package:Ohstel_app/hostel_market_place/models/paid_market_orders_model.dart';
import 'package:Ohstel_app/hostel_market_place/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MarketMethods {
  final CollectionReference marketCollection =
      FirebaseFirestore.instance.collection('market');

  final CollectionReference marketOrderCollection =
      FirebaseFirestore.instance.collection('marketOrders');

  Future<List<Map>> getAllCategories() async {
    List<Map> dataList = List<Map>();

    try {
      QuerySnapshot querySnapshot = await marketCollection
          .doc('categories')
          .collection('productsList')
          .limit(8)
          .get();

      for (var i = 0; i < querySnapshot.docs.length; i++) {
        Map<String, dynamic> data = Map();
        String id = querySnapshot.docs[i].data()['searchKey'];
        String imageUrl = querySnapshot.docs[i].data()['imageUrl'];

        data['searchKey'] = id;
        data['imageUrl'] = imageUrl;
        dataList.add(data);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: '${e}');
    }

    return dataList;
  }

  Future<void> saveOrderToDataBase({@required PaidOrderModel data}) async {
    try {
      await marketOrderCollection.doc(data.id).set(data.toMap());
      Fluttertoast.showToast(msg: 'Order Complete!');
    } catch (e) {
      Fluttertoast.showToast(msg: '${e}');
    }
  }

  Future<List<ProductModel>> getProductByKeyword(
      {@required String keyword}) async {
    List<ProductModel> productList = List<ProductModel>();

    QuerySnapshot querySnapshot = await marketCollection
        .doc('products')
        .collection('allProducts')
        .orderBy('dateAdded', descending: true)
        .where('searchKeys', arrayContains: keyword)
        .limit(5)
        .get();

    for (var i = 0; i < querySnapshot.docs.length; i++) {
      productList.add(ProductModel.fromMap(querySnapshot.docs[i].data()));
    }

    return productList;
  }

  Future<List<ProductModel>> getMoreProductByKeyword({
    @required String keyword,
    @required ProductModel lastProduct,
  }) async {
    List<ProductModel> productList = List<ProductModel>();

    QuerySnapshot querySnapshot = await marketCollection
        .doc('products')
        .collection('allProducts')
        .orderBy('dateAdded', descending: true)
        .where('searchKeys', arrayContains: keyword)
        .startAfter([lastProduct.dateAdded])
        .limit(3)
        .get();

    for (var i = 0; i < querySnapshot.docs.length; i++) {
      productList.add(ProductModel.fromMap(querySnapshot.docs[i].data()));
    }

    return productList;
  }
}
