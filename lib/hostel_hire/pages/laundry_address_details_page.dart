import 'dart:async';

import 'package:Ohstel_app/hive_methods/hive_class.dart';
import 'package:Ohstel_app/hostel_food/_/pages/select_location_page.dart';
import 'package:Ohstel_app/hostel_hire/model/laundry_address_details_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'file:///C:/Users/olamilekan/flutter_projects/work_space/Ohstel_app/lib/hostel_hire/pages/laundry_payment_page.dart';

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
  DateTime pickedDate;
  TimeOfDay time;

  void selectDeliveryLocation({@required String type}) {
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
                  color: Colors.green,
                  child: Text('Submit'),
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
//    numberSteam.add(userData['phoneNumber']);
//    userDataBox = await HiveMethods().getOpenBox('userDataBox');
//    addressDetailsBox = await HiveMethods().getOpenBox('addressBox');
//    print(data);
//    userData = data;

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
        pickedDate = date;
      });
  }

  void pickTime() async {
    TimeOfDay t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (t != null)
      setState(() {
        time = t;
      });
  }

  @override
  void initState() {
    getBox();
//    pickedDate = DateTime.now();
//    time = TimeOfDay.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: ListView(
                children: [
                  Center(child: Text('Address Details')),
                  pickUpDetailsWidget(),
                  SizedBox(height: 50),
                  dropOffDetailsWidget(),
                  SizedBox(height: 20),
                  button()
                ],
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
    return FlatButton(
      child: Text('Proceed'),
      color: Colors.orange,
      onPressed: () {
        Map pickUpData = laundryAddressBox.get('pickUp');
        Map dropOffData = laundryAddressBox.get('dropOff');

        if (pickUpData != null &&
            dropOffData != null &&
            pickUpNumber != null &&
            dropOffNumber != null &&
            pickedDate != null &&
            time != null) {
          if (pickedDate.month <= DateTime.now().month &&
              pickedDate.day <= DateTime.now().day) {
            Fluttertoast.showToast(msg: 'Choose A Date One Day From Today!!');
            return;
          }

          LaundryAddressDetailsModel laundryAddressDetails =
              LaundryAddressDetailsModel(
            pickUpDate: pickedDate.toString(),
            pickUpTime: time.format(context).toString(),
            pickUpAddress: pickUpData,
            dropOffAddress: dropOffData,
            dropOffNumber: dropOffNumber.toString(),
            pickUpNumber: pickUpNumber.toString(),
          );

          print(laundryAddressDetails.toMap());
          print(pickedDate.month);
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
      },
    );
  }

  Widget pickUpDetailsWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        pickUpAddress(),
        datePicker(),
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
              border: Border.all(color: Colors.black),
            ),
            child: ListTile(
              title: pickedDate == null
                  ? Text('Date: Not Set')
                  : Text(
                      "Date: ${pickedDate.year}, ${pickedDate.month}, ${pickedDate.day}"),
              trailing: Icon(Icons.keyboard_arrow_down),
              onTap: pickDate,
            ),
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
            child: ListTile(
              title: time == null
                  ? Text('Time: Not Set')
                  : Text("Time: ${time.hour}:${time.minute}"),
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
      margin: EdgeInsets.all(10.0),
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Pick-Up Adress Details'),
              FlatButton(
                color: Colors.grey[300],
                onPressed: () async {
//                  addressDetails = await HiveMethods().getFoodLocationDetails();
                  selectDeliveryLocation(type: 'pickUp');
                },
                child: Text('Edit'),
              ),
            ],
          ),
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
            child: Container(
              margin: EdgeInsets.all(15.0),
              child: Center(
                child: Text('No Pick Up Adress Found!!'),
              ),
            ),
          );
        } else {
          Map data = box.get('pickUp');
//          Map data = box.get('dropOff');
          return Card(
            elevation: 2.5,
            child: Container(
              padding: EdgeInsets.all(15.0),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('${userData['fullName']}'),
                  Container(
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
                  ),
                  Divider(),
                  Container(
                    margin: EdgeInsets.only(top: 15.0),
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
                        Container(
                          padding: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: InkWell(
                            onTap: () {
                              editPhoneNumber(type: 'pickUp');
                            },
                            child: Text('Edit'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget dropOffAddress() {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Drop-Off Adress Details'),
              FlatButton(
                color: Colors.grey[300],
                onPressed: () async {
//                  addressDetails = await HiveMethods().getFoodLocationDetails();
                  selectDeliveryLocation(type: 'dropOff');
                },
                child: Text('Edit'),
              ),
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
            child: Container(
              margin: EdgeInsets.all(15.0),
              child: Center(
                child: Text('No Drop Off Adress Found!!'),
              ),
            ),
          );
        } else {
//          Map data = box.get('pickUp');
          Map data = box.get('dropOff');
          return Card(
            elevation: 2.5,
            child: Container(
              padding: EdgeInsets.all(15.0),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('${userData['fullName']}'),
                  Container(
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
                  ),
                  Divider(),
                  Container(
                    margin: EdgeInsets.only(top: 15.0),
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
                        Container(
                          padding: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: InkWell(
                            onTap: () {
                              editPhoneNumber(type: 'dropOff');
                            },
                            child: Text('Edit'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
