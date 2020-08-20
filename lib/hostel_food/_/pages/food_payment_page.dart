import 'dart:convert';
import 'dart:io';

import 'package:Ohstel_app/hive_methods/hive_class.dart';
import 'package:Ohstel_app/hostel_food/_/methods/fast_food_methods.dart';
import 'package:Ohstel_app/hostel_food/_/models/extras_food_details.dart';
import 'package:Ohstel_app/hostel_food/_/models/food_details_model.dart';
import 'package:Ohstel_app/hostel_food/_/models/paid_food_model.dart';
import 'package:Ohstel_app/hostel_food/_/pages/select_location_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class FoodPaymentPage extends StatefulWidget {
  @override
  _FoodPaymentPageState createState() => _FoodPaymentPageState();
}

class _FoodPaymentPageState extends State<FoodPaymentPage> {
  Box<Map> cartBox;
  Box<Map> userDataBox;
  Box<Map> addressDetailsBox;
  Map addressDetails;
  bool onCampus = false;
  Map userData;
  bool isLoading = true;

  List<ExtraItemDetails> getExtraFromMap({@required List data}) {
    List<ExtraItemDetails> _extraList = [];

    for (var i = 0; i < data.length; i++) {
      _extraList.add(ExtraItemDetails.fromMap(data[i].cast<String, dynamic>()));
    }
    return _extraList;
  }

  Future<void> getUserData() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    cartBox = await HiveMethods().getOpenBox('cart');
    userDataBox = await HiveMethods().getOpenBox('userDataBox');
    addressDetailsBox = await HiveMethods().getOpenBox('addressBox');
    Map data = await HiveMethods().getUserData();
    print(data);
    userData = data;
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
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
    Map addressDetails = await HiveMethods().getFoodLocationDetails();
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
      addressDetails: addressDetails,
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

  void selectDeliveryLocation() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(5.0),
          content: Builder(builder: (context) {
            var height = MediaQuery.of(context).size.height;
            var width = MediaQuery.of(context).size.width;

            return Container(
              height: height * .70,
              width: width,
              child: SelectDeliveryLocationPage(),
            );
          }),
        );
      },
    );
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

  void pay() async {
    Map addressDetails = await HiveMethods().getFoodLocationDetails();
    if (addressDetails != null && onCampus != null) {
      chargeCard(price: getGrandTotal() * 100);
    } else {
      Fluttertoast.showToast(
        msg: 'Plase Provide a delivery Location!',
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  Widget getAddress() {
    return ValueListenableBuilder(
      valueListenable: addressDetailsBox.listenable(),
      builder: (context, Box box, widget) {
        if (box.values.isEmpty) {
          return Text('No Adress Found!!');
        } else {
          Map data = box.getAt(0);
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Address:  '),
              Expanded(
                  child: Text(
                '${data['address']}, ${data['areaName']}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )),
            ],
          );
        }
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
    return Scaffold();
  }
}
