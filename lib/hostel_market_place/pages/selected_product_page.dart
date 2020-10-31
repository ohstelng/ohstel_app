import 'dart:async';

import 'package:Ohstel_app/hive_methods/hive_class.dart';
import 'package:Ohstel_app/hostel_market_place/models/market_cart_model.dart';
import 'package:Ohstel_app/hostel_market_place/models/product_model.dart';
import 'package:Ohstel_app/utilities/shared_widgets.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SelectedProductPage extends StatefulWidget {
  final ProductModel productModel;

  SelectedProductPage({@required this.productModel});

  @override
  _SelectedProductPageState createState() => _SelectedProductPageState();
}

class _SelectedProductPageState extends State<SelectedProductPage> {
  StreamController<int> unitStream = StreamController<int>();
  int units = 1;
  bool isLoading = true;
  Map userData;

  // Box marketBox;
  String selectedSize;

  Future<void> getUserData() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
    });
    userData = await HiveMethods().getUserData();
    // marketBox = await HiveMethods().getOpenBox('marketCart');
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getUserData();
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
            productShopOwnerPhoneNumber:
                productModel.productShopOwnerPhoneNumber,
            units: units,
            size: selectedSize ?? null)
        .toMap();
    HiveMethods().saveMarketCartToDb(map: data);
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            appBar: appBar(),
            body: body(),
          );
  }

  Widget body() {
    return Container(
      margin: EdgeInsets.all(10),
      child: ListView(
        children: <Widget>[
          displayMultiPic(imageList: widget.productModel.imageUrls),
          productDetails(),
          SizedBox(height: 16),
          unitController(),
          SizedBox(height: 16),
          hasSizedWidget(),
          SizedBox(height: 24),
          addToCartButton(),
          SizedBox(height: 8),
          ExpansionTile(
            childrenPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            expandedAlignment: Alignment.centerLeft,
            title: Text(
              "Product Details",
              style: TextStyle(fontSize: 20),
            ),
            children: [
              Text(
                '${widget.productModel.productDescription}',
                style: TextStyle(
                  fontSize: 16,
                ),
              )
            ],
          ),
          ExpansionTile(
            childrenPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            expandedAlignment: Alignment.centerLeft,
            title: Text(
              "Delivery Information",
              style: TextStyle(fontSize: 20),
            ),
            children: [
              Text(
                'The delivery Esp. 1 - 4 Day Depending On Your Loaction. \n A More Accurate Delivery Will Be Shown On The Check Out Summary Page',
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
          ExpansionTile(
            childrenPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            expandedAlignment: Alignment.centerLeft,
            title: Text(
              "About Brand",
              style: TextStyle(fontSize: 20),
            ),
            children: [
              Text(
                '${widget.productModel.productShopName} Shop',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Text(
                '${widget.productModel.productShopOwnerPhoneNumber}',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Text(
                '${widget.productModel.productShopOwnerEmail} Shop',
                style: TextStyle(
                  fontSize: 16,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget hasSizedWidget() {
    if (widget.productModel.hasSize == null ||
        widget.productModel.hasSize.isEmpty) {
      return Container();
    } else {
      return Container(
        height: 50,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: widget.productModel.hasSize.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                setState(() {
                  selectedSize = widget.productModel.hasSize[index];
                });
              },
              child: Container(
                height: 50,
                child: Card(
                  elevation: 1.5,
                  child: Container(
                    width: 80,
                    decoration: BoxDecoration(
                      color: selectedSize == widget.productModel.hasSize[index]
                          ? Theme.of(context).primaryColor
                          : Colors.transparent,
                    ),
                    child: Center(
                      child: Text(
                        '${widget.productModel.hasSize[index]}',
                        style: TextStyle(
                            color: selectedSize ==
                                    widget.productModel.hasSize[index]
                                ? Colors.white
                                : Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    }
  }

  Widget addToCartButton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: InkWell(
        onTap: () {
          if (widget.productModel.hasSize == null ||
              widget.productModel.hasSize.isEmpty) {
            saveInfoToCart();
          } else {
            if (selectedSize == null) {
              Fluttertoast.showToast(msg: 'Please Select Size!');
            } else {
              saveInfoToCart();
            }
          }
        },
        child: Container(
          height: 55,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).primaryColor),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Add to Cart',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SvgPicture.asset(
                  "asset/cart.svg",
                  color: Colors.white,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget unitController() {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 8,
          ),
          Text(
            '${widget.productModel.productName}',
            style: TextStyle(
              color: Color(0xff3A3A3A),
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            '₦${widget.productModel.productPrice}',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget displayMultiPic({@required List imageList}) {
    return Container(
      color: Colors.transparent,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.3,
        maxWidth: MediaQuery.of(context).size.width * .75,
      ),
      child: imageList != null
          ? Carousel(
              images: imageList.map(
                (images) {
                  return Container(
                    child: ExtendedImage.network(
                      images,
                      fit: BoxFit.cover,
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
              indicatorBgPadding: 8,
              dotPosition: DotPosition.bottomCenter,
              dotSpacing: 15.0,
              dotSize: 4,
              dotIncreaseSize: 2.5,
              dotIncreasedColor: Theme.of(context).primaryColor,
              dotBgColor: Colors.transparent,
              animationCurve: Curves.fastOutSlowIn,
              animationDuration: Duration(milliseconds: 2000),
            )
          : Container(
              color: Colors.grey[200],
              child: Center(
                child: Icon(Icons.image),
              ),
            ),
    );
  }

  Widget appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.0,
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
        cartWidget(),
        SizedBox(
          width: 8,
        ),
      ],
    );
  }
}
