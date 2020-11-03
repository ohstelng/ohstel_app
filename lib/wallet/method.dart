import 'dart:convert';

import 'package:Ohstel_app/auth/models/userModel.dart';
import 'package:Ohstel_app/hive_methods/hive_class.dart';
import 'package:Ohstel_app/wallet/models/wallet_history_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../constant/constant.dart';

class WalletMethods {
//  final String uid;
//
//  WalletMethods(this.uid);

  final CollectionReference userDataCollectionRef =
      FirebaseFirestore.instance.collection('userData');
  final CollectionReference userWalletCollectionRef =
      FirebaseFirestore.instance.collection('wallet');
  final CollectionReference userCoinCollectionRef =
      FirebaseFirestore.instance.collection('wallet');
  final CollectionReference fundHistoryCollectionRef =
      FirebaseFirestore.instance.collection('fundHistory');

  ///

  Future<void> fundWallet({@required int amount}) async {
    Map userData = await HiveMethods().getUserData();
    String type = 'credit';
    String ref = 'funded wallet. userID: ${userData['uid']}';
    String desc =
        'Funded Wallet With $amount From Paystack By ${userData['fullName']}';
    try {
      final DocumentReference userDoc =
          userWalletCollectionRef.doc(userData['uid']);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot docSnapshot = await transaction.get(userDoc);
        Map snapshotData = docSnapshot.data() ?? {'walletBalance': 0};

        int previousBalance = snapshotData['walletBalance'] ?? 0;
        print(previousBalance);
        int updatedWalletBalance;

        if (!docSnapshot.exists) {
          print('Document does not exist!');
          throw Exception("Document does not exist!");
        }

        updatedWalletBalance = previousBalance + amount.toInt();

        print("balance = $updatedWalletBalance");

        transaction.update(
          userDoc,
          {'walletBalance': updatedWalletBalance.toInt()},
        );

        WalletHistoryModel walletHistory = WalletHistoryModel(
          amount: amount.toInt().toString(),
          balance: updatedWalletBalance,
          previousAmount: previousBalance,
          desc: desc,
          type: type,
          ref: ref,
          uid: userData['uid'],
        );

        fundHistoryCollectionRef
            .doc(userData['uid'])
            .collection('walletHistory')
            .add(walletHistory.toMap());

        return updatedWalletBalance;
      });
    } catch (e, s) {
      print(e);
      print(s);
      Fluttertoast.showToast(msg: '$e');
    }
  }

  Future<int> deductWallet(
      {@required double amount,
      @required String payingFor,
      @required String itemId}) async {
    int status;
    Map userData = await HiveMethods().getUserData();
    String type = 'debit';
    String ref = 'userID: ${userData['uid']} , itemID: $itemId';
    String desc = '${userData['fullName']} Paided For $payingFor';

    try {
      final DocumentReference userDoc =
          userWalletCollectionRef.doc(userData['uid']);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot docSnapshot = await transaction.get(userDoc);
        Map snapshotData = docSnapshot.data() ?? {'walletBalance': 0};
        int previousBalance = snapshotData['walletBalance'] ?? 0;
        print(previousBalance);
        int updatedWalletBalance;

        if (!docSnapshot.exists) {
          print('Document does not exist!');
          throw Exception("Document does not exist!");
        }

        if (previousBalance < amount) {
          print('Insufficient Balance!');
          throw Exception("Insufficient Balance!!");
        }

        updatedWalletBalance = previousBalance - amount.toInt();

        print("balance = $updatedWalletBalance");

        transaction.update(
          userDoc,
          {'walletBalance': updatedWalletBalance.toInt()},
        );

        fundHistoryCollectionRef
            .doc(userData['uid'])
            .collection('walletHistory')
            .add({
          'amount': amount.toInt().toString(),
          'balance': updatedWalletBalance,
          'previousAmount': previousBalance,
          'desc': desc,
          'date': Timestamp.now(),
          'type': type,
          'ref': ref,
          'uid': userData['uid'],
        });
        status = 0;
//        return updatedWalletBalance;
      });
    } catch (e) {
      print(e);
      status = 1;
      Fluttertoast.showToast(msg: '$e');
    }

    return status;
  }

  Future<int> transferFund({
    @required double amount,
    @required UserModel receiver,
  }) async {
    int status;
    Map userData = await HiveMethods().getUserData();
    String type = 'debit';
    String ref = 'userID: ${userData['uid']} , receiver: ${receiver.uid}';
    String desc =
        '${userData['fullName']} Transfer $amount To ${receiver.fullName}';

    try {
      final DocumentReference userDoc =
          userWalletCollectionRef.doc(userData['uid']);
      final DocumentReference receiverDoc =
          userWalletCollectionRef.doc(receiver.uid);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        String userUid = await HiveMethods().getUid();
        DocumentSnapshot userDocSnapshot = await transaction.get(userDoc);
        DocumentSnapshot receiverDocSnapshot =
            await transaction.get(receiverDoc);
        Map userData = userDocSnapshot.data() ?? {'walletBalance': 0};
        Map receiverData = receiverDocSnapshot.data() ?? {'walletBalance': 0};
        int userPreviousBalance = userData['walletBalance'] ?? 0;
        int receiverPreviousBalance = receiverData['walletBalance'] ?? 0;

        int userUpdateWalletBalance;
        int receiverUpdateWalletBalance;

        if (!userDocSnapshot.exists && !receiverDocSnapshot.exists) {
          print('Document does not exist!');
          throw Exception(
              "Document does not exist!, Make Sure The Receiver Uid Is Correct");
        }
        print(1);

        if (userPreviousBalance < amount) {
          print('Insufficient Balance!');
          throw Exception("Insufficient Balance!!");
        }

        print(2);
        userUpdateWalletBalance = userPreviousBalance - amount.toInt();
        receiverUpdateWalletBalance = receiverPreviousBalance + amount.toInt();

        transaction.update(
          userDoc,
          {'walletBalance': userUpdateWalletBalance.toInt()},
        );
        print(3);

        transaction.update(
          receiverDoc,
          {'walletBalance': receiverUpdateWalletBalance.toInt()},
        );

        print(4);
        WalletHistoryModel userWalletHistory = WalletHistoryModel(
          amount: amount.toInt().toString(),
          balance: userUpdateWalletBalance,
          previousAmount: userPreviousBalance,
          desc: desc,
          type: type,
          ref: ref,
          uid: userUid,
        );

        WalletHistoryModel receiverWalletHistory = WalletHistoryModel(
          amount: amount.toInt().toString(),
          balance: receiverUpdateWalletBalance,
          previousAmount: receiverPreviousBalance,
          type: type,
          desc: desc,
          ref: ref,
          uid: receiver.uid,
        );

        print(5);
        print(userData);
        await fundHistoryCollectionRef
            .doc(userUid)
            .collection('walletHistory')
            .add(userWalletHistory.toMap());

        print(6);
        await fundHistoryCollectionRef
            .doc(receiver.uid)
            .collection('walletHistory')
            .add(receiverWalletHistory.toMap());

        status = 0;
      });
    } catch (e, s) {
      print(e);
      print(s);
      status = 1;
      Fluttertoast.showToast(msg: '$e');
    }

    return status;
  }

  Future<void> fundCoin(
      {@required int amount, @required BuildContext context}) async {
    Map userData = await HiveMethods().getUserData();
    String type = 'credit';
    String ref = 'funded wallet. userID: ${userData['uid']}';
    String desc =
        'Funded Coin With $amount From Video Ads By ${userData['fullName']}';
    try {
      final DocumentReference userDoc =
          userWalletCollectionRef.doc(userData['uid']);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot docSnapshot = await transaction.get(userDoc);
        Map userData = docSnapshot.data() ?? {'walletBalance': 0};
        int previousAmount = userData['coinBalance'];
        print('ppppppppppppppppppppppppppppppppppppppp');
        print(previousAmount);
        int updatedCoinBalance;
        int balance = docSnapshot.data()['coinBalance'];
        print(balance);

        if (!docSnapshot.exists) {
          print('Document does not exist!');
          throw Exception("Document does not exist!");
        }

        updatedCoinBalance = (balance == null ? 0 : balance) + amount.toInt();

        print("balance = $updatedCoinBalance");

        transaction.update(
          userDoc,
          {'coinBalance': updatedCoinBalance.toInt()},
        );

        WalletHistoryModel walletHistory = WalletHistoryModel(
          amount: amount.toInt().toString(),
          balance: updatedCoinBalance,
          previousAmount: previousAmount,
          desc: desc,
          type: type,
          ref: ref,
          uid: userData['uid'],
        );

        fundHistoryCollectionRef
            .doc(userData['uid'])
            .collection('coinHistory')
            .add(walletHistory.toMap());

        showSuccessMessage(context: context, price: amount);
      });
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '$e');
    }
  }

  Future<void> getCoin({@required BuildContext context}) async {
    int fee;

    String url = baseApiUrl + "/coinFee";
    var response = await http.get(url);
    var result = json.decode(response.body);
    print(result);

    if (result != null) {
      fee = result['coinFee'];

      fundCoin(amount: fee, context: context);
    }
  }

  void showSuccessMessage(
      {@required BuildContext context, @required int price}) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Congratulations'),
          content: Text(
              'You Have Just Recived $price. It Will Be Added To Your Coin Balance.'),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),
          ],
        );
      },
    );
  }

  ///
//  Future<void> createWalletHistory(
//    double amount, {
//    String type = 'fund',
//    String ref = '',
//    @required String desc,
//  }) async {
//    try {
//      final DocumentReference userDoc = userDataCollectionRef.doc(uid);
//
//      await FirebaseFirestore.instance.runTransaction((transaction) async {
//        DocumentSnapshot txSnapshot = await transaction.get(userDoc);
//        double updatedWalletBalance;
//        if (!txSnapshot.exists) {
//          print("Document does not exist!");
//          throw Exception("Document does not exist!");
//        }
//
//        if (type == 'fund') {
//          updatedWalletBalance =
//              (double.parse(txSnapshot.data()['walletBalance'].toString()) ??
//                      0) +
//                  amount;
//        } else {
//          updatedWalletBalance =
//              (double.parse(txSnapshot.data()['walletBalance'].toString()) ??
//                      0) -
//                  amount;
//        }
//        print("balance = $updatedWalletBalance");
//        transaction.update(
//          userDoc,
//          {'walletBalance': updatedWalletBalance.toString()},
//        );
//
//        walletHistoryCollectionRef.add({
//          'amount': amount.toString(),
//          'balance': updatedWalletBalance,
//          'desc': desc,
//          'date': Timestamp.now(),
//          'type': type,
//          'ref': ref,
//          'uid': uid,
//        });
//        return updatedWalletBalance;
//      });
//    } catch (e) {
//      print(e);
//      Fluttertoast.showToast(msg: '${e.message}');
//    }
//  }
//
//  Future<void> createCoinHistory(
//    double amount, {
//    String type = 'credit',
//    //String ref = '',
//    @required String desc,
//  }) async {
//    try {
//      final DocumentReference userDoc = userDataCollectionRef.doc(uid);
//      await FirebaseFirestore.instance.runTransaction((transaction) async {
//        DocumentSnapshot txSnapshot = await transaction.get(userDoc);
//        double updatedCoinBalance;
//        if (!txSnapshot.exists) {
//          throw Exception("Document does not exist!");
//        }
//        if (type == 'credit') {
//          updatedCoinBalance =
//              (double.parse(txSnapshot.data()['coinBalance'].toString()) ?? 0) +
//                  amount;
//        } else {
//          updatedCoinBalance =
//              (double.parse(txSnapshot.data()['coinBalance'].toString()) ?? 0) -
//                  amount;
//        }
//        transaction
//            .update(userDoc, {'coinBalance': updatedCoinBalance.toString()});
//
//        coinHistoryCollectionRef.add({
//          'amount': amount.toString(),
//          'balance': updatedCoinBalance,
//          'desc': desc,
//          'date': Timestamp.now(),
//          'type': type,
//          'uid': uid,
//        });
//
//        return updatedCoinBalance;
//      });
//    } catch (e) {
//      print(e);
//      Fluttertoast.showToast(msg: '${e.message}');
//    }
//  }
//
//  Future<List<WalletHistoryModel>> fetchWalletHistory() async {
//    List<WalletHistoryModel> walletHistorys = List<WalletHistoryModel>();
//
//    try {
//      QuerySnapshot querySnapshot = await walletHistoryCollectionRef
//          .where('uid', isEqualTo: uid)
//          .orderBy('date', descending: true)
//          .limit(6)
//          .get();
//
//      for (var i = 0; i < querySnapshot.docs.length; i++) {
//        walletHistorys
//            .add(WalletHistoryModel.fromMap(querySnapshot.docs[i].data()));
//        print(walletHistorys);
//      }
//    } catch (e) {
//      print(e);
//      Fluttertoast.showToast(msg: '${e}');
//    }
//    return walletHistorys;
//  }
//
//  Future<List<CoinHistoryModel>> fetchCoinHistory() async {
//    List<CoinHistoryModel> coinHistorys = List<CoinHistoryModel>();
//
//    try {
//      QuerySnapshot querySnapshot = await coinHistoryCollectionRef
//          .where('uid', isEqualTo: uid)
//          .orderBy('date', descending: true)
//          .limit(6)
//          .get();
//
//      for (var i = 0; i < querySnapshot.docs.length; i++) {
//        coinHistorys
//            .add(CoinHistoryModel.fromMap(querySnapshot.docs[i].data()));
//        print(coinHistorys);
//      }
//    } catch (e) {
//      print(e);
//      Fluttertoast.showToast(msg: '${e}');
//    }
//    return coinHistorys;
//  }
//
//  Future<void> convertCoin(double amount) async {
//    try {
//      final DocumentReference userDoc = userDataCollectionRef.doc(uid);
//      await FirebaseFirestore.instance.runTransaction((transaction) async {
//        DocumentSnapshot txSnapshot = await transaction.get(userDoc);
//
//        if (!txSnapshot.exists) {
//          throw Exception("Document does not exist!");
//        }
//
//        if (double.parse(txSnapshot.data()['coinBalance']) < amount) {
//          return Fluttertoast.showToast(msg: 'Insufficient Coin Balance');
//        }
//
//        double updatedCoinBalance =
//            (double.parse(txSnapshot.data()['coinBalance'].toString()) ?? 0) -
//                amount;
//
//        transaction
//            .update(userDoc, {'coinBalance': updatedCoinBalance.toString()});
//
//        double updatedWalletBalance =
//            (double.parse(txSnapshot.data()['walletBalance'].toString()) ?? 0) +
//                amount;
//
//        transaction.update(
//            userDoc, {'walletBalance': updatedWalletBalance.toString()});
//
//        coinHistoryCollectionRef.add({
//          'amount': amount.toString(),
//          'balance': updatedCoinBalance,
//          'desc': "Coin Converted into Wallet Ballance",
//          'date': Timestamp.now(),
//          'type': 'debit',
//          'uid': uid,
//        });
//
//        walletHistoryCollectionRef.add({
//          'amount': amount.toString(),
//          'balance': updatedWalletBalance,
//          'desc': "Coin Converted into Wallet Ballance",
//          'date': Timestamp.now(),
//          'type': 'fund',
//          'ref': '',
//          'uid': userData['uid'],
//        });
//
//        return updatedCoinBalance;
//      });
//    } catch (e) {
//      print(e);
//      Fluttertoast.showToast(msg: '${e.message}');
//    }
//  }
}
