import 'dart:async';
import 'dart:convert';

import 'package:Ohstel_app/hostel_booking/_/page/booking_home_page.dart';
import 'package:Ohstel_app/hostel_hire/methods/hire_methods.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../../auth/methods/auth_methods.dart';
import '../../hive_methods/hive_class.dart';
import '../../utilities/app_style.dart';
import '../../utilities/shared_widgets.dart';
import '../../wallet/method.dart';
import '../model/laundry_address_details_model.dart';
import '../model/paid_laundry_model.dart';

class LaundryPaymentPage extends StatefulWidget {
  final LaundryAddressDetailsModel laundryAddressDetails;

  LaundryPaymentPage({@required this.laundryAddressDetails});

  @override
  _LaundryPaymentPageState createState() => _LaundryPaymentPageState();
}

class _LaundryPaymentPageState extends State<LaundryPaymentPage> {
  StreamController<String> numberSteam = StreamController<String>();
  Box<Map> laundryBox;
  Box<Map> userDataBox;
  Map userData;
  Box<Map> addressDetailsBox;
  Map addressDetails;
  bool loading = true;
  int deliveryFee;
  bool payByCash = false;

  Future<void> getDeliveryFeeFromApi() async {
    String uniName = await HiveMethods().getUniName();
    Box<Map> laundry = await HiveMethods().getOpenBox('laundryBox');
    String url = 'https://quiz-demo-de79d.appspot.com/hire_api/$uniName';
    var response = await http.get(url);
    Map data = json.decode(response.body);
    deliveryFee = (data['$uniName'] * laundry.length);
  }

  int getGrandTotal() {
    int _price = 0;

    for (Map laundryData in laundryBox.values) {
      _price = _price + laundryData['price'];
    }

    return _price;
  }

  Future<void> getBox() async {
    if (!mounted) return;

    setState(() {
      loading = true;
    });

    await getDeliveryFeeFromApi();
    laundryBox = await HiveMethods().getOpenBox('laundryBox');
    userDataBox = await HiveMethods().getOpenBox('userDataBox');
    addressDetailsBox = await HiveMethods().getOpenBox('addressBox');
    Map data = await HiveMethods().getUserData();
    print(data);
    userData = data;
    numberSteam.add(data['phoneNumber']);

    setState(() {
      loading = false;
    });
  }

  void paymentPopUp() async {
//    try {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Confirm Payment',
            style: heading2,
          ),
          content: Container(
            child: PaymentPopUp(
              laundryAddressDetails: widget.laundryAddressDetails,
              deliveryFee: deliveryFee,
              laundryBox: laundryBox,
              userData: userData,
            ),
          ),
        );
      },
    );

//      Navigator.pop(context);
//    } catch (e) {
//      print(e);
//      Fluttertoast.showToast(msg: '$e');
//    }
  }

  @override
  void initState() {
    getBox();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDFDFD),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(
          color: midnightExpress,
          size: 24,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        bottom: PreferredSize(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: Text(
                'Review your Order',
                style: heading2,
              ),
            ),
            preferredSize: Size.fromHeight(32)),
      ),
      body: loading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(child: body()),
    );
  }

  Widget body() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //Order Summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFFF4F5F6),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              children: [
                SizedBox(height: 16),
                address(),
                // Number of items
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Number of items',
//                      style: tableLabelTextStyle,
                    ),
                    Text(
                      '${laundryBox.length}',
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),
//                      style: tableDataTextStyle,
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // Sub Total
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Sub Total',
//                      style: tableLabelTextStyle,
                    ),
                    RichText(
                      text: TextSpan(
                        text: '₦',style: TextStyle(color: Colors.black),
//                        style: nairaSignStyle,
                        children: [
                          TextSpan(
                            text: '${formatCurrency.format(getGrandTotal())}',
//                            style: tableDataTextStyle,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: 16),

                // Delivery Fee
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Delivery Fee',
//                      style: tableLabelTextStyle,
                    ),
                    RichText(
                      text: TextSpan(
                        text: '₦',
                        style: TextStyle(color: Colors.black),
//                        style: nairaSignStyle,
                        children: [
                          TextSpan(
                            text: '${formatCurrency.format(deliveryFee ?? 0)}',
//                            style: tableDataTextStyle,
                          ),
                        ],
                      ),
                    )
                  ],
                ),

                // Total
                Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: '₦',
                          style: TextStyle(color: Colors.black),
//                        style: nairaSignStyle,
                        children: [
                          TextSpan(
                            text: '${formatCurrency.format(getGrandTotal() + (deliveryFee ?? 0))}',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          //---Order summary

          // address


          Padding(
            padding: const EdgeInsets.fromLTRB(0, 40, 0, 16),
            child: CustomLongButton(
              label: 'Make Payment',
              onTap: () async {
//                Map addressDetails =
//                    await HiveMethods().getFoodLocationDetails();
                if (userData != null && addressDetailsBox != null) {
                  paymentPopUp();
                } else {
                  Fluttertoast.showToast(
                    msg: 'Plase Provide a delivery Location!',
                    gravity: ToastGravity.CENTER,
                    toastLength: Toast.LENGTH_LONG,
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }

  // Widget payButton() {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: Color(0xffF27509),
  //       borderRadius: BorderRadius.circular(15.0),
  //     ),
  //     width: double.infinity,
  //     margin: EdgeInsets.all(15.0),
  //     child: FlatButton(
  //       onPressed: () async {
  //         Map addressDetails = await HiveMethods().getFoodLocationDetails();

  //         if (userData != null && addressDetails != null) {
  //           paymentPopUp();
  //         } else {
  //           Fluttertoast.showToast(
  //             msg: 'Plase Provide a delivery Location!',
  //             gravity: ToastGravity.CENTER,
  //             toastLength: Toast.LENGTH_LONG,
  //           );
  //         }
  //       },
  //       child: Text(
  //         'Make Payment',
  //         style: TextStyle(color: Colors.white),
  //       ),
  //     ),
  //   );
  // }

  Widget address() {
    return Container(

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                  'Pick Up Address:'),
              Spacer(),
              Text(
                  '${widget.laundryAddressDetails.pickUpAddress['address']}, ${widget.laundryAddressDetails.pickUpAddress['areaName']}')
            ],
          ),
          SizedBox(height: 16,),
          Row(
            children: [
              Text(
                  'Pick Up PhoneNumber: '),
              Spacer(),
              Text(
                  '${widget.laundryAddressDetails.pickUpNumber}')
            ],
          ),
          SizedBox(height: 16,),
          Row(
            children: [
              Text('Pick Up Date: '),
              Spacer(),
              Text('${widget.laundryAddressDetails.pickUpDate}')
            ],
          ),
          SizedBox(height: 16,),
          Row(
            children: [
              Text('Pick Up Time: '),
              Spacer(),
              Text('${widget.laundryAddressDetails.pickUpTime}')
            ],
          ),
          SizedBox(height: 16,),
          Row(
            children: [
              Text(
                  'Drop Off Address: '),
              Spacer(),
              Text(
                  '${widget.laundryAddressDetails.dropOffAddress['address']}, ${widget.laundryAddressDetails.dropOffAddress['areaName']}')
            ],
          ),
          SizedBox(height: 16,),
          Row(
            children: [
              Text(
                  'Drop Off Phone Number:'),
              Spacer(),
              Text(
                  '${widget.laundryAddressDetails.pickUpNumber}')
            ],
          ),
          SizedBox(height: 16,),
          Divider()
        ],
      ),
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
                Text('${laundryBox.length}')
              ]),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Sub Total'),
                Text('NGN ${getGrandTotal()}')
              ]),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Delivery Fee'),
                Text('NGN $deliveryFee')
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
                  '${getGrandTotal() + deliveryFee}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                )
              ]),
        ],
      ),
    );
  }
}

class PaymentPopUp extends StatefulWidget {
  final Box laundryBox;
  final Map userData;
  final LaundryAddressDetailsModel laundryAddressDetails;
  final int deliveryFee;

  PaymentPopUp({
    @required this.laundryBox,
    @required this.userData,
    @required this.laundryAddressDetails,
    @required this.deliveryFee,
  });

  @override
  _PaymentPopUpState createState() => _PaymentPopUpState();
}

class _PaymentPopUpState extends State<PaymentPopUp> {
  bool loading = false;

  int getGrandTotal() {
    int _price = 0;

    for (Map laundryData in widget.laundryBox.values) {
      _price = _price + laundryData['price'];
    }

    print(_price);
    return _price + (widget.deliveryFee ?? 0);
  }

  void clearCart() {
    widget.laundryBox.clear();
  }

  Future<void> saveFoodInfoToDb() async {
    Map currentUserData = await HiveMethods().getUserData();
    List shopNamesList = [];

    widget.laundryBox.values.forEach((element) {
      String currentShopName = element['laundryPersonName'];

      if (!shopNamesList.contains(currentShopName)) {
        shopNamesList.add(currentShopName);
      }
    });

    print(shopNamesList);

    PaidLaundryBookingModel paidLaundry = PaidLaundryBookingModel(
      clothesOwnerName: currentUserData['fullName'],
      clothesOwnerEmail: currentUserData['email'],
      clothesOwnerAddressDetails: widget.laundryAddressDetails.toMap(),
      clothesOwnerPhoneNumber: currentUserData['phoneNumber'],
      listOfLaundry: widget.laundryBox.values.toList(),
      listOfLaundryShopsOrderedFrom: shopNamesList,
    );

    Map data = await paidLaundry.toMap();
    String id = data['id'];

    print(paidLaundry.toMap());
    await HireMethods().saveLaundryToServer(data: data, id: id);
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
      payingFor: 'Laundry',
      itemId: widget.userData['fullName'],
    );
    if (result == 0) {
      saveFoodInfoToDb();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    String password;
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'The sum of NGN ${getGrandTotal()} '
            'will be deducted from your Wallet Balance!',
            textAlign: TextAlign.start,
            style: body1.copyWith(height: 1.3),
          ),
          SizedBox(height: 16),
          SizedBox(
            height: 48,
            child: TextField(
              style: body1,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter Your Password',
                labelStyle: body1.copyWith(color: Color(0xFFC4C4C4)),
                hintStyle: body2.copyWith(color: Color(0xFFC4C4C4)),
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                  borderSide: BorderSide(color: childeanFire, width: 2),
                ),
              ),
              obscureText: true,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              onChanged: (val) {
                password = val;
              },
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
//                child: CustomShortButton(
//                  onTap: () async {
//                  label: 'Proceed',
//                  type: ButtonType.filledBlue,
                child: loading
                    ? Center(child: CircularProgressIndicator())
                    : FlatButton(
                        onPressed: () async {
                          if (password == null) return;
                          setState(() {
                            loading = true;
                          });
                          await validateUser(password: password);
                          setState(() {
                            loading = false;
                          });
                        },
                        child: Text('Proceed'),
                      ),
              ),
              Expanded(
//                child: CustomShortButton(
//                    label: 'Cancel',
//                    type: ButtonType.borderBlue
                child: FlatButton(
                  child: Text('Cancel'), //
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
