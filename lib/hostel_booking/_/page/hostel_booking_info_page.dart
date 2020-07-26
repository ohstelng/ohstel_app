import 'dart:convert';
import 'dart:io';

import 'package:Ohstel_app/hive_methods/hive_class.dart';
import 'package:Ohstel_app/hostel_booking/_/model/hostel_model.dart';
import 'package:Ohstel_app/hostel_booking/_/page/hostel_booking_inspection_request_page.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class HostelBookingInFoPage extends StatefulWidget {
  final HostelModel hostelModel;

  HostelBookingInFoPage({@required this.hostelModel});

  @override
  _HostelBookingInFoPageState createState() => _HostelBookingInFoPageState();
}

class _HostelBookingInFoPageState extends State<HostelBookingInFoPage> {
  Map userData;

  Future<void> getUserData() async {
    Map data = await HiveMethods().getUserData();
    print(data);
    userData = data;
  }

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'ChargedFrom${platform}_${DateTime.now().microsecondsSinceEpoch}';
  }

  Future<String> createAccessCode(skTest, _getReference) async {
    // skTest -> Secret key
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $skTest'
    };

    Map data = {
      "amount": 600,
      "email": "johnsonoye34@gmail.com",
      "reference": _getReference
    };

    String payload = json.encode(data);
    http.Response response = await http.post(
      'https://api.paystack.co/transaction/initialize',
      headers: headers,
      body: payload,
    );

    final Map _data = jsonDecode(response.body);
    String accessCode = _data['data']['access_code'];

    return accessCode;
  }

  void _verifyOnServer(String reference) async {
    String skTest = 'sk_test_5df98ac979ca2f2d10789cb1a158715096cde107';

    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $skTest',
      };

      http.Response response = await http.get(
          'https://api.paystack.co/transaction/verify/' + reference,
          headers: headers);

      final Map body = json.decode(response.body);

      if (body['data']['status'] == 'success') {
        Fluttertoast.showToast(msg: 'SucessFull!!!! :)');
        //do something with the response. show success
      } else {}
    } catch (e) {
      print(e);
    }
  }

  chargeCard() async {
    Charge charge = Charge()
      ..amount = 10000
      ..reference = _getReference()
//..accessCode = _createAcessCode(skTest, _getReference())
      ..email = userData['email'];
    CheckoutResponse response = await PaystackPlugin.checkout(
      context,
      method: CheckoutMethod.card,
      charge: charge,
    );
    if (response.status == true) {
      _verifyOnServer(response.reference);
    } else {
      print('error');
    }
  }

  @override
  void initState() {
    getUserData();
    PaystackPlugin.initialize(
      publicKey: 'pk_test_d0490fa7b5ae91bf5317ebdbd761760c8f14fd8f',
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            header(),
            body(),
            footer(),
          ],
        ),
      ),
    );
  }

  Widget header() {
    return Container(
      margin: EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
            ),
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Center(
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
            ),
            child: InkWell(
              onTap: () {
                // TODO: implement bookmarking of post
              },
              child: Center(
                child: Icon(
                  Icons.bookmark_border,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget body() {
    return Expanded(
      child: Container(
        child: ListView(
          children: <Widget>[
            displayMultiPic(imageList: widget.hostelModel.imageUrl),
            hostelDetails(),
          ],
        ),
      ),
    );
  }

  Widget footer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        FlatButton(
          color: Colors.blue,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => HostelBookingInspectionRequestPage(
                  hostelModel: widget.hostelModel,
                ),
              ),
            );
          },
          child: Text('Request Inspection'),
        ),
        FlatButton(
          color: Colors.green,
          onPressed: () {
            chargeCard();
          },
          child: Text('Pay'),
        ),
      ],
    );
  }

  Widget hostelDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Name: ${widget.hostelModel.hostelName}'),
        Text('Des: ${widget.hostelModel.description}'),
        Text('Distance: ${widget.hostelModel.distanceFromSchoolInKm}'),
        Text('Price: ${widget.hostelModel.price}'),
        Text('Location: ${widget.hostelModel.hostelLocation}'),
        Text('ratings: ${widget.hostelModel.ratings}'),
        Text('Features: ${widget.hostelModel.extraFeatures}'),
        Text('lank Mark Close by: ${widget.hostelModel.landMark}'),
        Text('School Hostel?: ${widget.hostelModel.isRoomMateNeeded}'),
        Text('Roommate needed? : ${widget.hostelModel.isSchoolHostel}'),
        Text('and lots more..............'),
      ],
    );
  }

  Widget displayMultiPic({@required List imageList}) {
    return Container(
      margin: EdgeInsets.all(10),
      constraints: BoxConstraints(
        maxHeight: 400,
        maxWidth: MediaQuery.of(context).size.width * .95,
      ),
      child: Carousel(
        images: imageList.map(
          (images) {
            return Container(
              child: ExtendedImage.network(
                images,
                fit: BoxFit.fill,
                handleLoadingProgress: true,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(15),
                cache: false,
                enableMemoryCache: true,
              ),
            );
          },
        ).toList(),
        autoplay: true,
        indicatorBgPadding: 0.0,
        dotPosition: DotPosition.bottomCenter,
        dotSpacing: 15.0,
        dotSize: 4,
        dotIncreaseSize: 2.5,
        dotIncreasedColor: Colors.teal,
        dotBgColor: Colors.transparent,
        animationCurve: Curves.fastOutSlowIn,
        animationDuration: Duration(milliseconds: 2000),
      ),
    );
  }
}
