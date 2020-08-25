import 'dart:async';

import 'package:Ohstel_app/hive_methods/hive_class.dart';
import 'package:Ohstel_app/hostel_market_place/models/market_cart_model.dart';
import 'package:Ohstel_app/hostel_market_place/models/product_model.dart';
import 'package:Ohstel_app/hostel_market_place/pages/market_cart_page.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SelectedProductPage extends StatefulWidget {
  final ProductModel productModel;

  SelectedProductPage({@required this.productModel});

  @override
  _SelectedProductPageState createState() => _SelectedProductPageState();
}

class _SelectedProductPageState extends State<SelectedProductPage> {
  StreamController<int> unitStream = StreamController<int>();
  int units = 1;

  @override
  void initState() {
    unitStream.add(1);
    super.initState();
  }

  @override
  void dispose() {
    unitStream.close();
    super.dispose();
  }

  void saveInfoToCart() {
    ProductModel productModel = widget.productModel;
    Map data = MarketCartModel(
      productName: productModel.productName,
      imageUrls: productModel.imageUrls,
      productCategory: productModel.productCategory,
      productDescription: productModel.productDescription,
      productOriginLocation: productModel.productOriginLocation,
      productSubCategory: productModel.productSubCategory,
      productPrice: productModel.productPrice,
      productShopName: productModel.productShopName,
      productShopOwnerEmail: productModel.productShopOwnerEmail,
      productShopOwnerPhoneNumber: productModel.productShopOwnerPhoneNumber,
      units: units,
    ).toMap();
    HiveMethods().saveMarketCartToDb(map: data);
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
      child: ListView(
        children: <Widget>[
          displayMultiPic(imageList: widget.productModel.imageUrls),
          productDetails(),
          unitController(),
          addToCartButton(),
        ],
      ),
    );
  }

  Widget addToCartButton() {
    return Container(
      margin: EdgeInsets.all(20.0),
      child: FlatButton(
        onPressed: () {
          saveInfoToCart();
        },
        color: Colors.green,
        child: Text('Add to Cart'),
      ),
    );
  }

  Widget unitController() {
    return Container(
      margin: EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Units',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 20,
            ),
          ),
          Row(
            children: <Widget>[
              InkWell(
                onTap: () {
                  if (units > 1) {
                    int _units = units - 1;
                    unitStream.add(_units);
                    units = _units;
                    print(units);
                  }
                },
                child: Container(
                  margin: EdgeInsets.only(right: 15.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  child: Icon(Icons.remove),
                ),
              ),
              Container(
                child: StreamBuilder<Object>(
                  stream: unitStream.stream,
                  builder: (context, snapshot) {
                    return Text(
                      '${snapshot.data}',
                    );
                  },
                ),
              ),
              InkWell(
                onTap: () {
                  int _units = units + 1;
                  unitStream.add(_units);
                  units = _units;
                  print(units);
                },
                child: Container(
                  margin: EdgeInsets.only(left: 15.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  child: Icon(Icons.add),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget productDetails() {
    return Container(
      margin: EdgeInsets.only(top: 15.0, left: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            '${widget.productModel.productName}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          Text(
            'Price: \$${widget.productModel.productPrice}',
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 20,
            ),
          ),
          Text(
            'des: ${widget.productModel.productDescription}',
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 20,
            ),
          ),
          Text(
            'shop name: ${widget.productModel.productShopName} Shop',
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 20,
            ),
          ),
          Text(
            'shop Phone Number: ${widget.productModel.productShopOwnerPhoneNumber}',
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 20,
            ),
          ),
          Text(
            'shop email: ${widget.productModel.productShopOwnerEmail} Shop',
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget displayMultiPic({@required List imageList}) {
    return Container(
      color: Colors.grey,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.45,
        maxWidth: MediaQuery.of(context).size.width * .98,
      ),
      child: Carousel(
        images: imageList.map(
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
    );
  }

  Widget appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: <Widget>[
        InkWell(onTap: () {
//            saveProduct();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MarketCartPage(),
            ),
          );
        },child: SvgPicture.asset("asset/cart.svg")),
        SizedBox(width: 8)
      ],
    );
  }
}
