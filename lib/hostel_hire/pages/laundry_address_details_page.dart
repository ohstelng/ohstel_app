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

//
//class LaundryAddressDetailsPage extends StatefulWidget {
//  @override
//  _LaundryAddressDetailsPageState createState() =>
//      _LaundryAddressDetailsPageState();
//}
//
//class _LaundryAddressDetailsPageState extends State<LaundryAddressDetailsPage> {
//  StreamController<String> pickUpNumberStream =
//      StreamController<String>.broadcast();
//  StreamController<String> dropOffNumberStream =
//      StreamController<String>.broadcast();
//  Box<Map> laundryAddressBox;
//  int pickUpNumber;
//  int dropOffNumber;
//  Map userData;
//  bool loading = true;
//  Map addressDetails;
//  DateTime pickUpDate;
//  TimeOfDay pickUpTime;
//
//  @override
//  void initState() {
//    super.initState();
//    getBox();
//  }
//
//// Function to initialise boxes and data
//  Future<void> getBox() async {
//    laundryAddressBox = await HiveMethods().getOpenBox('laundryAddressBox');
//    userData = await HiveMethods().getUserData();
//
//    if (mounted)
//      setState(() {
//        loading = false;
//      });
//  }
//
//  ///Function to select pick up date
//  void pickDate() async {
//    DateTime date = await showDatePicker(
//      context: context,
//      firstDate: DateTime(DateTime.now().year),
//      lastDate: DateTime(DateTime.now().year + 1),
//      initialDate: DateTime.now(),
//      errorInvalidText: 'Error',
//    );
//    if (date != null)
//      setState(() {
//        pickUpDate = date;
//      });
//  }
//
//  ///Function to select pickUpTime
//  void pickTime() async {
//    TimeOfDay t = await showTimePicker(
//      context: context,
//      initialTime: TimeOfDay.now(),
//    );
//    if (t != null)
//      setState(() {
//        pickUpTime = t;
//      });
//  }
//
////  void selectAnAddress({@required AddressType type}) {
////    showDialog(
////      barrierDismissible: false,
////      context: context,
////      builder: (BuildContext context) {
////        return AlertDialog(
////          contentPadding: EdgeInsets.all(5.0),
////          content: Builder(builder: (context) {
////            var height = MediaQuery.of(context).size.height;
////            var width = MediaQuery.of(context).size.width;
////
////            return Container(
////              height: height * .70,
////              width: width,
////              child: SelectDeliveryLocationPage(type: type),
////            );
////          }),
////        );
////      },
////    );
////  }
//
//  @override
//  void dispose() {
//    dropOffNumberStream.close();
//    pickUpNumberStream.close();
//    super.dispose();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      backgroundColor: Color(0xFFFDFDFD),
//      appBar: AppBar(
//        automaticallyImplyLeading: true,
//        iconTheme: IconThemeData(
//          color: midnightExpress,
//          size: 24,
//        ),
//        elevation: 0,
//        backgroundColor: Colors.transparent,
//        bottom: PreferredSize(
//            child: Container(
//              padding: const EdgeInsets.symmetric(horizontal: 16.0),
//              alignment: Alignment.centerLeft,
//              child: Text(
//                'Delivery Details',
//                style: heading2,
//              ),
//            ),
//            preferredSize: Size.fromHeight(32)),
//      ),
//      body: loading
//          ? Center(
//              child: CircularProgressIndicator(),
//            )
//          : SingleChildScrollView(
//              child: Padding(
//                padding:
//                    const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
//                child: Column(
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  children: [
//                    Text(
//                      'Pick Up Details',
//                      style: pageTitle,
//                    ),
//                    SizedBox(height: 8),
//                    Row(
//                      crossAxisAlignment: CrossAxisAlignment.start,
//                      children: [
//                        Expanded(
//                          child: InkWell(
//                            onTap: pickDate,
//                            child: Container(
//                              height: 40,
//                              padding: const EdgeInsets.only(left: 16),
//                              margin: const EdgeInsets.only(right: 12.0),
//                              decoration: BoxDecoration(
//                                borderRadius: BorderRadius.circular(6),
//                                border: Border.all(
//                                  color: textAnteBlack,
//                                ),
//                              ),
//                              child: Row(
//                                children: [
//                                  Expanded(
//                                    child: pickUpDate == null
//                                        ? Text(
//                                            'Date: Not Set',
//                                          )
//                                        : Text(
//                                            '$pickUpDate',
////                                            "${formatDate(pickUpDate, [
////                                              d,
////                                              ', ',
////                                              MM,
////                                              ' ',
////                                              yyyy
////                                            ])}",
//                                            overflow: TextOverflow.ellipsis,
//                                            maxLines: 1,
//                                          ),
//                                  ),
//                                  Icon(
//                                    Icons.arrow_drop_down,
//                                    color: textAnteBlack,
//                                    size: 24,
//                                  ),
//                                ],
//                              ),
//                            ),
//                          ),
//                        ),
//                        Expanded(
//                          child: InkWell(
//                            onTap: pickTime,
//                            child: Container(
//                              height: 40,
//                              padding: const EdgeInsets.only(left: 16),
//                              margin: const EdgeInsets.only(right: 12.0),
//                              decoration: BoxDecoration(
//                                borderRadius: BorderRadius.circular(6),
//                                border: Border.all(
//                                  color: textAnteBlack,
//                                ),
//                              ),
//                              child: Row(
//                                children: [
//                                  Expanded(
//                                    child: pickUpTime == null
//                                        ? Text('Time: Not Set')
//                                        : Text(
//                                            "${pickUpTime.hourOfPeriod}:${pickUpTime.minute} ${pickUpTime.period == DayPeriod.am ? 'AM' : 'PM'}",
//                                          ),
//                                  ),
//                                  Icon(
//                                    Icons.arrow_drop_down,
//                                    color: textAnteBlack,
//                                    size: 24,
//                                  ),
//                                ],
//                              ),
//                            ),
//                          ),
//                        ),
//                      ],
//                    ),
//                    Container(
//                      constraints:
//                          BoxConstraints(maxHeight: 100, minHeight: 50),
//                      decoration: BoxDecoration(
//                        color: Color(0xFFEBF1EF),
//                        borderRadius: BorderRadius.circular(6),
//                      ),
//                      margin: const EdgeInsets.only(bottom: 56, top: 16),
//                      padding: const EdgeInsets.all(8),
//                      child: ValueListenableBuilder(
//                          valueListenable: laundryAddressBox.listenable(),
//                          builder: (context, Box box, _) {
//                            return Stack(
//                              children: [
//                                Positioned(
//                                  right: 32,
//                                  left: 0,
//                                  bottom: 0,
//                                  top: 0,
//                                  child: Column(
//                                    crossAxisAlignment:
//                                        CrossAxisAlignment.start,
//                                    children: (box.values.isEmpty ||
//                                            !box.containsKey('pickUp'))
//                                        ? [Text('No Address Found')]
//                                        : [
//                                            Text(
//                                              'Home Address',
//                                              style: pageTitle,
//                                            ),
//                                            SizedBox(height: 16),
//                                            Flexible(
//                                              child: NotificationListener(
//                                                onNotification:
//                                                    (OverscrollIndicatorNotification
//                                                        notif) {
//                                                  notif.disallowGlow();
//                                                  return true;
//                                                },
//                                                child: SingleChildScrollView(
//                                                  child: Text(
//                                                    '${box.get('pickUp')['address']}, ${box.get('pickUp')['areaName']}',
//                                                    style: body1.copyWith(
//                                                      fontWeight:
//                                                          FontWeight.w300,
//                                                    ),
//                                                  ),
//                                                ),
//                                              ),
//                                            ),
//                                          ],
//                                  ),
//                                ),
//                                Positioned(
//                                  top: 0,
//                                  right: 0,
//                                  child: (box.values.isEmpty ||
//                                          !box.containsKey('pickUp'))
//                                      ? Icon(
//                                          Icons.cancel,
//                                          color: midnightExpress,
//                                          size: 24,
//                                        )
//                                      : Icon(
//                                          Icons.check_circle,
//                                          color: childeanFire,
//                                          size: 24,
//                                        ),
//                                ),
//                                Positioned(
//                                  bottom: 0,
//                                  right: 0,
//                                  child: IconButton(
//                                    onPressed: () {
////                                      selectAnAddress(type: AddressType.pickUp);
//                                    },
//                                    icon: Icon(
//                                      Icons.edit,
//                                      size: 20,
//                                      color: Color(0xFF62666E),
//                                    ),
//                                    constraints:
//                                        BoxConstraints.tight(Size(24, 24)),
//                                    padding: const EdgeInsets.all(0),
//                                  ),
//                                )
//                              ],
//                            );
//                          }),
//                    ),
//                    Text(
//                      'Drop Off Details',
//                      style: pageTitle,
//                    ),
//                    SizedBox(height: 8),
//                    Row(
//                      crossAxisAlignment: CrossAxisAlignment.start,
//                      children: [
//                        Expanded(
//                          child: Container(
//                            height: 40,
//                            margin: const EdgeInsets.only(right: 12.0),
//                            decoration: BoxDecoration(
//                              borderRadius: BorderRadius.circular(6),
//                              border: Border.all(
//                                color: textAnteBlack,
//                              ),
//                            ),
//                            child: InkWell(
//                              onTap: () {},
//                              child: Row(
//                                children: [
//                                  Expanded(
//                                    child: Placeholder(),
//                                  ),
//                                  Icon(
//                                    Icons.arrow_drop_down,
//                                    color: textAnteBlack,
//                                    size: 24,
//                                  ),
//                                ],
//                              ),
//                            ),
//                          ),
//                        ),
//                        Expanded(
//                          child: Container(
//                            height: 40,
//                            margin: const EdgeInsets.only(right: 12.0),
//                            decoration: BoxDecoration(
//                              borderRadius: BorderRadius.circular(6),
//                              border: Border.all(
//                                color: textAnteBlack,
//                              ),
//                            ),
//                            alignment: Alignment.center,
//                            child: InkWell(
//                              onTap: () {},
//                              child: Text('Tomorrow (+ N550)'),
//                            ),
//                          ),
//                        ),
//                      ],
//                    ),
//                    Container(
//                      constraints:
//                          BoxConstraints(maxHeight: 100, minHeight: 50),
//                      decoration: BoxDecoration(
//                        color: Color(0xFFEBF1EF),
//                        borderRadius: BorderRadius.circular(6),
//                      ),
//                      margin: const EdgeInsets.symmetric(vertical: 16),
//                      padding: const EdgeInsets.all(8),
//                      child: ValueListenableBuilder(
//                        valueListenable: laundryAddressBox.listenable(),
//                        builder: (context, Box box, _) {
//                          return Stack(
//                            children: [
//                              Positioned(
//                                right: 32,
//                                left: 0,
//                                bottom: 0,
//                                top: 0,
//                                child: Column(
//                                  crossAxisAlignment: CrossAxisAlignment.start,
//                                  children: (box.values.isEmpty ||
//                                          !box.containsKey('dropOff'))
//                                      ? [Text('No Address Found')]
//                                      : [
//                                          Text(
//                                            'Home Address',
//                                            style: pageTitle,
//                                          ),
//                                          SizedBox(height: 16),
//                                          Flexible(
//                                            child: NotificationListener(
//                                              onNotification:
//                                                  (OverscrollIndicatorNotification
//                                                      notif) {
//                                                notif.disallowGlow();
//                                                return true;
//                                              },
//                                              child: SingleChildScrollView(
//                                                child: Text(
//                                                  '${box.get('dropOff')['address']}, ${box.get('dropOff')['areaName']}',
//                                                  style: body1.copyWith(
//                                                    fontWeight: FontWeight.w300,
//                                                  ),
//                                                ),
//                                              ),
//                                            ),
//                                          ),
//                                        ],
//                                ),
//                              ),
//                              Positioned(
//                                top: 0,
//                                right: 0,
//                                child: (box.values.isEmpty ||
//                                        !box.containsKey('dropOff'))
//                                    ? Icon(
//                                        Icons.cancel,
//                                        color: midnightExpress,
//                                        size: 24,
//                                      )
//                                    : Icon(
//                                        Icons.check_circle,
//                                        color: childeanFire,
//                                        size: 24,
//                                      ),
//                              ),
//                              Positioned(
//                                bottom: 0,
//                                right: 0,
//                                child: IconButton(
//                                  onPressed: () {
////                                    selectAnAddress(type: AddressType.dropOff);
//                                  },
//                                  icon: Icon(
//                                    Icons.edit,
//                                    size: 20,
//                                    color: Color(0xFF62666E),
//                                  ),
//                                  constraints:
//                                      BoxConstraints.tight(Size(24, 24)),
//                                  padding: const EdgeInsets.all(0),
//                                ),
//                              )
//                            ],
//                          );
//                        },
//                      ),
//                    ),
//                  ],
//                ),
//              ),
//            ),
//      bottomNavigationBar: Padding(
//        padding: const EdgeInsets.only(bottom: 16.0),
//        child: CustomLongButton(
//          label: 'Place Order',
//          onTap: () {
//            Map pickUpData = laundryAddressBox.get('pickUp');
//            Map dropOffData = laundryAddressBox.get('dropOff');
//
//            if ((pickUpData?.isNotEmpty ?? false) &&
//                (dropOffData?.isNotEmpty ?? false) &&
//                // pickUpNumber != null &&
//                // dropOffNumber != null &&
//                pickUpDate != null &&
//                pickUpTime != null) {
//              if (pickUpDate.month <= DateTime.now().month &&
//                  pickUpDate.day <= DateTime.now().day) {
//                Fluttertoast.showToast(
//                    msg: 'Choose A Date One Day From Today!!');
//                return;
//              }
//
//              LaundryAddressDetailsModel laundryAddressDetails =
//                  LaundryAddressDetailsModel(
//                pickUpDate: pickUpDate.toString(),
//                pickUpTime: pickUpTime.format(context).toString(),
//                pickUpAddress: pickUpData,
//                dropOffAddress: dropOffData,
//                dropOffNumber: dropOffNumber.toString(),
//                pickUpNumber: pickUpNumber.toString(),
//              );
//
//              print(laundryAddressDetails.toMap());
//              print(pickUpDate.month);
//              Navigator.of(context).push(
//                MaterialPageRoute(
//                  builder: (context) => LaundryPaymentPage(
//                    laundryAddressDetails: laundryAddressDetails,
//                  ),
//                ),
//              );
//            } else {
//              Fluttertoast.showToast(
//                  msg: 'Empty fields! Please fill all inputs');
//            }
//          },
//        ),
//      ),
//    );
//  }
//}

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

  bool buttonState = false;

  @override
  void initState() {
    getBox();
    //    pickUpDate = DateTime.now();
    //    pickUpTime = TimeOfDay.now();
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
          Map pickUpData = laundryAddressBox.get('pickUp');
          Map dropOffData = laundryAddressBox.get('dropOff');

          if (pickUpData.isNotEmpty &&
              dropOffData.isNotEmpty &&
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
            child: Container(
              child: Center(
                child: Text('No Pick Up Adress Found!!'),
              ),
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
                Text("Home Address",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                SizedBox(height: 8,),
                Text('${userData['fullName']}'),
                Row(
                  children: [
                    Column(
                      children: [
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
            child: Container(
              margin: EdgeInsets.all(15.0),
              child: Center(
                child: Text('No Drop Off Address Found!!'),
              ),
            ),
          );
        } else {
          //          Map data = box.get('pickUp');
          Map data = box.get('dropOff');
          return Container(
            margin: EdgeInsets.only(top: 8),
            color: Color(0xffEBF1EF),
            padding: EdgeInsets.only(top:15.0,left: 8,right: 16),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Home Address",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                SizedBox(height: 8,),
                Text('${userData['fullName']}'),
                Row(
                  children: [
                    Column(
                      children: [
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
                      ],
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () async {
                        //                  addressDetails = await HiveMethods().getFoodLocationDetails();
                        selectDeliveryLocation(type: AddressType.dropOff);
                      },
                      child: Icon(Icons.edit, size: 20,),
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
                        child: Icon(Icons.edit, size: 20,),
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
