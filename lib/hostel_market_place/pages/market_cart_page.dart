import 'dart:convert';
import 'dart:io';

import 'package:Ohstel_app/hive_methods/hive_class.dart';
import 'package:Ohstel_app/hostel_market_place/methods/market_methods.dart';
import 'package:Ohstel_app/hostel_market_place/models/market_cart_model.dart';
import 'package:Ohstel_app/hostel_market_place/models/paid_market_orders_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

class MarketCartPage extends StatefulWidget {
  @override
  _MarketCartPageState createState() => _MarketCartPageState();
}

class _MarketCartPageState extends State<MarketCartPage> {
  Box<Map> cartBox = Hive.box('marketCart');
  Box<Map> userDataBox = Hive.box('userDataBox');
  int numbers = 0;
  Map userData;


  //Todo: implement userData checker
  //Todo: implement userData checker
  //Todo: implement userData checker
  //Todo: implement userData checker
  //Todo: implement userData checker


  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'ChargedFrom${platform}_${DateTime.now().microsecondsSinceEpoch}';
  }

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

  void saveFoodInfoToDb() {
    int numbers = cartBox.length;
    List<Map> orderList = [];
    List<String> shopsList = [];
    PaidOrderModel paidOrderModel;

    for (var i = 0; i < numbers; i++) {
      Map data = cartBox.getAt(i);
      EachPaidOrderModel eachPaidOrderModel;

      MarketCartModel currentItemDetails =
          MarketCartModel.fromMap(data.cast<String, dynamic>());

      eachPaidOrderModel = EachPaidOrderModel(
        productName: currentItemDetails.productName,
        imageUrls: currentItemDetails.imageUrls,
        productCategory: currentItemDetails.productCategory,
        productPrice: currentItemDetails.productPrice,
        productShopName: currentItemDetails.productShopName,
        productShopOwnerEmail: currentItemDetails.productShopOwnerEmail,
        productShopOwnerPhoneNumber:
            currentItemDetails.productShopOwnerPhoneNumber,
        units: currentItemDetails.units,
      );

      if (shopsList.contains(currentItemDetails.productShopName) == false) {
        shopsList.add(currentItemDetails.productShopName);
      }

      orderList.add(eachPaidOrderModel.toMap());
    }
    print(orderList);
    print(shopsList);

    paidOrderModel = PaidOrderModel(
      buyerFullName: userData['fullName'],
      buyerEmail: userData['email'],
      buyerPhoneNumber: userData['phoneNumber'],
      buyerAddress: userData['address'],
      timestamp: Timestamp.now(),
      listOfShopsPurchasedFrom: shopsList,
      orders: orderList,
    );
    MarketMethods().saveOrderToDataBase(data: paidOrderModel);
  }

  Future<String> createAccessCode(skTest, _getReference) async {
    // skTest -> Secret key
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $skTest'
    };

    Map data = {
      "amount": 600,
      "email": "johnsonoye34@gmail.com",
      "reference": _getReference
    };

    String payload = json.encode(data);
    http.Response response = await http.post(
      'https://api.paystack.co/transaction/initialize',
      headers: headers,
      body: payload,
    );

    final Map _data = jsonDecode(response.body);
    String accessCode = _data['data']['access_code'];

    return accessCode;
  }

  void _verifyOnServer(String reference) async {
    String skTest = 'sk_test_5df98ac979ca2f2d10789cb1a158715096cde107';

    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $skTest',
      };

      http.Response response = await http.get(
          'https://api.paystack.co/transaction/verify/' + reference,
          headers: headers);

      final Map body = json.decode(response.body);

      if (body['data']['status'] == 'success') {
        Fluttertoast.showToast(msg: 'Paymeny Sucessfull');
      } else {}
    } catch (e) {
      print(e);
    }
  }

  chargeCard({@required int price}) async {
    Charge charge = Charge()
      ..amount = price
      ..reference = _getReference()
//..accessCode = _createAcessCode(skTest, _getReference())
      ..email = userData['email'];
    CheckoutResponse response = await PaystackPlugin.checkout(
      context,
      method: CheckoutMethod.card,
      charge: charge,
    );
    if (response.status == true) {
      _verifyOnServer(response.reference);
      saveFoodInfoToDb();
      clearCart();
      Navigator.pop(context);
    } else {
      print('error');
    }
  }

  Future<void> getUserData() async {
    Map data = await HiveMethods().getUserData();
    print(data);
    userData = data;
  }

  void clearCart() {
    cartBox.clear();
  }

  Future<void> editAddressDialog() async {
    String addr = await HiveMethods().getAddress();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        TextEditingController controller = TextEditingController();
        controller.text = addr.toString();
        return AlertDialog(
          title: Text("Edit Address"),
          content: TextField(
            controller: controller,
            textInputAction: TextInputAction.done,
            autocorrect: true,
            maxLength: 250,
            maxLines: null,
            onSubmitted: (val) {
              print(val);
            },
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                if (controller.text == 'null' || controller.text.trim() == '') {
                  Fluttertoast.showToast(msg: 'Please Input an address');
                } else {
                  editAddress(address: controller.text.trim());
                }
              },
              child: Text('Save Address'),
            ),
          ],
        );
      },
    );
  }

  Future<void> editAddress({@required String address}) async {
    Map currentUserData = await HiveMethods().getUserData();
    print(currentUserData);
    currentUserData['address'] = address;
    print(currentUserData);
    HiveMethods().updateUserAddress(map: currentUserData);
    Navigator.maybePop(context);
  }

  @override
  void initState() {
    getUserData();
    PaystackPlugin.initialize(
      publicKey: 'pk_test_d0490fa7b5ae91bf5317ebdbd761760c8f14fd8f',
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        actions: <Widget>[
          FlatButton(
            textColor: Colors.black,
            child: Text('Edit Address'),
            onPressed: () {
              editAddressDialog();
            },
          )
        ],
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
            return Column(
              children: <Widget>[
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: box.values.length,
                    itemBuilder: (context, index) {
                      numbers = box.values.length;
                      Map data = box.getAt(index);
                      MarketCartModel currentCartItem = MarketCartModel.fromMap(
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('Address'),
                      Flexible(child: getAddress()),
                    ],
                  ),
                ),
                Container(
                  child: FlatButton(
                    color: Colors.green,
                    onPressed: () async {
                      String addr = await HiveMethods().getAddress();
                      if (addr != null) {
                        chargeCard(price: getGrandTotal() * 100);
                      } else {
                        Fluttertoast.showToast(
                          msg: 'Plase Provide a delivery Location!',
                          gravity: ToastGravity.CENTER,
                          toastLength: Toast.LENGTH_LONG,
                        );
                      }
                    },
                    child: Text('Pay'),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget getAddress() {
    return ValueListenableBuilder(
      valueListenable: userDataBox.listenable(),
      builder: (context, Box box, _) {
        if (box.values.isEmpty)
          return Center(
            child: Text("User Details is empty"),
          );
        return ListView.builder(
          shrinkWrap: true,
          itemCount: box.values.length,
          itemBuilder: (context, index) {
            Map data = box.getAt(0);
            if (data['address'] == null) {
              return Center(child: Text("User Address Not Found!"));
            }
            return Text(
              data['address'],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            );
          },
        );
      },
    );
  }
}
