import 'package:Ohstel_app/auth/methods/auth_database_methods.dart';
import 'package:Ohstel_app/models/login_user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
      );

      // create user data
//      await DatabaseService(uid: user.uid).updateUserData(
//        email: email,
//        fullName: fullName,
//        userName: userName,
//      );

      // create public user data
//      await DatabaseService(uid: user.uid).createPublicUserData(
//        email: email,
//        fullName: fullName,
//        userName: userName,
//      );

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
      return await auth.signOut();
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '${e.message}');
    }
  }
}
