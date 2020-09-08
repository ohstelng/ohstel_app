import 'dart:convert';
import 'dart:io';

import 'package:Ohstel_app/auth/methods/auth_methods.dart';
import 'package:Ohstel_app/hive_methods/hive_class.dart';
import 'package:Ohstel_app/wallet/method.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../auth/models/userModel.dart';

class WalletHome extends StatefulWidget {
  _WalletHomeState createState() => _WalletHomeState();
}

class _WalletHomeState extends State<WalletHome> {
  UserModel userModel;
  Map userData;
  bool isLoading = true;

  Future<void> getUserData() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
    });
    userData = await HiveMethods().getUserData();
    setState(() {
      isLoading = false;
    });

    getUserDetails();
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

  Future<void> _verifyOnServer(String reference) async {
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

  Future chargeCard({@required int price}) async {
    Charge charge = Charge()
      ..amount = (price * 100).toInt()
      ..reference = _getReference()
//..accessCode = _createAcessCode(skTest, _getReference())
      ..email = userData['email'];
    CheckoutResponse response = await PaystackPlugin.checkout(
      context,
      method: CheckoutMethod.card,
      charge: charge,
    );
    if (response.status == true) {
      await _verifyOnServer(response.reference);
      WalletMethods(userData['uid']).fundWallet(amount: price.toDouble());
    } else {
      print('error');
    }
  }

  void showPopUp() {
    String amount;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: TextField(
            decoration: InputDecoration(hintText: 'Enter Amount'),
            onChanged: (val) {
              amount = val;
            },
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.number,
          ),
          actions: [
            FlatButton(
              onPressed: () async {
                if (amount != null) {
                  await chargeCard(price: int.parse(amount));
                  Navigator.pop(context);
                }
              },
              child: Text('Pay'),
              color: Colors.green,
            ),
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.grey,
            )
          ],
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

  getUserDetails() {
    AuthService().getUserDetails(uid: userData['uid']).then((data) {
      setState(() {
        userModel = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //userModel = widget.userModel;
//    WalletMethods methods = WalletMethods(userData['uid']);
    return Scaffold(
      body: userModel == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.symmetric(vertical: 50, horizontal: 10),
              child: Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        walletBalanceWidget(),
                        coinBalanceWidget(),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RaisedButton(
                          onPressed: () async {
                            showPopUp();
                          },
                          child: Text("Fund Wallet"),
                        ),
                        RaisedButton(
                          onPressed: () async {
//                            methods
//                                .createCoinHistory(10,
//                                    desc: "Wallet funded from Advert Video")
//                                .then((v) {
//                              getUserDetails();
//                            });
                          },
                          child: Text("Watch Ads"),
                        ),
                        RaisedButton(
                          onPressed: () async {
//                            methods.convertCoin(10).then((v) {
//                              getUserDetails();
//                            });
                          },
                          child: Text("Convert Coin"),
                        )
                      ],
                    ),
                    Expanded(
                      //height: 1000,
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          item(
                            "Wallet History",
//                              action: () => Get.to(WalletHistory(widget.uid)),
                          ),
                          item(
                            "Coin History",
//                              action: () => Get.to(CoinHistory(widget.uid)),
                          ),
                          Divider(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  item(title, {Function action}) {
    return InkWell(
      onTap: () async => action(),
      child: Card(
        //color: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          height: 100,
          child: ListTile(
            title: Center(
                child: Text(title,
                    style: TextStyle(
                        //color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold))),
          ),
          //color: Colors.blue,
          //width: MediaQuery.of(context).size.width / 2.2,
        ),
      ),
    );
  }

  Widget walletBalanceWidget() {
    return Container(
        width: MediaQuery.of(context).size.width / 2.2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.green,
          boxShadow: [
//            BoxShadow(color: color, spreadRadius: 3),
          ],
        ),
        //color: Colors.green,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Wallet',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
              StreamBuilder(
                  stream: WalletMethods(userData['uid'])
                      .userDataCollectionRef
                      .doc(userData['uid'])
                      .snapshots(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return Text('Loading...');
                    } else {
                      if (snapshot.data == null) {
                        return Text('......');
                      }
                      DocumentSnapshot doc = snapshot.data;
                      String balance =
                          (doc.data()['walletBalance'] ?? 0).toString();
                      return Text(
                        "NGN $balance.0",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold),
                      );
                    }
                  }),
            ],
          ),
        ));
  }

  Widget coinBalanceWidget() {
    return Container(
        width: MediaQuery.of(context).size.width / 2.2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.green,
          boxShadow: [
//            BoxShadow(color: color, spreadRadius: 3),
          ],
        ),
        //color: Colors.green,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Coin',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
              StreamBuilder(
                  stream: WalletMethods(userData['uid'])
                      .userDataCollectionRef
                      .doc(userData['uid'])
                      .snapshots(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return Text('Loading...');
                    } else {
                      if (snapshot.data == null) {
                        return Text('......');
                      }
                      DocumentSnapshot doc = snapshot.data;
                      String balance =
                          (doc.data()['coinBalance'] ?? 0).toString();
                      return Text(
                        "NGN $balance.0",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold),
                      );
                    }
                  }),
            ],
          ),
        ));
  }
}
