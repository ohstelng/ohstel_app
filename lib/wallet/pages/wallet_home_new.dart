import 'package:flutter/material.dart';

import 'coin_history.dart';
import 'wallet_history.dart';

const childeanFire = Color(0xFFF27507);
const midnightExpress = Color(0xFF1F2430);
const wineColor = Color(0xFF770000);
const textBlack = Color(0xFF12121F);

class WalletHomeNew extends StatelessWidget {
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
      body: SingleChildScrollView(
        child: Container(
          child: DefaultTabController(
            length: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
//Naira Wallet Card
                Container(
                  margin: const EdgeInsets.fromLTRB(24, 32, 24, 8),
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
                            backgroundColor: Colors.white.withOpacity(0.4),
                            child: Text(
                              '₦',
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
                              Text(
                                'NGN 30,000',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),

//Coin wallet card
                Container(
                  margin: const EdgeInsets.fromLTRB(24, 8, 24, 16),
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
                          'C',
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
                          Text(
                            'BTC 0.0222',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
// Action buttons
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    runAlignment: WrapAlignment.center,
                    children: <Widget>[
                      ActionButton(
                        label: 'Fund Wallet',
                        onTap: () {},
                        color: childeanFire,
                      ),
                      ActionButton(
                        onTap: () {},
                        label: 'Get a student Loan',
                        color: childeanFire,
                      ),
                      ActionButton(
                        onTap: () {},
                        label: 'Naira to Coin',
                      ),
                      ActionButton(
                        onTap: () {},
                        label: 'Coin to Naira',
                      ),
                    ],
                  ),
                ),
// Wallet History Page views
                Container(
                  margin: const EdgeInsets.fromLTRB(24, 16, 24, 8),
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
  }) : super(key: key);
  final Function onTap;
  final String label;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onTap,
      // color: color ?? midnightExpress,
      child: Text(
        '$label',
        style: TextStyle(
          color: color ?? midnightExpress,
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),
      ),
      height: 48,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: color ?? midnightExpress,
            width: 1,
          )),
    );
  }
}
