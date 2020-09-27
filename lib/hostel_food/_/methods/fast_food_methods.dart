import 'package:Ohstel_app/hostel_food/_/models/fast_food_details_model.dart';
import 'package:Ohstel_app/hostel_food/_/models/paid_food_model.dart';
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
          .where('display', isEqualTo: true)
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

  Future<void> saveOrderToDb({@required PaidFood paidFood}) async {
    try {
      print('iiiiii');
      await orderedFoodCollectionRef.doc(paidFood.id).set(paidFood.toMap());
      Fluttertoast.showToast(msg: 'Order Sucessfull!');
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '$e');
    }
  }

  Future<FastFoodModel> getDrinksFromDb() async {
    FastFoodModel drinksData;

    try {
      DocumentSnapshot documentSnapshot =
          await foodCollectionRef.doc('drinks').get();

//      for (var i = 0; i < querySnapshot.docs.length; i++) {
//        fastFoodList.add(querySnapshot.docs[i].data());
//      }
      drinksData = FastFoodModel.fromMap(documentSnapshot.data());
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '$e');
    }

    return drinksData;
  }
}
