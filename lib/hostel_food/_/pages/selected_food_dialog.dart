import 'dart:async';

import 'package:Ohstel_app/hive_methods/hive_class.dart';
import 'package:Ohstel_app/hostel_food/_/models/extras_food_details.dart';
import 'package:Ohstel_app/hostel_food/_/models/food_cart_model.dart';
import 'package:Ohstel_app/hostel_food/_/models/food_details_model.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import 'cart_page.dart';

class FoodDialog extends StatefulWidget {
  final List<ExtraItemDetails> currentExtraItemDetails;
  final ItemDetails itemDetails;

  FoodDialog({
    @required this.itemDetails,
    @required this.currentExtraItemDetails,
  });

  @override
  _FoodDialogState createState() => _FoodDialogState();
}

class _FoodDialogState extends State<FoodDialog> {
  Runes input = Runes('\u20a6');
  var symbol;
  StreamController<List<ExtraItemDetails>> extraListController =
      StreamController();
  String selectedExtras;
  List<ExtraItemDetails> extraList = [];
  int totalPrice;
  int numberOfPlates = 1;

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

  @override
  void dispose() {
    extraListController.close();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    symbol = String.fromCharCodes(input);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
            color: Colors.black,
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop()),
        actions: [
          IconButton(
            color: Colors.black87,
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
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: ListView(
            children: <Widget>[
              widget.itemDetails.imageUrl != null
                  ? Container(
                margin: const EdgeInsets.all(10.0),
                height: 150,
                width: double.infinity,
                child: ExtendedImage.network(
                  widget.itemDetails.imageUrl,
                  fit: BoxFit.contain,
                  handleLoadingProgress: true,
                  shape: BoxShape.circle,
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
                          color: numberOfPlates == 1 ? Colors.grey : Color(
                              0xFFF27507),
                        ),
                      ),
                      child: InkWell(
                        child: Icon(
                          Icons.remove,
                          color: numberOfPlates == 1 ? Colors.grey : Color(
                              0xFFF27507),
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
                            setState(() {
                              numberOfPlates++;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '${widget.itemDetails.itemName}',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      '$symbol${widget.itemDetails.price}',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
              widget.currentExtraItemDetails.isNotEmpty
                  ? Container(
                //     constraints: BoxConstraints(maxHeight: 150),
                margin: EdgeInsets.all(10.0),
                child: extraItemWidget(),
              )
                  : Container(),
              widget.currentExtraItemDetails.isNotEmpty
                  ? Container(
                margin: EdgeInsets.all(5.0),
                child: DropdownButton(
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
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Description",
                      style:
                      TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${widget.itemDetails.shortDescription}',
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
//              Container(
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                  children: <Widget>[
//                    Text('Nmuber Of Plates'),
//                    Row(
//                      children: <Widget>[
//                        Container(
////                        padding: EdgeInsets.symmetric(horizontal: 1.5),
//                          margin: EdgeInsets.only(right: 10),
//                          decoration: BoxDecoration(
//                            border: Border.all(color: Colors.grey),
//                          ),
//                          child: InkWell(
//                            child: Icon(Icons.remove, color: Colors.grey),
//                            onTap: () {
//                              if (numberOfPlates > 1) {
//                                if (mounted) {
//                                  setState(() {
//                                    numberOfPlates--;
//                                  });
//                                }
//                              }
//                            },
//                          ),
//                        ),
//                        Text('$numberOfPlates'),
//                        Container(
//                          margin: EdgeInsets.only(left: 10),
//                          decoration: BoxDecoration(
//                            border: Border.all(color: Colors.grey),
//                          ),
//                          child: InkWell(
//                            child: Icon(Icons.add, color: Colors.grey),
//                            onTap: () {
//                              if (mounted) {
//                                setState(() {
//                                  numberOfPlates++;
//                                });
//                              }
//                            },
//                          ),
//                        ),
//                      ],
//                    )
//                  ],
//                ),
//              ),
              Divider(
                thickness: 0.5,
                color: Colors.black,
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Total:',
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '$symbol${getTotal()}',
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: RaisedButton.icon(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: const EdgeInsets.all(20),
                    onPressed: () {
                      Map map = FoodCartModel(
                        itemDetails: widget.itemDetails,
                        totalPrice: getTotal(),
                        numberOfPlates: numberOfPlates,
                        extraItems: extraList,
                      ).toMap();
                      HiveMethods().saveFoodCartToDb(map: map);
//                Navigator.maybePop(context);
                    },
                    color: Color(0xFFF27507),
                    label: Text(
                      "Add to Cart",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    icon: Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget extraItemWidget() {
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
}
