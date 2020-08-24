import 'package:Ohstel_app/hive_methods/hive_class.dart';
import 'file:///C:/Users/olamilekan/flutter_projects/work_space/Ohstel_app/lib/hostel_market_place/pages/market_checkout_page.dart';
import 'package:Ohstel_app/hostel_market_place/models/market_cart_model.dart';
import 'package:flutter/material.dart';
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
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              elevation: 0.0,
              title: Text(
                'Food Cart',
                style: TextStyle(color: Colors.black),
              ),
            ),
            body: Container(
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
                            margin: EdgeInsets.all(15.0),
                            child: Column(
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text('${currentCartItem.productName}'),
                                        Text('${currentCartItem.productPrice}'),
                                      ],
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text('units'),
                                          Text('${currentCartItem.units}'),
                                        ],
                                      ),
                                    ),
                                    Divider(),
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(''),
                                          Row(
                                            children: <Widget>[
                                              Text('Remove'),
                                              InkWell(
                                                child: Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),
                                                onTap: () {
                                                  cartBox.deleteAt(index);
                                                },
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      Container(
                        margin: EdgeInsets.all(15.0),
                        child: Column(
                          children: <Widget>[
                            Divider(
                              thickness: 1.5,
                              color: Colors.black,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('Total'),
                                Text('${getGrandTotal()}'),
                              ],
                            ),
                            Divider(
                              thickness: 1.5,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: FlatButton(
                          color: Colors.green,
                          onPressed: () async {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => MarketCheckOutPage(),
                              ),
                            );
//                            pay();
                          },
                          child: Text('Check Out'),
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
          );
  }
}
