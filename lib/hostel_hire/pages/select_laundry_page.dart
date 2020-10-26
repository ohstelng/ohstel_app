import 'package:Ohstel_app/hive_methods/hive_class.dart';
import 'package:Ohstel_app/hostel_hire/pages/laundry_basket_page.dart';
import 'package:Ohstel_app/hostel_hire/pages/laundry_option_pop_up.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../model/hire_agent_model.dart';
import '../model/laundry_booking_model.dart';

class SelectLaundryPage extends StatefulWidget {
  final List laundryList;
  final HireWorkerModel laundryWork;

  SelectLaundryPage({
    @required this.laundryList,
    @required this.laundryWork,
  });

  @override
  _SelectLaundryPageState createState() => _SelectLaundryPageState();
}

class _SelectLaundryPageState extends State<SelectLaundryPage> {
  Box<Map> laundryBox;
  bool loadingBasket = true;

  Future<void> getBox() async {
    laundryBox = await HiveMethods().getOpenBox('laundryBox');
    if(!mounted) return;
    setState(() {
      loadingBasket = false;
    });
  }

  void selectOption({@required LaundryBookingModel laundry}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            child: LaundryOptionPopUp(
              laundryDetails: laundry,
              hireWorkerDetails: widget.laundryWork,
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    getBox();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          header(),
          body(),
        ],
      ),
    );
  }

  Widget body() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.laundryList.length,
      itemBuilder: (context, index) {
        LaundryBookingModel currentLaundry =
            LaundryBookingModel.fromMap(widget.laundryList[index]);

        return Container(
          //          margin: EdgeInsets.all(5.0),
          child: Card(
            child: Container(
              margin: EdgeInsets.all(5.0),
              child: Row(
                children: [
                  Center(
                    child: Container(
                      height: 70,
                      width: 60,
                      margin: EdgeInsets.only(right: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: currentLaundry.imageUrl != null
                          ? ExtendedImage.network(
                              currentLaundry.imageUrl,
                              fit: BoxFit.fill,
                              handleLoadingProgress: true,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(10),
                              cache: false,
                              enableMemoryCache: true,
                            )
                          : Center(
                              child: Icon(Icons.person),
                            ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${currentLaundry.clothTypes}'),
                      SizedBox(height: 20),
                      Text(
                          '${currentLaundry.laundryModeAndPrice['Wash Only']}'),
                    ],
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      //                      setPrice();
                      selectOption(
                        laundry: currentLaundry,
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.add_shopping_cart),
                      //                      child: Text('Add To Basket'),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Color(0xffF9BA83),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        basketWidget(),
      ],
    );
  }

  Widget basketWidget() {
//    if (widget.hireWorker.workType.toLowerCase() == 'laundry') {
//      if (loadingBasket) return CircularProgressIndicator();
    return loadingBasket
        ? Center(child: CircularProgressIndicator())
        : Container(
            margin: EdgeInsets.only(right: 5.0),
            child: ValueListenableBuilder(
              valueListenable: laundryBox.listenable(),
              builder: (context, Box box, widget) {
                if (box.values.isEmpty) {
                  return Container(
                    margin: EdgeInsets.only(right: 5.0),
                    child: IconButton(
                      color: Colors.grey,
                      icon: Icon(
                        Icons.shopping_basket,
//                    color: childeanFire,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => LaundryBasketPage(),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  int count = box.length;

                  return Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 5.0),
                        child: IconButton(
                          color: Colors.grey,
                          icon: Icon(
                            Icons.shopping_basket,
                            color: Theme.of(context).primaryColor,
                            size: 43,
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => LaundryBasketPage(),
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        top: 8.0,
                        right: 0.0,
                        child: Container(
                          padding: EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '$count',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          );
//    } else {
//      return Container();
//    }
  }
}
