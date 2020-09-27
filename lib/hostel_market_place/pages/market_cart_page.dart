import 'package:Ohstel_app/hive_methods/hive_class.dart';
import 'package:Ohstel_app/hostel_market_place/models/market_cart_model.dart';
import 'package:Ohstel_app/hostel_market_place/pages/market_checkout_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MarketCartPage extends StatefulWidget {
  @override
  _MarketCartPageState createState() => _MarketCartPageState();
}

class _MarketCartPageState extends State<MarketCartPage> {
  Box<Map> cartBox;
  Box<Map> userDataBox;
  int numbers = 0;
  Map userData;
  bool isLoading = true;

  int getGrandTotal() {
    int numbers = cartBox.length;
    int _total = 0;

    for (var i = 0; i < numbers; i++) {
      int unitNumber = 1;
      int _itemPrice = 0;
      Map data = cartBox.getAt(i);
      int _currentTotal = 0;

      MarketCartModel currentItemDetails =
          MarketCartModel.fromMap(data.cast<String, dynamic>());
      unitNumber = currentItemDetails.units;

      _itemPrice = currentItemDetails.productPrice;
      _currentTotal = _itemPrice * unitNumber;
      _total = _total + _currentTotal;
    }

    return _total;
  }

  Future<void> getUserData() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    Map data = await HiveMethods().getUserData();
    cartBox = await HiveMethods().getOpenBox('marketCart');
    userDataBox = await HiveMethods().getOpenBox('userDataBox');
    print(data);
    userData = data;
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
    return isLoading
        ? Scaffold(
            body: Center(child: CircularProgressIndicator()),
          )
        : Scaffold(
            appBar: AppBar(
                centerTitle: true,
                backgroundColor: Colors.white,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                elevation: 0.0,
                title: Text(
                  'Market Cart',
                  style: TextStyle(color: Colors.black),
                )),
            body: Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(8),
              color: Colors.white,
              child: ValueListenableBuilder(
                valueListenable: cartBox.listenable(),
                builder: (context, box, widget) {
                  if (box.values.isEmpty) {
                    return Center(
                      child: Text("Cart list is empty"),
                    );
                  }
                  return ListView(
                    children: <Widget>[
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: box.values.length,
                        itemBuilder: (context, index) {
                          numbers = box.values.length;
                          Map data = box.getAt(index);
                          MarketCartModel currentCartItem =
                              MarketCartModel.fromMap(
                            data.cast<String, dynamic>(),
                          );

                          return Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.all(15.0),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Container(
                                      height: 80,
                                      width: 80,
                                      child: Image.asset(
                                        "asset/image1.jpg",
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(height: 10),
                                          Text(
                                            '${currentCartItem.productName}',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 8),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                'Store',
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    color: Color(0xffB9BBBE)),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            '₦${currentCartItem.productPrice}',
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                                Row(
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () {
                                        cartBox.deleteAt(index);
                                        setState(() {});
                                      },
                                      child: Row(
                                        children: [
                                          SvgPicture.asset("asset/Vector.svg"),
                                          SizedBox(width: 8),
                                          Text(
                                            'Remove',
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Color(0xffC4C4C4)),
                                          )
                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      'Units: ${currentCartItem.units}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  thickness: 1.5,
                                  color: Color(0xffc4c4c4),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                      Container(
                        margin: EdgeInsets.all(15.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Total',
                                  style: TextStyle(fontSize: 20),
                                ),
                                Text(
                                  '₦${getGrandTotal()}',
                                  style: TextStyle(
                                      fontSize: 20, color: Color(0xffC4C4C4)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            bottomSheet: ValueListenableBuilder(
              valueListenable: cartBox.listenable(),
              builder: (context, box, widget) {
                if (box.values.isEmpty) {
                  return Center(
                    child: Text("Cart is Empty"),
                  );
                }
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                  child: InkWell(
                    onTap: () async {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => MarketCheckOutPage(),
                        ),
                      );
//                            pay();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xff1f2430),
                          borderRadius: BorderRadius.circular(10)),
                      height: 55,
                      child: Center(
                        child: Text(
                          'PROCEED TO PAYMENT',
                          style: TextStyle(
                              color: Color(0xffFFFFFF),
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ));
  }
}
