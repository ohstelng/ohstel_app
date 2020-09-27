import 'package:Ohstel_app/hive_methods/hive_class.dart';
import 'package:Ohstel_app/hostel_food/_/methods/fast_food_methods.dart';
import 'package:Ohstel_app/hostel_food/_/models/paid_food_model.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class FoodOrderPage extends StatefulWidget {
  @override
  _FoodOrderPageState createState() => _FoodOrderPageState();
}

class _FoodOrderPageState extends State<FoodOrderPage> {
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
        itemsPerPage: 10,
        itemBuilderType: PaginateBuilderType.listView,
        query: FastFoodMethods()
            .orderedFoodCollectionRef
//            .where('doneWith', isEqualTo: false)
            .where('buyerID', isEqualTo: userData['uid'])
//            .where('fastFoodName', arrayContains: widget.fastFoodName)
            .orderBy('timestamp', descending: true),
        itemBuilder: (_, context, snap) {
//          print(snap.data())
          PaidFood paidOrder = PaidFood.fromMap(snap.data());
          return Container(
//              margin: EdgeInsets.all(5.0),
            child: Card(
              elevation: 2.0,
              child: ExpansionTile(
                title: Text('${paidOrder.id}'),
//                subtitle: Text('${paidOrder.timestamp.toDate()}'),
                children: [
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Buyer Name: ${paidOrder.buyerFullName}'),
                        Text('Buyer Number: ${paidOrder.phoneNumber}'),
                        Text('Buyer ID: ${paidOrder.buyerID}'),
                        Text('id: ${paidOrder.id}'),
                        Text('Buyer Email: ${paidOrder.email}'),
                        Text(
                            'Buyer Address: ${paidOrder.addressDetails['address']}, ${paidOrder.addressDetails['areaName']}. Oncampus: ${paidOrder.addressDetails['onCampus']}'),
                        Text('Number Of Orders: ${paidOrder.orders.length}'),
                      ],
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: paidOrder.orders.length,
                    itemBuilder: (context, index) {
                      EachOrder currentOrder =
                          EachOrder.fromMap(paidOrder.orders[index]);
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                        ),
                        margin: EdgeInsets.all(10.0),
                        child: details(currentOrder: currentOrder),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget details({@required EachOrder currentOrder}) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Food Name: ${currentOrder.mainItem}'),
          Text('Fast Food: ${currentOrder.fastFoodName}'),
          currentOrder.extraItems.isEmpty
              ? Container()
              : Container(
//                  decoration: BoxDecoration(
//                    border: Border.all(color: Colors.black),
//                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(),
                      Text('............ Extras ............'),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.70,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: currentOrder.extraItems.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.all(2.0),
                              child: Text(
                                  'Extra ${currentOrder.extraItems[index]}'),
                            );
                          },
                        ),
                      ),
                      Divider(),
                    ],
                  ),
                ),
//          Text('Price: ${currentOrder.productPrice}'),
//          Text('Category: ${currentOrder.productCategory}'),
          Text('deliveryStatus: ${currentOrder.status}'),
        ],
      ),
    );
  }

  Widget displayMultiPic({@required String image}) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 120,
        maxWidth: 150,
      ),
      child: image != null
          ? ExtendedImage.network(
              image,
              fit: BoxFit.fill,
              handleLoadingProgress: true,
              shape: BoxShape.rectangle,
              cache: false,
              enableMemoryCache: true,
            )
          : Center(child: Icon(Icons.image)),
    );
  }
}
