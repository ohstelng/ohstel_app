import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth/wrapper.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      color: Colors.blue,
      home: new Splash(),
    );
  }
}

class Splash extends StatefulWidget {
  @override
  SplashState createState() => new SplashState();
}

class SplashState extends State<Splash> with AfterLayoutMixin<Splash> {
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new Wrapper()));
    } else {
      await prefs.setBool('seen', true);
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new IntroScreen()));
    }
  }

  @override
  void afterFirstLayout(BuildContext context) => checkFirstSeen();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class IntroScreen extends StatelessWidget {
  final PageController _controller = PageController(
    initialPage: 0,
  );

  // @override
  // void dispose() {
  //   _controller.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: PageView(
          controller: _controller,
          children: [
            Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                  Container(
                      height: MediaQuery.of(context).size.height * 0.30,
                      width: MediaQuery.of(context).size.width,
                      child: SvgPicture.asset("asset/shop.svg")),
                  SizedBox(
                    height: 60,
                  ),
                  Text(
                    "Book",
                    style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),
                  ),
                 Container(
                   height: 120,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                    child: Text(
                        "We help you bypass all the stress "
                            "involved in Hostel booking and processes.",style: TextStyle(fontSize: 16),textAlign: TextAlign.center,),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 6,
                        width: 40,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Container(
                        height: 6,
                        width: 16,
                        decoration: BoxDecoration(
                            color: Color(0xffF9BA83),
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Container(
                        height: 6,
                        width: 16,
                        decoration: BoxDecoration(
                            color: Color(0xffF9BA83),
                            borderRadius: BorderRadius.circular(20)),
                      )
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  InkWell(
                    onTap: () {
                      if (_controller.hasClients) {
                        _controller.animateToPage(
                          1,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: Container(
                      child: Center(
                          child: Text(
                        "Next",
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17, color: Colors.white),
                      )),
                      height: 37,
                      width: 132,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).primaryColor),
                    ),
                  )
                ],
              ),
            ),
            Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                  Container(
                      height: MediaQuery.of(context).size.height * 0.30,
                      width: MediaQuery.of(context).size.width,
                      child: SvgPicture.asset("asset/deliver.svg")),
                  SizedBox(
                    height: 60,
                  ),
                  Text(
                    "Shop",
                    style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),
                  ),
                Container(
                  height: 120,
                  padding:
                        const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                    child: Text(
                        "Are you new to hostel? And not quite sure about all you'll need and where to get them? \n\n Worry less, shopping just got easier",textAlign: TextAlign.center,style: TextStyle(fontSize: 16),),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 6,
                        width: 16,
                        decoration: BoxDecoration(
                            color: Color(0xffF9BA83),
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Container(
                        height: 6,
                        width: 40,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Container(
                        height: 6,
                        width: 16,
                        decoration: BoxDecoration(
                            color: Color(0xffF9BA83),
                            borderRadius: BorderRadius.circular(20)),
                      )
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  InkWell(
                    onTap: () {
                      if (_controller.hasClients) {
                        _controller.animateToPage(
                          2,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: Container(
                      child: Center(
                          child: Text(
                        "Skip",
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17, color: Colors.white),
                      )),
                      height: 37,
                      width: 132,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).primaryColor),
                    ),
                  )
                ],
              ),
            ),
            Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                  Container(
                      height: MediaQuery.of(context).size.height * 0.30,
                      width: MediaQuery.of(context).size.width,
                      child: SvgPicture.asset("asset/address.svg")),
                  SizedBox(
                    height: 60,
                  ),
                  Text(
                    "Hire",
                    style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),
                  ),

                  Container(
                    height: 120,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                    child: Text(
                        "OHstel connects you with all your needs, with few steps. \nGet a painter, laundry service, gas filling agent, carpenter etc.",style: TextStyle(fontSize: 16),textAlign: TextAlign.center),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 6,
                        width: 16,
                        decoration: BoxDecoration(
                            color: Color(0xffF9BA83),
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Container(
                        height: 6,
                        width: 16,
                        decoration: BoxDecoration(
                            color: Color(0xffF9BA83),
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Container(
                        height: 6,
                        width: 40,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Wrapper()));
                    },
                    child: Container(
                      child: Center(
                          child: Text(
                        "Get Started",
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17, color: Colors.white),
                      )),
                      height: 37,
                      width: 132,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).primaryColor),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
