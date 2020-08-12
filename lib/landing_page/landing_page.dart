import 'package:Ohstel_app/auth/methods/auth_methods.dart';
import 'package:Ohstel_app/hostel_booking/_/page/booking_home_page.dart';
import 'package:Ohstel_app/hostel_food/_/pages/food_home_page.dart';
import 'package:Ohstel_app/hostel_market_place/pages/market_home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
<<<<<<< HEAD
      appBar: AppBar(
        title: Text('home Page'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.phonelink_erase),
            onPressed: () async {
              await AuthService().signOut();
            },
          ),
        ],
      ),
=======
>>>>>>> 8cbbef7a8fabad5527916a7eb245f7d0eb5670ca
      body: PageView(
        children: <Widget>[
          HostelBookingHomePage(),
          FoodHomePage(),
          MarketHomePage(),
          Container(child: Center(child: Text('Hire'))),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Account\n SignOut'),
              IconButton(
                icon: Icon(Icons.phonelink_erase),
                onPressed: () async {
                  await AuthService().signOut();
                },
              ),
            ],
          )
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
            icon: Icon(Icons.home),
            title: Text(
              'Booking',
              style: TextStyle(fontSize: 14),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood),
            title: Text(
              'Food',
              style: TextStyle(fontSize: 14),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_shopping_cart),
            title: Text(
              'Mall',
              style: TextStyle(fontSize: 14),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text(
              'Hire',
              style: TextStyle(fontSize: 14),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            title: Text(
              'Wallet',
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

