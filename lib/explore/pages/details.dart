import 'package:Ohstel_app/auth/models/userModel.dart';
import 'package:Ohstel_app/explore/models/location.dart';
import 'package:Ohstel_app/explore/widgets/user_details_bottomsheet.dart';
import 'package:Ohstel_app/hive_methods/hive_class.dart';
import 'package:Ohstel_app/utilities/app_style.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class ExploreDetails extends StatefulWidget {
  final ExploreLocation location;
  ExploreDetails(this.location);
  @override
  _ExploreDetailsState createState() => _ExploreDetailsState();
}

class _ExploreDetailsState extends State<ExploreDetails> {
  DateTime _selectedDate = DateTime.now();
  DateTime _selectedTime = DateTime.now();
  String formattedDate;
  String formattedTime;
  int numberOfTickets = 1;
  UserModel user;
  int finalAmount;

  var formKey = GlobalKey<FormState>();
  String email;
  String name;
  String phone;
  String university;
  String department = "";

  bool isLoading = false;

  @override
  void initState() {
    formattedDate = DateFormat('E, MMM d, y').format(_selectedDate);
    formattedTime = DateFormat.jm().format(_selectedTime);
    finalAmount = widget.location.price * numberOfTickets;
    getUserData();
    super.initState();
  }

  getUserData() async {
    try {
      var userDetails = await HiveMethods().getUserData();
      user = UserModel.fromMap(userDetails);
    } catch (e) {
      print(e.toString());
    }
  }

  _selectDate(context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != _selectedDate) {
      DateTime _today = DateTime.now();
      if (picked.difference(_today).inDays < 0) {
        Fluttertoast.showToast(msg: 'You can\'t select past dates');
      } else {
        setState(() {
          _selectedDate = picked;
          formattedDate = DateFormat('E, MMM d, y').format(_selectedDate);
        });
      }
    }
  }

  _selectTime(context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedTime),
    );
    if (picked != null && picked != TimeOfDay.fromDateTime(_selectedTime))
      setState(() {
        DateTime now = DateTime.now();
        _selectedTime =
            DateTime(now.year, now.month, now.day, picked.hour, picked.minute);

        formattedTime = DateFormat.jm().format(_selectedTime);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          widget.location.name,
          style: TextStyle(fontFamily: 'Lato'),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20.0),
        children: [
          Text(
            'Tickets and prices',
            style: heading1,
          ),
          SizedBox(
            height: 20.0,
          ),
          Text(
            'When are you going?',
            style: heading2.copyWith(
              fontSize: 18.0,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            padding: EdgeInsets.only(
              left: 15,
              right: 15,
            ),
            color: Colors.green[50],
            child: ListTile(
              title: Text(
                formattedDate,
                style: body1,
              ),
              trailing: Icon(Icons.date_range),
              onTap: () => _selectDate(context),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            padding: EdgeInsets.only(
              left: 15,
              right: 15,
            ),
            color: Colors.green[50],
            child: ListTile(
              title: Text(
                formattedTime,
                style: body1,
              ),
              trailing: Icon(Icons.timer),
              onTap: () => _selectTime(context),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Text(
            'How many tickets?',
            style: heading2.copyWith(
              fontSize: 18.0,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            padding: EdgeInsets.only(
              left: 15,
              right: 15,
            ),
            color: Colors.green[50],
            child: Column(
              children: [
                ListTile(
                  title: Row(
                    children: [
                      Icon(Icons.timer),
                      SizedBox(width: 10.0),
                      Text(
                        'Duration: ${widget.location.duration} hours',
                        style: body1,
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: Text(
                    'Number of tickets',
                    style: body1,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: numberOfTickets > 1
                            ? () => setState(() {
                                  numberOfTickets--;
                                  finalAmount =
                                      widget.location.price * numberOfTickets;
                                })
                            : null,
                        child: Container(
                          width: 35.0,
                          height: 35.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: numberOfTickets > 1
                                ? Colors.white
                                : Colors.grey[300],
                          ),
                          child: Center(
                            child: Icon(
                              Icons.remove,
                              color: numberOfTickets > 1
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey[700],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      Text(
                        numberOfTickets.toString(),
                        style: body1,
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      GestureDetector(
                        onTap: () => setState(() {
                          numberOfTickets++;
                          finalAmount = widget.location.price * numberOfTickets;
                        }),
                        child: Container(
                          width: 35.0,
                          height: 35.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: Colors.white,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.add,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total',
                            style: body1,
                          ),
                          Text(
                            'NGN$finalAmount',
                            style: heading2,
                          ),
                        ],
                      ),
                      FlatButton(
                        color: Theme.of(context).primaryColor,
                        onPressed: () => showUserDetailsBottomSheet(
                          context,
                          scheduledDate: _selectedDate,
                          scheduledTime: _selectedTime,
                          finalAmount: finalAmount,
                          location: widget.location,
                          numberOfTickets: numberOfTickets,
                          user: user,
                        ),
                        child: Text(
                          'Next',
                          style: body1.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
