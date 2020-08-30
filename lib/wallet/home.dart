import 'package:Ohstel_app/auth/methods/auth_methods.dart';
import 'package:Ohstel_app/wallet/method.dart';
import 'package:Ohstel_app/wallet/pages/coin_history.dart';
import 'package:Ohstel_app/wallet/pages/wallet_history.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../auth/models/userModel.dart';

class WalletHome extends StatefulWidget {
  final String uid;
  WalletHome(this.uid, {Key key}) : super(key: key);

  _WalletHomeState createState() => _WalletHomeState();
}

class _WalletHomeState extends State<WalletHome> {
  UserModel userModel;
  @override
  void initState() {
    getUserDetails();
    super.initState();
  }

  getUserDetails() {
    AuthService().getUserDetails(uid: widget.uid).then((data) {
      setState(() {
        userModel = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //userModel = widget.userModel;
    WalletMethods methods = WalletMethods(widget.uid);
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
                        InkWell(
                          /* onTap: () async {
                            methods.updateWalletBalance(10).then((v) {
                              getUserDetails();
                            });
                          }, */
                          child: walletWidget(
                              "Wallet", userModel.walletBalance, Colors.green),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          /* onTap: () async {
                            methods.updateCoinBalance(10).then((v) {
                              getUserDetails();
                            });
                          }, */
                          child: walletWidget(
                              "Coin", userModel.coinBalance, Colors.red),
                        ),
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
                            methods
                                .createWalletHistory(10,
                                    desc: "Wallet funded from online payment")
                                .then((v) {
                              getUserDetails();
                            });
                          },
                          child: Text("Fund Wallet"),
                        ),
                        RaisedButton(
                          onPressed: () async {
                            methods
                                .createCoinHistory(10,
                                    desc: "Wallet funded from Advert Video")
                                .then((v) {
                              getUserDetails();
                            });
                          },
                          child: Text("Watch Ads"),
                        ),
                        RaisedButton(
                          onPressed: () async {
                            methods.convertCoin(10).then((v) {
                              getUserDetails();
                            });
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
                          item("Wallet History",
                              action: () => Get.to(WalletHistory(widget.uid))),
                          item("Coin History",
                              action: () => Get.to(CoinHistory(widget.uid))),
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

  walletWidget(String title, double balance, Color color) {
    return Container(
        width: MediaQuery.of(context).size.width / 2.2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color,
          boxShadow: [
            BoxShadow(color: color, spreadRadius: 3),
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
                title,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "NGN${balance.toString()}",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ));
  }
}
