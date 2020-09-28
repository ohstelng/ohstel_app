import 'package:Ohstel_app/hive_methods/hive_class.dart';
import 'package:Ohstel_app/hostel_market_place/models/paid_market_orders_model.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
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
            child: Card(
              child: ExpansionTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'id: ${currentProductModel.id}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Date: ${DateFormat.yMMMd().add_jm().format(date)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Aomunt Paid: NGN ${currentProductModel.amountPaid}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: currentProductModel.orders.length,
                    itemBuilder: (context, index) {
                      EachPaidOrderModel currentOrder =
                          EachPaidOrderModel.fromMap(
                        currentProductModel.orders[index],
                      );
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                        ),
//                        margin: EdgeInsets.all(10.0),
                        child: Row(
//                              mainAxisSize: MainAxisSize.min,
                          children: [
                            displayMultiPic(
                              imageList: currentOrder.imageUrls,
                            ),
                            details(currentOrder: currentOrder),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
        itemBuilderType: PaginateBuilderType.listView,
      ),
    );
  }

  Widget details({@required EachPaidOrderModel currentOrder}) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('productName: ${currentOrder.productName}'),
          Text('product Size: ${currentOrder.size ?? 'None'}'),
          Text('ShopName: ${currentOrder.productShopName}'),
          Text('Shop Email: ${currentOrder.productShopOwnerEmail}'),
          Text('Shop Number: ${currentOrder.productShopOwnerPhoneNumber}'),
          Text('Price: ${currentOrder.productPrice}'),
          Text('Category: ${currentOrder.productCategory}'),
          Text('deliveryStatus: ${currentOrder.deliveryStatus}'),
        ],
      ),
    );
  }

  Widget displayMultiPic({@required List imageList}) {
    List imgs = imageList.map(
      (images) {
        return Container(
          child: ExtendedImage.network(
            images,
            fit: BoxFit.fill,
            handleLoadingProgress: true,
            shape: BoxShape.rectangle,
            cache: false,
            enableMemoryCache: true,
          ),
        );
      },
    ).toList();
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      constraints: BoxConstraints(
        maxHeight: 120,
        maxWidth: 150,
      ),
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)),
            child: CarouselSlider(
              items: imgs,
              options: CarouselOptions(
                onPageChanged: (index, reason) {
                  setState(() {
//                    _current = index;
                  });
                },
                height: 100.0,
                aspectRatio: 2.0,
                viewportFraction: 1,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: false,
                scrollDirection: Axis.horizontal,
              ),
            ),
          ),
//          SizedBox(height: 8),
//          Row(
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: map<Widget>(imageList, (index, url) {
//                return Container(
//                  width: 8.0,
//                  height: 8.0,
//                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
//                  decoration: BoxDecoration(
//                      shape: BoxShape.circle,
//                      color: _current == index ? Colors.grey : Colors.black),
//                );
//              }).toList())
        ],
      ),
    );
  }
}
