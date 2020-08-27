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
  TextStyle _mainText =TextStyle(fontSize: 16,color: Color(0xff000000));
  TextStyle _subText = TextStyle(fontSize: 16,color: Color(0xffc4c4c4));
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
            height: 200,
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
                  color: Theme.of(context).primaryColor,
                  child: Text('Submit',style: TextStyle(color: Colors.white),),
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
        msg: 'Please Provide a delivery Location!',
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
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: cartBox.isNotEmpty
                  ? Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      color: Color(0xffE5E5E5),
                      child: ListView(
                        children: [
                          getAddress(),
                          Container(
                            padding: EdgeInsets.all(16),
                            height: 45,
                            child: Text("Details",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),),
                          productDetails(),
                          Container(height: 45,),
                          priceInfo(),
                          button(),
                          modifybutton()
                        ],
                      ),
                    )
                  : emptyCart(),
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
                              color: Theme.of(context).primaryColor)),
                      Spacer(),
                      Text("Summary", style: TextStyle(fontSize: 14)),
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

  Widget emptyCart() {
    return Container(
      child: Center(
        child: Text('Cart Is Empty'),
      ),
    );
  }

  Widget button() {
    return Container(
      margin: EdgeInsets.only(top: 24,bottom: 8),
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: InkWell(
        onTap: () async {
          proceedToPay();
        },
        child: Container(
          decoration: BoxDecoration(color: Color(0xff1f2430),borderRadius: BorderRadius.circular(10)),
          height: 55,
          child: Center(
            child:
            Text('Next',
              style: TextStyle(color: Color(0xffFFFFFF),fontSize: 20, fontWeight: FontWeight.bold),),),
        ),
      ),
    );
  }
  Widget modifybutton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: InkWell(
        onTap: () async {
          Navigator.pop(context);
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(border: Border.all(color:Color(0xff1f2430),width: 2),color: Colors.white,borderRadius: BorderRadius.circular(10)),
          height: 55,
          child: Center(
            child:
            Text('Modify Cart',
              style: TextStyle(color: Color(0xff000000),fontSize: 20, fontWeight: FontWeight.bold),),),
        ),
      ),
    );
  }

  Widget priceInfo() {
    return Container(color: Colors.white,
      padding: EdgeInsets.all(15.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Product Amount',style: _mainText,),
              Text('₦${getSubTotal()}',style: _mainText,),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Delivery Fees',style: _mainText,),
              Text('₦${deliveryFee()}',style: _mainText,),
            ],
          ),
          Divider(
            thickness: 1.5,
            color: Color(0xffc4c4c4),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Total',style: _mainText,),
              Text('₦${getGrandTotal()}',style: _mainText,),
            ],
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
                    '₦${_uniMap[currentCartItem.productOriginLocation.toLowerCase()]['price']}'),
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
                    '₦${_uniMap[currentCartItem.productOriginLocation.toLowerCase()]['delivery_time']} Day'),
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
      TextStyle _mainText =TextStyle(fontSize: 16,color: Color(0xff000000));
      TextStyle _subText = TextStyle(fontSize: 16,color: Color(0xffc4c4c4));
      return Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Shipped From ${currentCartItem.productOriginLocation}',style:_mainText ,),
                Text('${_uniMap[schoolNameAbbr.toLowerCase()]['price']}',style: _subText,),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Delivery Time',style: _mainText,),
                Text(
                    '${_uniMap[schoolNameAbbr.toLowerCase()]['delivery_time']} Day',style: _subText,),
              ],
            ),
          ),
        ],
      );
    }
  }

  Widget productDetails() {
    TextStyle _mainText = TextStyle(fontSize: 16,color: Colors.black);
    TextStyle _subText = TextStyle(fontSize: 16,color: Color(0xffc4c4c4));
    return Container(color: Colors.white,
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
                                    Text('${currentCartItem.productName}',style: _mainText,),
                                    Text('${currentCartItem.productPrice}',style: _subText,),
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
                                      Text("Units",style: _mainText,),
                                      Text('${currentCartItem.units}',style: _subText,),
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
              elevation: 0,
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(" Address "),
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
                    ),
                    Container(
                      width: double.infinity,
                      child: Card(
                        elevation: 0,
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
                  padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 16),
                  child: Row(
                    children: [
                      Text(
                        "Delivery Method ",
                        style: TextStyle(fontSize: 16, fontWeight:FontWeight.bold,color: Colors.black),
                      ),
                      Spacer(),
                      Container(
                        child: InkWell(
                          child: Text(
                            "Change Address",
                            style: TextStyle(
                                fontSize: 16, color: Color(0xffc4c4c4)),
                          ),
                          onTap: () {
                            editAddressDialog();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container
                  (
                  decoration: BoxDecoration(color: Colors.white),
                  padding: EdgeInsets.symmetric(horizontal: 16,vertical:15.0),
                  width: MediaQuery.of(context).size.width,
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
                             child: InkWell(
                                onTap: () {
                                  editPhoneNumber();
                                },
                                child: Text('Edit Phone Number',style: TextStyle(color: Color(0xffc4c4c4)),),
                              ),
                            ),
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
}
