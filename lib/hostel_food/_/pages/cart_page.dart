import 'package:Ohstel_app/hive_methods/hive_class.dart';
import 'package:Ohstel_app/hostel_food/_/methods/fast_food_methods.dart';
import 'package:Ohstel_app/hostel_food/_/models/extras_food_details.dart';
import 'package:Ohstel_app/hostel_food/_/models/food_details_model.dart';
import 'package:Ohstel_app/hostel_food/_/models/paid_food_model.dart';
import 'package:Ohstel_app/hostel_food/_/pages/food_payment_page.dart';
import 'package:Ohstel_app/hostel_food/_/pages/select_location_page.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Box<Map> cartBox;
  Box<Map> userDataBox;
  Box<Map> addressDetailsBox;
  int numbers = 0;
  Map userData;
  bool onCampus = false;
  bool isLoading = true;
  Map addressDetails;
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
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
//    cartBox = await HiveMethods().getOpenBox('cart');
    cartBox = await HiveMethods().getCartData();
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
    symbol = String.fromCharCodes(input);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
            color: Colors.black,
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop()),
        title: Text(
          "Cart",
          style: TextStyle(
            color: Colors.black,
            fontSize: 17,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
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
                            int numberOfPlates = data['numberOfPlates'];
                            ItemDetails currentItemDetails =
                                ItemDetails.formMap(data['itemDetails']
                                    .cast<String, dynamic>());
                            List<ExtraItemDetails> currentExtraItemDetails =
                                getExtraFromMap(data: data['extraItems']);

                            return Column(
                              children: [
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 20, 20, 10),
                                  width: double.infinity,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      currentItemDetails.imageUrl != null
                                          ? Container(
                                              height: 80,
                                              width: 80,
                                              child: ExtendedImage.network(
                                                currentItemDetails.imageUrl,
                                                fit: BoxFit.contain,
                                                handleLoadingProgress: true,
                                                shape: BoxShape.rectangle,
                                                cache: false,
                                                enableMemoryCache: true,
                                              ),
                                            )
                                          : Container(
                                              height: 120,
                                              width: 120,
                                              decoration: BoxDecoration(
                                                color: Colors.grey,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                      Flexible(
                                        child: Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 0, 10, 0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                '${currentItemDetails.itemName}',
                                                textAlign: TextAlign.start,
                                                overflow: TextOverflow.clip,
                                                style: TextStyle(fontSize: 24),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                '${currentItemDetails.itemFastFoodName}',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.grey),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                '$symbol ${formatCurrency.format(currentItemDetails.price)}',
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 20, 0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
//
//                                      getExtraWidget(
//                                          extras: currentExtraItemDetails),
//                                      Container(
//                                        margin: EdgeInsets.only(top: 10.0),
//                                        child: Row(
//                                          mainAxisAlignment:
//                                              MainAxisAlignment.spaceBetween,
//                                          children: <Widget>[
//                                            Text('Number Of Plates'),
//                                            Text('${data['numberOfPlates']}'),
//                                          ],
//                                        ),
//                                      ),

                                      Container(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: <Widget>[
                                                InkWell(
                                                  child: Icon(
                                                    Icons.delete_outline,
                                                    // color: Colors.red,
                                                  ),
                                                  onTap: () {
                                                    cartBox.deleteAt(index);
                                                  },
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    cartBox.deleteAt(index);
                                                  },
                                                  child: Text(
                                                    'Remove',
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 17),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        child: Row(
                                          children: [
                                            IconButton(
                                              icon: Icon(
                                                Icons.favorite_border,
                                                color: Colors.black87,
                                              ),
                                              onPressed: () {
                                                setState(() {});
                                              },
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Container(
//                        padding: EdgeInsets.symmetric(horizontal: 1.5),
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: numberOfPlates == 1
                                                      ? Colors.grey
                                                      : Color(0xFFF27507),
                                                ),
                                              ),
                                              child: InkWell(
                                                child: Icon(
                                                  Icons.remove,
                                                  color: numberOfPlates == 1
                                                      ? Colors.grey
                                                      : Color(0xFFF27507),
                                                ),
                                                onTap: () {
                                                  if (numberOfPlates > 1) {
                                                    if (mounted) {
                                                      setState(() {
                                                        numberOfPlates--;
                                                      });
                                                    }
                                                  }
                                                },
                                              ),
                                            ),
                                            Text('$numberOfPlates'),
                                            Container(
                                              margin: EdgeInsets.only(left: 10),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Color(0xFFF27507),
                                                ),
                                              ),
                                              child: InkWell(
                                                child: Icon(
                                                  Icons.add,
                                                  color: Color(0xFFF27507),
                                                ),
                                                onTap: () {
                                                  if (mounted) {
                                                    setState(() {
                                                      numberOfPlates++;
                                                    });
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: Divider(
                                    thickness: 0.5,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total Amount:",
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                                "$symbol ${formatCurrency.format(getGrandTotal())}",
                                style: TextStyle(fontSize: 20))
                          ],
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
        width: double.infinity,
        child: FlatButton(
          padding: EdgeInsets.all(15),
          color: Color(0xFF202530),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => FoodPaymentPage(),
              ),
            );
          },
          child: Text(
            'PROCEED TO PAYMENT',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
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
