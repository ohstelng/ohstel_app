import 'dart:async';
import 'dart:convert';

import 'package:Ohstel_app/hive_methods/hive_class.dart';
import 'package:Ohstel_app/hostel_market_place/models/market_cart_model.dart';
import 'package:Ohstel_app/hostel_market_place/pages/market_summary_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

class MarketCheckOutPage extends StatefulWidget {
  @override
  _MarketCheckOutPageState createState() => _MarketCheckOutPageState();
}

class _MarketCheckOutPageState extends State<MarketCheckOutPage> {
  StreamController<String> numberSteam = StreamController<String>.broadcast();
  Box<Map> cartBox;
  Box<Map> userDataBox;
  Map userData;
  bool isLoading = true;
  String uniName = 'Select Drop Location';
  int numbers = 0;
  Map deliveryDetailsFromApi;
  String _phoneNumber;

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
    String num = data['phoneNumber'];
    print(num);
    numberSteam.add(num);
    if (mounted) {
      setState(() {
        isLoading = false;
        numberSteam.add(num);
      });
    }
  }

  Future<void> editAddress({@required String address}) async {
    Map currentUserData = await HiveMethods().getUserData();
    print(currentUserData);
    currentUserData['address'] = address;
    print(currentUserData);
    HiveMethods().updateUserAddress(map: currentUserData);
    Navigator.maybePop(context);
  }

  Future getDeliveryInfoFromApi() async {
    String url = "http://quiz-demo-de79d.appspot.com/market_api/deliveryInfo";
    var response = await http.get(url);
    var data = json.decode(response.body);

    return data;
  }

  Future getUniList() async {
    String url = "https://quiz-demo-de79d.appspot.com/hostel_api/searchKeys";
    var response = await http.get(url);
    var result = json.decode(response.body);
    print(result);
    return result;
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

  void editAddressDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        String address;
        String _uniName;
        return Dialog(
          child: Container(
            margin: EdgeInsets.all(15.0),
//            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    hintText: 'Enter Your Address',
                  ),
                  maxLines: null,
                  maxLength: 250,
                  onChanged: (val) {
                    address = val.trim();
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    hintText: 'Enter Your Uni Name',
                  ),
                  maxLines: null,
                  maxLength: 100,
                  onChanged: (val) {
                    _uniName = val.trim();
                  },
                ),
                FlatButton(
                  onPressed: () {
//                    print(address.length);
                    if (address.trim() != '' && _uniName.trim() != null) {
                      editAddress(address: '$address, $_uniName');
                    } else {
                      Fluttertoast.showToast(msg: 'Input Invaild Input!');
                    }
                  },
                  color: Colors.green,
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  int deliveryFee() {
    int numbers = cartBox.length;
    int shippingFee = 0;

    for (var i = 0; i < numbers; i++) {
      Map data = cartBox.getAt(i);

      MarketCartModel currentItemDetails =
          MarketCartModel.fromMap(data.cast<String, dynamic>());
      int num = 0;

      if (deliveryDetailsFromApi != null) {
        deliveryDetailsFromApi.forEach((key, value) {
          if (key.toString().toLowerCase() ==
              userData['uniDetails']['name'].toString().toLowerCase()) {
            num =
                num + value[currentItemDetails.productOriginLocation]['price'];
          }
        });
      }

      shippingFee = shippingFee + num;
    }

    return shippingFee;
  }

  int getGrandTotal() {
    int numbers = cartBox.length;
    int _total = 0;

    for (var i = 0; i < numbers; i++) {
      int unitNumber = 1;
      int _itemPrice = 0;
      Map data = cartBox.getAt(i);
      int _currentTotal = 0;
      int shippingFee = 0;

      MarketCartModel currentItemDetails =
          MarketCartModel.fromMap(data.cast<String, dynamic>());
      unitNumber = currentItemDetails.units;

      if (deliveryDetailsFromApi != null) {
        deliveryDetailsFromApi.forEach((key, value) {
          if (key.toString().toLowerCase() ==
              userData['uniDetails']['name'].toString().toLowerCase()) {
            print(key);
            print(value[currentItemDetails.productOriginLocation]['price']);
            shippingFee = shippingFee +
                value[currentItemDetails.productOriginLocation]['price'];
          }
        });
      }

      _itemPrice = currentItemDetails.productPrice;
      _currentTotal = _itemPrice * unitNumber;
      _total = _total + _currentTotal + shippingFee;
    }

    return _total;
  }

  int getSubTotal() {
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

  void proceedToPay() async {
    String address = await HiveMethods().getAddress();
    if (address != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MarketSummaryPage(
            phoneNumber: _phoneNumber,
          ),
        ),
      );
    } else {
      Fluttertoast.showToast(
        msg: 'Plase Provide a delivery Location!',
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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: cartBox.isNotEmpty
                  ? ListView(
                      children: [
                        getAddress(),
                        productDetails(),
                        priceInfo(),
                        button(),
                      ],
                    )
                  : emptyCart(),
            ),
    );
  }

  Widget emptyCart() {
    return Container(
      child: Center(
        child: Text('Cart Is Empty'),
      ),
    );
  }

  Widget button() {
    return Container(
      child: FlatButton(
        color: Colors.green,
        onPressed: () async {
          proceedToPay();
        },
        child: Text('Procced To Pay'),
      ),
    );
  }

  Widget priceInfo() {
    return Container(
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
              Text('Sub Total'),
              Text('${getSubTotal()}'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Delivery Fee'),
              Text('${deliveryFee()}'),
            ],
          ),
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
    );
  }

  Widget deliveryInfo(
      {@required MarketCartModel currentCartItem, @required Map apiData}) {
    String schoolName = userData['uniDetails']['name'].toString();
    String schoolNameAbbr = userData['uniDetails']['abbr'].toString();
    print(userData);
    print(schoolName);
    print(schoolNameAbbr);

    if (currentCartItem.productOriginLocation !=
        userData['uniDetails']['abbr'].toString().toLowerCase()) {
      Map _uniMap;

      apiData.forEach((key, value) {
//        print('ggggggggggggggggggggggggggg');
//        print(value);
//        print(key);
        if (key.toString().toLowerCase() == schoolName.toLowerCase()) {
//          print('ggggggggggggggggggggggggggg');
//          print(value);
          _uniMap = value;
        }
      });

      print(_uniMap);

      return Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Shipped From ${currentCartItem.productOriginLocation}'),
                Text(
                    '${_uniMap[currentCartItem.productOriginLocation.toLowerCase()]['price']}'),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Delivery Time'),
                Text(
                    '${_uniMap[currentCartItem.productOriginLocation.toLowerCase()]['delivery_time']} Day'),
              ],
            ),
          ),
        ],
      );
    } else {
      Map _uniMap;

      apiData.forEach((key, value) {
        if (key.toString().toLowerCase() == schoolName.toLowerCase()) {
          _uniMap = value;
        }
      });
      return Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Shipped From ${currentCartItem.productOriginLocation}'),
                Text('${_uniMap[schoolNameAbbr.toLowerCase()]['price']}'),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Delivery Time'),
                Text(
                    '${_uniMap[schoolNameAbbr.toLowerCase()]['delivery_time']} Day'),
              ],
            ),
          ),
        ],
      );
    }
  }

  Widget productDetails() {
    return Container(
      child: FutureBuilder(
          future: getDeliveryInfoFromApi(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Map apiData = snapshot.data;
//            List locationList = apiData.values.toList();
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
                                deliveryInfo(
                                  currentCartItem: currentCartItem,
                                  apiData: apiData,
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
//                                            print(currentCartItem.productOriginLocation);
//                                            print(locationList);
                                              cartBox.deleteAt(index);
                                              setState(() {});
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
                  );
                },
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
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
                      children: [
                        Text("Address "),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: Colors.grey[300],
                          ),
                          padding: EdgeInsets.all(8.0),
                          child: InkWell(
                            child: Text("Edit"),
                            onTap: () {
                              editAddressDialog();
                            },
                          ),
                        ),
                      ],
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Address "),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.grey[300],
                      ),
                      padding: EdgeInsets.all(8.0),
                      child: InkWell(
                        child: Text("Edit"),
                        onTap: () {
                          editAddressDialog();
                        },
                      ),
                    ),
                  ],
                ),
                Card(
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
                            '${userData['address']}',
//                        ']}',
                            maxLines: 4,
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
                                      _phoneNumber = userData['phoneNumber'];
                                      return Text('${userData['phoneNumber']}');
                                    } else {
                                      _phoneNumber = snapshot.data;
                                      return Text(
                                        '${snapshot.data}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      );
                                    }
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
                ),
              ],
            );
          },
        );
      },
    );
  }
}
