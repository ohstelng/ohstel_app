import 'dart:async';

import 'package:Ohstel_app/hive_methods/hive_class.dart';
import 'package:Ohstel_app/hostel_food/_/methods/fast_food_methods.dart';
import 'package:Ohstel_app/hostel_food/_/models/extras_food_details.dart';
import 'package:Ohstel_app/hostel_food/_/models/fast_food_details_model.dart';
import 'package:Ohstel_app/hostel_food/_/models/food_details_model.dart';
import 'package:Ohstel_app/hostel_food/_/pages/selected_fast_food_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class FoodHomePage extends StatefulWidget {
  @override
  _FoodHomePageState createState() => _FoodHomePageState();
}

//class _FoodHomePageState extends State<FoodHomePage> with AutomaticKeepAliveClientMixin {
class _FoodHomePageState extends State<FoodHomePage> {
  List _imgList = [
    "asset/ban4.jpg",
    "asset/ban7.jpg",
  ];
  String uniName;
  String state;
//  bool loading = true;

  Future<String> getStateLocation() async {
//    String name = await HiveMethods().getUniName();
    String _state = await HiveMethods().getUserState();
    state = _state;
    print('state: $state');
//    uniName = name;

//    if (!mounted) return;
//    setState(() {
//      loading = false;
//    });
//    setState(() {});
    return _state;
  }

  List<ItemDetails> getItemDetails(List data) {
    List<ItemDetails> _itemDetails = List<ItemDetails>();

    for (var d = 0; d < data.length; d++) {
      _itemDetails.add(ItemDetails.formMap(data[d]));
    }

    return _itemDetails;
  }

  List<ExtraItemDetails> getExtraItemDetails(List data) {
    List<ExtraItemDetails> _itemDetails = List<ExtraItemDetails>();

    for (var d = 0; d < data.length; d++) {
      _itemDetails.add(ExtraItemDetails.fromMap(data[d]));
    }

    return _itemDetails;
  }

  @override
  void initState() {
    getStateLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              imageList(),
              paginatedFoodList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget imageList() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
      height: 150,
      width: 395,
      child: CarouselSlider(
        options: CarouselOptions(
          initialPage: 0,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 3),
          pauseAutoPlayOnTouch: true,
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: true,
          scrollDirection: Axis.horizontal,
        ),
        items: _imgList.map((i) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: Theme.of(context).primaryColor)),
                child: Image.asset(
                  "$i",
                  fit: BoxFit.fill,
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }

  Widget paginatedFoodList() {
    return FutureBuilder(
      future: getStateLocation(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return CircularProgressIndicator();
        }
        String _state = snapshot.data;
        print('SSState: $_state');
        if (_state == 'null') {
          return Container(
            height: 400,
            margin: EdgeInsets.symmetric(horizontal: 10.0),
            child: Center(
              child: Text(
                'It Seems An Error Occured!! \n Please Re - Select Your '
                'Location And Restarting The App. \n\n\n You Can Edit Your Setting '
                'By Tapping In The Circular Image On The Home Page.',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey[900].withOpacity(0.5),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        } else {
          return PaginateFirestore(
            shrinkWrap: true,
            initialLoader: Center(child: CircularProgressIndicator()),
            emptyDisplay: Container(
              height: 400,
              child: Center(
                child: Text(
                  'No Fast Food Found!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                    color: Colors.grey[900].withOpacity(0.5),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            bottomLoader: Center(child: CircularProgressIndicator()),
            query: FastFoodMethods()
                .foodCollectionRef
                .where('display', isEqualTo: true)
                .where('stateLocation', isEqualTo: _state.toString())
                .orderBy('fastFood'),
            itemBuilder:
                (int index, BuildContext context, DocumentSnapshot snapshot) {
              FastFoodModel currentFastFood =
                  FastFoodModel.fromMap(snapshot.data());
              print('Stata:: $_state');

              List<ItemDetails> currentItemDetails =
                  getItemDetails(snapshot.data()['itemDetails']);

              List<ExtraItemDetails> currentExtraItemDetails =
                  getExtraItemDetails(snapshot.data()['extraItems']);

              print(currentFastFood.stateLocation);

              return InkWell(
                onTap: () {
                  print("currentFastFood.toMap():${currentFastFood.toMap()}");
                  print(
                      "currentItemDetails[0].toMap():${currentItemDetails[0].toMap()}");

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SelectedFastFoodPage(
                        currentFastFood: currentFastFood,
                        currentExtraItemDetails: currentExtraItemDetails,
                        currentItemDetails: currentItemDetails,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 5,
                  ),
                  child: Card(
                    color: Color(0xFFF4F5F6),
                    elevation: 1,
                    child: Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(8.0),
                          height: 150,
                          width: 150,
                          child: ExtendedImage.network(
                            currentFastFood.logoImageUrl,
                            fit: BoxFit.fill,
                            handleLoadingProgress: true,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10),
                            cache: true,
                            enableMemoryCache: true,
                          ),
                        ),
                        Container(
                          height: 120,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '${currentFastFood.fastFoodName.trim()}',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '0801 345 6767',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '${currentFastFood.openTime.trim()}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: Colors.black45,
                                    size: 14,
                                  ),
                                  Text(
                                    '${currentFastFood.address.trim()}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            itemBuilderType: PaginateBuilderType.listView,
          );
        }
      },
    );
  }

  Widget searchBar() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 30, 10, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 8,
            child: Container(
              height: 40,
              margin: EdgeInsets.only(right: 5),
              decoration: BoxDecoration(),
              child: MaterialButton(
                onPressed: () {
//
                },
                color: Colors.grey[50],
                shape: RoundedRectangleBorder(),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.search, color: Colors.black, size: 19),
                    SizedBox(width: 24),
                    Text(
                      'Search',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                        fontSize: 17.0,
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
          ),
          //  Expanded(flex: 2, child: dropdownButton()),
        ],
      ),
    );
  }

//  @override
//  bool get wantKeepAlive => true;
}
