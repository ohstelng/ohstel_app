import 'package:Ohstel_app/hive_methods/hive_class.dart';
import 'package:Ohstel_app/hostel_market_place/models/product_model.dart';
import 'package:Ohstel_app/hostel_market_place/pages/market_cart_page.dart';
import 'package:Ohstel_app/hostel_market_place/pages/selected_product_page.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class SelectedCategoriesPage extends StatefulWidget {
  final String title;
  final String searchKey;

  SelectedCategoriesPage({
    @required this.title,
    @required this.searchKey,
  });

  @override
  _SelectedCategoriesPageState createState() => _SelectedCategoriesPageState();
}

class _SelectedCategoriesPageState extends State<SelectedCategoriesPage> {
  String uniName;

  Future<void> getUniName() async {
    String name = await HiveMethods().getUniName();
    print(name);
    uniName = name;
  }

  @override
  void initState() {
    getUniName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: body(),
    );
  }

  Widget body() {
    return Container(
      child: Container(
        margin: EdgeInsets.only(top: 20.0),
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
              .collection('market')
              .document('products')
              .collection('allProducts')
              .where('productCategory',
                  isEqualTo: widget.searchKey.toLowerCase())
              .orderBy('dateAdded', descending: true),
          itemBuilder: (context, DocumentSnapshot documentSnapshot) {
            ProductModel currentProductModel =
                ProductModel.fromMap(documentSnapshot.data);

            return Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
              child: Card(
                elevation: 0,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SelectedProductPage(
                            productModel: currentProductModel),
                      ),
                    );
                  },
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: 150,
                        width: 200,
                        margin: EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 5.0),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border.all(color: Colors.grey),
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
                          dotIncreasedColor: Theme.of(context).primaryColor,
                          dotBgColor: Colors.transparent,
                          animationCurve: Curves.fastOutSlowIn,
                          animationDuration: Duration(milliseconds: 2000),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 2.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('${currentProductModel.productName}',
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(
                                height: 8,
                              ),
                              Text('\₦${currentProductModel.productPrice}',
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: Color(0xffc4c4c4),
                                      fontSize: 17,
                                      )),
                              SizedBox(height: 8,),
                              Text(
                                '${currentProductModel.productDescription}',
                                maxLines: 3,

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
      ),
    );
  }

  Widget appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.0,
      title: Text(
        '${widget.title}',
        style: TextStyle(color: Colors.black),
      ),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: <Widget>[
        InkWell(
          child: SvgPicture.asset("asset/cart.svg"),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MarketCartPage(),
              ),
            );
          },
        ),
        SizedBox(
          width: 16,
        )
      ],
    );
  }
}
