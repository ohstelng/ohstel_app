import 'package:Ohstel_app/hive_methods/hive_class.dart';
import 'package:Ohstel_app/wallet/models/wallet_history_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class WalletMethods {
//  final String uid;
//
//  WalletMethods(this.uid);

  final CollectionReference userDataCollectionRef =
      FirebaseFirestore.instance.collection('userData');
  final CollectionReference walletHistoryCollectionRef =
      FirebaseFirestore.instance.collection('walletHistory');
  final CollectionReference coinHistoryCollectionRef =
      FirebaseFirestore.instance.collection('coinHistory');

  final CollectionReference fundHistoryCollectionRef =
      FirebaseFirestore.instance.collection('fundHistory');

  ///

  Future<void> fundWallet({@required double amount}) async {
    Map userData = await HiveMethods().getUserData();
    String type = 'credit';
    String ref = 'funded wallet. userID: ${userData['uid']}';
    String desc =
        'Funded Wallet With $amount From Paystack By ${userData['fullName']}';
    try {
      final DocumentReference userDoc =
          userDataCollectionRef.doc(userData['uid']);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot docSnapshot = await transaction.get(userDoc);
        double previousAmount =
            (double.parse(docSnapshot.data()['walletBalance'].toString()) ?? 0);
        print('ppppppppppppppppppppppppppppppppppppppp');
        print(previousAmount);
        int updatedWalletBalance;
        int balance = docSnapshot.data()['walletBalance'];
        print(balance);

        if (!docSnapshot.exists) {
          print('Document does not exist!');
          throw Exception("Document does not exist!");
        }

        updatedWalletBalance = (balance == null ? 0 : balance) + amount.toInt();

        print("balance = $updatedWalletBalance");

        transaction.update(
          userDoc,
          {'walletBalance': updatedWalletBalance.toInt()},
        );

        WalletHistoryModel walletHistory = WalletHistoryModel(
          amount: amount.toString(),
          balance: updatedWalletBalance.toString(),
          previousAmount: previousAmount.toString(),
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
    } catch (e) {
      print(e);
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
          userDataCollectionRef.doc(userData['uid']);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot docSnapshot = await transaction.get(userDoc);
        double previousAmount =
            (double.parse(docSnapshot.data()['walletBalance'].toString()) ?? 0);
        print('ppppppppppppppppppppppppppppppppppppppp');
        print(previousAmount);
        int updatedWalletBalance;
        int balance = docSnapshot.data()['walletBalance'] ?? 0;
        print(balance);

        if (!docSnapshot.exists) {
          print('Document does not exist!');
          throw Exception("Document does not exist!");
        }

        if (balance < amount) {
          print('Insufficient Balance!');
          throw Exception("Insufficient Balance!!");
        }

        updatedWalletBalance = balance - amount.toInt();

        print("balance = $updatedWalletBalance");

        transaction.update(
          userDoc,
          {'walletBalance': updatedWalletBalance.toInt()},
        );

        walletHistoryCollectionRef.add({
          'amount': amount.toString(),
          'balance': updatedWalletBalance,
          'previousAmount': previousAmount,
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
