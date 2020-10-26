import 'dart:async';

import 'package:Ohstel_app/hive_methods/hive_class.dart';
import 'package:Ohstel_app/hostel_food/_/pages/select_location_page.dart';
import 'package:Ohstel_app/hostel_hire/model/laundry_address_details_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../hive_methods/hive_class.dart';
import '../model/laundry_address_details_model.dart';
import 'laundry_payment_page.dart';

class LaundryAddressDetailsPage extends StatefulWidget {
  @override
  _LaundryAddressDetailsPageState createState() =>
      _LaundryAddressDetailsPageState();
}

class _LaundryAddressDetailsPageState extends State<LaundryAddressDetailsPage> {
  StreamController<String> pickUpNumberSteam =
      StreamController<String>.broadcast();
  StreamController<String> dropOffNumberSteam =
      StreamController<String>.broadcast();
  Box<Map> laundryAddressBox;
  int pickUpNumber;
  int dropOffNumber;
  Map userData;
  bool loading;
  Map addressDetails;
  DateTime pickUpDate;
  TimeOfDay pickUpTime;

  void selectDeliveryLocation({@required AddressType type}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(5.0),
          content: Builder(builder: (context) {
            var height = MediaQuery.of(context).size.height;
            var width = MediaQuery.of(context).size.width;

            return Container(
              height: height * .70,
              width: width,
              child: SelectDeliveryLocationPage(type: type),
            );
          }),
        );
      },
    );
  }

  void editPhoneNumber({@required String type}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        String number;
        return Dialog(
          child: Container(
            margin: EdgeInsets.all(15.0),
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    hintText: 'Enter You Phone Number',
                  ),
                  maxLines: null,
                  maxLength: 20,
                  onChanged: (val) {
                    number = val.trim();
                  },
                ),
                FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  onPressed: () {
                    print(number.length);
                    if (number.length > 10) {
                      if (type == 'pickUp') {
                        pickUpNumberSteam.add(number);
                      } else if (type == 'dropOff') {
                        dropOffNumberSteam.add(number);
                      }

                      Navigator.pop(context);
                    } else {
                      Fluttertoast.showToast(msg: 'Input Invaild Number!');
                    }
                  },
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> getBox() async {
    if (!mounted) return;

    setState(() {
      loading = true;
    });

    laundryAddressBox = await HiveMethods().getOpenBox('laundryAddressBox');
    userData = await HiveMethods().getUserData();

    setState(() {
      loading = false;
    });
  }

  void pickDate() async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year + 1),
      initialDate: DateTime.now(),
      errorInvalidText: 'Error',
    );
    if (date != null)
      setState(() {
        pickUpDate = date;
      });
  }

  void pickTime() async {
    TimeOfDay t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (t != null)
      setState(() {
        pickUpTime = t;
      });
  }

  void proceedToPayment() {
    Map pickUpData = laundryAddressBox.get('pickUp');
    Map dropOffData = laundryAddressBox.get('dropOff');

    if (pickUpData != null &&
        dropOffData != null &&
        pickUpNumber != null &&
        dropOffNumber != null &&
        pickUpDate != null &&
        pickUpTime != null) {
      if (pickUpDate.month <= DateTime.now().month &&
          pickUpDate.day <= DateTime.now().day) {
        Fluttertoast.showToast(msg: 'Choose A Date One Day From Today!!');

        return;
      }

      LaundryAddressDetailsModel laundryAddressDetails =
          LaundryAddressDetailsModel(
        pickUpDate: pickUpDate.toString(),
        pickUpTime: pickUpTime.format(context).toString(),
        pickUpAddress: pickUpData,
        dropOffAddress: dropOffData,
        dropOffNumber: dropOffNumber.toString(),
        pickUpNumber: pickUpNumber.toString(),
      );

      print(laundryAddressDetails.toMap());
      print(pickUpDate.month);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => LaundryPaymentPage(
            laundryAddressDetails: laundryAddressDetails,
          ),
        ),
      );
    } else {
      Fluttertoast.showToast(msg: 'Please Provide All Info!');
    }
  }

  bool buttonState = false;

  @override
  void initState() {
    getBox();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Container(
                padding: EdgeInsets.all(10),
                child: ListView(
                  children: [
                    Text(
                      'Delivery Details',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                    ),
                    pickUpDetailsWidget(),
                    dropOffDetailsWidget(),
                    SizedBox(height: 20),
                    button()
                  ],
                ),
              ),
            ),
    );
  }

  Widget dropOffDetailsWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        dropOffAddress(),
      ],
    );
  }

  Widget button() {
    return Container(
      height: 70,
      padding: EdgeInsets.all(8),
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Text(
          'Proceed',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        color: buttonState ? Color(0xffEBF1EF) : Theme.of(context).primaryColor,
        onPressed: () {
          proceedToPayment();
        },
      ),
    );
  }

  Widget pickUpDetailsWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        pickUpAddress(),
      ],
    );
  }

  Widget datePicker() {
    return Row(
      //      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Container(
            margin: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.black),
            ),
            child: ListTile(
              title: pickUpDate == null
                  ? Text('Date: Not Set')
                  : Text(
                      "Date: ${pickUpDate.year}, ${pickUpDate.month}, ${pickUpDate.day}"),
              trailing: Icon(Icons.keyboard_arrow_down),
              onTap: pickDate,
            ),
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.black),
            ),
            child: ListTile(
              title: pickUpTime == null
                  ? Text('Time: Not Set')
                  : Text("Time: ${pickUpTime.hour}:${pickUpTime.minute}"),
              trailing: Icon(Icons.keyboard_arrow_down),
              onTap: pickTime,
            ),
          ),
        ),
      ],
    );
  }

  Widget pickUpAddress() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Text('Pick Up Details'),
          datePicker(),
          getPickUpAddress(),
        ],
      ),
    );
  }

  Widget getPickUpAddress() {
    return ValueListenableBuilder(
      valueListenable: laundryAddressBox.listenable(),
      builder: (context, Box box, widget) {
        if (box.values.isEmpty || !box.containsKey('pickUp')) {
          return Card(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(15.0),
                  child: Center(
                    child: Text('No Pick Up Adress Found!!'),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(15.0),
                  child: FlatButton(
                    color: Colors.grey[200],
                    onPressed: () {
                      selectDeliveryLocation(type: AddressType.pickUp);
                    },
                    child: Center(
                      child: Text('Select PickUp Address.'),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          Map data = box.get('pickUp');
          //          Map data = box.get('dropOff');
          return Container(
            color: Color(0xffEBF1EF),
            margin: EdgeInsets.only(top: 8),
            padding: EdgeInsets.fromLTRB(8, 16, 16, 16),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Home Address",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                Text('${userData['fullName']}'),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.80,
                          margin: EdgeInsets.only(top: 5.0),
                          child: Text(
                            '${data['address']}',
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5.0),
                          child: Text(
                            '${data['areaName']}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () async {
                        //                  addressDetails = await HiveMethods().getFoodLocationDetails();
                        selectDeliveryLocation(type: AddressType.pickUp);
                      },
                      child: Icon(Icons.edit, size: 20),
                    )
                  ],
                ),
                Divider(),
                Container(
                  margin: EdgeInsets.only(top: 15.0, left: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      StreamBuilder<String>(
                          stream: pickUpNumberSteam.stream,
                          builder: (context, snapshot) {
                            if (snapshot.data == null) {
                              return Text('No Number Found');
                            }
                            pickUpNumber = int.parse(snapshot.data);
                            return Text(
                              '${snapshot.data}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            );
                          }),
                      InkWell(
                        onTap: () {
                          editPhoneNumber(type: 'pickUp');
                        },
                        child: Icon(
                          Icons.edit,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget dropOffAddress() {
    return Container(
      margin: EdgeInsets.only(top: 8),
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Drop Off Details'),
            ],
          ),
          getDropOffAddress(),
        ],
      ),
    );
  }

  Widget getDropOffAddress() {
    return ValueListenableBuilder(
      valueListenable: laundryAddressBox.listenable(),
      builder: (context, Box box, widget) {
        if (box.values.isEmpty || !box.containsKey('dropOff')) {
          return Card(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(15.0),
                  child: Center(
                    child: Text('No Drop Off Address Found!!'),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(15.0),
                  child: FlatButton(
                    color: Colors.grey[200],
                    onPressed: () {
                      selectDeliveryLocation(type: AddressType.dropOff);
                    },
                    child: Center(
                      child: Text('Select PickUp Address.'),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          //          Map data = box.get('pickUp');
          Map data = box.get('dropOff');
          return Container(
            margin: EdgeInsets.only(top: 8),
            color: Color(0xffEBF1EF),
            padding: EdgeInsets.only(top: 15.0, left: 8, right: 16),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Home Address",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                Text('${userData['fullName']}'),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.80,
                          margin: EdgeInsets.only(top: 5.0),
                          child: Text(
                            '${data['address']}',
                            maxLines: null,
//                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5.0),
                          child: Text(
                            '${data['areaName']}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () async {
                        //                  addressDetails = await HiveMethods().getFoodLocationDetails();
                        selectDeliveryLocation(type: AddressType.dropOff);
                      },
                      child: Icon(
                        Icons.edit,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                Divider(),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      StreamBuilder<String>(
                          stream: dropOffNumberSteam.stream,
                          builder: (context, snapshot) {
                            if (snapshot.data == null) {
                              return Text('No Number Found');
                            }
                            dropOffNumber = int.parse(snapshot.data);
                            return Text(
                              '${snapshot.data}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            );
                          }),
                      InkWell(
                        onTap: () {
                          editPhoneNumber(type: 'dropOff');
                        },
                        child: Icon(
                          Icons.edit,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
