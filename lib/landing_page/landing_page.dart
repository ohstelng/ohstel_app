import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../hive_methods/hive_class.dart';
import '../hostel_booking/_/page/booking_home_page.dart';
import '../hostel_food/_/pages/food_home_page.dart';
import '../hostel_market_place/pages/market_home_page.dart';
import '../wallet/pages/wallet_home.dart';
import 'custom_navigation_bar.dart';
import 'homepage.dart';

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

  TextStyle _bottomStyle = TextStyle(fontSize: 9, color: Colors.blueGrey);

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
        ],
        controller: pageController,
        onPageChanged: pageChanged,
        physics: BouncingScrollPhysics(),
      ),
      bottomNavigationBar: CustomNavBar(
        onChanged: onTapChangePage,
        currentPage: getPageIndex,
      ),
    );
  }
}
