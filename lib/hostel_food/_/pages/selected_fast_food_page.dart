import 'dart:async';

import 'package:Ohstel_app/hive_methods/hive_class.dart';
import 'package:Ohstel_app/hostel_food/_/models/extras_food_details.dart';
import 'package:Ohstel_app/hostel_food/_/models/fast_food_details_model.dart';
import 'package:Ohstel_app/hostel_food/_/models/food_details_model.dart';
import 'package:Ohstel_app/hostel_food/_/pages/food_cart_page.dart';
import 'package:Ohstel_app/hostel_food/_/pages/selected_drinks_page.dart';
import 'package:Ohstel_app/hostel_food/_/pages/selected_food_dialog.dart';
import 'package:Ohstel_app/hostel_food/_/pages/selected_fries_page.dart';
import 'package:Ohstel_app/hostel_food/_/pages/selected_snacks_page.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

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
  final formatCurrency = new NumberFormat.currency(locale: "en_US", symbol: "");
  String selectedFoodBar = 'Fast Food';
  Box cartBox;
  bool isLoading = true;
  StreamController<String> toDisplayController = StreamController();

  Runes input = Runes('\u20a6');

  //TODO: implement drinks backend!!!!
  //TODO: implement drinks backend!!!!
  //TODO: implement drinks backend!!!!
  //TODO: implement drinks backend!!!!

  void getCart() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
    });
    cartBox = await HiveMethods().getOpenBox('cart');
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getCart();
    toDisplayController.add('Fast Food');
    super.initState();
  }

  @override
  void dispose() {
    toDisplayController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
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
      stream: toDisplayController.stream,
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
//    var size = MediaQuery.of(context).size;
//    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
//    final double itemWidth = size.width / 2;

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
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20),
              child: GridView.count(
                childAspectRatio: 0.85,
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
                        margin: EdgeInsets.all(5),
                        child: Card(
                          color: Color(0xFFF4F5F6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              fastFoodList[index].imageUrl != null
                                  ? Expanded(
                                      child: Container(
                                        width: double.infinity,
//                                        height: 150,
                                        margin:
                                            EdgeInsets.fromLTRB(0, 0, 0, 10),
                                        alignment: Alignment.topCenter,
                                        //  height: 150,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                        ),
                                        child: ExtendedImage.network(
                                          fastFoodList[index].imageUrl,
                                          fit: BoxFit.contain,
                                          handleLoadingProgress: true,
                                          shape: BoxShape.rectangle,
                                          cache: false,
                                          enableMemoryCache: true,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      alignment: Alignment.topCenter,
                                      height: 120,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        shape: BoxShape.rectangle,
                                      ),
                                    ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      '${fastFoodList[index].itemName}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.grey[600],
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '$symbol ${formatCurrency.format(fastFoodList[index].price)}',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(fontSize: 15),
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
        toDisplayController.add('Fast Food');
      } else if (input.trim() == 'Snacks') {
        setState(() {
          selectedFoodBar = 'Snacks';
        });
        toDisplayController.add('Snacks');
      } else if (input.trim() == 'Drinks') {
        setState(() {
          selectedFoodBar = 'Drinks';
        });
        toDisplayController.add('Drinks');
      }
    }

//    var width = MediaQuery.of(context).size.width;
    //var width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: 60,
      child: Container(
        // width: width,
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
              margin: EdgeInsets.all(5.0),
              padding: EdgeInsets.all(10.0),
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
        cartWidget(),
      ],
    );
  }

  Widget cartWidget() {
    return Container(
      margin: EdgeInsets.only(right: 5.0),
      child: ValueListenableBuilder(
        valueListenable: cartBox.listenable(),
        builder: (context, Box box, widget) {
          if (box.values.isEmpty) {
            return Container(
              margin: EdgeInsets.only(right: 5.0),
              child: IconButton(
                color: Colors.grey,
                icon: Icon(
                  Icons.shopping_cart,
                  color: Theme.of(context).primaryColor,
                  size: 43,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CartPage(),
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
                      Icons.shopping_cart,
                      color: Theme.of(context).primaryColor,
                      size: 43,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CartPage(),
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
  }
}
