import 'package:Ohstel_app/hostel_food/_/models/food_details_model.dart';
import 'package:flutter/material.dart';

class DrinksDialog extends StatefulWidget {
  //final List<ExtraItemDetails> currentExtraItemDetails;
  final ItemDetails itemDetails;

  DrinksDialog({
    @required this.itemDetails,
    //   @required this.currentExtraItemDetails,
  });

  @override
  _DrinksDialogState createState() => _DrinksDialogState();
}

class _DrinksDialogState extends State<DrinksDialog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Drinks"),
      ),
    );
  }
}
