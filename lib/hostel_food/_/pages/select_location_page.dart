import 'dart:convert';

import 'package:Ohstel_app/constant/constant.dart';
import 'package:Ohstel_app/hive_methods/hive_class.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

enum AddressType { pickUp, dropOff }

class SelectDeliveryLocationPage extends StatefulWidget {
  final AddressType type;

  SelectDeliveryLocationPage({this.type});

  @override
  _SelectDeliveryLocationPageState createState() =>
      _SelectDeliveryLocationPageState();
}

class _SelectDeliveryLocationPageState
    extends State<SelectDeliveryLocationPage> {

  bool onCampus = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFFF27507),
//          backgroundColor: Colors.teal,
            elevation: 0.0,
            leading: Container(),
            centerTitle: true,
            title: Text('Select Location'),
            bottom: TabBar(
              indicatorColor: Colors.white,
              indicatorWeight: 5,
              onTap: (index) {
                print(index);
                if (index == 0) {
                  onCampus = true;
                } else if (index == 1) {
                  onCampus = false;
                }
              },
              tabs: [
                Tab(text: "On Campus"),
                Tab(text: "Off Campus"),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Container(
                child: OnCampusLocation(type: widget.type),
              ),
              Container(
                child: OffCampusLocation(type: widget.type),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OffCampusLocation extends StatefulWidget {
  final AddressType type;

  OffCampusLocation({this.type});

  @override
  _OffCampusLocationState createState() => _OffCampusLocationState();
}

class _OffCampusLocationState extends State<OffCampusLocation> {
  TextEditingController controller = TextEditingController();
  String address;
  String _areaName = 'Selected Area Name';

  Future<Map> getAreaNamesFromApi() async {
    String uniName = await HiveMethods().getUniName();
    String url = baseApiUrl+'/food_api/$uniName';
    var response = await http.get(url);
    Map data = json.decode(response.body);

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15.0),
      child: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 40),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
            child: ExpansionTile(
              key: GlobalKey(),
              title: Text('$_areaName'),
              leading: Icon(Icons.location_on),
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * .30,
                  child: FutureBuilder(
                    future: getAreaNamesFromApi(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        List areaNameList = snapshot.data['areaNames'];
                        return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: areaNameList.length,
                          itemBuilder: (context, index) {
                            String currentAreaName = areaNameList[index];
                            return InkWell(
                              onTap: () {
                                if (mounted) {
                                  setState(() {
                                    _areaName = currentAreaName;
                                  });
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.all(5.0),
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.add_location,
                                      color: Colors.grey,
                                    ),
                                    Text(
                                      '$currentAreaName',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w400),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          TextField(
            decoration: InputDecoration(hintText: 'Enter Your Location'),
            controller: controller,
            textInputAction: TextInputAction.done,
            autocorrect: true,
            maxLength: 250,
            maxLines: null,
            onChanged: (val) {
              address = val;
            },
            onSubmitted: (val) {
              print(val);
            },
          ),
          FlatButton(
            color: Color(0xFFF27507),
            onPressed: () {
              if (address != null && address.length > 3) {
                Map addressDetails = {
                  'address': address,
                  'areaName': _areaName,
                  'onCampus': false,
                };
                print(addressDetails);

                if (widget.type == null) {
                  HiveMethods()
                      .saveFoodLocationDetailsToDb(map: addressDetails);
                } else {
                  if (widget.type == AddressType.pickUp) {
                    HiveMethods().saveToLaundryPickUpBox(data: addressDetails);
                  } else if (widget.type == AddressType.dropOff) {
                    HiveMethods().saveToLaundryDropBox(data: addressDetails);
                  }
                }
                Navigator.pop(context);
              } else {
                Fluttertoast.showToast(msg: 'Please Fill All Input!');
              }
            },
            child: Text(
              'Submit',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}

class OnCampusLocation extends StatefulWidget {
  final AddressType type;

  OnCampusLocation({this.type});

  @override
  _OnCampusLocationState createState() => _OnCampusLocationState();
}

class _OnCampusLocationState extends State<OnCampusLocation> {
  TextEditingController controller = TextEditingController();
  String address;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            decoration: InputDecoration(hintText: 'Enter Your Location'),
            controller: controller,
            textInputAction: TextInputAction.done,
            autocorrect: true,
            maxLength: 250,
            maxLines: null,
            onChanged: (val) {
              address = val;
            },
            onSubmitted: (val) {
              print(val);
            },
          ),
          Container(
            width: double.infinity,
            child: FlatButton(
              color: Color(0xFFF27507),
              onPressed: () async {
                if (address != null && address.length > 3) {
                  Map addressDetails = {
                    'address': address,
                    'areaName': 'onCampus',
                    'onCampus': true,
                  };
                  print(addressDetails);
                  if (widget.type == null) {
                    await HiveMethods().saveFoodLocationDetailsToDb(map: addressDetails);
                  } else {
                    if (widget.type == AddressType.pickUp) {
                      await HiveMethods()
                          .saveToLaundryPickUpBox(data: addressDetails);
                    } else if (widget.type == AddressType.dropOff) {
                      await HiveMethods().saveToLaundryDropBox(data: addressDetails);
                    }
                  }
                  Navigator.pop(context);
                }
              },
              child: Text(
                'Submit',
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
