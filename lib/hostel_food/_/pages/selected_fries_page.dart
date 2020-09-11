import 'package:Ohstel_app/hostel_food/_/models/food_details_model.dart';
import 'package:flutter/material.dart';

class FriesDialog extends StatefulWidget {
  //final List<ExtraItemDetails> currentExtraItemDetails;
  final ItemDetails itemDetails;

  FriesDialog({
    @required this.itemDetails,
    //   @required this.currentExtraItemDetails,
  });

  @override
  _FriesDialogState createState() => _FriesDialogState();
}

class _FriesDialogState extends State<FriesDialog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Fries"),
      ),
    );
  }
}
