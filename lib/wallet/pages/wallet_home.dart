import 'dart:convert';
import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../../auth/methods/auth_methods.dart';
import '../../auth/models/userModel.dart';
import '../../hive_methods/hive_class.dart';
import '../../utilities/app_style.dart';
import '../method.dart';
import 'coin_history.dart';
import 'wallet_history.dart';

class WalletHome extends StatefulWidget {
  @override
  _WalletHomeState createState() => _WalletHomeState();
}

class _WalletHomeState extends State<WalletHome> {
  AdmobReward reward;
  // Screen Functionality
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

  getUserDetails() {
    AuthService().getUserDetails(uid: userData['uid']).then((data) {
      if(!mounted) return;
      setState(() {
        userModel = data;
      });
    });
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
            style: TextStyle(
              color: textBlack,
              fontSize: 24,
            ),
            decoration: InputDecoration(
              hintText: 'Enter Amount',
              isDense: true,
              hintStyle: TextStyle(
                color: Colors.blueGrey,
                fontSize: 20,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2),
                borderSide: BorderSide(
                  color: childeanFire,
                  width: 1.5,
                ),
              ),
              contentPadding: const EdgeInsets.only(
                left: 24,
                top: 8,
                bottom: 8,
              ),
            ),
            onChanged: (val) {
              amount = val;
            },
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.number,
          ),
          actions: [
            ActionButton(
              onTap: () async {
                if (amount != null) {
                  await chargeCard(price: int.parse(amount));
                  Navigator.pop(context);
                }
              },
              label: 'Pay',
              filled: true,
              color: childeanFire,
            ),
            ActionButton(
              onTap: () {
                Navigator.pop(context);
              },
              label: 'Cancel',
              filled: false,
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
//    reward = AdmobReward(
//        adUnitId: AdManager.RewardId,
//        listener: (event, args) {
//          if (event == AdmobAdEvent.rewarded) {
//            //TODO: implement get coin
//            //TODO: implement get coin
//            //TODO: implement get coin
//            // The backend for the reward goes here, Mr Ola.
//            WalletMethods().getCoin(context: context);
//            print('User Rewarded');
//          }
//        });
//    reward.load();
  }

//-- Screen Functionality

// Screen UI
  Widget tabBar() {
    return Container(
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: TabBar(
        indicatorColor: childeanFire,
        tabs: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Naira",
              style: TextStyle(
                color: midnightExpress,
              ),
            ),
          ),
          Text(
            "Coin",
            style: TextStyle(
              color: midnightExpress,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F4F4),
      appBar: AppBar(
        backgroundColor: Color(0xFFF4F4F4),
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Wallet',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: textBlack,
          ),
        ),
      ),
      body: userModel == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
//Naira Wallet Card
                      Container(
                        margin: const EdgeInsets.fromLTRB(20, 32, 20, 8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: childeanFire,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                CircleAvatar(
                                  backgroundColor:
                                      Colors.white.withOpacity(0.4),
                                  child: Text(
                                    'N',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Naira Wallet',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    StreamBuilder(
                                        stream: WalletMethods()
                                            .userWalletCollectionRef
                                            .doc(userData['uid'])
                                            .snapshots(),
                                        builder:
                                            (context, AsyncSnapshot snapshot) {
                                          if (!snapshot.hasData) {
                                            return Text('Loading...');
                                          } else {
                                            if (snapshot.data == null) {
                                              return Text('......');
                                            }
                                            DocumentSnapshot doc =
                                                snapshot.data;
                                            String balance =
                                                (doc.data()['walletBalance'] ??
                                                        0)
                                                    .toString();
                                            return Text(
                                              'NGN $balance.0',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 24,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            );
                                          }
                                        }),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),

//Coin wallet card
                      Container(
                        margin: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: wineColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundColor: Colors.white.withOpacity(0.4),
                              child: Text(
                                'O',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Coin Wallet',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(height: 8),
                                StreamBuilder(
                                    stream: WalletMethods()
                                        .userWalletCollectionRef
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
                                            (doc.data()['coinBalance'] ?? 0)
                                                .toString();
                                        return Text(
                                          'OHC $balance.0',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        );
                                        /* Text(
                        "NGN $balance.0",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold),
                      ); */
                                      }
                                    }),
                              ],
                            ),
                          ],
                        ),
                      ),
// Action buttons
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.start,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          runAlignment: WrapAlignment.center,
                          children: <Widget>[
                            ActionButton(
                              label: 'Fund Wallet',
                              onTap: () {
                                showFundPopUp();
                              },
                              color: childeanFire,
                            ),
                            ActionButton(
                              onTap: () async {
                                if (await reward.isLoaded) {
                                  reward.show();
                                } else {
                                  print('Error');
                                }
                              },
                              label: 'Get  Coin',
                              color: childeanFire,
                            ),
                            ActionButton(
                              onTap: () {},
                              label: 'Coin to Naira',
                              color: childeanFire,
                            ),
                            ActionButton(
                              onTap: () {},
                              label: 'Get a student Loan',
                            ),
                            ActionButton(
                              onTap: () {
                                showTransferPopUp();
                              },
                              label: 'Transfer Fund',
                            ),
                          ],
                        ),
                      ),
// Wallet History Page views
                      Container(
                        margin: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                        child: Text(
                          'Wallet History',
                          style: TextStyle(
                            fontSize: 24,
                            color: textBlack,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      tabBar(),
                      SizedBox(
                        height: 400,
                        child: TabBarView(
                          children: [
                            WalletHistoryPage(),
                            CoinHistoryPage(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

// Reused action Button widget
class ActionButton extends StatelessWidget {
  const ActionButton({
    Key key,
    @required this.onTap,
    @required this.label,
    this.color,
    this.filled = false,
  }) : super(key: key);
  final Function onTap;
  final String label;
  final Color color;
  final bool filled;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onTap,
      color: filled ? color ?? midnightExpress : null,
      child: Text(
        '$label',
        style: TextStyle(
          color: filled ? Colors.white : color ?? midnightExpress,
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),
      ),
      height: 48,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: filled ? Colors.transparent : color ?? midnightExpress,
            width: 1,
          )),
    );
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
      message = 'Transfer SuccessFull!. $amount Has Been Sent To'
          ' ${receiver.fullName}. \n ID: ${receiver.uid}';
    } else if (result == 1) {
      message = 'Error Occurred';
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
              isDense: true,
              hintStyle: TextStyle(
                color: Colors.blueGrey,
                fontSize: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2),
                borderSide: BorderSide(
                  color: childeanFire,
                  width: 1.5,
                ),
              ),
              contentPadding: const EdgeInsets.only(
                left: 24,
                top: 8,
                bottom: 8,
              ),
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
          SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Amount',
              hintText: 'Input Amount',
              isDense: true,
              hintStyle: TextStyle(
                color: Colors.blueGrey,
                fontSize: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2),
                borderSide: BorderSide(
                  color: childeanFire,
                  width: 1.5,
                ),
              ),
              contentPadding: const EdgeInsets.only(
                left: 24,
                top: 8,
                bottom: 8,
              ),
            ),
            keyboardType: TextInputType.number,
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
              ActionButton(
                onTap: () {
                  if (formKey.currentState.validate()) {
                    nextStep();
                  }
                },
                label: 'Proceed',
                filled: true,
                color: childeanFire,
              ),
              ActionButton(
                onTap: () {
                  Navigator.pop(context);
                },
                label: 'Cancel',
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

//-- Screen UI
