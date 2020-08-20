import 'dart:async';

import 'package:Ohstel_app/hostel_food/_/models/extras_food_details.dart';
import 'package:Ohstel_app/hostel_food/_/models/fast_food_details_model.dart';
import 'package:Ohstel_app/hostel_food/_/models/food_details_model.dart';
import 'package:Ohstel_app/hostel_food/_/pages/cart_page.dart';
import 'package:Ohstel_app/hostel_food/_/pages/selected_drinks_page.dart';
import 'package:Ohstel_app/hostel_food/_/pages/selected_food_dialog.dart';
import 'package:Ohstel_app/hostel_food/_/pages/selected_fries_page.dart';
import 'package:Ohstel_app/hostel_food/_/pages/selected_snacks_page.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class SelectedFastFoodPage extends StatefulWidget {
  final List<ExtraItemDetails> currentExtraItemDetails;
  final List<ItemDetails> currentItemDetails;
  final FastFoodModel currentFastFood;

  SelectedFastFoodPage({
    @required this.currentFastFood,
    @required this.currentExtraItemDetails,
    @required this.currentItemDetails,
  });

  @override
  _SelectedFastFoodPageState createState() => _SelectedFastFoodPageState();
}

class _SelectedFastFoodPageState extends State<SelectedFastFoodPage> {
  String selectedFoodBar = 'Fast Food';
  StreamController<String> toDisplayContoller = StreamController();

  Runes input = Runes('\u20a6');

  //TODO: implement drinks backend!!!!
  //TODO: implement drinks backend!!!!
  //TODO: implement drinks backend!!!!
  //TODO: implement drinks backend!!!!

  @override
  void initState() {
    toDisplayContoller.add('Fast Food');
    super.initState();
  }

  @override
  void dispose() {
    toDisplayContoller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            header(),
            titleBar(),
            foodBar(),
            body(context: context),
          ],
        ),
      ),
    );
  }

  Widget body({BuildContext context}) {
    List<ItemDetails> cookedItemsList = widget.currentItemDetails
        .where((element) =>
            element.itemCategory == 'cookedFood' ||
            element.itemCategory == 'cookFood')
        .toList();

    List<ItemDetails> snacksItemsList = widget.currentItemDetails
        .where((element) => element.itemCategory == 'snacks')
        .toList();

    List<ItemDetails> drinksItemsList = widget.currentItemDetails
        .where((element) => element.itemCategory == 'drinks')
        .toList();

    List<ItemDetails> friesItemsList = widget.currentItemDetails
        .where((element) => element.itemCategory == 'fries')
        .toList();

    return StreamBuilder<String>(
      stream: toDisplayContoller.stream,
      builder: (context, snapshot) {
        List<ItemDetails> listToPass = [];
        if (snapshot.data == 'Fast Food') {
          listToPass = cookedItemsList;
        } else if (snapshot.data == 'Snacks') {
          listToPass = snacksItemsList;
        } else if (snapshot.data == 'Drinks') {
          listToPass = drinksItemsList;
        } else if (snapshot.data == 'Fries') {
          listToPass = friesItemsList;
        }

        return Container(
          child: fastFoodToDisplay(
            context: context,
            fastFoodList: listToPass,
          ),
        );
      },
    );
  }

  void showFoodDialog(
      {@required ItemDetails itemDetails,
      @required List<ExtraItemDetails> extraItemDetails}) {
    if (selectedFoodBar == 'Fast Food') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => FoodDialog(
            currentExtraItemDetails: extraItemDetails,
            itemDetails: itemDetails,
          ),
        ),
      );
    } else if (selectedFoodBar == 'Snacks') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SnackDialog(
            itemDetails: itemDetails,
          ),
        ),
      );
    } else if (selectedFoodBar == 'Drinks') {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => DrinksDialog(itemDetails: itemDetails)));
    } else if (selectedFoodBar == 'Fries') {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => FriesDialog(itemDetails: itemDetails)));
    }
    return null;
  }

  Widget fastFoodToDisplay({
    BuildContext context,
    @required List<ItemDetails> fastFoodList,
  }) {
    var symbol = String.fromCharCodes(input);
    var size = MediaQuery.of(context).size;
//    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;

    print(fastFoodList.length);
    if (fastFoodList.isEmpty) {
      return Expanded(
        child: Container(
          child: Center(
            child: Text('No $selectedFoodBar Found!'),
          ),
        ),
      );
    }
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
//          Container(
//              padding: const EdgeInsets.fromLTRB(5,0,5,10),
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                children: [
//                  Text(
//                    "$selectedFoodBar",
//                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 24),
//                  ),
//                  FlatButton(
//                    child: Text(
//                      "Show all",
//                      style: TextStyle(
//                        fontSize: 24,
//                        fontWeight: FontWeight.w400,
//                        color: Color(0xFFF27507),
//                      ),
//                    ),
//                    onPressed: () {},
//                  )
//                ],
//              )),
          Expanded(
            child: SizedBox(
              height: 250,
              child: GridView.count(
                childAspectRatio: (itemWidth / 220),
                physics: BouncingScrollPhysics(),
                crossAxisCount: 2,
                children: List.generate(
                  fastFoodList.length,
                  (index) {
                    return InkWell(
                      onTap: () => showFoodDialog(
                        itemDetails: fastFoodList[index],
                        extraItemDetails: widget.currentExtraItemDetails,
                      ),
                      child: Container(
                        child: Card(
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              fastFoodList[index].imageUrl != null
                                  ? Container(
                                      height: 150,
                                      width: 150,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: ExtendedImage.network(
                                        fastFoodList[index].imageUrl,
                                        fit: BoxFit.contain,
                                        handleLoadingProgress: true,
                                        shape: BoxShape.circle,
//                        borderRadius: BorderRadius.circular(10),
                                        cache: false,
                                        enableMemoryCache: true,
                                      ),
                                    )
                                  : Container(
                                      height: 120,
                                      width: 120,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      '${fastFoodList[index].itemName}',
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          '$symbol${fastFoodList[index].price}',
                                          textAlign: TextAlign.start,
                                        ),
                                        InkWell(
                                          onTap: () {
//                                            Map map = FoodCartModel(
//                                              itemDetails: widget
//                                                  .currentItemDetails[index],
//                                              totalPrice: 1,
//                                              numberOfPlates: 1,
////                                              extraItems: widget
////                                                  .currentExtraItemDetails,
//                                            ).toMap();
//                                            HiveMethods()
//                                                .saveFoodCartToDb(map: map);

                                            showFoodDialog(
                                              itemDetails: fastFoodList[index],
                                              extraItemDetails: widget
                                                  .currentExtraItemDetails,
                                            );
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(5.0),
                                            decoration: BoxDecoration(
                                              color: Color(0xFFF27507),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(5.0),
                                              ),
                                            ),
                                            child: Text(
                                              'Order',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget titleBar() {
    return Container(
      padding: EdgeInsets.all(10),
      alignment: Alignment.topLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${widget.currentFastFood.fastFoodName}",
            textAlign: TextAlign.start,
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 24),
          ),
          Text(
            "${widget.currentItemDetails.length} products",
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget foodBar() {
    void getColors({@required String input}) {
      if (input.trim() == 'Fast Food') {
        setState(() {
          selectedFoodBar = 'Fast Food';
        });
        toDisplayContoller.add('Fast Food');
      } else if (input.trim() == 'Snacks') {
        setState(() {
          selectedFoodBar = 'Snacks';
        });
        toDisplayContoller.add('Snacks');
      } else if (input.trim() == 'Drinks') {
        setState(() {
          selectedFoodBar = 'Drinks';
        });
        toDisplayContoller.add('Drinks');
      } else if (input.trim() == 'Fries') {
        setState(() {
          selectedFoodBar = 'Fries';
        });
        toDisplayContoller.add('Fries');
      }
    }

    var width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: 60,
      child: Container(
        width: width,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 4,
          itemBuilder: (context, index) {
            List<String> list = [
              'Fast Food',
              'Snacks',
              'Drinks',
            ];
            return Container(
              margin: EdgeInsets.all(2.0),
              padding: EdgeInsets.all(3.0),
              child: FlatButton(
                onPressed: () {
                  print(list[index]);
                  getColors(input: list[index]);
                },
                child: Text(
                  list[index],
                  style: TextStyle(
                    color: (list[index].trim() == selectedFoodBar)
                        ? Color(0xFFF27507)
                        : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        IconButton(
          color: Colors.grey,
          icon: Icon(Icons.shopping_cart, color: Colors.black87),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CartPage(),
              ),
            );
          },
        )
      ],
    );
  }
}
