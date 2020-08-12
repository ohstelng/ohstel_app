import 'package:Ohstel_app/hive_methods/hive_class.dart';
import 'package:Ohstel_app/hostel_food/_/models/food_cart_model.dart';
import 'package:Ohstel_app/hostel_food/_/models/food_details_model.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class SnackDialog extends StatefulWidget {
  final ItemDetails itemDetails;

  SnackDialog({
    @required this.itemDetails,
  });

  @override
  _SnackDialogState createState() => _SnackDialogState();
}

class _SnackDialogState extends State<SnackDialog> {
  int number = 1;

  int getTotal() {
    int _initialTotal = widget.itemDetails.price;
    return _initialTotal * number;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                        border: Border.all(color: Colors.grey),
                      ),
                      child: InkWell(
                        child: Icon(Icons.add, color: Colors.grey),
                        onTap: () {
                          if (mounted) {
                            setState(() {
                              number++;
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
                numberOfPlates: number,
              ).toMap();
              HiveMethods().saveFoodCartToDb(map: map);
//              Navigator.maybePop(context);
            },
            color: Colors.green,
            child: Text('Add To Cart'),
          ),
        ],
      ),
    );
  }
}
