import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FastFoodMethods {
  final CollectionReference foodCollectionRef =
      Firestore.instance.collection('food');

  final CollectionReference orderedFoodCollectionRef =
      Firestore.instance.collection('orderedFood');

  Future<List<Map>> getFoodsFromDb({@required String uniName}) async {
    List<Map> fastFoodList = List<Map>();

    try {
      QuerySnapshot querySnapshot = await foodCollectionRef
          .orderBy('fastFood')
          .where('uniName', isEqualTo: uniName)
          .getDocuments();

      for (var i = 0; i < querySnapshot.documents.length; i++) {
        fastFoodList.add(querySnapshot.documents[i].data);
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '$e');
    }

    return fastFoodList;
  }

  Future<void> saveOrderToDb({@required Map data}) async {
    try {
      await orderedFoodCollectionRef.add(data);
      Fluttertoast.showToast(msg: 'Order Sucessfull!');
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '$e');
    }
  }
}
