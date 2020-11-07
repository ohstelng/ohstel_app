import 'package:Ohstel_app/hive_methods/hive_class.dart';
import 'package:Ohstel_app/hostel_food/_/models/fast_food_details_model.dart';
import 'package:Ohstel_app/hostel_food/_/models/food_cart_model.dart';
import 'package:Ohstel_app/hostel_food/_/models/food_details_model.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'food_cart_page.dart';

class SnackDialog extends StatefulWidget {
  final ItemDetails itemDetails;
  final FastFoodModel fastFoodDetails;

  SnackDialog({
    @required this.itemDetails,
    @required this.fastFoodDetails,
  });

  @override
  _SnackDialogState createState() => _SnackDialogState();
}

class _SnackDialogState extends State<SnackDialog> {
  final formatCurrency = new NumberFormat.currency(locale: "en_US", symbol: "");

  Runes input = Runes('\u20a6');
  var symbol;
  int number = 1;

  int getTotal() {
    int _initialTotal = widget.itemDetails.price;
    return _initialTotal * number;
  }

  @override
  void initState() {
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
      body: Container(
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
                    // margin: EdgeInsets.all(10.0),
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
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.rectangle,
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
                        color: number == 1 ? Colors.grey : Color(0xFFF27507),
                      ),
                    ),
                    child: InkWell(
                      child: Icon(
                        Icons.remove,
                        color: number == 1 ? Colors.grey : Color(0xFFF27507),
                      ),
                      onTap: () {
                        if (number > 1) {
                          if (mounted) {
                            setState(() {
                              number--;
                            });
                          }
                        }
                      },
                    ),
                  ),
                  Text('$number'),
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
                          if (number < 10) {
                            setState(() {
                              number++;
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
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '${widget.itemDetails.itemName}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '$symbol${formatCurrency.format(getTotal())}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
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
                          "delivery time will be here",
                          style: TextStyle(color: Color(0xFFF27507)),
                        )
                      ],
                    ),
                  ),
                  Text("Ratings will be here")
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Description",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
//            Divider(
//              thickness: 0.5,
//              color: Colors.black,
//            ),
//            Container(
//              margin: EdgeInsets.all(10.0),
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                children: <Widget>[
//                  Text(
//                    'Total:',
//                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                  ),
//                  Text(
//                    '$symbol ${formatCurrency.format(getTotal())}',
//                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                  ),
//                ],
//              ),
//            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
              width: double.infinity,
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
                      numberOfPlates: number,
                      extraItems: [],
                      itemFastFoodLocation:
                          widget.fastFoodDetails.foodFastLocation,
                      fastFoodStateLocation: widget.fastFoodDetails.stateLocation,
                      fastFoodMainArea: widget.fastFoodDetails.mainArea,
                    ).toMap();
                    HiveMethods().saveFoodCartToDb(map: map);
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
    );
  }
}
