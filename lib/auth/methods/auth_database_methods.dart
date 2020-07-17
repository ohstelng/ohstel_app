import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class AuthDatabaseMethods {
  // collection ref
  final CollectionReference userDataCollectionRef =
      Firestore.instance.collection('userData');

  Future createUserDataInFirestore({
    @required String uid,
    @required String email,
    @required String fullName,
    @required String userName,
    @required String schoolLocation,
    @required String phoneNumber,
  }) {
    return userDataCollectionRef.document(uid).setData(
      {
        'uid': uid,
        'email': email,
        'fullName': fullName,
        'userName': userName,
        'schoolLocation': schoolLocation,
        'phoneNumber': phoneNumber,
      },
      merge: true,
    );
  }
}
