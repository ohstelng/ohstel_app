import 'dart:async';

import 'package:Ohstel_app/hive_methods/hive_class.dart';
import 'package:Ohstel_app/hostel_food/_/models/extras_food_details.dart';
import 'package:Ohstel_app/hostel_food/_/models/food_cart_model.dart';
import 'package:Ohstel_app/hostel_food/_/models/food_details_model.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            widget.itemDetails.imageUrl != null
                ? Container(
                    margin: EdgeInsets.all(10.0),
                    height: 150,
                    width: 150,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '${widget.itemDetails.itemName}',
                ),
                Text(
                  '\$${widget.itemDetails.price}',
                ),
              ],
            ),
            widget.currentExtraItemDetails.isNotEmpty
                ? Flexible(
                    child: Container(
                      margin: EdgeInsets.all(10.0),
                      child: extraItemWidget(),
                    ),
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
                                .where(
                                    (element) => element.extraItemName == value)
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Nmuber Of Plates'),
                  Row(
                    children: <Widget>[
                      Container(
//                        padding: EdgeInsets.symmetric(horizontal: 1.5),
                        margin: EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                        ),
                        child: InkWell(
                          child: Icon(Icons.remove, color: Colors.grey),
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
                          border: Border.all(color: Colors.grey),
                        ),
                        child: InkWell(
                          child: Icon(Icons.add, color: Colors.grey),
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
                  )
                ],
              ),
            ),
            Divider(
              thickness: 0.5,
              color: Colors.black,
            ),
            Container(
              margin: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Total'),
                  Text('\$${getTotal()}'),
                ],
              ),
            ),
            FlatButton(
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
              color: Colors.green,
              child: Text('Add To Cart'),
            ),
          ],
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
                  Text('\$${extraItem.price}'),
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
              Text('\$${extraItem.price}'),
            ],
          );
        },
      );
    }
  }
}
