import 'package:Ohstel_app/hive_methods/hive_class.dart';
import 'package:Ohstel_app/hostel_market_place/models/product_model.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
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
      body: isLoading ? Container(child: CircularProgressIndicator()) : body(),
    );
  }

  Widget body() {
    return Container(
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
        query: Firestore.instance
            .collection('marketOrders')
//            .where('')
            .orderBy('dateAdded', descending: true),
        itemBuilder: (context, DocumentSnapshot documentSnapshot) {
          ProductModel currentProductModel =
              ProductModel.fromMap(documentSnapshot.data);

          return Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
            child: Card(
              elevation: 2.5,
              child: InkWell(
                onTap: () {
//                  Navigator.of(context).push(
//                    MaterialPageRoute(
//                      builder: (context) => SelectedProductPage(
//                          productModel: currentProductModel),
//                    ),
//                  );
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 150,
                      width: 200,
                      margin:
                          EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: Carousel(
                        images: currentProductModel.imageUrls.map(
                          (images) {
                            return Container(
                              child: ExtendedImage.network(
                                images,
                                fit: BoxFit.fill,
                                handleLoadingProgress: true,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(10),
                                cache: false,
                                enableMemoryCache: true,
                              ),
                            );
                          },
                        ).toList(),
                        autoplay: true,
                        indicatorBgPadding: 0.0,
                        dotPosition: DotPosition.bottomCenter,
                        dotSpacing: 15.0,
                        dotSize: 4,
                        dotIncreaseSize: 2.5,
                        dotIncreasedColor: Colors.teal,
                        dotBgColor: Colors.transparent,
                        animationCurve: Curves.fastOutSlowIn,
                        animationDuration: Duration(milliseconds: 2000),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 2.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '${currentProductModel.productName}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '\$${currentProductModel.productPrice}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '${currentProductModel.productDescription}',
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
