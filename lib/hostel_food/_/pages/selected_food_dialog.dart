import 'dart:async';

import 'package:Ohstel_app/hive_methods/hive_class.dart';
import 'package:Ohstel_app/hostel_food/_/models/extras_food_details.dart';
import 'package:Ohstel_app/hostel_food/_/models/fast_food_details_model.dart';
import 'package:Ohstel_app/hostel_food/_/models/food_cart_model.dart';
import 'package:Ohstel_app/hostel_food/_/models/food_details_model.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import 'food_cart_page.dart';

class FoodDialog extends StatefulWidget {
  final List<ExtraItemDetails> currentExtraItemDetails;
  final ItemDetails itemDetails;
  final FastFoodModel foodModel;

  FoodDialog({
    @required this.itemDetails,
    @required this.currentExtraItemDetails,
    @required this.foodModel,
  });

  @override
  _FoodDialogState createState() => _FoodDialogState();
}

class _FoodDialogState extends State<FoodDialog> {
  final formatCurrency = new NumberFormat.currency(locale: "en_US", symbol: "");
  Box cartBox;
  bool isLoading = true;
  Runes input = Runes('\u20a6');
  var symbol;
  StreamController<List<ExtraItemDetails>> extraListController =
      StreamController();
  String selectedExtras;
  List<ExtraItemDetails> extraList = [];
  int totalPrice;
  int numberOfPlates = 1;

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

  int getTotal() {
    int _initialTotal = widget.itemDetails.price;

    if (extraList.isEmpty) {
      return _initialTotal * numberOfPlates;
    } else {
      int _total = _initialTotal;
      for (ExtraItemDetails extra in extraList) {
        _total = _total + extra.price;
      }
      return _total * numberOfPlates;
    }
  }

  void saveToCart() {
    Map foodData = FoodCartModel(
      itemDetails: widget.itemDetails,
      totalPrice: getTotal(),
      numberOfPlates: numberOfPlates,
      extraItems: extraList,
      itemFastFoodLocation: widget.foodModel.foodFastLocation,
      fastFoodStateLocation: widget.foodModel.stateLocation,
      fastFoodMainArea: widget.foodModel.mainArea,
    ).toMap();

    print(foodData);

    HiveMethods().saveFoodCartToDb(map: foodData);
    numberOfPlates = 1;
    extraList = [];

    if (!mounted) return;
    setState(() {});
  }

  @override
  void dispose() {
    extraListController.close();
    super.dispose();
  }

  @override
  void initState() {
    getCart();
    super.initState();
    symbol = String.fromCharCodes(input);
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              leading: IconButton(
                  color: Colors.black,
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop()),
              actions: [
                cartWidget(),
              ],
            ),
            body: SafeArea(
              child: Container(
                child: ListView(
                  children: <Widget>[
                    Container(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: Text(
                          "${widget.itemDetails.itemFastFoodName}",
                          style: TextStyle(fontSize: 24),
                        )),
                    widget.itemDetails.imageUrl != null
                        ? Container(
                            //  margin: const EdgeInsets.all(10.0),
                            height: 200,
                            width: double.infinity,
                            child: ExtendedImage.network(
                              widget.itemDetails.imageUrl,
                              fit: BoxFit.fitWidth,
                              handleLoadingProgress: true,
                              shape: BoxShape.rectangle,
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
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
//                        padding: EdgeInsets.symmetric(horizontal: 1.5),
                            margin: EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: numberOfPlates == 1
                                    ? Colors.grey
                                    : Color(0xFFF27507),
                              ),
                            ),
                            child: InkWell(
                              child: Icon(
                                Icons.remove,
                                color: numberOfPlates == 1
                                    ? Colors.grey
                                    : Color(0xFFF27507),
                              ),
                              onTap: () {
                                if (numberOfPlates > 1) {
                                  if (mounted) {
                                    setState(() {
                                      numberOfPlates--;
                                    });
                                  }
                                }
                              },
                            ),
                          ),
                          Text('$numberOfPlates'),
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xFFF27507),
                              ),
                            ),
                            child: InkWell(
                              child: Icon(
                                Icons.add,
                                color: Color(0xFFF27507),
                              ),
                              onTap: () {
                                if (mounted) {
                                  if (numberOfPlates < 10) {
                                    setState(() {
                                      numberOfPlates++;
                                    });
                                  }
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '${widget.itemDetails.itemName}',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            '$symbol ${formatCurrency.format(getTotal())}',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      constraints: BoxConstraints(minWidth: 90),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.alarm,
                                  color: Color(0xFFF27507),
                                  size: 16,
                                ),
                                Text(
                                  "  5 - 10 Mins Delivery Time Range",
                                  style: TextStyle(color: Color(0xFFF27507)),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    widget.currentExtraItemDetails.isNotEmpty
                        ? Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: Card(
                              elevation: 1.5,
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                //     constraints: BoxConstraints(maxHeight: 150),
                                margin: EdgeInsets.all(10.0),
                                child: extraItemWidget(),
                              ),
                            ),
                          )
                        : Container(),
                    widget.currentExtraItemDetails.isNotEmpty
                        ? Container(
                            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                            margin: EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: DropdownButton(
                              underline: Container(),
                              hint: extraList.isEmpty
                                  ? Text('Select Extras')
                                  : Text('Add More Extras'),
                              items: widget.currentExtraItemDetails
                                  .map((ExtraItemDetails element) {
                                return DropdownMenuItem<String>(
                                  value: element.extraItemName,
                                  child: Text('${element.extraItemName}'),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  print(value);
                                  selectedExtras = value;
                                  extraList.add(
                                    widget.currentExtraItemDetails
                                        .where((element) =>
                                            element.extraItemName == value)
                                        .toList()[0],
                                  );
                                  setState(() {});
                                  print(selectedExtras);
                                });
                                setState(() {});
                              },
                            ),
                          )
                        : Container(),
                    batchTimeDetails(),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Description",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            '${widget.itemDetails.shortDescription}',
                            textAlign: TextAlign.justify,
                            style: TextStyle(fontSize: 17),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: RaisedButton.icon(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: const EdgeInsets.all(20),
                        onPressed: () {
                          saveToCart();
                        },
                        color: Color(0xFFF27507),
                        label: Text(
                          "Add to Cart",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        icon: Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  Widget batchTimeDetails() {
    /// null check
    if (widget.foodModel.hasBatchTime != null) {
      if (widget.foodModel.hasBatchTime) {
        return Container(
          margin: EdgeInsets.all(10.0),
          child: Card(
            elevation: 2.5,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 2.0),
                  child: Text(
                    'Note: This Fast Food Is Not At Your Current Location \n So The Foods Ordered Will '
                    'Be Deliverd In Batches. \n They Are 5 Batches In Total Which Are Shown Below.',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w300,
                      color: Colors.orange[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                batchTimes(),
                Container(
                  margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
                  child: Text(
                    'If You Order Now You Food Will Be Deliverd By ${getBatchDeliveryTime()}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        return Container();
      }

      ///
    } else {
      return Container();
    }
  }

  Widget batchTimes() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.all(5.0),
            child: Text(
              'Morning Batch: 10:00Am',
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(5.0),
            child: Text(
              'Mid Day Batch: 12:00Am',
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(5.0),
            child: Text(
              'Afternoon Batch: 2:00Pm',
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ),
          Container(
              margin: EdgeInsets.all(5.0),
              child: Text(
                'Evening Batch: 04:00Pm',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              )),
          Container(
            margin: EdgeInsets.all(5.0),
            child: Text(
              'Night Batch: 07:00Pm',
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getBatchDeliveryTime() {
    TimeOfDay time = TimeOfDay.now();

    if (time.hour < 10) {
      return 'Morning Batch By 10:00Am';
    } else if (time.hour < 12) {
      return 'Mid Day Batch By 12:00Am';
    } else if (time.hour < 14) {
      return 'Afternoon Batch By 02:00Pm';
    } else if (time.hour < 16) {
      return 'Evening Batch By 04:00Pm';
    } else if (time.hour < 19) {
      return 'Night Batch By 07:00Pm';
    } else {
      return '';
    }
  }

  Widget extraItemWidget() {
    if (extraList == [] || extraList.isEmpty) {
      return Container(
          child: Text(
        'No Extras Selected..',
        style: TextStyle(
          fontSize: 15,
          color: Colors.grey[600],
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ));
    } else {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: extraList.length,
        itemBuilder: (context, index) {
          ExtraItemDetails extraItem = extraList[index];

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Extra ${extraItem.extraItemName}'),
              Row(
                children: <Widget>[
                  Text('$symbol${extraItem.price}'),
                  InkWell(
                    onTap: () {
                      setState(() {
                        extraList.remove(extraItem);
                      });
                    },
                    child: Icon(
                      Icons.cancel,
                      color: Colors.red,
                    ),
                  )
                ],
              ),
            ],
          );
        },
      );
    }
  }

  Widget addDrinkWidget() {
    if (extraList == [] || extraList.isEmpty) {
      return Container(child: Text('Add Extras'));
    } else {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: extraList.length,
        itemBuilder: (context, index) {
          ExtraItemDetails extraItem = extraList[index];

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Extra ${extraItem.extraItemName}'),
              Text('$symbol${extraItem.price}'),
            ],
          );
        },
      );
    }
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
