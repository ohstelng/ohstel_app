import 'package:Ohstel_app/auth/methods/auth_methods.dart';
import 'package:Ohstel_app/hive_methods/hive_class.dart';
import 'package:Ohstel_app/hostel_booking/_/page/booking_home_page.dart';
import 'package:Ohstel_app/hostel_food/_/pages/food_home_page.dart';
import 'package:Ohstel_app/hostel_hire/pages/hire_home_page.dart';
import 'package:Ohstel_app/hostel_market_place/pages/market_home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Ohstel_app/landing_page/homepage.dart';

class MainHomePage extends StatefulWidget {
  @override
  _MainHomePageState createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  PageController pageController;
  int getPageIndex = 0;

  void pageChanged(int pageIndex) {
    setState(() {
      getPageIndex = pageIndex;
    });
  }

  void onTapChangePage(int pageIndex) {
    pageController.animateToPage(pageIndex,
        duration: Duration(milliseconds: 200), curve: Curves.bounceInOut);
  }

  @override
  void initState() {
    pageController = PageController();
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
          Homepage(),
          MarketHomePage(),
          HireHomePage(),
        ],
        controller: pageController,
        onPageChanged: pageChanged,
        physics: BouncingScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: getPageIndex,
        onTap: onTapChangePage,
        activeColor: Colors.deepOrange,
        inactiveColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset("asset/hostel.png"),
            title: Text(
              'Hostel',
              style: TextStyle(fontSize: 12),
            ),
          ),
          BottomNavigationBarItem(
            icon: Image.asset("asset/food.png"),
            title: Text(
              'Food',
              style: TextStyle(fontSize: 12),
            ),
          ),
          BottomNavigationBarItem(
            icon: Image.asset("asset/OHstel.png"),

          ),
          BottomNavigationBarItem(
            icon: Image.asset("asset/market.png"),
            title: Text(
              'Market',
              style: TextStyle(fontSize: 12),
            ),
          ),
          BottomNavigationBarItem(
            icon: Image.asset("asset/hire.png"),
            title: Text(
              'Other Services',
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}


