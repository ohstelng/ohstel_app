import 'dart:async';
import 'dart:convert';

import 'package:Ohstel_app/auth/methods/auth_methods.dart';
import 'package:Ohstel_app/constant/constant.dart';
import 'package:Ohstel_app/hive_methods/hive_class.dart';
import 'package:Ohstel_app/hostel_food/_/methods/fast_food_methods.dart';
import 'package:Ohstel_app/hostel_food/_/models/extras_food_details.dart';
import 'package:Ohstel_app/hostel_food/_/models/food_cart_model.dart';
import 'package:Ohstel_app/hostel_food/_/models/food_details_model.dart';
import 'package:Ohstel_app/hostel_food/_/models/paid_food_model.dart';
import 'package:Ohstel_app/hostel_food/_/pages/select_location_page.dart';
import 'package:Ohstel_app/wallet/method.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
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
  Map userData;
  bool isLoading = true;
//  Map deliveryInfo;
  String uniName;
  int userNumber;
  int deliveryPrice;

  Runes input = Runes('\u20a6');
  final formatCurrency = new NumberFormat.currency(locale: "en_US", symbol: "");
  var symbol;

  Future<void> refreshPage() async {
    setState(() {
      isLoading = false;
    });
    await Future.delayed(Duration(milliseconds: 100));
    setState(() {
      isLoading = false;
    });
  }

  List<ExtraItemDetails> getExtraFromMap({@required List data}) {
    List<ExtraItemDetails> _extraList = [];

    for (var i = 0; i < data.length; i++) {
      _extraList.add(ExtraItemDetails.fromMap(data[i].cast<String, dynamic>()));
    }
    return _extraList;
  }

  Future<Map> getDeliveryFeeDataFromApi() async {
    String userState = await HiveMethods().getUserState();

    String url = baseApiUrl + '/food_api/price?location=$userState&area=all';
    debugPrint(url);
    var response = await http.get(url);
    Map data = await json.decode(response.body.toLowerCase());

    return data;
  }

  Future<Map> getPriceMultiplierFromApi() async {
    String url = baseApiUrl + '/food_api/price_multiplier';
    debugPrint(url);
    var response = await http.get(url);
    Map data = await json.decode(response.body.toLowerCase());

    return data;
  }

  Future<int> getDeliveryFee() async {
    Map deliveryPricing = await getDeliveryFeeDataFromApi();
    Map priceMultiplier = await getPriceMultiplierFromApi();
    String userDeliveryArea =
        addressDetails['areaName'].toString().toLowerCase();
    int totalPrice = 0;

    cartBox.values.forEach((mapData) {
      FoodCartModel item = FoodCartModel.fromMap(mapData);
      String currentItemFastFoodMainArea = item.fastFoodMainArea;
      String numberOfPlates = item.numberOfPlates.toString();
      Map priceMap = deliveryPricing[currentItemFastFoodMainArea];
      int _currentTotal = 0;

      int _currentItemPrice = priceMap[userDeliveryArea];
      int _currentMultiplierForNumberOfPlate = priceMultiplier[numberOfPlates];
      _currentTotal = (_currentItemPrice * _currentMultiplierForNumberOfPlate);
      totalPrice += _currentTotal;
    });

    print(totalPrice);
    deliveryPrice = totalPrice;

    return totalPrice;
  }

  Future<void> getUserData() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    addressDetails = await HiveMethods().getFoodDeliveryLocationDetails();
    uniName = await HiveMethods().getUniName();
    cartBox = await HiveMethods().getOpenBox('cart');
    userDataBox = await HiveMethods().getOpenBox('userDataBox');
    addressDetailsBox = await HiveMethods().getOpenBox('addressBox');
    Map data = await HiveMethods().getUserData();
    print(data);
    userData = data;
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
                deliveryFee: deliveryPrice,
                cartBox: cartBox,
                userData: userData,
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

  Future<void> selectDeliveryLocation() async {
    await showDialog(
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

    addressDetails = await HiveMethods().getFoodDeliveryLocationDetails();
    print(addressDetails);
    print('ffffpfpfpfpff');
    setState(() {});
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
                  onPressed: () async {
                    print(number.length);
                    if (number.length > 10) {
                      numberSteam.add(number);

                      Navigator.pop(context);
                    } else {
                      Fluttertoast.showToast(msg: 'Input Invaild Number!');
                    }
                  },
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
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
      resizeToAvoidBottomPadding: false,
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
    return SingleChildScrollView(
      child: Container(
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
      ),
    );
  }

  Widget payButton() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xffF27509),
        borderRadius: BorderRadius.circular(10.0),
      ),
      width: double.infinity,
      margin: EdgeInsets.all(15.0),
      child: FlatButton(
        onPressed: () async {
          if (userData != null &&
              addressDetails != null &&
              userNumber != null &&
              deliveryPrice != null) {
            print('pass');
            paymentPopUp();
          } else {
            Fluttertoast.showToast(
              msg: 'Plase Provide a delivery Location! '
                  'OR Wait For Your Delivery Fee To Be Calculated.',
              gravity: ToastGravity.TOP,
              toastLength: Toast.LENGTH_LONG,
              fontSize: 18,
              backgroundColor: Colors.black,
              textColor: Colors.white,
            );
          }
        },
        child: Text(
          'Make Payment',
          style: TextStyle(fontSize: 20, color: Colors.white),
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
                  addressDetails =
                      await HiveMethods().getFoodDeliveryLocationDetails();
                  await selectDeliveryLocation();
                  refreshPage();
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
          return Card(
            child: Container(
              margin: EdgeInsets.all(10.0),
              child: Text(
                'No Adress Found!!',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          );
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
                              userNumber = int.parse(snapshot.data);
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
    int _numberOfItems = 0;
    cartBox.values.forEach((map) {
      FoodCartModel item = FoodCartModel.fromMap(map);
      _numberOfItems += item.numberOfPlates;
    });

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
                deliveryFeeInfo(),
              ]),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Total Number Of Items'),
                Text('$_numberOfItems')
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
              deliveryFeeInfo(getGrandTotal()),
            ],
          ),
        ],
      ),
    );
  }

  Widget deliveryFeeInfo([int otherTotal = 0]) {
    return FutureBuilder(
      future: getDeliveryFee(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text(
            'Calculation.....',
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 16,
            ),
          );
        } else {
          int price = snapshot.data;
          return Text(
            '$symbol ${formatCurrency.format(price + otherTotal)}',
          );
        }
      },
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
  final int deliveryFee;

  PaymentPopUp({
    @required this.cartBox,
    @required this.userData,
    @required this.deliveryFee,
  });

  @override
  _PaymentPopUpState createState() => _PaymentPopUpState();
}

class _PaymentPopUpState extends State<PaymentPopUp> {
  bool loading = false;

  Future<void> showMessage() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          insetPadding: EdgeInsets.symmetric(vertical: 110, horizontal: 30),
          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          content: Container(
            child: Column(
              children: [
                Image.asset("asset/success.jpg"),
                Text(
                  'Payment Successful',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                Expanded(
                  child: Text(
                    'Your Food Will Be Delivered To You In the next 10 - 15 Mins. '
                    '\n\n Our Dispatch Rider will contact you via Phone Number provided. \n\n Thanks for your patronage',
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'OK',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),
          ],
        );
      },
    );
  }

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
    return _total + widget.deliveryFee;
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
    Map addressDetails = await HiveMethods().getFoodDeliveryLocationDetails();
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
      buyerFullName: currentUserData['fullName'],
      phoneNumber: currentUserData['phoneNumber'],
      email: currentUserData['email'],
      fastFoodNames: fastFoodList,
      orders: ordersList,
      uniName: widget.userData['uniDetails']['abbr'].toString().toLowerCase(),
      addressDetails: addressDetails,
      buyerID: currentUserData['uid'],
      amountPaid: getGrandTotal(),
      orderState:
          currentUserData['uniDetails']['state'].toString().toLowerCase(),
    );

    try {
      await FastFoodMethods().saveOrderToDb(
        paidFood: orderedFood,
      );
      clearCart();
      await showMessage();
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
              'The Sum Of ₦${getGrandTotal()} '
              'Will Be Deducted From Your Wallet Balance!',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
                loading
                    ? CircularProgressIndicator()
                    : Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: Theme.of(context).primaryColor)),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                        child: InkWell(
                          onTap: () async {
                            setState(() {
                              loading = true;
                            });
                            await validateUser(password: password);
                            setState(() {
                              loading = false;
                            });
                          },
                          child: Text(
                            'Proceed',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border:
                          Border.all(color: Theme.of(context).primaryColor)),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
