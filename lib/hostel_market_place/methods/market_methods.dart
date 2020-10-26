import 'package:Ohstel_app/hostel_market_place/models/paid_market_orders_model.dart';
import 'package:Ohstel_app/hostel_market_place/models/product_model.dart';
import 'package:Ohstel_app/hostel_market_place/models/shop_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MarketMethods {
  final CollectionReference marketCollection =
      FirebaseFirestore.instance.collection('market');

  final CollectionReference marketOrderCollection =
      FirebaseFirestore.instance.collection('marketOrders');

  final CollectionReference shopCollection =
      FirebaseFirestore.instance.collection('shopOwnersData');

  final CollectionReference marketData =
      FirebaseFirestore.instance.collection('marketData');

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
      Fluttertoast.showToast(msg: '$e');
    }

    return dataList;
  }

  Future<void> saveOrderToDataBase({@required PaidOrderModel data}) async {
    var dateParse = DateTime.parse(DateTime.now().toString());
    FirebaseFirestore db = FirebaseFirestore.instance;
    var batch = db.batch();

    try {
      data.orders.forEach((currentOrder) async {
        EachPaidOrderModel order = EachPaidOrderModel.fromMap(currentOrder);

        /// this Increses the Shop Owner Sales Count by one
        batch.set(
          marketData.doc('${order.productShopName}'),
          {"count": FieldValue.increment(1)},
          SetOptions(merge: true),
        );

        /// this Increses the Total Company Sales Count by one
        batch.set(
          marketData
              .doc('salesInfo')
              .collection(dateParse.year.toString())
              .doc(dateParse.month.toString()),
          {"count": FieldValue.increment(1)},
          SetOptions(merge: true),
        );
      });

      batch.set(
        marketOrderCollection.doc(data.id),
        data.toMap(),
      );

      await batch.commit();
      Fluttertoast.showToast(msg: 'Order Complete!');
    } catch (e) {
      Fluttertoast.showToast(msg: '$e');
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

  Future<List<ProductModel>> getShopItems(String shopName) async {
    List<ProductModel> productList = List<ProductModel>();

    QuerySnapshot querySnapshot = await marketCollection
        .doc('products')
        .collection('allProducts')
        .orderBy('dateAdded', descending: true)
        .where('productShopName', isEqualTo: shopName)
        .get();

    querySnapshot.docs.forEach((doc) {
      productList.add(ProductModel.fromMap(doc.data()));
    });

    return productList;
  }

  Future<List<ProductModel>> getPartnerShopCategoryItems(
      {String shopName, String category}) async {
    List<ProductModel> productList = List<ProductModel>();

    QuerySnapshot querySnapshot = await marketCollection
        .doc('products')
        .collection('allProducts')
        .orderBy('dateAdded', descending: true)
        .where('productShopName', isEqualTo: shopName)
        .where('partnerProductCategory', isEqualTo: category)
        .get();

    querySnapshot.docs.forEach((doc) {
      productList.add(ProductModel.fromMap(doc.data()));
    });

    return productList;
  }

  Future<List<ShopModel>> getPartnerShops() async {
    List<ShopModel> shopList = List<ShopModel>();

    QuerySnapshot querySnapshot = await shopCollection
        .where('isPartner', isEqualTo: true)
        .orderBy('shopName')
        .limit(10)
        .get();

    querySnapshot.docs.forEach((doc) {
      shopList.add(ShopModel.fromMap(doc.data()));
    });

    return shopList;
  }

  Future<List<ShopModel>> getTopPartnerShops() async {
    List<ShopModel> shopList = List<ShopModel>();

    final CollectionReference shopCollection =
        FirebaseFirestore.instance.collection('shopOwnersData');

    QuerySnapshot querySnapshot = await shopCollection
        .where('isPartner', isEqualTo: true)
        .orderBy('numberOfProducts', descending: true)
        .limit(4)
        .get();

    querySnapshot.docs.forEach((doc) {
      shopList.add(ShopModel.fromMap(doc.data()));
    });

    return shopList;
  }

  Future<List<ShopModel>> searchPartnerShop(String query) async {
    List<ShopModel> shopList = List<ShopModel>();

    final CollectionReference shopCollection =
        FirebaseFirestore.instance.collection('shopOwnersData');

    QuerySnapshot querySnapshot = await shopCollection
        .where('shopName', isGreaterThanOrEqualTo: query)
        .where('shopName', isLessThan: query + 'z')
        .orderBy('shopName')
        .limit(10)
        .get();

    querySnapshot.docs.forEach((doc) {
      print(doc.data());
      shopList.add(ShopModel.fromMap(doc.data()));
    });

    return shopList;
  }

  Future<List<ShopModel>> searchMorePartnerShop({
    String query,
    ShopModel lastShop,
  }) async {
    List<ShopModel> shopList = List<ShopModel>();

    final CollectionReference shopCollection =
        FirebaseFirestore.instance.collection('shopOwnersData');

    QuerySnapshot querySnapshot = await shopCollection
        .where('isPartner', isEqualTo: true)
        .where('shopName', isGreaterThanOrEqualTo: query)
        .where('shopName', isLessThan: query + 'z')
        .orderBy('shopName')
        .startAfter([lastShop.shopName])
        .limit(10)
        .get();

    querySnapshot.docs.forEach((doc) {
      print(doc.data());
      shopList.add(ShopModel.fromMap(doc.data()));
    });

    return shopList;
  }
}
