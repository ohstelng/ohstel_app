import 'package:Ohstel_app/hostel_booking/_/model/coin_history.dart';
import 'package:Ohstel_app/hostel_booking/_/model/wallet_history_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class WalletMethods {
  final String uid;
  WalletMethods(this.uid);
  final CollectionReference userDataCollectionRef =
      Firestore.instance.collection('userData');
  final CollectionReference walletHistoryCollectionRef =
      Firestore.instance.collection('walletHistory');
  final CollectionReference coinHistoryCollectionRef =
      Firestore.instance.collection('coinHistory');

  Future<void> createWalletHistory(
    double amount, {
    String type = 'fund',
    String ref = '',
    @required String desc,
  }) async {
    try {
      final DocumentReference userDoc = userDataCollectionRef.document(uid);
      await Firestore.instance.runTransaction((transaction) async {
        DocumentSnapshot txSnapshot = await transaction.get(userDoc);
        double updatedWalletBalance;
        if (!txSnapshot.exists) {
          print("Document does not exist!");
          throw Exception("Document does not exist!");
        }

        if (type == 'fund') {
          updatedWalletBalance =
              (double.parse(txSnapshot.data['walletBalance'].toString()) ?? 0) +
                  amount;
        } else {
          updatedWalletBalance =
              (double.parse(txSnapshot.data['walletBalance'].toString()) ?? 0) -
                  amount;
        }
        print("balance = $updatedWalletBalance");
        transaction.update(
            userDoc, {'walletBalance': updatedWalletBalance.toString()});
        walletHistoryCollectionRef.add({
          'amount': amount.toString(),
          'balance': updatedWalletBalance,
          'desc': desc,
          'date': Timestamp.now(),
          'type': type,
          'ref': ref,
          'uid': uid,
        });
        return updatedWalletBalance;
      });
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '${e.message}');
    }
  }

  Future<void> createCoinHistory(
    double amount, {
    String type = 'credit',
    //String ref = '',
    @required String desc,
  }) async {
    try {
      final DocumentReference userDoc = userDataCollectionRef.document(uid);
      await Firestore.instance.runTransaction((transaction) async {
        DocumentSnapshot txSnapshot = await transaction.get(userDoc);
        double updatedCoinBalance;
        if (!txSnapshot.exists) {
          throw Exception("Document does not exist!");
        }
        if (type == 'credit') {
          updatedCoinBalance =
              (double.parse(txSnapshot.data['coinBalance'].toString()) ?? 0) +
                  amount;
        } else {
          updatedCoinBalance =
              (double.parse(txSnapshot.data['coinBalance'].toString()) ?? 0) -
                  amount;
        }
        transaction
            .update(userDoc, {'coinBalance': updatedCoinBalance.toString()});

        coinHistoryCollectionRef.add({
          'amount': amount.toString(),
          'balance': updatedCoinBalance,
          'desc': desc,
          'date': Timestamp.now(),
          'type': type,
          'uid': uid,
        });

        return updatedCoinBalance;
      });
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '${e.message}');
    }
  }

  Future<List<WalletHistoryModel>> fetchWalletHistory() async {
    List<WalletHistoryModel> walletHistorys = List<WalletHistoryModel>();

    try {
      QuerySnapshot querySnapshot = await walletHistoryCollectionRef
          .where('uid', isEqualTo: uid)
          .orderBy('date', descending: true)
          .limit(6)
          .getDocuments();

      for (var i = 0; i < querySnapshot.documents.length; i++) {
        walletHistorys
            .add(WalletHistoryModel.fromMap(querySnapshot.documents[i].data));
        print(walletHistorys);
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '${e}');
    }
    return walletHistorys;
  }

  Future<List<CoinHistoryModel>> fetchCoinHistory() async {
    List<CoinHistoryModel> coinHistorys = List<CoinHistoryModel>();

    try {
      QuerySnapshot querySnapshot = await coinHistoryCollectionRef
          .where('uid', isEqualTo: uid)
          .orderBy('date', descending: true)
          .limit(6)
          .getDocuments();

      for (var i = 0; i < querySnapshot.documents.length; i++) {
        coinHistorys
            .add(CoinHistoryModel.fromMap(querySnapshot.documents[i].data));
        print(coinHistorys);
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '${e}');
    }
    return coinHistorys;
  }

  Future<void> convertCoin(double amount) async {
    try {
      final DocumentReference userDoc = userDataCollectionRef.document(uid);
      await Firestore.instance.runTransaction((transaction) async {
        DocumentSnapshot txSnapshot = await transaction.get(userDoc);

        if (!txSnapshot.exists) {
          throw Exception("Document does not exist!");
        }

        if (double.parse(txSnapshot.data['coinBalance']) < amount) {
          return Fluttertoast.showToast(msg: 'Insufficient Coin Balance');
        }

        double updatedCoinBalance =
            (double.parse(txSnapshot.data['coinBalance'].toString()) ?? 0) -
                amount;

        transaction
            .update(userDoc, {'coinBalance': updatedCoinBalance.toString()});

        double updatedWalletBalance =
            (double.parse(txSnapshot.data['walletBalance'].toString()) ?? 0) +
                amount;

        transaction.update(
            userDoc, {'walletBalance': updatedWalletBalance.toString()});

        coinHistoryCollectionRef.add({
          'amount': amount.toString(),
          'balance': updatedCoinBalance,
          'desc': "Coin Converted into Wallet Ballance",
          'date': Timestamp.now(),
          'type': 'debit',
          'uid': uid,
        });

        walletHistoryCollectionRef.add({
          'amount': amount.toString(),
          'balance': updatedWalletBalance,
          'desc': "Coin Converted into Wallet Ballance",
          'date': Timestamp.now(),
          'type': 'fund',
          'ref': '',
          'uid': uid,
        });

        return updatedCoinBalance;
      });
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '${e.message}');
    }
  }
}
