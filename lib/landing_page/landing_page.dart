import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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


  @override
  void initState() {
    pageController = PageController(initialPage: getPageIndex, keepPage: true);
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
        homeButtonObject: Image.asset(
          "asset/OHstel.png",
          height: 60,
          width: 60,
          fit: BoxFit.contain,
        ),
        navBarObjects: [
          NavBarObject(
            icon: SvgPicture.asset("asset/hostel.svg"),
            label: 'Hostel',
          ),
             NavBarObject(
            icon: SvgPicture.asset("asset/food.svg"),
            label: 'Food',
          ),
             NavBarObject(
            icon: SvgPicture.asset("asset/market.svg"),
            label: 'Market',
          ),
             NavBarObject(
            icon: SvgPicture.asset("asset/wallet.svg"),
            label: 'Wallet',
          ),
        ],
      ),
    );
  }
}
