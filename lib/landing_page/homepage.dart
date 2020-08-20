import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  BoxDecoration _boxDec = BoxDecoration(
      color: Color(0xfff4f5f6), borderRadius: BorderRadius.circular(10));

  TextStyle _tStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.normal);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Image.asset("asset/timmy.png"),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: <Widget>[
                    Text(
                      'Welcome, ',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.normal),
                    ),
                    Text(
                      'Timmy',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                SizedBox(
                  height: 24,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 30.0),
                  child: Container(
                    height: 147,
                    width: 315,
                    child: CarouselSlider(
                      options: CarouselOptions(
                        height: 400.0,
                        initialPage: 0,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 3),
                        pauseAutoPlayOnTouch: true,
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        scrollDirection: Axis.horizontal,
                      ),
                      items: [1, 2, 3, 4].map((i) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 5.0),
                              decoration: BoxDecoration(color: Colors.grey),
                              child: Center(
                                child: Text(
                                  'image $i',
                                  style: TextStyle(fontSize: 16.0),
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        margin: EdgeInsets.all(8),
                        decoration: _boxDec,
                        height: 135,
                        width: 162,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset("asset/chostel.png"),
                            SizedBox(height: 16),
                            Text(
                              "Hostel",
                              style: _tStyle,
                            )
                          ],
                        )),
                    Container(
                        margin: EdgeInsets.all(8),
                        decoration: _boxDec,
                        height: 135,
                        width: 162,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset("asset/cfood.png"),
                            SizedBox(height: 16),
                            Text(
                              "Food",
                              style: _tStyle,
                            )
                          ],
                        ))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        margin: EdgeInsets.all(8),
                        decoration: _boxDec,
                        height: 135,
                        width: 162,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset("asset/cmarket.png"),
                            SizedBox(height: 16),
                            Text(
                              "Market",
                              style: _tStyle,
                            )
                          ],
                        )),
                    Container(
                        margin: EdgeInsets.all(8),
                        decoration: _boxDec,
                        height: 135,
                        width: 162,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset("asset/chire.png"),
                            SizedBox(height: 16),
                            Text(
                              "Other Services",
                              style: _tStyle,
                            )
                          ],
                        ))
                  ],
                ),
//              Text('Account\n SignOut'),
//              IconButton(
//                icon: Icon(Icons.phonelink_erase),
//                onPressed: () async {
//                  await AuthService().signOut();
//                },
//              ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
