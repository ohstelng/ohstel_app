import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FastFoodMethods {
  final CollectionReference foodCollectionRef =
  FirebaseFirestore.instance.collection('food');

  final CollectionReference orderedFoodCollectionRef =
  FirebaseFirestore.instance.collection('orderedFood');

  Future<List<Map>> getFoodsFromDb({@required String uniName}) async {
    List<Map> fastFoodList = List<Map>();

    try {
      QuerySnapshot querySnapshot = await foodCollectionRef
          .orderBy('fastFood')
          .where('uniName', isEqualTo: uniName)
          .get();

      for (var i = 0; i < querySnapshot.docs.length; i++) {
        fastFoodList.add(querySnapshot.docs[i].data());
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
