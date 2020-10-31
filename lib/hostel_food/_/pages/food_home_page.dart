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

class _FoodHomePageState extends State<FoodHomePage> {

  List _imgList = ["asset/ban4.jpg","asset/ban7.jpg",];

  String uniName;
  bool loading = true;

  Future<void> getUniName() async {
    String name = await HiveMethods().getUniName();
    print(name);
    uniName = name;

    if (!mounted) return;
    setState(() {
      loading = false;
    });
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
    getUniName();
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
              loading
                  ? Center(child: CircularProgressIndicator())
                  : paginatedFoodList(),
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
                decoration: BoxDecoration(color: Colors.transparent,border: Border.all(color: Theme.of(context).primaryColor)),
                child: Image.asset("$i",fit: BoxFit.fill,),
              );
            },
          );
        }).toList(),
      ),
    );
  }

  Widget paginatedFoodList() {
    return PaginateFirestore(
      shrinkWrap: true,
      initialLoader: Center(child: CircularProgressIndicator()),
      emptyDisplay: Container(
        child: Center(
          child: Text('No Fast Food Found!'),
        ),
      ),
      bottomLoader: Center(child: CircularProgressIndicator()),
      query: FastFoodMethods()
          .foodCollectionRef
          .orderBy('fastFood')
          .where('display', isEqualTo: true)
          .where('uniName', isEqualTo: uniName),
      itemBuilder:
          (int index, BuildContext context, DocumentSnapshot snapshot) {
        FastFoodModel currentFastFood = FastFoodModel.fromMap(snapshot.data());

        List<ItemDetails> currentItemDetails =
            getItemDetails(snapshot.data()['itemDetails']);

        List<ExtraItemDetails> currentExtraItemDetails =
            getExtraItemDetails(snapshot.data()['extraItems']);

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
                      cache: false,
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

  Widget foodList() {
    return Container(
      padding: EdgeInsets.all(10),
      child: FutureBuilder(
        future: FastFoodMethods().getFoodsFromDb(uniName: uniName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.none &&
              snapshot.hasData == null) {
            //print('project snapshot data is: ${projectSnap.data}');
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                FastFoodModel currentFastFood =
                    FastFoodModel.fromMap(snapshot.data[index]);

                List<ItemDetails> currentItemDetails =
                    getItemDetails(snapshot.data[index]['itemDetails']);

                List<ExtraItemDetails> currentExtraItemDetails =
                    getExtraItemDetails(snapshot.data[index]['extraItems']);

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
                              cache: false,
                              enableMemoryCache: true,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 120,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
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
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
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
}
