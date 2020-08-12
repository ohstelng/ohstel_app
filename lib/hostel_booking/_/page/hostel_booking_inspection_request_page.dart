import 'package:Ohstel_app/hive_methods/hive_class.dart';
import 'package:Ohstel_app/hostel_booking/_/methods/hostel_booking_methods.dart';
import 'package:Ohstel_app/hostel_booking/_/model/hostel_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HostelBookingInspectionRequestPage extends StatefulWidget {
  final HostelModel hostelModel;

  HostelBookingInspectionRequestPage({@required this.hostelModel});

  @override
  _HostelBookingInspectionRequestPageState createState() =>
      _HostelBookingInspectionRequestPageState();
}

class _HostelBookingInspectionRequestPageState
    extends State<HostelBookingInspectionRequestPage> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  Map userData;
  String fullName;
  String email;
  String phoneNumber;
  String date = "Not set";
  String time = "Not set";
  bool isSending = false;

  Future<void> getUserData() async {
    Map data = await HiveMethods().getUserData();
    print(data);
    userData = data;
    setState(() {
      setInitialInfo();
    });
  }

  void setInitialInfo() {
    fullNameController.text = userData['fullName'];
    print(fullNameController.text);
    emailController.text = userData['email'];
    phoneNumberController.text = userData['phoneNumber'];
  }

  Future<void> validateAndSave() async {
    fullName = fullNameController.text.trim();
    phoneNumber = phoneNumberController.text.trim();
    email = emailController.text.trim();

    if (fullName != null &&
        email != null &&
        phoneNumber != null &&
        date != 'Not set' &&
        time != 'Not set') {
      print('pass');

      if (mounted) {
        setState(() {
          isSending = true;
        });
      }

      int result = await HostelBookingMethods().saveBookingInspectionDetails(
        fullName: fullName,
        phoneNumber: phoneNumber,
        email: email,
        date: date,
        time: time,
        hostelDetails: widget.hostelModel,
      );

      if (result == 0) {
        Fluttertoast.showToast(
          msg: 'Sent Sucessfully!!',
          gravity: ToastGravity.CENTER,
        );
        if (mounted) {
          setState(() {
            isSending = false;
          });
        }
        Navigator.of(context).pop();
      } else {
        if (mounted) {
          setState(() {
            isSending = false;
          });
        }
        Fluttertoast.showToast(
          msg: 'An Error Occur :(',
          gravity: ToastGravity.CENTER,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: 'Make Sure All Field Above Are Filled',
        gravity: ToastGravity.CENTER,
      );
    }
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(),
      body: Column(
        children: <Widget>[
          Expanded(child: _body()),
          saveButton(),
        ],
      ),
    );
  }

  Widget saveButton() {
    return Container(
      margin: EdgeInsets.fromLTRB(30, 10, 30, 10),
      child: FlatButton(
        color: Theme.of(context).primaryColor,
        onPressed: () {
          validateAndSave();
        },
        child: Center(
          child: Text(
            'Save',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _body() {
    return ListView(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(30, 10, 30, 10),
          child: TextField(
            controller: fullNameController,
            textInputAction: TextInputAction.done,
            autocorrect: true,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
                border: OutlineInputBorder(), hintText: 'Full Name'),
            onChanged: (text) {
              print(text);
            },
            onSubmitted: (value) {
              fullName = fullNameController.text.trim();
              print(fullName);
            },
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(30, 10, 30, 10),
          child: TextField(
            controller: emailController,
            textInputAction: TextInputAction.done,
            autocorrect: true,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
                border: OutlineInputBorder(), hintText: 'Email'),
            onChanged: (text) {
              print(text);
            },
            onSubmitted: (value) {
              email = emailController.text.trim();
              print('EEEEEEEEEEEEEEEEEE $email');
            },
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(30, 10, 30, 10),
          child: TextField(
            controller: phoneNumberController,
            textInputAction: TextInputAction.done,
            autocorrect: true,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
                border: OutlineInputBorder(), hintText: 'Phone Number'),
            onChanged: (text) {
              print(text);
            },
            onSubmitted: (value) {
              phoneNumber = phoneNumberController.text.trim();
              print('PPPPPPPPPPPPPPPP $phoneNumber');
            },
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(30, 10, 30, 10),
          child: RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            elevation: 4.0,
            onPressed: () {
              DatePicker.showDatePicker(
                context,
                theme: DatePickerTheme(
                  containerHeight: 210.0,
                ),
                showTitleActions: true,
                minTime: DateTime.now(),
                maxTime: DateTime.now().add(Duration(days: 365)),
                onConfirm: (_date) {
                  print('confirm $_date');
                  date = '${_date.year} - ${_date.month} - ${_date.day}';
                  setState(() {});
                },
                currentTime: DateTime.now(),
                locale: LocaleType.en,
              );
            },
            child: Container(
              alignment: Alignment.center,
              height: 50.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.date_range,
                              size: 18.0,
                              color: Colors.teal,
                            ),
                            Text(
                              " $date",
                              style: TextStyle(
                                  color: Colors.teal,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Text(
                    "  Change",
                    style: TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0),
                  ),
                ],
              ),
            ),
            color: Colors.white,
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(30, 10, 30, 10),
          child: RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            elevation: 4.0,
            onPressed: () {
              DatePicker.showTimePicker(
                context,
                theme: DatePickerTheme(containerHeight: 210.0),
                showTitleActions: true,
                showSecondsColumn: false,
                onConfirm: (_time) {
                  print('confirm $_time');
                  if (_time.hour <= 7 ||
                      (_time.hour >= 18 && _time.minute >= 0)) {
                    Fluttertoast.showToast(
                      msg:
                          'Inspection Time Should Be Between 8am - 6pm(07 - 18)',
                      gravity: ToastGravity.CENTER,
                    );
                  } else {
                    time = '${_time.hour} : ${_time.minute} : ${_time.second}';
                    setState(() {});
                  }
                },
                currentTime: DateTime.now(),
                locale: LocaleType.en,
              );
              setState(() {});
            },
            child: Container(
              alignment: Alignment.center,
              height: 50.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.access_time,
                              size: 18.0,
                              color: Colors.teal,
                            ),
                            Text(
                              " $time",
                              style: TextStyle(
                                  color: Colors.teal,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Text(
                    "  Change",
                    style: TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0),
                  ),
                ],
              ),
            ),
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _appbar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.0,
      centerTitle: true,
      title: Text(
        'Request For Inspection',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
      ),
    );
  }
}
