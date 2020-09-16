import 'package:Ohstel_app/hive_methods/hive_class.dart';
import 'package:Ohstel_app/hostel_booking/_/page/booking_home_page.dart';
import 'package:Ohstel_app/hostel_food/_/pages/food_home_page.dart';
import 'package:Ohstel_app/hostel_market_place/pages/market_home_page.dart';
import 'package:Ohstel_app/landing_page/homepage.dart';
import 'package:Ohstel_app/wallet/pages/wallet_home.dart';
import 'package:Ohstel_app/wallet/wallet_home_old.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainHomePage extends StatefulWidget {
  @override
  _MainHomePageState createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  PageController pageController;
  int getPageIndex = 2;

  void pageChanged(int pageIndex) {
    setState(() {
      getPageIndex = pageIndex;
    });
  }

  void onTapChangePage(int pageIndex) {
    pageController.animateToPage(pageIndex,
        duration: Duration(milliseconds: 200), curve: Curves.bounceInOut);
  }

  void navigatorCallBack(int i) {
    print(i);
    onTapChangePage(i);
  }

  TextStyle _bottomStyle = TextStyle(fontSize: 9);

  @override
  void initState() {
    pageController = PageController(initialPage: 2, keepPage: true);
    //TODO: implement connectivity checker
    //TODO: implement connectivity checker
    //TODO: implement connectivity checker
    //TODO: implement connectivity checker
    HiveMethods().intiLocationData();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: <Widget>[
          HostelBookingHomePage(),
          FoodHomePage(),
          Homepage(callback: navigatorCallBack),
          MarketHomePage(),
          WalletHome(),
//          HireHomePage(),
        ],
        controller: pageController,
        onPageChanged: pageChanged,
        physics: BouncingScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: Color(0xfff4f5f6),
        currentIndex: getPageIndex,
        onTap: onTapChangePage,
        activeColor: Colors.deepOrange,
        inactiveColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Color(0xfff4f5f6),
            icon: Padding(
              padding: const EdgeInsets.all(4.0),
              child: SvgPicture.asset("asset/hostel.svg"),
            ),
            title: Text(
              'Hostel',
              style: _bottomStyle,
            ),
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.all(4.0),
              child: SvgPicture.asset("asset/food.svg"),
            ),
            title: Text(
              'Food',
              style: _bottomStyle,
            ),
          ),
          BottomNavigationBarItem(
            icon: Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Color(0xffF4F5F6)),
              padding: const EdgeInsets.all(4),
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Image.asset("asset/OHstel.png"),
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.all(4.0),
              child: SvgPicture.asset("asset/market.svg"),
            ),
            title: Text(
              '  Market',
              style: _bottomStyle,
            ),
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(Icons.account_balance_wallet, color: Colors.black),
            ),
            title: Text(
              'Wallet',
              style: _bottomStyle,
            ),
          ),
        ],
      ),
    );
  }
}
