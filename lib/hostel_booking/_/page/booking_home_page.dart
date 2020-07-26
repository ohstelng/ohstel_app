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
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:intl/intl.dart';

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
  int perPage = 3;
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

  void getHostelSearchByOnCampusOnly() {
    try {
      isStillLoadingData = true;
      moreHostelAvailable = true;

      HostelBookingMethods().fetchAllSchoolHostel(uniName: uniName).then(
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

  void getHostelSearchByPrice() {
    try {
      isStillLoadingData = true;
      moreHostelAvailable = true;

      HostelBookingMethods().fetchAllHostelSortByPrice(uniName: uniName).then(
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

  void getHostelSearchByDistance() {
    try {
      isStillLoadingData = true;
      moreHostelAvailable = true;

      HostelBookingMethods()
          .fetchAllHostelSortByDistanceFromSchool(uniName: uniName)
          .then(
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

  void getHostelSearchByRoommateNeeded() {
    try {
      isStillLoadingData = true;
      moreHostelAvailable = true;

      HostelBookingMethods()
          .fetchAllHostelSortByRoommateNeeded(uniName: uniName)
          .then(
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

  void performSearchController() {
    // 5 option available are default(by date Added), price, distance, roomMate needed, on campus Only(school hostel)

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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          searchInputControl(),
          Expanded(
            child: isStillLoadingData
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    child:
                        sortBy == 'distance' ? sortByDistance() : resultList(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget sortByDistance() {
    print('distance');
    return PaginateFirestore(
      itemsPerPage: 3,
      initialLoader: Container(
        height: 50,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      bottomLoader: CircularProgressIndicator(),
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
            },
            child: Container(
              margin: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  displayMultiPic(imageList: currentHostelModel.imageUrl),
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
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        controller: scrollController,
        itemCount: searchList.length,
        itemBuilder: (context, index) {
          print(index);
          HostelModel currentHostelModel = searchList[index];

          return Card(
            elevation: 2.5,
            child: InkWell(
              onTap: () {
                print(currentHostelModel.id);
                print(uniName);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        HostelBookingInFoPage(hostelModel: currentHostelModel),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    displayMultiPic(imageList: currentHostelModel.imageUrl),
                    hostelDetails(hostel: currentHostelModel),
                    index == (searchList.length - 1)
                        ? Container(
                            height: 100,
                            child: Center(
                              child: moreHostelAvailable == false
                                  ? Text('No More Hostel Available!!')
                                  : CircularProgressIndicator(),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget hostelDetails({@required HostelModel hostel}) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${hostel.hostelName}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${hostel.hostelLocation}',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 15.0,
                    color: Colors.grey,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Text(
                  '₦${formatCurrency.format(hostel.price)}K',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${hostel.distanceFromSchoolInKm}KM',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10.0,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget displayMultiPic({@required List imageList}) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 250,
        maxWidth: MediaQuery.of(context).size.width * .95,
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
        dotSize: 4,
        dotIncreaseSize: 2.5,
        dotIncreasedColor: Colors.teal,
        dotBgColor: Colors.transparent,
        animationCurve: Curves.fastOutSlowIn,
        animationDuration: Duration(milliseconds: 2000),
      ),
    );
  }

  Widget searchInputControl() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Container(
              height: 50,
              margin: EdgeInsets.only(right: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),

              ),
              child: MaterialButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => HostelBookingSearchPage(),
                    ),
                  );
                },
                color: Colors.grey[200],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: <Widget>[
                    Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Search Hostel',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 20.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(flex: 2, child: dropdownButton()),
        ],
      ),
    );
  }

  DropdownButton dropdownButton() {
    return DropdownButton<String>(
      onChanged: (value) {
        print('value: ${value.runtimeType}');
        print('value: $value');
        setState(() {
          sortBy = value;
        });
        performSearchController();
      },
      hint: Text('Filter'),
//      hint: Icon(Icons.sort),
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
                "By Price",
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
                "By distance(KM)",
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
                "By Roommate Needed",
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
              Text(
                "By onCampus Only",
                textAlign: TextAlign.center,
              ),
              Divider(),
            ],
          ),
        ),
      ],
    );
  }
}
