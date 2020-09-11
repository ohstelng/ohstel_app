import 'package:Ohstel_app/hive_methods/hive_class.dart';
import 'package:Ohstel_app/wallet/method.dart';
import 'package:Ohstel_app/wallet/models/wallet_history_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class WalletHistoryPage extends StatefulWidget {
  @override
  _WalletHistoryPageState createState() => _WalletHistoryPageState();
}

class _WalletHistoryPageState extends State<WalletHistoryPage> {
  Map userData;
  bool loading = true;

  Future<void> getUserData() async {
    if (!mounted) return;

    setState(() {
      loading = true;
    });
    userData = await HiveMethods().getUserData();

    if (!mounted) return;
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? Center(child: CircularProgressIndicator())
          : PaginateFirestore(
              itemBuilder: (_, BuildContext context, DocumentSnapshot snap) {
                WalletHistoryModel walletHistory =
                    WalletHistoryModel.fromMap(snap.data());

                return Container();
              },
              query: WalletMethods()
                  .walletHistoryCollectionRef
                  .doc(userData['uid'])
                  .collection('walletHistory')
                  .orderBy('date'),
              itemBuilderType: dynamic,
            ),
    );
  }
}
