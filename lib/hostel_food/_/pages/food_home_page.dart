import 'package:Ohstel_app/hive_methods/hive_class.dart';
import 'package:Ohstel_app/hostel_food/_/methods/fast_food_methods.dart';
import 'package:Ohstel_app/hostel_food/_/models/extras_food_details.dart';
import 'package:Ohstel_app/hostel_food/_/models/fast_food_details_model.dart';
import 'package:Ohstel_app/hostel_food/_/models/food_details_model.dart';
import 'package:Ohstel_app/hostel_food/_/pages/selected_fast_food_page.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FoodHomePage extends StatefulWidget {
  @override
  _FoodHomePageState createState() => _FoodHomePageState();
}

class _FoodHomePageState extends State<FoodHomePage> {
  String uniName;

  Future<void> getUniName() async {
    String name = await HiveMethods().getUniName();
    print(name);
    uniName = name;
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.black,
          ),
          onPressed: () {},
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
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
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else {
//                      return Container(
//                        child: SingleChildScrollView(
//                            child: Text(
//                                snapshot.data[0]['itemDetails'].toString())),
//                      );
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          FastFoodModel currentFastFood =
                              FastFoodModel.fromMap(snapshot.data[index]);

                          List<ItemDetails> currentItemDetails = getItemDetails(
                              snapshot.data[index]['itemDetails']);

                          List<ExtraItemDetails> currentExtraItemDetails =
                              getExtraItemDetails(
                                  snapshot.data[index]['extraItems']);

                          return InkWell(
                            onTap: () {
                              print(currentFastFood.toMap());
                              print(currentItemDetails);
                              print(currentExtraItemDetails);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => SelectedFastFoodPage(
                                    currentFastFood: currentFastFood,
                                    currentExtraItemDetails:
                                        currentExtraItemDetails,
                                    currentItemDetails: currentItemDetails,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 10,
                              ),
                              child: Card(
                                elevation: 2.5,
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.all(15.0),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            '${currentFastFood.openTime.trim()}',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          Text(
                                            '${currentFastFood.fastFoodName.trim()}',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          Text(
                                            '${currentFastFood.address.trim()}',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w300,
                                            ),
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
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
