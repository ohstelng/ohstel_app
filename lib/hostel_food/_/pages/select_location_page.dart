import 'dart:convert';

import 'package:Ohstel_app/hive_methods/hive_class.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class SelectDeliveryLocationPage extends StatefulWidget {
  @override
  _SelectDeliveryLocationPageState createState() =>
      _SelectDeliveryLocationPageState();
}

class _SelectDeliveryLocationPageState
    extends State<SelectDeliveryLocationPage> {
  bool onCampus = true;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
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
              child: OnCampusLocation(),
            ),
            Container(
              child: OffCampusLocation(),
            ),
          ],
        ),
      ),
    );
  }
}

class OffCampusLocation extends StatefulWidget {
  @override
  _OffCampusLocationState createState() => _OffCampusLocationState();
}

class _OffCampusLocationState extends State<OffCampusLocation> {
  TextEditingController controller = TextEditingController();
  String address;
  String _areaName = 'Selected Area Name';

  Future<Map> getAreaNamesFromApi() async {
//    String uniName = await HiveMethods().getUniName();
    String url = 'https://quiz-demo-de79d.appspot.com/food_api/unilorin';
    var response = await http.get(url);
    Map data = json.decode(response.body);

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                  HiveMethods()
                      .saveFoodLocationDetailsToDb(map: addressDetails);
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
      ),
    );
  }
}

class OnCampusLocation extends StatefulWidget {
  @override
  _OnCampusLocationState createState() => _OnCampusLocationState();
}

class _OnCampusLocationState extends State<OnCampusLocation> {
  TextEditingController controller = TextEditingController();
  String address;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(15.0),
        child: Column(
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
                onPressed: () {
                  if (address != null && address.length > 3) {
                    Map addressDetails = {
                      'address': address,
                      'areaName': 'inside campus',
                      'onCampus': true,
                    };
                    print(addressDetails);
                    HiveMethods()
                        .saveFoodLocationDetailsToDb(map: addressDetails);
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
      ),
    );
  }
}
