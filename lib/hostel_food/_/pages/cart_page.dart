import 'dart:convert';
import 'dart:io';

import 'package:Ohstel_app/hive_methods/hive_class.dart';
import 'package:Ohstel_app/hostel_food/_/methods/fast_food_methods.dart';
import 'package:Ohstel_app/hostel_food/_/models/extras_food_details.dart';
import 'package:Ohstel_app/hostel_food/_/models/food_details_model.dart';
import 'package:Ohstel_app/hostel_food/_/models/paid_food_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Box<Map> cartBox = Hive.box('cart');
  Box<Map> userDataBox = Hive.box('userDataBox');
  int numbers = 0;
  Map userData;
  bool onCampus = false;

  List<ExtraItemDetails> getExtraFromMap({@required List data}) {
    List<ExtraItemDetails> _extraList = [];

    for (var i = 0; i < data.length; i++) {
      _extraList.add(ExtraItemDetails.fromMap(data[i].cast<String, dynamic>()));
    }
    return _extraList;
  }

  int getGrandTotal() {
    int numbers = cartBox.length;
    int _total = 0;

    for (var i = 0; i < numbers; i++) {
      int numberPlate = 1;
      int _itemPrice = 0;
      int _extraItemPrice = 0;
      Map data = cartBox.getAt(i);
      int _currentTotal = 0;

      ItemDetails currentItemDetails =
          ItemDetails.formMap(data['itemDetails'].cast<String, dynamic>());
      List<ExtraItemDetails> currentExtraItemDetails =
          getExtraFromMap(data: data['extraItems']);
      numberPlate = data['numberOfPlates'];

      _itemPrice = currentItemDetails.price;

      for (ExtraItemDetails i in currentExtraItemDetails) {
        _extraItemPrice = _extraItemPrice + i.price;
      }

      _currentTotal = (_itemPrice + _extraItemPrice) * numberPlate;
      _total = _total + _currentTotal;
    }

    print(_total);
    return _total;
  }

  Future<void> getUserData() async {
    Map data = await HiveMethods().getUserData();
    print(data);
    userData = data;
  }

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'ChargedFrom${platform}_${DateTime.now().microsecondsSinceEpoch}';
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
    } else {
      print('error');
    }
  }

  ///

  void clearCart() {
    cartBox.clear();
  }

  Future<void> saveFoodInfoToDb() async {
    int numbers = cartBox.length;
    Map currentUserData = await HiveMethods().getUserData();
    List<String> fastFoodList = [];
    List<Map> ordersList = [];

    for (var i = 0; i < numbers; i++) {
      Map data = cartBox.getAt(i);
      ItemDetails currentItemDetails =
          ItemDetails.formMap(data['itemDetails'].cast<String, dynamic>());
      List<ExtraItemDetails> currentExtraItemDetails =
          getExtraFromMap(data: data['extraItems']);
      int _numberOfPlate = data['numberOfPlates'];
      String fastFoodName = currentItemDetails.itemFastFoodName;
      List<String> extraOrders = [];

      if (fastFoodList.contains(fastFoodName) == false) {
        fastFoodList.add(fastFoodName);
      }

      for (ExtraItemDetails i in currentExtraItemDetails) {
        extraOrders.add(i.extraItemName);
      }

      EachOrder eachOrder = EachOrder(
        fastFoodName: fastFoodName,
        mainItem: currentItemDetails.itemName,
        extraItems: extraOrders,
        numberOfPlates: _numberOfPlate,
      );

      ordersList.add(eachOrder.toMap());
    }

    PaidFood orderedFood = PaidFood(
      address: currentUserData['address'],
      phoneNumber: currentUserData['phoneNumber'],
      email: currentUserData['email'],
      fastFoodNames: fastFoodList,
      orders: ordersList,
      uniName: userData['uniName'],
      onCampus: onCampus,
    );

    try {
      await FastFoodMethods().saveOrderToDb(data: orderedFood.toMap());
//      Navigator.maybePop(context);
      clearCart();
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '$e');
    }
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
        title: Text('Food Cart'),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
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
                      ItemDetails currentItemDetails = ItemDetails.formMap(
                          data['itemDetails'].cast<String, dynamic>());
                      List<ExtraItemDetails> currentExtraItemDetails =
                          getExtraFromMap(data: data['extraItems']);

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
                                    Text('${currentItemDetails.itemName}'),
                                    Text('${currentItemDetails.price}'),
                                  ],
                                ),
                                getExtraWidget(extras: currentExtraItemDetails),
                                Container(
                                  margin: EdgeInsets.only(top: 10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text('Number Of Plates'),
                                      Text('${data['numberOfPlates']}'),
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
                    child: CheckboxListTile(
                  title: Text("Are you on School Campus??"),
                  value: onCampus,
                  onChanged: (newValue) {
                    setState(() {
                      onCampus = newValue;
                    });
                  },
                  controlAffinity:
                      ListTileControlAffinity.trailing, //  <-- leading Checkbox
                )),
                Container(
                  child: FlatButton(
                    color: Colors.green,
                    onPressed: () async {
                      String addr = await HiveMethods().getAddress();
                      if (addr != null && onCampus != null) {
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

  Widget getExtraWidget({@required List<ExtraItemDetails> extras}) {
    if (extras.isEmpty) {
      return Container();
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: extras.length,
      itemBuilder: (context, index) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Extra ${extras[index].extraItemName}'),
            Text('${extras[index].price}'),
          ],
        );
      },
    );
  }
}
