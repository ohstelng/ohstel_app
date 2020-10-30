import 'dart:async';

import 'package:Ohstel_app/auth/models/userModel.dart';
import 'package:Ohstel_app/explore/pages/dashboard.dart';
import 'package:Ohstel_app/hive_methods/hive_class.dart';
import 'package:Ohstel_app/hostel_hire/pages/hire_home_page.dart';
import 'package:Ohstel_app/landing_page/profile_page.dart';
import 'package:Ohstel_app/utilities/app_style.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Homepage extends StatefulWidget {
  final void Function(int) callback;

  Homepage({@required this.callback});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  BoxDecoration _boxDec = BoxDecoration(
    color: Color(0xfff4f5f6),
    borderRadius: BorderRadius.circular(10),
  );

  TextStyle _tStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.normal);
  bool isLoading = true;
  Map userData;


  Future<void> getUserData() async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });

    userData = await HiveMethods().getUserData();

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 24,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfilePage(),
                              ),
                            );
                          },
                          child: Container(
                            height: 100,
                            width: 100,
                            child: userData['profilePicUrl'] == null
                                ? Icon(Icons.person, color: Color(0xffebf1ef))
                                : ExtendedImage.network(
                                    userData['profilePicUrl'],
                                    fit: BoxFit.fill,
                                    handleLoadingProgress: true,
                                    shape: BoxShape.circle,
                                    cache: false,
                                    enableMemoryCache: true,
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Welcome, ',
                              style: TextStyle(
                                fontSize: 24,
                              ),
                            ),
                            iD(),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 30.0),
                          child: Container(
                            height: 147,
                            width: MediaQuery.of(context).size.width * 0.78,
                            child: CarouselSlider(
                              options: CarouselOptions(
                                height: 400.0,
                                initialPage: 0,
                                autoPlay: true,
                                autoPlayInterval: Duration(seconds: 3),
                                pauseAutoPlayOnTouch: true,
                                autoPlayAnimationDuration:
                                    Duration(milliseconds: 800),
                                autoPlayCurve: Curves.fastOutSlowIn,
                                enlargeCenterPage: true,
                                scrollDirection: Axis.horizontal,
                              ),
                              items: ["asset/ban1.jpg","asset/ban2.jpg","asset/ban3.jpg","asset/ban4.jpg"].map((i) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 5.0),
                                      decoration:
                                          BoxDecoration(color: Colors.transparent),
                                      child: Image.asset("$i",fit: BoxFit.fill,

                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                widget.callback(0);
                              },
                              child: Container(
                                  margin: EdgeInsets.all(8),
                                  decoration: _boxDec,
                                  height: 135,
                                  width: 162,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SvgPicture.asset("asset/chostel.svg"),
                                      SizedBox(height: 16),
                                      Text(
                                        "Hostel",
                                        style: _tStyle,
                                      )
                                    ],
                                  )),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                widget.callback(1);
                              },
                              child: Container(
                                  margin: EdgeInsets.all(8),
                                  decoration: _boxDec,
                                  height: 135,
                                  width: 162,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SvgPicture.asset("asset/cfood.svg"),
                                      SizedBox(height: 16),
                                      Text(
                                        "Food",
                                        style: _tStyle,
                                      )
                                    ],
                                  )),
                            ),
                          )
                        ],
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ExploreDashboard())),
                        child: Container(
                          margin: EdgeInsets.all(8.0),
                          padding: EdgeInsets.all(15.0),
                          decoration: _boxDec,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'asset/explore.svg',
                                height: 80.0,
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Explore',
                                      style: heading2,
                                    ),
                                    Text(
                                      'Visit places around your institution.',
                                      textAlign: TextAlign.center,
                                      style: body1,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                widget.callback(3);
                              },
                              child: Container(
                                  margin: EdgeInsets.all(8),
                                  decoration: _boxDec,
                                  height: 135,
                                  width: 162,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SvgPicture.asset("asset/cmarket.svg"),
                                      SizedBox(height: 16),
                                      Text(
                                        "Market",
                                        style: _tStyle,
                                      )
                                    ],
                                  )),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => HireHomePage(),
                                  ),
                                );
//                                widget.callback(3);
                              },
                              child: Container(
                                margin: EdgeInsets.all(8),
                                decoration: _boxDec,
                                height: 135,
                                width: 162,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SvgPicture.asset("asset/chire.svg"),
                                    SizedBox(height: 16),
                                    Text(
                                      "Hire",
                                      style: _tStyle,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget iD() {
    if (userData != null) {
      UserModel userModel = UserModel.fromMap(userData.cast<String, dynamic>());
      return Text(
        '${userModel.userName}',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
      );
    } else {
      return Text(
        'Name',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
      );
    }
  }
}
