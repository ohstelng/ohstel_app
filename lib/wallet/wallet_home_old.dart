import 'dart:convert';
import 'dart:io';

import 'package:Ohstel_app/auth/methods/auth_methods.dart';
import 'package:Ohstel_app/hive_methods/hive_class.dart';
import 'package:Ohstel_app/wallet/method.dart';
import 'package:Ohstel_app/wallet/pages/coin_history.dart';
import 'package:Ohstel_app/wallet/pages/wallet_history.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../auth/models/userModel.dart';

class WalletHomeOld extends StatefulWidget {
  _WalletHomeOldState createState() => _WalletHomeOldState();
}

class _WalletHomeOldState extends State<WalletHomeOld> {
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
      WalletMethods().fundWallet(amount: price);
    } else {
      print('error');
    }
  }

  void showFundPopUp() {
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

  void showTransferPopUp() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: TransferFundPopUp(),
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
    AuthService().getUserDetails().then((data) {
      setState(() {
        userModel = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: userModel == null
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.symmetric(vertical: 50, horizontal: 10),
                child: Container(
                  child: ListView(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          walletBalanceWidget(),
                          coinBalanceWidget(),
                        ],
                      ),
                      SizedBox(height: 20),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RaisedButton(
                            onPressed: () async {
                              showFundPopUp();
                            },
                            child: Text("Fund Wallet"),
                          ),
                          RaisedButton(
                            onPressed: () async {},
                            child: Text("Watch Ads"),
                          ),
                          RaisedButton(
                            onPressed: () async {},
                            child: Text("Convert Coin"),
                          ),
                          RaisedButton(
                            onPressed: () async {
                              showTransferPopUp();
                            },
                            child: Text("Transfer Fund"),
                          )
                        ],
                      ),
                      tabBar(),
                      Container(
                        child: SizedBox(
                          height: 400,
                          child: TabBarView(
                            children: [
                              WalletHistoryPage(),
                              CoinHistoryPage(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget tabBarView() {
    return Flexible(
      child: TabBarView(
        children: [
          WalletHistoryPage(),
          CoinHistoryPage(),
        ],
      ),
    );
  }

  Widget tabBar() {
    return Container(
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: TabBar(
        indicatorColor: Colors.orange,
        tabs: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Wallet History",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          Text(
            "Coin History",
            style: TextStyle(
              color: Colors.black,
            ),
          )
        ],
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
                  stream: WalletMethods()
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
                  stream: WalletMethods()
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

class TransferFundPopUp extends StatefulWidget {
  @override
  _TransferFundPopUpState createState() => _TransferFundPopUpState();
}

class _TransferFundPopUpState extends State<TransferFundPopUp> {
  bool _loading = false;
  int stage = 0;

  int amount;
  UserModel receiver;
  String uid;
  String message = 'Loading....';
  final formKey = GlobalKey<FormState>();

  void nextStep() {
    if (!mounted) return;

    if (stage <= 5) {
      setState(() {
        stage++;
      });
    }
  }

  Future<void> makeTransfer() async {
    if (!mounted) return;

    setState(() {
      _loading = true;
      stage = 2;
    });

    int result = await WalletMethods().transferFund(
      amount: amount.toDouble(),
      receiver: receiver,
    );

    if (result == 0) {
      message = 'Transfer SucessFull!. $amount Has Been Sent To'
          ' ${receiver.fullName}. \n ID: ${receiver.uid}';
    } else if (result == 1) {
      message = 'Error Occured';
    }

    setState(() {
      _loading = false;
      stage = 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: toDisplay(),
    );
  }

  Widget inputReceiver() {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Account ID',
              hintText: 'Input Receiver Account ID',
            ),
            keyboardType: TextInputType.text,
            validator: (value) {
              if (value.trim().isEmpty) {
                return 'Account ID Can\'t Be Empty';
              } else if (value.trim().length < 28) {
                return 'Account ID Must Be More Than 28 Characters';
              } else {
                return null;
              }
            },
            textInputAction: TextInputAction.done,
            onChanged: (val) {
              uid = val.trim();
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Amount',
              hintText: 'Input Amount',
            ),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            onChanged: (val) {
              amount = int.parse(val.trim());
            },
            validator: (value) {
              if (value.trim().isEmpty) {
                return 'Amount Can\'t Be Empty';
              } else {
                return null;
              }
            },
          ),
          SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FlatButton(
                onPressed: () {
                  if (formKey.currentState.validate()) {
                    nextStep();
                  }
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
              )
            ],
          )
        ],
      ),
    );
  }

  Widget getUserDetails() {
    return FutureBuilder(
      future: AuthService().getUserDetailsByUid(uid: uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox(
            height: 100,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          receiver = snapshot.data;
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'You are About To Transfer $amount To The User Below!',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0),
              Text('Full Name: ${receiver.fullName}'),
              SizedBox(height: 10.0),
              Text('Email: ${receiver.email}'),
              SizedBox(height: 10.0),
              Text('Phone Number: ${receiver.phoneNumber}'),
              SizedBox(height: 10.0),
              Text('ID: ${receiver.uid}'),
              SizedBox(height: 35.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FlatButton(
                    onPressed: () {
                      makeTransfer();
//                        nextStep();
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
                  )
                ],
              )
            ],
          );
        }
      },
    );
  }

  Widget loading() {
    return Container(
      margin: EdgeInsets.all(15.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(child: CircularProgressIndicator()),
          Text('Loading....')
        ],
      ),
    );
  }

  Widget messageWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$message'),
        SizedBox(height: 30.0),
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Ok'),
          color: Colors.grey,
        )
      ],
    );
  }

  Widget toDisplay() {
    Widget toDisplay;
    if (stage == 0) {
      toDisplay = inputReceiver();
    } else if (stage == 1) {
      toDisplay = getUserDetails();
    } else if (stage == 2) {
      toDisplay = loading();
    } else if (stage == 3) {
      toDisplay = messageWidget();
    }

    return toDisplay;
  }
}
