import 'package:Ohstel_app/constant/sub_location_info.dart';
import 'package:Ohstel_app/hive_methods/hive_class.dart';
import 'package:Ohstel_app/hostel_booking/_/methods/hostel_booking_methods.dart';
import 'package:Ohstel_app/hostel_booking/_/model/hostel_model.dart';
import 'package:Ohstel_app/hostel_booking/_/page/hostel_booking_info_page.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'booking_home_page.dart';

class HostelBookingSearchPage extends StatefulWidget {
  @override
  _HostelBookingSearchPageState createState() =>
      _HostelBookingSearchPageState();
}

class _HostelBookingSearchPageState extends State<HostelBookingSearchPage> {
  GlobalKey<AutoCompleteTextFieldState<SubLocation>> key = new GlobalKey();
  AutoCompleteTextField searchTextField;
  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();
  List<HostelModel> searchList = [];
  String query = '';
  bool isStillLoadingData = false;
  bool moreHostelAvailable = true;
  bool gettingMoreHostels = false;
  bool searchStarted = false;
  HostelModel lastHostel;
  String uniName;

  Future<void> _loadData() async {
    await SubLocationViewModel.loadSubLocationsFromDb();
  }

  Future<void> getUniName() async {
    String name = await HiveMethods().getUniName();
    print(name);
    uniName = name;
  }

  void startSearch({@required String value}) {
    setState(() {
      searchStarted = true;
      isStillLoadingData = true;
    });
    try {
      HostelBookingMethods()
          .fetchHostelByKeyWord(
        keyWord: value,
        uniName: uniName,
      )
          .then((List<HostelModel> list) {
        setState(() {
          if (list.isNotEmpty) {
            if (list.length < 3) {
              moreHostelAvailable = false;
            }
            searchList = list;
            lastHostel = searchList[searchList.length - 1];
            isStillLoadingData = false;
//            searchStarted = false;
          } else {
            searchList = list;
            isStillLoadingData = false;
          }
        });
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.message, toastLength: Toast.LENGTH_LONG);
      setState(() {
          isStillLoadingData = false;
        });
    }
  }

  void moreSearchOption() {
    print('getting more');
    if (moreHostelAvailable == false) {
      return;
    }

    if (gettingMoreHostels == true) {
      return;
    }

    try {
      gettingMoreHostels = true;
      print('getting more Hostel now');
      HostelBookingMethods()
          .fetchHostelByKeyWordWithPagination(
        keyWord: query,
        lastHostel: lastHostel,
        uniName: uniName,
      )
          .then((List<HostelModel> list) {
        print(list);
        print(list.length);
        setState(() {
          if (list.length < 3) {
            moreHostelAvailable = false;
          }

          searchList.addAll(list);
          lastHostel = searchList[searchList.length - 1];

          gettingMoreHostels = false;
        });
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.message, toastLength: Toast.LENGTH_LONG);
    }
  }

  void _scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      print("at the end of list");
      moreSearchOption();
    }
  }

  @override
  void initState() {
    getUniName();
    _loadData();
    scrollController.addListener(() {
      _scrollListener();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            autoSuggest(),
            searchStarted
                ? Expanded(
                    child: isStillLoadingData == true
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: resultList(),
                          ),
                  )
                : greetingWidget(),
          ],
        ),
      ),
    );
  }

  Widget notFound() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.local_hotel,
                  color: Colors.grey,
                  size: 85.0,
                ),
                Text(
                  'Sorry No Hostel Was Found With This Location :(',
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 18.0,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget autoSuggest() {
    return Container(
      height: 50,
      margin: EdgeInsets.all(10.0),
      child: Center(
        child: searchTextField = AutoCompleteTextField<SubLocation>(
            textChanged: (String text) {
              print(text);
              query = text.trim();
            },
            style: new TextStyle(color: Colors.black, fontSize: 16.0),
            decoration: new InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(),
              ),
              suffixIcon: Container(
                margin: EdgeInsets.all(8.0),
                width: 50.0,
                child: InkWell(
                  onTap: () {
                    if (query.trim() == '') {
                      Fluttertoast.showToast(
                        msg: 'Enter Hostel Location!',
                        gravity: ToastGravity.CENTER,
                      );
                    } else {
                      startSearch(value: query);
                      FocusManager.instance.primaryFocus.unfocus();
                    }
                  },
                  child: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                ),
              ),
              contentPadding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 20.0),
              filled: true,
              hintText: 'Search For Hostel By Location',
              hintStyle: TextStyle(color: Colors.black),
            ),
            itemSubmitted: (item) {
              setState(() => searchTextField.textField.controller.text =
                  item.autoCompleteTerm);
              startSearch(value: item.autoCompleteTerm);
            },
            clearOnSubmit: false,
            key: key,
            suggestions: SubLocationViewModel.subLocations,
            itemBuilder: (context, item) {
              print('pppppppppppppppppppppppppppppppp');
              print(item);
              return Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.location_on,
                      color: Colors.grey,
                    ),
                    Text(
                      item.autoCompleteTerm.trim(),
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Text(', '),
                    Text(
                      item.uni.trim(),
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(15.0),
                    ),
                  ],
                ),
              );
            },
            itemSorter: (a, b) {
              return a.autoCompleteTerm.compareTo(b.autoCompleteTerm);
            },
            itemFilter: (item, query) {
              return item.autoCompleteTerm
                  .toLowerCase()
                  .startsWith(query.toLowerCase());
            }),
      ),
    );
  }

  Widget resultList() {
    if (searchList.isEmpty || searchList == null) {
      return notFound();
    } else {
      return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: searchList.length,
        controller: scrollController,
        itemBuilder: ((context, index) {
          HostelModel currentHostelModel = searchList[index];
          return Container(
            child: Card(
              elevation: 1,
              child: InkWell(
                onTap: () {
                  print(currentHostelModel.id);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          HostelBookingInFoPage(hostelModel: currentHostelModel),
                    ),
                  );
                },
                child: Column(
                  children: [
                    Container(
                      height: 120,
                      margin: EdgeInsets.all(10),
                      child: Row(
                        children: <Widget>[
                          Expanded(flex: 3,child: displayMultiPic(imageList: currentHostelModel.imageUrl)),
                          Expanded(flex: 4, child: hostelDetails(hostel: currentHostelModel)),

                        ],
                      ),
                    ),
                    index == (searchList.length - 1)
                        ? Container(
                      height: 80,
                      child: Center(
                        child: moreHostelAvailable == false
                            ? Text('No More Hostel Available!!')
                            : CircularProgressIndicator(),
                      ),
                    )
                        : Container()
                  ],
                ),
              ),
            ),
          );
        }),
      );
    }
  }

  Widget hostelDetails({@required HostelModel hostel}) {
    return Container(
      width: MediaQuery.of(context).size.width*0.7 ,
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${hostel.hostelName}',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8,),
                  Text(
                    '₦${formatCurrency.format(hostel.price)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8,),
                  Row(
                    children: [
                      Text(
                        '${hostel.hostelLocation}',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 15.0,
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.orange[200]
                        ),
                        child: Text(
                          '${hostel.distanceFromSchoolInKm} km',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget displayMultiPic({@required List imageList}) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 250,
        maxWidth: MediaQuery.of(context).size.width * .60,
      ),
      child: Carousel(
        images: imageList.map(
          (images) {
            return Container(
              child: ExtendedImage.network(
                images,
                fit: BoxFit.fitHeight,
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
        dotIncreasedColor: Theme.of(context).primaryColor,
        dotBgColor: Colors.transparent,
        animationCurve: Curves.fastOutSlowIn,
        animationDuration: Duration(milliseconds: 2000),
      ),
    );
  }

  Widget greetingWidget() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.hotel,
              color: Colors.grey,
              size: 85.0,
            ),
            Text(
              'Search For Hostel By Name',
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 18.0,
              ),
            )
          ],
        ),
      ),
    );
  }
}
