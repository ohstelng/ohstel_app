import 'package:Ohstel_app/hive_methods/hive_class.dart';
import 'package:Ohstel_app/wallet/method.dart';
import 'package:Ohstel_app/wallet/models/wallet_history_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    print(userData);
    print(userData['uid']);

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
          : SafeArea(
              child: Center(
                child: PaginateFirestore(
                  itemsPerPage: 5,
                  itemBuilder:
                      (_, BuildContext context, DocumentSnapshot snap) {
                    WalletHistoryModel walletHistory =
                        WalletHistoryModel.fromMap(snap.data());
                    DateTime date = walletHistory.date.toDate();
                    String _dateTime = DateFormat.yMMMd().add_jm().format(date);

                    return Card(
                      elevation: 2.5,
                      child: Container(
                        padding: EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text('${walletHistory.desc}'),
                                ),
                                Divider(),
                                Container(
                                  child: Text('$_dateTime'),
                                ),
                              ],
                            ),
                            Text(
                              '${walletHistory.type == 'credit' ? '+' : '-'}${walletHistory.amount}',
                              style: TextStyle(
                                fontSize: 18,
                                color: walletHistory.type == 'credit'
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  query: WalletMethods()
                      .fundHistoryCollectionRef
                      .doc(userData['uid'])
                      .collection('walletHistory')
                      .orderBy('date', descending: true),
                  itemBuilderType: PaginateBuilderType.listView,
                ),
              ),
            ),
    );
  }
}
