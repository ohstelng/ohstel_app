import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';

class AuthDatabaseMethods {
  // collection ref
  final CollectionReference userDataCollectionRef =
      FirebaseFirestore.instance.collection('userData');

  Future createUserDataInFirestore({
    @required String uid,
    @required String email,
    @required String fullName,
    @required String userName,
    @required String schoolLocation,
    @required String phoneNumber,
    @required String uniName,
    @required Map uniDetails,
  }) {
    return userDataCollectionRef.doc(uid).set(
      {
        'uid': uid,
        'email': email,
        'fullName': fullName,
        'userName': userName,
        'phoneNumber': phoneNumber,
        'uniDetails': uniDetails,
        'walletBalance': 0,
        'coinBalance': 0,
      },
//      merge: true,
    );
  }

  Future<String> uploadFile({@required File image}) async {
    int currentDateTime = DateTime.now().millisecondsSinceEpoch;
    String imageUrl;

    try {
      StorageReference storageReference = FirebaseStorage.instance
          .ref()
          .child('profileImage/$currentDateTime}');

      StorageUploadTask uploadTask = storageReference.putFile(image);

      await uploadTask.onComplete;

      print('File Uploaded');
      await storageReference.getDownloadURL().then((fileURL) {
        imageUrl = fileURL;
        print(imageUrl);
      });
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '${e.message}');
    }

    return imageUrl;
  }

  Future<void> updateProfilePic(
      {@required String uid, @required String url}) async {
    try {
      await userDataCollectionRef.doc(uid).update(
        {'profilePicUrl': url},
      );
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '${e.message}');
    }
  }

  Future<void> updateUserPhoneNumber(
      {@required String uid, @required String phoneNumber}) async {
    try {
      await userDataCollectionRef.doc(uid).update(
        {'phoneNumber': phoneNumber},
      );
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '${e.message}');
    }
  }

  Future<void> updateUserUniversity(
      {@required String uid, @required Map uniDetail}) async {
    try {
      await userDataCollectionRef.doc(uid).update(
        {'uniDetails': uniDetail},
      );
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '${e.message}');
    }
  }

  void saveUserDataToDb({@required Map userData}) {
    Box<Map> userDataBox = Hive.box<Map>('userDataBox');
    final key = 0;
    final value = userData;

    userDataBox.put(key, value);
    print('saved');
  }
}
