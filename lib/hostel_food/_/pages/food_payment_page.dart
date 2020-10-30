import 'dart:async';
import 'dart:collection';
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
  Map deliveryInfo;
  String uniName;

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

  Future<void> getDeliveryFeeFromApi() async {
    String uniName = await HiveMethods().getUniName();

    String url = baseApiUrl + '/food_api/food_delivery_info';
    debugPrint(url);
    var response = await http.get(url);
    Map data = await json.decode(response.body)['$uniName'];
    deliveryInfo = data;
  }

  int getDeliveryFee() {
    int sameLocationCount = 0;
    int differentLocationCount = 0;
    int onCampus = 0;
    int totalDeliveryFee;

    if (addressDetails == null) {
      return null;
    }
    cartBox.toMap().forEach((key, value) {
      var currentValueData = HashMap.from(value);

      FoodCartModel foodCart = FoodCartModel.fromMap(
        Map<String, dynamic>.from(currentValueData),
      );

      if (foodCart.itemFastFoodLocation.toLowerCase() == 'onCampus' &&
          addressDetails['areaName'].toString().toLowerCase() == 'onCampus') {
        print(foodCart.itemFastFoodLocation.toLowerCase() == 'onCampus' &&
            addressDetails['areaName'].toString().toLowerCase() == 'onCampus');
        onCampus++;
      } else {
        if (foodCart.itemFastFoodLocation.toLowerCase() ==
            addressDetails['areaName'].toString().toLowerCase()) {
          sameLocationCount++;
        } else {
          differentLocationCount++;
        }
        print('${foodCart.itemFastFoodLocation}');
      }
    });
    print(addressDetails);
    print(sameLocationCount);
    print(differentLocationCount);

    Map onCampusData = deliveryInfo['onCampus'];
    Map sameLocationData = deliveryInfo['sameLocation'];
    Map differentLocationData = deliveryInfo['differentLocation'];

    int onCampusPrice = onCampusData['$onCampus'] ?? 0;
    int sameLocationPrice = sameLocationData['$sameLocationCount'] ?? 0;
    int differentLocationPrice =
        differentLocationData['$differentLocationCount'] ?? 0;

    totalDeliveryFee =
        (onCampusPrice + sameLocationPrice + differentLocationPrice);

    return totalDeliveryFee;
  }

  Future<void> getUserData() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    addressDetails = await HiveMethods().getFoodLocationDetails();
    uniName = await HiveMethods().getUniName();
    cartBox = await HiveMethods().getOpenBox('cart');
    userDataBox = await HiveMethods().getOpenBox('userDataBox');
    addressDetailsBox = await HiveMethods().getOpenBox('addressBox');
    Map data = await HiveMethods().getUserData();
    print(data);
    userData = data;
    numberSteam.add(data['phoneNumber']);

    await getDeliveryFeeFromApi();

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
                deliveryFee: getDeliveryFee(),
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
                  color: Theme.of(context).primaryColor,
                  child: Text('Submit',style: TextStyle(color: Colors.white),),
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
          if (userData != null && addressDetails != null) {
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
          style: TextStyle(fontSize: 20,color: Colors.white),
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
                Text('$symbol ${formatCurrency.format(getDeliveryFee() ?? 0)}')
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
                  '$symbol ${formatCurrency.format(getGrandTotal() + (getDeliveryFee() ?? 0))}',
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
        return AlertDialog(insetPadding: EdgeInsets.symmetric(vertical: 110,horizontal: 30),
          contentPadding: EdgeInsets.symmetric(vertical: 16,horizontal: 16),
          content: Container(
            child: Column(
              children: [
                Image.asset("asset/success.jpg"),
                Text('Payment Successful',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)
                  ,),
                SizedBox(height: 8,),
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
              child: Text('OK',style: TextStyle(fontSize: 20),),
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
      buyerFullName: currentUserData['fullName'],
      phoneNumber: currentUserData['phoneNumber'],
      email: currentUserData['email'],
      fastFoodNames: fastFoodList,
      orders: ordersList,
      uniName: widget.userData['uniDetails']['abbr'].toString().toLowerCase(),
      addressDetails: addressDetails,
      buyerID: currentUserData['uid'],
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
                loading
                    ? CircularProgressIndicator()
                    : FlatButton(
                        onPressed: () async {
                          setState(() {
                            loading = true;
                          });
                          await validateUser(password: password);
                          setState(() {
                            loading = false;
                          });
                        },
                        child: Text('Proceed',style: TextStyle(color: Colors.white),),
                        color: Theme.of(context).primaryColor,
                      ),
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel',style: TextStyle(color: Colors.red),),
                  color: Colors.white38,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
