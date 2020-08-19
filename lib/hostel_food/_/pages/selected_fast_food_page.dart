import 'dart:async';

import 'package:Ohstel_app/hostel_food/_/models/extras_food_details.dart';
import 'package:Ohstel_app/hostel_food/_/models/fast_food_details_model.dart';
import 'package:Ohstel_app/hostel_food/_/models/food_details_model.dart';
import 'package:Ohstel_app/hostel_food/_/pages/cart_page.dart';
import 'package:Ohstel_app/hostel_food/_/pages/selected_food_dialog.dart';
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
    } else if (selectedFoodBar == 'Drinks') {}
    return null;
  }

  Widget fastFoodToDisplay({
    BuildContext context,
    @required List<ItemDetails> fastFoodList,
  }) {
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
      child: SizedBox(
        height: 250,
        child: GridView.count(
          childAspectRatio: (itemWidth / 220),
          physics: BouncingScrollPhysics(),
          crossAxisCount: 2,
          children: List.generate(
            fastFoodList.length,
            (index) {
              return Container(
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '${fastFoodList[index].itemName}',
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text(
                                'Price: \$${fastFoodList[index].price}',
                              ),
                              InkWell(
                                onTap: () {
                                  showFoodDialog(
                                    itemDetails: fastFoodList[index],
                                    extraItemDetails:
                                        widget.currentExtraItemDetails,
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
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
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
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
      }
    }

    return SizedBox(
      height: 60,
      child: Container(
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 3,
          itemBuilder: (context, index) {
            List<String> list = [
              'Fast Food',
              'Snacks',
              'Drinks',
            ];
            return Container(
              margin: EdgeInsets.all(10.0),
              padding: EdgeInsets.all(8.0),
              child: RaisedButton(
                color: (list[index].trim() == selectedFoodBar)
                    ? Colors.blueAccent
                    : Colors.grey,
                onPressed: () {
                  print(list[index]);
                  getColors(input: list[index]);
                },
                child: Text(
                  list[index],
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
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
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        IconButton(
          color: Colors.grey,
          icon: Icon(Icons.shopping_cart),
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
