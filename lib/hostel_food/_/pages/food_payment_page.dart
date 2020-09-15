import 'dart:async';

import 'package:Ohstel_app/auth/methods/auth_methods.dart';
import 'package:Ohstel_app/hive_methods/hive_class.dart';
import 'package:Ohstel_app/hostel_food/_/methods/fast_food_methods.dart';
import 'package:Ohstel_app/hostel_food/_/models/extras_food_details.dart';
import 'package:Ohstel_app/hostel_food/_/models/food_details_model.dart';
import 'package:Ohstel_app/hostel_food/_/models/paid_food_model.dart';
import 'package:Ohstel_app/hostel_food/_/pages/select_location_page.dart';
import 'package:Ohstel_app/wallet/method.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class FoodPaymentPage extends StatefulWidget {
  @override
  _FoodPaymentPageState createState() => _FoodPaymentPageState();
}

class _FoodPaymentPageState extends State<FoodPaymentPage> {
  StreamController<String> numberSteam = StreamController<String>();
  Box<Map> cartBox;
  Box<Map> userDataBox;
  Box<Map> addressDetailsBox;
  Map addressDetails;
  bool onCampus = false;
  Map userData;
  bool isLoading = true;
  int deliveryFee = 100;
  Runes input = Runes('\u20a6');
  final formatCurrency = new NumberFormat.currency(locale: "en_US", symbol: "");
  var symbol;

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
//    _phoneNumber = data['phoneNumber'];
    numberSteam.add(data['phoneNumber']);
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void paymentPopUp() async {
    try {
      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Payment Alert'),
            content: Container(
              child: PaymentPopUp(
                cartBox: cartBox,
                userData: userData,
                onCampus: onCampus,
              ),
            ),
          );
        },
      );

      Navigator.pop(context);
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

  void editPhoneNumber() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        String number;
        return Dialog(
          child: Container(
            margin: EdgeInsets.all(15.0),
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    hintText: 'Enter You Phone Number',
                  ),
                  maxLines: null,
                  maxLength: 20,
                  onChanged: (val) {
                    number = val.trim();
                  },
                ),
                FlatButton(
                  onPressed: () {
                    print(number.length);
                    if (number.length > 10) {
                      numberSteam.add(number);
                      Navigator.pop(context);
                    } else {
                      Fluttertoast.showToast(msg: 'Input Invaild Number!');
                    }
                  },
                  color: Colors.green,
                  child: Text('Submit'),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    getUserData();
    symbol = String.fromCharCodes(input);
    super.initState();
  }

  @override
  void dispose() {
    numberSteam.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            header(),
            isLoading == false
                ? body()
                : Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }

  Widget body() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 10.0),
            child: Text(
              'Review Your Payment',
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
            ),
          ),
          ordersContainer(),
          address(),
          payButton(),
        ],
      ),
    );
  }

  Widget payButton() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xffF27509),
        borderRadius: BorderRadius.circular(15.0),
      ),
      width: double.infinity,
      margin: EdgeInsets.all(15.0),
      child: FlatButton(
        onPressed: () async {
          Map addressDetails = await HiveMethods().getFoodLocationDetails();

          if (userData != null && addressDetails != null && onCampus != null) {
            paymentPopUp();
          } else {
            Fluttertoast.showToast(
              msg: 'Plase Provide a delivery Location!',
              gravity: ToastGravity.CENTER,
              toastLength: Toast.LENGTH_LONG,
            );
          }
        },
        child: Text(
          'Make Payment',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget address() {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Adress Details'),
              FlatButton(
                color: Colors.grey[300],
                onPressed: () async {
                  addressDetails = await HiveMethods().getFoodLocationDetails();
                  selectDeliveryLocation();
                },
                child: Text('Edit'),
              ),
            ],
          ),
          getAddress(),
        ],
      ),
    );
  }

  Widget getAddress() {
    return ValueListenableBuilder(
      valueListenable: addressDetailsBox.listenable(),
      builder: (context, Box box, widget) {
        if (box.values.isEmpty) {
          return Text('No Adress Found!!');
        } else {
          Map data = box.getAt(0);
          return Card(
            elevation: 2.5,
            child: Container(
              padding: EdgeInsets.all(15.0),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('${userData['fullName']}'),
                  Container(
                    margin: EdgeInsets.only(top: 5.0),
                    child: Text(
                      '${data['address']}',
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5.0),
                    child: Text(
                      '${data['areaName']}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        StreamBuilder<String>(
                            stream: numberSteam.stream,
                            builder: (context, snapshot) {
                              if (snapshot.data == null) {
                                return Text('No Number Found');
                              }
                              return Text(
                                '${snapshot.data}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              );
                            }),
                        Container(
                          padding: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: InkWell(
                            onTap: () {
                              editPhoneNumber();
                            },
                            child: Text('Edit'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget ordersContainer() {
    return Container(
      height: 210,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      margin: EdgeInsets.all(10.0),
      padding: EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Number Of Item'),
                Text('${cartBox.length}')
              ]),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Sub Total'),
                Text('$symbol ${formatCurrency.format(getGrandTotal())}')
              ]),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Delivery Fee'),
                Text('$symbol ${formatCurrency.format(deliveryFee)}')
              ]),
          Divider(
            thickness: .5,
            color: Colors.black45,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Total',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                ),
                Text(
                  '$symbol ${formatCurrency.format(getGrandTotal() + deliveryFee)}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                )
              ]),
        ],
      ),
    );
  }

  Widget header() {
    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}

class PaymentPopUp extends StatefulWidget {
  final Box cartBox;
  final Map userData;
  final bool onCampus;

  PaymentPopUp({
    @required this.cartBox,
    @required this.userData,
    @required this.onCampus,
  });

  @override
  _PaymentPopUpState createState() => _PaymentPopUpState();
}

class _PaymentPopUpState extends State<PaymentPopUp> {
  bool loading = false;

  int getGrandTotal() {
    int numbers = widget.cartBox.length;
    int _total = 0;

    for (var i = 0; i < numbers; i++) {
      int numberPlate = 1;
      int _itemPrice = 0;
      int _extraItemPrice = 0;
      Map data = widget.cartBox.getAt(i);
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

  void clearCart() {
    widget.cartBox.clear();
  }

  List<ExtraItemDetails> getExtraFromMap({@required List data}) {
    List<ExtraItemDetails> _extraList = [];

    for (var i = 0; i < data.length; i++) {
      _extraList.add(ExtraItemDetails.fromMap(data[i].cast<String, dynamic>()));
    }
    return _extraList;
  }

  Future<void> saveFoodInfoToDb() async {
    int numbers = widget.cartBox.length;
    Map currentUserData = await HiveMethods().getUserData();
    Map addressDetails = await HiveMethods().getFoodLocationDetails();
    List<String> fastFoodList = [];
    List<Map> ordersList = [];

    for (var i = 0; i < numbers; i++) {
      Map data = widget.cartBox.getAt(i);
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
      uniName: widget.userData['uniName'],
      onCampus: widget.onCampus,
      addressDetails: addressDetails,
    );

    try {
      await FastFoodMethods().saveOrderToDb(data: orderedFood.toMap());
      clearCart();
      Navigator.maybePop(context);
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '$e');
    }
  }

  Future<void> validateUser({@required String password}) async {
    Map userDate = await HiveMethods().getUserData();

    await AuthService()
        .loginWithEmailAndPassword(
      email: userDate['email'],
      password: password,
    )
        .then((value) async {
      if (value != null) {
        await pay();
      }
    });
  }

  Future<void> pay() async {
    int result = await WalletMethods().deductWallet(
      amount: getGrandTotal().toDouble(),
      payingFor: 'Food',
      itemId: widget.userData['fullName'],
    );
    if (result == 0) {
      saveFoodInfoToDb();
    }
  }

  @override
  Widget build(BuildContext context) {
    String password;
    return Container(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'The Sum Of NGN ${getGrandTotal()} '
              'Will Be Deducted From Your Wallet Balance!',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter Your Password',
              ),
              obscureText: true,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              onChanged: (val) {
                password = val;
              },
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FlatButton(
                  onPressed: () async {
                    setState(() {
                      loading = true;
                    });
                    await validateUser(password: password);
                    setState(() {
                      loading = false;
                    });
                  },
                  child:
                      loading ? CircularProgressIndicator() : Text('Proceed'),
                  color: Colors.green,
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                  color: Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
