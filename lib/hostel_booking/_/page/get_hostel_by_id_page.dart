import 'dart:convert';
import 'dart:io';

import 'package:Ohstel_app/hive_methods/hive_class.dart';
import 'package:Ohstel_app/hostel_booking/_/methods/hostel_booking_methods.dart';
import 'package:Ohstel_app/hostel_booking/_/model/hostel_model.dart';
import 'package:Ohstel_app/hostel_booking/_/page/booking_home_page.dart';
import 'package:Ohstel_app/hostel_booking/_/page/hostel_booking_inspection_request_page.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class GetHostelByIDPage extends StatefulWidget {
  final String id;

  GetHostelByIDPage({@required this.id});

  @override
  _GetHostelByIDPageState createState() => _GetHostelByIDPageState();
}

class _GetHostelByIDPageState extends State<GetHostelByIDPage> {
  Map userData;
  HostelModel hostelModel;
  bool isLoading = true;

  Future getHostel() async {
    setState(() {
      isLoading = true;
    });
    hostelModel = await HostelBookingMethods().getHostelByID(id: widget.id);
    setState(() {
      isLoading = false;
    });
  }

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
        Fluttertoast.showToast(msg: 'Payment Successfull');
        savePaidDataToServer();
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

  Future<void> savePaidDataToServer() async {
    int result = await HostelBookingMethods().savePaidHostelDetailsDetails(
      fullName: userData['fullName'],
      phoneNumber: userData['phoneNumber'],
      email: userData['email'],
      price: hostelModel.price,
      hostelDetails: hostelModel,
    );

    if (result == 0) {
      Fluttertoast.showToast(
        msg: 'Sent Sucessfully!!',
        gravity: ToastGravity.CENTER,
      );
    } else {
      Fluttertoast.showToast(
        msg: 'An Error Occur :(',
        gravity: ToastGravity.CENTER,
      );
    }
  }

  @override
  void initState() {
    getHostel();
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
        child: isLoading == false
            ? Column(
                children: <Widget>[
                  body(),
                  footer(),
                ],
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget body() {
    return Expanded(
      child: Container(
        child: Column(
          children: <Widget>[
            Stack(children: [
              displayMultiPic(imageList: hostelModel.imageUrl),
              Container(
                padding: EdgeInsets.only(right: 10, top: 10, left: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Center(
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 6,
                        child: Text('Hostel Details',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white))),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          HostelBookingMethods().archiveHostel(
                            userDetails: userData,
                            hostelDetails: hostelModel,
                          );
                        },
                        child: Center(
                          child: Icon(
                            Icons.bookmark_border,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ]),
            hostelDetails(),
          ],
        ),
      ),
    );
  }

  Widget footer() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              child: FlatButton(
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  chargeCard();
                },
                child: Text(
                  'Make Payment',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              child: FlatButton(
                color: Theme.of(context).buttonColor,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => HostelBookingInspectionRequestPage(
                        hostelModel: hostelModel,
                      ),
                    ),
                  );
                },
                child: Text(
                  'Request Inspection',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget hostelDetails() {
    TextStyle _titlestyle =
        TextStyle(fontSize: 22, fontWeight: FontWeight.bold);
    return Expanded(
      child: DefaultTabController(
        length: 1,
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    '${hostelModel.hostelName}',
                    style: _titlestyle,
                  ),
                  Spacer(),
                  Text(
                    'N${formatCurrency.format(hostelModel.price)}',
                    style: _titlestyle,
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: <Widget>[
                  Text('${hostelModel.hostelLocation}'),
                  Spacer(),
                  Text(hostelModel.isSchoolHostel ? 'Roommate Needed' : '')
                ],
              ),
              SizedBox(height: 8),
              Row(children: <Widget>[
                Icon(
                  Icons.location_on,
                  size: 16,
                ),
                Text('${hostelModel.distanceFromSchoolInKm}KM from Unilorin'),
                Spacer(),
              ]),
              Container(
                child: TabBar(
                  tabs: <Widget>[
                    Tab(
                      child: Text(
                        'Details',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.22,
                  child: TabBarView(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                            child: Text('${hostelModel.description}')),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget displayMultiPic({@required List imageList}) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.5,
        maxWidth: MediaQuery.of(context).size.width,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
        child: Carousel(
          images: imageList.map(
            (images) {
              return Container(
                child: ExtendedImage.network(
                  images,
                  fit: BoxFit.fill,
                  handleLoadingProgress: true,
                  shape: BoxShape.rectangle,
                  cache: false,
                  enableMemoryCache: true,
                ),
              );
            },
          ).toList(),
          autoplay: true,
          indicatorBgPadding: 16.0,
          dotPosition: DotPosition.bottomCenter,
          dotSpacing: 15.0,
          dotSize: 4,
          dotIncreaseSize: 2.5,
          dotIncreasedColor: Colors.deepOrange,
          dotBgColor: Colors.transparent,
          animationCurve: Curves.fastOutSlowIn,
          animationDuration: Duration(milliseconds: 2000),
        ),
      ),
    );
  }
}
