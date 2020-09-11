import 'package:flutter/material.dart';

class PaymentPopUp extends StatefulWidget {
  final int amount;

  PaymentPopUp({@required this.amount});

  @override
  _PaymentPopUpState createState() => _PaymentPopUpState();
}

class _PaymentPopUpState extends State<PaymentPopUp> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        shrinkWrap: true,
        children: [
          Text(
              'The Sum Of ${widget.amount} Will Be Deducted From Your Wallet Balance!'),
          Row(
            children: [
              FlatButton(
                onPressed: () {},
                child: Text('Proceed'),
              ),
              FlatButton(
                onPressed: () {},
                child: Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
