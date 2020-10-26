import 'package:Ohstel_app/hostel_hire/model/hire_agent_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HireMethods {
  CollectionReference hireCollection =
      FirebaseFirestore.instance.collection('hire');

  CollectionReference laundryOrderCollection =
      FirebaseFirestore.instance.collection('laundryOrder');

  Future<List<HireWorkerModel>> getWorkerByKeyword(
      {@required String keyword}) async {
    print('ppppppppppppp');
    print(keyword);
    List<HireWorkerModel> hireWorkersList = List<HireWorkerModel>();

    print('oooooooooooooooooooo');
    QuerySnapshot querySnapshot = await hireCollection
        .doc('workers')
        .collection('allWorkers')
        .orderBy('dateJoined', descending: true)
        .where('searchKeys', arrayContains: keyword)
        .limit(5)
        .get();

    print('oooooooooooooooooooo2222');
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      print(querySnapshot.docs[i].data());
      print(i);
      hireWorkersList
          .add(HireWorkerModel.fromMap(querySnapshot.docs[i].data()));
    }

    print(hireWorkersList.length);
    print('oooooooooooooooooooo33333333');
    print(hireWorkersList);
    return hireWorkersList;
  }

  Future<List<HireWorkerModel>> getMoreWorkerByKeyword(
      {@required String keyword,
      @required HireWorkerModel lastWorkerModel}) async {
    List<HireWorkerModel> hireWorkersList = List<HireWorkerModel>();

    QuerySnapshot querySnapshot = await hireCollection
        .doc('workers')
        .collection('allWorkers')
        .orderBy('dateJoined', descending: true)
        .where('searchKeys', arrayContains: keyword)
        .startAfter([lastWorkerModel.dateJoined])
        .limit(3)
        .get();

    for (var i = 0; i < querySnapshot.docs.length; i++) {
      hireWorkersList
          .add(HireWorkerModel.fromMap(querySnapshot.docs[i].data()));
    }

    return hireWorkersList;
  }

  Future<void> saveLaundryToServer(
      {@required Map data, @required String id}) async {
    try {
      await laundryOrderCollection.doc(id).set(data);
      Fluttertoast.showToast(msg: 'Order Added To DataBase.');
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '$e');
    }
  }

  ///
  List<Map> catList = [
    {
      'searchKey': 'Laundry',
      'imageUrl':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQG_x83EKHSX_btg-lJ0DbYhJGXqNzxSG4_pg&usqp=CAU'
    },
    {
      'searchKey': 'Painter',
      'imageUrl':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRwYu9MAK0d0PAOYQjNPWNn98TC7FQHzssfTA&usqp=CAU'
    },
    {
      'searchKey': 'Carpenter',
      'imageUrl':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSWoblzstQ0xTj46gkbIgBdb_2wXZfvUc-prQ&usqp=CAU'
    },
    {
      'searchKey': 'Electrician',
      'imageUrl':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcS2ckZIUhwPY1UGXHSdi6mQSr1EcYguQz5Qsg&usqp=CAU'
    },
  ];
}
