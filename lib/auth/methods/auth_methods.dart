import 'package:Ohstel_app/auth/methods/auth_database_methods.dart';
import 'package:Ohstel_app/auth/models/login_user_model.dart';
import 'package:Ohstel_app/auth/models/userModel.dart';
import 'package:Ohstel_app/hive_methods/hive_class.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  // create login user object
  LoginUserModel userFromFirebase(FirebaseUser user) {
    return user != null ? LoginUserModel(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<LoginUserModel> get userStream {
    /// emit a stream of user current state(e.g emit an event when the user
    /// log out so the UI can be notify and update as needed or emit a event when
    /// a user log in so the UI can also be updated

    return auth.onAuthStateChanged.map(userFromFirebase);
  }

  // log in with email an pass
  Future loginWithEmailAndPassword(
      {@required String email, @required String password}) async {
    try {
      AuthResult result = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;

      await getUserDetails(uid: user.uid);

      return userFromFirebase(user);
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.message, toastLength: Toast.LENGTH_LONG);
      return null;
    }
  }

  // register with email an pass
  Future registerWithEmailAndPassword({
    @required String email,
    @required String password,
    @required String fullName,
    @required String userName,
    @required String schoolLocation,
    @required String phoneNumber,
    @required String uniName,
    @required Map uniDetails,
  }) async {
    try {
      AuthResult result = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      FirebaseUser user = result.user;

      // add user details to firestore database
      await AuthDatabaseMethods().createUserDataInFirestore(
        uid: user.uid,
        email: email,
        fullName: fullName,
        userName: userName,
        schoolLocation: schoolLocation,
        phoneNumber: phoneNumber,
        uniName: uniName,
        uniDetails: uniDetails,
      );

      UserModel userData = UserModel(
        uid: user.uid,
        email: email,
        fullName: fullName,
        userName: userName,
        schoolLocation: schoolLocation,
        phoneNumber: phoneNumber,
        uniName: uniName,
        uniDetails: uniDetails,
      );

      // save user info to local database using hive
      saveUserDataToDb(userData: userData.toMap());
//      getUserDetails(uid: user.uid);

      return userFromFirebase(user);
    } catch (e) {
      Fluttertoast.showToast(msg: e.message, toastLength: Toast.LENGTH_LONG);
      print(e.toString());
      return null;
    }
  }

  // signing out method
  Future signOut() async {
    try {
      await deleteAllUserDataToDb();
      return await auth.signOut();
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '${e.message}');
    }
  }

  Future getUserDetails({@required String uid}) async {
    final CollectionReference userDataCollectionRef =
        Firestore.instance.collection('userData');
    print(
        'uuuuuuuuuuuuuuuuuuuuuuuuiiiiiiiiiiiiiiiiiiiiiiiiiiiiddddddddddddddddddd');
    print(uid.trim());
    try {
      DocumentSnapshot document =
          await userDataCollectionRef.document(uid).get();
      print('pppppppppppppppppppppppppppppppppppppppppppppppppppppp');
      print(document.data);
      saveUserDataToDb(userData: document.data);
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

  Future<void> deleteAllUserDataToDb() async {
    Box<Map> userDataBox = await HiveMethods().getOpenBox('userDataBox');
    Box<Map> marketDataBox = await HiveMethods().getOpenBox('cart');
    Box<Map> foodDataBox = await HiveMethods().getOpenBox('marketCart');
    final key = 0;

    userDataBox.delete(key);
  }

//  Future<void> update() async {
//    final CollectionReference hostelCollectionRef =
//        Firestore.instance.collection('hostelBookings');
//
//    try {
//      QuerySnapshot querySnapshot = await hostelCollectionRef.getDocuments();
//      for (var i = 0; i < querySnapshot.documents.length; i++) {
//        String id = querySnapshot.documents[i].documentID;
//        await hostelCollectionRef.document(id).updateData({
//          'uniName': 'unilorin',
//        });
//        print(id);
//      }
//    } catch (e) {
//      print(e);
//      Fluttertoast.showToast(msg: '${e.message}');
//    }
//  }
}
