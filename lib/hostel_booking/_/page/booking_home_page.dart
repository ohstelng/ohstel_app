import 'dart:convert';

import 'package:Ohstel_app/hive_methods/hive_class.dart';
import 'package:Ohstel_app/hostel_booking/_/methods/hostel_booking_methods.dart';
import 'package:Ohstel_app/hostel_booking/_/model/hostel_model.dart';
import 'package:Ohstel_app/hostel_booking/_/page/hostel_booking_info_page.dart';
import 'package:Ohstel_app/hostel_booking/_/page/hostel_booking_search_page.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

final formatCurrency = new NumberFormat.currency(locale: "en_US", symbol: "");

class HostelBookingHomePage extends StatefulWidget {
  @override
  _HostelBookingHomePageState createState() => _HostelBookingHomePageState();
}

class _HostelBookingHomePageState extends State<HostelBookingHomePage> {
  Box<Map> userDataBox;
  ScrollController scrollController = ScrollController();
  bool isStillLoadingData = true;
  var queryResultSet = [];
  var tempSearchStore = [];
  List<HostelModel> searchList;
  var query = '';
  int perPage = 6;
  bool gettingMoreHostels = false;
  bool moreHostelAvailable = true;
  HostelModel lastHostel;
  String uniName;

  // 5 option available are default(by date Added), price, distance,
  // roomMate needed, on campus Only(school hostel)
  String sortBy = 'default';

  void initSearch() {
    try {
      isStillLoadingData = true;

      HostelBookingMethods().fetchAllHostel(uniName: uniName).then(
        (List<HostelModel> list) {
          if (list != null) {
            setState(() {
              searchList = list;
              isStillLoadingData = false;
              lastHostel = searchList[searchList.length - 1];
            });
          }
        },
      );
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: e.message);
      setState(() {
        isStillLoadingData = false;
      });
    }
  }

  void search() {
    try {
      setState(() {
        isStillLoadingData = true;
      });

      HostelBookingMethods().fetchAllHostel(uniName: uniName).then(
        (List<HostelModel> list) {
          if (list != null && list.isNotEmpty) {
            setState(() {
              searchList = list;
              isStillLoadingData = false;
              lastHostel = searchList[searchList.length - 1];
            });
          } else {
            setState(() {
              searchList = [];
              isStillLoadingData = false;
            });
          }
        },
      );
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: e.message);
      setState(() {
        isStillLoadingData = false;
      });
    }
  }

  void getHostelSearchByOnCampusOnly() {
    try {
      isStillLoadingData = true;
      moreHostelAvailable = true;

      HostelBookingMethods().fetchAllSchoolHostel(uniName: uniName).then(
        (List<HostelModel> list) {
          if (list != null && list.isNotEmpty) {
            setState(() {
              searchList = list;
              isStillLoadingData = false;
              lastHostel = searchList[searchList.length - 1];
            });
          } else {
            setState(() {
              searchList = [];
              isStillLoadingData = false;
            });
          }
        },
      );
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: e.message);
      setState(() {
        isStillLoadingData = false;
      });
    }
  }

  void getHostelSearchByPrice() {
    try {
      isStillLoadingData = true;
      moreHostelAvailable = true;

      HostelBookingMethods().fetchAllHostelSortByPrice(uniName: uniName).then(
        (List<HostelModel> list) {
          if (list != null && list.isNotEmpty) {
            setState(() {
              searchList = list;
              isStillLoadingData = false;
              lastHostel = searchList[searchList.length - 1];
            });
          } else {
            setState(() {
              searchList = [];
              isStillLoadingData = false;
            });
          }
        },
      );
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: e.message);
      setState(() {
        isStillLoadingData = false;
      });
    }
  }

  void getHostelSearchByDistance() {
    try {
      isStillLoadingData = true;
      moreHostelAvailable = true;

      HostelBookingMethods()
          .fetchAllHostelSortByDistanceFromSchool(uniName: uniName)
          .then(
        (List<HostelModel> list) {
          if (list != null && list.isNotEmpty) {
            setState(() {
              searchList = list;
              isStillLoadingData = false;
              lastHostel = searchList[searchList.length - 1];
            });
          } else {
            setState(() {
              searchList = [];
              isStillLoadingData = false;
            });
          }
        },
      );
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: e.message);
      setState(() {
        isStillLoadingData = false;
      });
    }
  }

  void getHostelSearchByRoommateNeeded() {
    try {
      isStillLoadingData = true;
      moreHostelAvailable = true;

      HostelBookingMethods()
          .fetchAllHostelSortByRoommateNeeded(uniName: uniName)
          .then(
        (List<HostelModel> list) {
          if (list != null && list.isNotEmpty) {
            setState(() {
              searchList = list;
              isStillLoadingData = false;
              lastHostel = searchList[searchList.length - 1];
            });
          } else {
            setState(() {
              searchList = [];
              isStillLoadingData = false;
            });
          }
        },
      );
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: e.message);
      setState(() {
        isStillLoadingData = false;
      });
    }
  }

  void getMoreHostelSearchByDateAdded() {
    if (moreHostelAvailable == false) {
      return;
    }

    if (gettingMoreHostels == true) {
      return;
    }

    try {
      print('getting more product');
      gettingMoreHostels = true;

      Future.delayed(Duration(seconds: 5));

      HostelBookingMethods()
          .fetchAllHostelWithPagination(
        perPage: perPage,
        lastHostel: lastHostel,
        uniName: uniName,
      )
          .then(
        (List<HostelModel> list) {
          if (list != null) {
            setState(() {
              if (list.length < perPage) {
                moreHostelAvailable = false;
              }
              searchList.addAll(list);
              lastHostel = searchList[searchList.length - 1];

              gettingMoreHostels = false;
            });
          }
        },
      );
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: e.message);
    }
  }

  void getMoreHostelSearchByOnCampusOnly() {
    if (moreHostelAvailable == false) {
      return;
    }

    if (gettingMoreHostels == true) {
      return;
    }

    try {
      print('getting more product');
      gettingMoreHostels = true;

      Future.delayed(Duration(seconds: 5));

      HostelBookingMethods()
          .fetchAllSchoolHostelWithPagination(
        perPage: perPage,
        lastHostel: lastHostel,
        uniName: uniName,
      )
          .then(
        (List<HostelModel> list) {
          if (list != null) {
            setState(() {
              if (list.length < perPage) {
                moreHostelAvailable = false;
              }
              searchList.addAll(list);
              lastHostel = searchList[searchList.length - 1];

              gettingMoreHostels = false;
            });
          }
        },
      );
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: e.message);
    }
  }

  void getMoreHostelSearchByPrice() {
    if (moreHostelAvailable == false) {
      return;
    }

    if (gettingMoreHostels == true) {
      return;
    }

    try {
      print('getting more product');
      gettingMoreHostels = true;

      Future.delayed(Duration(seconds: 5));

      HostelBookingMethods()
          .fetchAllHostelSortByPriceWithPagination(
        perPage: perPage,
        lastHostel: lastHostel,
        uniName: uniName,
      )
          .then(
        (List<HostelModel> list) {
          if (list != null) {
            setState(() {
              if (list.length < perPage) {
                moreHostelAvailable = false;
              }
              searchList.addAll(list);
              lastHostel = searchList[searchList.length - 1];

              gettingMoreHostels = false;
            });
          }
        },
      );
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: e.message);
    }
  }

  void getMoreHostelSearchByDistance() {
    if (moreHostelAvailable == false) {
      return;
    }

    if (gettingMoreHostels == true) {
      return;
    }

    try {
      print('getting more product');
      gettingMoreHostels = true;

      Future.delayed(Duration(seconds: 5));

      HostelBookingMethods()
          .fetchAllHostelSortByDistanceFromSchoolWithPagination(
        perPage: perPage,
        lastHostel: lastHostel,
        uniName: uniName,
      )
          .then(
        (List<HostelModel> list) {
          if (list != null) {
            setState(() {
              if (list.length < perPage) {
                moreHostelAvailable = false;
              }
              searchList.addAll(list);
              lastHostel = searchList[searchList.length - 1];

              gettingMoreHostels = false;
            });
          }
        },
      );
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: e.message);
    }
  }

  void getMoreHostelSearchByRoomMateNeeded() {
    if (moreHostelAvailable == false) {
      return;
    }

    if (gettingMoreHostels == true) {
      return;
    }

    try {
      print('getting more product');
      gettingMoreHostels = true;

      Future.delayed(Duration(seconds: 5));

      HostelBookingMethods()
          .fetchAllHostelSortByRoommateNeededWithPagination(
        perPage: perPage,
        lastHostel: lastHostel,
        uniName: uniName,
      )
          .then(
        (List<HostelModel> list) {
          if (list != null) {
            setState(() {
              if (list.length < perPage) {
                moreHostelAvailable = false;
              }
              searchList.addAll(list);
              lastHostel = searchList[searchList.length - 1];

              gettingMoreHostels = false;
            });
          }
        },
      );
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: e.message);
    }
  }

  void moreSearchOptionController() {
    // 5 option available are default(by date Added), price, distance, roomMate needed, on campus Only(school hostel)
    if (sortBy == 'default') {
      getMoreHostelSearchByDateAdded();
    } else if (sortBy == 'price') {
      getMoreHostelSearchByPrice();
    } else if (sortBy == 'roommateNeeded') {
      getMoreHostelSearchByRoomMateNeeded();
    } else if (sortBy == 'isSchoolHostel') {
      getMoreHostelSearchByOnCampusOnly();
    }
  }

  Future<void> performSearchController() async {
    // 5 option available are default(by date Added), price, distance, roomMate needed, on campus Only(school hostel)

    await Future.delayed(Duration(seconds: 3));

    if (sortBy == 'default') {
      print('pass default');
      initSearch();
    } else if (sortBy == 'price') {
      print('pass price');
      getHostelSearchByPrice();
    } else if (sortBy == 'roommateNeeded') {
      print('pass room mate');
      getHostelSearchByRoommateNeeded();
    } else if (sortBy == 'isSchoolHostel') {
      print('pass is schhol');
      getHostelSearchByOnCampusOnly();
    }
  }

  void _scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      print("at the end of list");
      moreSearchOptionController();
    }
  }

  Future<void> getUniName() async {
    String name = await HiveMethods().getUniName();
    print(name);
    uniName = name;
  }

  Future getUniList() async {
    String url = "http://ohstel.pythonanywhere.com/hostelSearchKey";
    var response = await http.get(url);
    var result = json.decode(response.body);
    print(result);
    return result;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUniName();
      initSearch();
    });
    scrollController.addListener(() {
      _scrollListener();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle tabStyle = TextStyle(
        color: Colors.black, fontSize: 15, fontWeight: FontWeight.normal);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(144),
          child: AppBar(
            backgroundColor: Colors.white,
            flexibleSpace: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {},
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.notifications_none),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  searchInputControl(),
                  TabBar(
                    tabs: [
                      Tab(
                          child: Text(
                        "Explore",
                        style: tabStyle,
                      )),
                      Tab(
                          child: Text(
                        "Saved",
                        style: tabStyle,
                      )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.97,
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.77,
              child: isStillLoadingData
                  ? Center(
                child: CircularProgressIndicator(),
              )
                  : sortBy == 'distance' ? sortByDistance() : resultList(),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.97,
              height: MediaQuery.of(context).size.height * 0.77,
              child: isStillLoadingData
                  ? Center(
                child: CircularProgressIndicator(),
              )
                  : resultList(),
            )
          ],
        ),
      ),
    );
  }

  Widget sortByDistance() {
    print('distance');
    return PaginateFirestore(
      itemsPerPage: 2,
      initialLoader: Container(
        height: 50,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      bottomLoader: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(child: CircularProgressIndicator()),
      ),
      query: Firestore.instance
          .collection('hostelBookings')
          .where('uniName', isEqualTo: uniName)
          .orderBy('distanceFromSchoolInKm', descending: false)
          .where('isSchoolHostel', isEqualTo: false),
      itemBuilder: (context, DocumentSnapshot documentSnapshot) {
        HostelModel currentHostelModel =
            HostelModel.fromMap(documentSnapshot.data);

        return Card(
          elevation: 2.5,
          child: InkWell(
            onTap: () {
              print(currentHostelModel.id);
//              Navigator.of(context).push(MaterialPageRoute(
//                  builder: (context) =>
//                      HostelBookingInFoPage(hostelModel: currentHostelModel)));
            },
            child: Container(
              margin: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  displayMultiPic(imageList: currentHostelModel.imageUrl),
                  SizedBox(
                    width: 8,
                  ),
                  hostelDetails(hostel: currentHostelModel),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget resultList() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 1.0,
        mainAxisSpacing: 8,
        childAspectRatio: 0.87,
      ),
      physics: BouncingScrollPhysics(),
      controller: scrollController,
      shrinkWrap: false,
      primary: false,
      itemCount: searchList.length,
      itemBuilder: (context, index) {
        print(index);
        HostelModel currentHostelModel = searchList[index];

        return Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => HostelBookingInFoPage(
                            hostelModel: currentHostelModel,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          displayMultiPic(
                              imageList: currentHostelModel.imageUrl),
                          hostelDetails(hostel: currentHostelModel),
                          SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              (index == (searchList.length - 1)) && moreHostelAvailable == true
                  ? CircularProgressIndicator()
                  : Container(),
            ],
          ),
        );
      },
    );
  }

  Widget hostelDetails({@required HostelModel hostel}) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.40,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '${hostel.hostelName}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17.0,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: <Widget>[
              Icon(Icons.location_on, size: 16, color: Colors.grey),
              SizedBox(width: 8),
              Text(
                '${hostel.hostelLocation}',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14.0,
                  color: Colors.grey,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                '${hostel.distanceFromSchoolInKm}KM',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: Colors.grey,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          SizedBox(height: 5),
          Row(children: <Widget>[
            Text(
              '₦ ${formatCurrency.format(hostel.price)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
            )
          ])
        ],
      ),
    );
  }

  Widget displayMultiPic({@required List imageList}) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 120,
        maxWidth: MediaQuery.of(context).size.width * .46,
      ),
      child: Carousel(
        images: imageList.map(
          (images) {
            return Container(
              child: ExtendedImage.network(
                images,
                fit: BoxFit.fill,
                handleLoadingProgress: true,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10),
                cache: false,
                enableMemoryCache: true,
              ),
            );
          },
        ).toList(),
        autoplay: true,
        indicatorBgPadding: 0.0,
        dotPosition: DotPosition.bottomCenter,
        dotSpacing: 15.0,
        dotSize: 0,
        dotIncreaseSize: 2.5,
        dotIncreasedColor: Colors.deepOrange,
        dotBgColor: Colors.transparent,
        animationCurve: Curves.fastOutSlowIn,
        animationDuration: Duration(milliseconds: 2000),
      ),
    );
  }

  Widget searchInputControl() {
    return Container(
      padding: EdgeInsets.only(left: 8, right: 8,),
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
//                  SubLocationViewModel.loadSubLocationsFromApi(
//                      uniName: uniName);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => HostelBookingSearchPage(),
                    ),
                  );
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
                    Icon(Icons.mic, size: 19)
                  ],
                ),
              ),
            ),
          ),
//          Expanded(flex: 2, child: dropdownButton()),
        ],
      ),
    );
  }

  void changeUni() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Uni'),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.55,
            child: FutureBuilder(
              future: getUniList(),
              builder: (context, snapshot) {
                print(snapshot.data);
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                print(snapshot.data);
                Map data = snapshot.data;
                return Container(
                  width: double.maxFinite,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      List<String> uniList = data.keys.toList();
                      uniList.sort();
                      Map currentUniDetails = data[uniList[index]];

                      return Column(
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(left: 10.0, right: 10.0),
                              child: ListTile(
                                onTap: () {
                                  print(currentUniDetails['abbr']
                                      .toString()
                                      .toLowerCase());
                                  uniName = currentUniDetails['abbr']
                                      .toString()
                                      .toLowerCase();
//                                  print(uniName);
                                  Navigator.pop(context);
                                  search();
                                },
                                title: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.grey,
                                    ),
                                    Expanded(
                                      child: Text(
                                        '${currentUniDetails['name']}',
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Text(
                                  '${currentUniDetails['abbr']}',
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.grey,
                                  ),
                                ),
                              )),
                          Divider(),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  DropdownButton dropdownButton() {
    return DropdownButton<String>(
      onChanged: (value) {
        print('value: $value');
        if (value == 'changeUni') {
          print('Change uin');
          changeUni();
          setState(() {
            sortBy = sortBy;
          });
        } else {
          setState(() {
            sortBy = value;
          });
          print(sortBy);
          print(sortBy);
          performSearchController();
        }
      },
      hint: Icon(
        Icons.tune,
        color: Colors.white,
      ),
      isExpanded: true,
      items: [
        DropdownMenuItem<String>(
          value: "default",
          child: Column(
            children: <Widget>[
              Text(
                "All",
                textAlign: TextAlign.center,
              ),
              Divider(),
            ],
          ),
        ),
        DropdownMenuItem<String>(
          value: "price",
          child: Column(
            children: <Widget>[
              Text(
                "Price",
                textAlign: TextAlign.center,
              ),
              Divider(),
            ],
          ),
        ),
        DropdownMenuItem<String>(
          value: "distance",
          child: Column(
            children: <Widget>[
              Text(
                "Distance",
                textAlign: TextAlign.center,
              ),
              Divider(),
            ],
          ),
        ),
        DropdownMenuItem<String>(
          value: "roommateNeeded",
          child: Column(
            children: <Widget>[
              Text(
                "Roommate",
                textAlign: TextAlign.center,
              ),
              Divider(),
            ],
          ),
        ),
        DropdownMenuItem<String>(
          value: "isSchoolHostel",
          child: Column(
            children: <Widget>[
              Text("On-Campus", textAlign: TextAlign.center, maxLines: 1),
              Divider(),
            ],
          ),
        ),
        DropdownMenuItem<String>(
          value: "changeUni",
          child: Column(
            children: <Widget>[
              Text("Edit Uni", textAlign: TextAlign.center, maxLines: 1),
              Divider(),
            ],
          ),
        ),
      ],
    );
  }
}

//TODO: implement save hostel
//TODO: implement save hostel
//TODO: implement save hostel
//TODO: implement save hostel
