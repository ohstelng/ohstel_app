import 'package:Ohstel_app/explore/models/location.dart';
import 'package:Ohstel_app/utilities/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
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

  @override
  void initState() {
    formattedDate = DateFormat('E, MMM d, y').format(_selectedDate);
    formattedTime = DateFormat.jm().format(_selectedTime);
    super.initState();
  }

  _selectDate(context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
        formattedDate = DateFormat('E, MMM d, y').format(_selectedDate);
      });
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
      appBar: AppBar(
        title: Text(widget.location.name),
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
          Container(
            padding: EdgeInsets.only(
              left: 15,
              right: 15,
            ),
            color: Colors.green[50],
            child: ListTile(
              title: Text(formattedDate),
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
              title: Text(formattedTime),
              trailing: Icon(Icons.timer),
              onTap: () => _selectTime(context),
            ),
          ),
        ],
      ),
    );
  }
}
