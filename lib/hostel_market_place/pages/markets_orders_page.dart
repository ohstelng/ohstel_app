import 'package:Ohstel_app/hive_methods/hive_class.dart';
import 'package:Ohstel_app/hostel_market_place/models/paid_market_orders_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class MarketOrdersPage extends StatefulWidget {
  @override
  _MarketOrdersPageState createState() => _MarketOrdersPageState();
}

class _MarketOrdersPageState extends State<MarketOrdersPage> {
  Map userData;
  bool isLoading = true;

  Future<void> getUserData() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    userData = await HiveMethods().getUserData();
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      body: isLoading ? Container(child: CircularProgressIndicator()) : body(),
    );
  }

  Widget body() {
    print(userData['uid']);
    return Container(
      margin: EdgeInsets.all(10.0),
      child: PaginateFirestore(
        scrollDirection: Axis.vertical,
        itemsPerPage: 3,
        physics: BouncingScrollPhysics(),
        initialLoader: Container(
          height: 50,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        bottomLoader: Center(
          child: CircularProgressIndicator(),
        ),
        shrinkWrap: true,
        query: FirebaseFirestore.instance
            .collection('marketOrders')
            .where('buyerID', isEqualTo: userData['uid'])
            .orderBy('timestamp', descending: true),
        itemBuilder: (_, context, DocumentSnapshot documentSnapshot) {
          PaidOrderModel currentProductModel =
              PaidOrderModel.fromMap(documentSnapshot.data());

          DateTime date =
              DateTime.parse(currentProductModel.timestamp.toDate().toString());

          return InkWell(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.all(5.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${currentProductModel.id}'),
                          Text('${DateFormat.yMMMd().add_jm().format(date)}'),
                        ],
                      ),
                      Text('${currentProductModel.amountPaid}'),
                    ],
                  ),
                  Divider(),
                ],
              ),
            ),
          );
        }, itemBuilderType: dynamic,
      ),
    );
  }
}
