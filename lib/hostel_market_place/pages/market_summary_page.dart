import 'dart:convert';

import 'package:Ohstel_app/auth/methods/auth_methods.dart';
import 'package:Ohstel_app/hive_methods/hive_class.dart';
import 'package:Ohstel_app/hostel_market_place/methods/market_methods.dart';
import 'package:Ohstel_app/hostel_market_place/models/market_cart_model.dart';
import 'package:Ohstel_app/hostel_market_place/models/paid_market_orders_model.dart';
import 'package:Ohstel_app/hostel_market_place/pages/market_cart_page.dart';
import 'package:Ohstel_app/wallet/method.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class MarketSummaryPage extends StatefulWidget {
  final String phoneNumber;

  MarketSummaryPage({@required this.phoneNumber});

  @override
  _MarketSummaryPageState createState() => _MarketSummaryPageState();
}

class _MarketSummaryPageState extends State<MarketSummaryPage> {
  TextStyle _normText = TextStyle(fontSize: 16);

  Box<Map> cartBox;
  Box<Map> userDataBox;
  Map userData;
  bool isLoading = true;
  Map deliveryDetailsFromApi;

  Runes input = Runes('\u20a6');
  final formatCurrency = new NumberFormat.currency(locale: "en_US", symbol: "");
  var symbol;

  Future<void> getUserData() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    deliveryDetailsFromApi = await getDeliveryInfoFromApi();
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

  Future getDeliveryInfoFromApi() async {
    String url = "http://quiz-demo-de79d.appspot.com/market_api/deliveryInfo";
    var response = await http.get(url);
    var data = json.decode(response.body);

    return data;
  }

  int getGrandTotal() {
    int numbers = cartBox.length;
    int _total = 0;

    for (var i = 0; i < numbers; i++) {
      int unitNumber = 1;
      int _itemPrice = 0;
      Map data = cartBox.getAt(i);
      int _currentTotal = 0;
//      int shippingFee = 0;

      MarketCartModel currentItemDetails =
          MarketCartModel.fromMap(data.cast<String, dynamic>());
      unitNumber = currentItemDetails.units;

//      if (deliveryDetailsFromApi != null) {
//        deliveryDetailsFromApi.forEach((key, value) {
//          if (key.toString().toLowerCase() ==
//              userData['uniDetails']['name'].toString().toLowerCase()) {
//            print(key);
//            print(value[currentItemDetails.productOriginLocation]['price']);
////            shippingFee = shippingFee +
////                value[currentItemDetails.productOriginLocation]['price'];
//          }
//        });
//      }

      _itemPrice = currentItemDetails.productPrice;
      _currentTotal = _itemPrice * unitNumber;
      _total = _total + _currentTotal;
    }

    return _total;
  }

  int deliveryFee() {
    String userLocation =
        userData['uniDetails']['name'].toString().toLowerCase();
    int numbers = cartBox.length;
    int shippingFee = 0;

    for (var i = 0; i < numbers; i++) {
      Map data = cartBox.getAt(i);

      MarketCartModel currentItemDetails =
          MarketCartModel.fromMap(data.cast<String, dynamic>());
      int num = 0;

      if (deliveryDetailsFromApi != null) {
        deliveryDetailsFromApi.forEach((key, value) {
          String currentKey = key.toString().toLowerCase();
          String itemOriginLocation = currentItemDetails.productOriginLocation;
          Map currentLocation = value[itemOriginLocation] ?? {'price': 0};

          if (currentKey == userLocation) {
            num = num + currentLocation['price'];
          }
        });
      }

      shippingFee = shippingFee + num;
    }

    return shippingFee;
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
                phoneNumber: widget.phoneNumber,
                deliveryDetailsFromApi: deliveryDetailsFromApi,
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

  void pay() async {
    String address = await HiveMethods().getAddress();
    if (address != null && widget.phoneNumber != null) {
      paymentPopUp();
    } else {
      Fluttertoast.showToast(
        msg: 'ERROR',
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              color: Color(0xffE5E5E5),
              child: ListView(
                children: [
                  header(),
                  ordersContainer(),
                  getAddress(),
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "Your Items",
                      style: _normText,
                    ),
                  ),
                  cartItems(),
                  button(),
                  modifybutton()
                ],
              ),
            ),
    );
  }

  Widget modifybutton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: InkWell(
        onTap: () async {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => MarketCartPage()));
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
              border: Border.all(color: Color(0xff1f2430), width: 2),
              color: Colors.white,
              borderRadius: BorderRadius.circular(10)),
          height: 55,
          child: Center(
            child: Text(
              'Modify Cart',
              style: TextStyle(
                  color: Color(0xff000000),
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget button() {
    return Container(
      margin: EdgeInsets.only(top: 24, bottom: 8),
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: InkWell(
        onTap: () {
          pay();
        },
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(10)),
          height: 55,
          child: Center(
            child: Text(
              'Pay',
              style: TextStyle(
                  color: Color(0xffFFFFFF),
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget cartItems() {
    return ValueListenableBuilder(
      valueListenable: cartBox.listenable(),
      builder: (context, box, widget) {
        if (box.values.isEmpty) {
          return Center(
            child: Text("Cart list is empty"),
          );
        }
        return ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: box.values.length,
          itemBuilder: (context, index) {
//                numbers = box.values.length;
            Map data = box.getAt(index);
            MarketCartModel currentCartItem = MarketCartModel.fromMap(
              data.cast<String, dynamic>(),
            );

            return Container(
              color: Colors.white,
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '${currentCartItem.productName}',
                            style: _normText,
                          ),
                          Text(
                            'N${currentCartItem.productPrice}',
                            style: _normText,
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Units',
                              style: _normText,
                            ),
                            Text(
                              '${currentCartItem.units}',
                              style: _normText,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget getAddress() {
    return ValueListenableBuilder(
      valueListenable: userDataBox.listenable(),
      builder: (context, Box box, _) {
        if (box.values.isEmpty)
          return Center(
            child: Card(
              child: Text("User Details is empty"),
            ),
          );
        return ListView.builder(
          shrinkWrap: true,
          itemCount: box.values.length,
          itemBuilder: (context, index) {
            Map userData = box.getAt(0);
            if (userData['address'] == null) {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text("Your Address"), Text("Change Address")],
                    ),
                    Container(
                      width: double.infinity,
                      child: Card(
                        elevation: 2.5,
                        child: Column(
                          children: [
                            Container(
                              child: Text("User Address Not Found!"),
                              padding: EdgeInsets.all(10.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Your Address",
                        style: _normText,
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(16.0),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${userData['fullName']}',
                        style: _normText,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5.0),
                        child: Text(
                          '${userData['address']}',
                          style: _normText,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              '${widget.phoneNumber}',
                              style: _normText,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget ordersContainer() {
    return Container(
      height: 210,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Number Of Item', style: _normText),
                Text(
                  '${cartBox.length}',
                  style: _normText,
                )
              ]),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Sub Total',
                  style: _normText,
                ),
                Text(
                  'N${formatCurrency.format(getGrandTotal())}',
                  style: _normText,
                )
              ]),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Delivery Fee',
                  style: _normText,
                ),
                Text(
                  'N${formatCurrency.format(deliveryFee())}',
                  style: _normText,
                )
              ]),
          Divider(
            thickness: 1,
            color: Color(0xffc4c4c4),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Total',
                  style: _normText,
                ),
                Text(
                  'N ${formatCurrency.format(getGrandTotal() + deliveryFee())}',
                  style: _normText,
                )
              ]),
        ],
      ),
    );
  }

  Widget appBar() {
    return AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Color(0xffE5E5E5),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        title: Text(
          "Cart",
          style: TextStyle(fontSize: 24, color: Colors.black),
        ),
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text("Delivery",
                          style: TextStyle(
                            fontSize: 14,
                          )),
                      Spacer(),
                      Text("Summary",
                          style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).primaryColor)),
                      SizedBox(
                        width: 8,
                      ),
                      Text("Payment", style: TextStyle(fontSize: 14))
                    ],
                  ),
                  Divider()
                ],
              ),
            )));
  }

  Widget header() {
    return Container(
      margin: EdgeInsets.all(16.0),
      child: Row(
        children: [
          Text(
            'Order Summary',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class PaymentPopUp extends StatefulWidget {
  final Box cartBox;
  final Map userData;
  final Map deliveryDetailsFromApi;
  final String phoneNumber;

  PaymentPopUp({
    @required this.cartBox,
    @required this.userData,
    @required this.phoneNumber,
    @required this.deliveryDetailsFromApi,
  });

  @override
  _PaymentPopUpState createState() => _PaymentPopUpState();
}

class _PaymentPopUpState extends State<PaymentPopUp> {
  bool loading = false;
  String id;

  int getGrandTotal() {
    int numbers = widget.cartBox.length;
    int _total = 0;

    for (var i = 0; i < numbers; i++) {
      int unitNumber = 1;
      int _itemPrice = 0;
      Map data = widget.cartBox.getAt(i);
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

  int deliveryFee() {
    String userLocation =
        widget.userData['uniDetails']['name'].toString().toLowerCase();
    int numbers = widget.cartBox.length;
    int shippingFee = 0;

    for (var i = 0; i < numbers; i++) {
      Map data = widget.cartBox.getAt(i);

      MarketCartModel currentItemDetails =
          MarketCartModel.fromMap(data.cast<String, dynamic>());
      int num = 0;

      if (widget.deliveryDetailsFromApi != null) {
        widget.deliveryDetailsFromApi.forEach((key, value) {
          String currentKey = key.toString().toLowerCase();
          String itemOriginLocation = currentItemDetails.productOriginLocation;
          Map currentLocation = value[itemOriginLocation] ?? {'price': 0};

          if (currentKey == userLocation) {
            num = num + currentLocation['price'];
          }
        });
      }

      shippingFee = shippingFee + num;
    }

    return shippingFee;
  }

  void clearCart() {
    widget.cartBox.clear();
  }

  Future<void> saveOrderInfoToDb() async {
    int numbers = widget.cartBox.length;
    List<Map> orderList = [];
    List<String> shopsList = [];
    PaidOrderModel paidOrderModel;

    for (var i = 0; i < numbers; i++) {
      Map data = widget.cartBox.getAt(i);
      EachPaidOrderModel eachPaidOrderModel;

      MarketCartModel currentItemDetails =
          MarketCartModel.fromMap(data.cast<String, dynamic>());

      eachPaidOrderModel = EachPaidOrderModel(
        size: currentItemDetails.size,
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
      buyerFullName: widget.userData['fullName'],
      buyerEmail: widget.userData['email'],
      buyerPhoneNumber: widget.phoneNumber,
      buyerAddress: widget.userData['address'],
      buyerID: widget.userData['uid'],
      listOfShopsPurchasedFrom: shopsList,
      orders: orderList,
      amountPaid: getGrandTotal() + deliveryFee(),
    );

    id = paidOrderModel.id;

    try {
      await MarketMethods().saveOrderToDataBase(data: paidOrderModel);
      clearCart();
      Navigator.pop(context);
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
      payingFor: 'Market Place',
      itemId: id,
    );
    if (result == 0) {
      saveOrderInfoToDb();
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
                        child: Text('Proceed'),
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
