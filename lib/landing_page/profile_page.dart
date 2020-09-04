import 'dart:convert';
import 'dart:io';

import 'package:Ohstel_app/auth/methods/auth_database_methods.dart';
import 'package:Ohstel_app/auth/methods/auth_methods.dart';
import 'package:Ohstel_app/auth/models/userModel.dart';
import 'package:Ohstel_app/hive_methods/hive_class.dart';
import 'package:Ohstel_app/landing_page/homepage.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isLoading = true;
  Map userData;
  AuthDatabaseMethods auth = AuthDatabaseMethods();
  bool isUpdatingPic = false;

  Future<void> getUserData() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
    });
    userData = await HiveMethods().getUserData();
    setState(() {
      isLoading = false;
    });
  }

  Future pickImage() async {
    File _image;

    if (!mounted) return;

    setState(() {
      isUpdatingPic = true;
    });

    await ImagePicker()
        .getImage(source: ImageSource.gallery)
        .then((image) async {
      _image = File(image.path);
      String imageUrl = await auth.uploadFile(image: _image);
      auth.updateProfilePic(
        uid: userData['uid'],
        url: imageUrl,
      );

      Map _userData = await HiveMethods().getUserData();
      _userData['profilePicUrl'] = imageUrl;
      AuthService().saveUserDataToDb(userData: _userData);
      userData = _userData;

      setState(() {
        isUpdatingPic = false;
      });
    });

    setState(() {
      isUpdatingPic = false;
    });
  }

  void editingController({@required int index}) {
    if (index == 0) {
      _showEditPhoneNumberDailog();
    } else if (index == 1) {
      _showEditUniDailog();
    }
  }

  void _showEditPhoneNumberDailog() {
    String phoneNumber;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Edit PhoneNumber'),
            content: TextField(
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.number,
              maxLength: 30,
              maxLines: null,
              onChanged: (val) {
                phoneNumber = val;
              },
            ),
            actions: [
              FlatButton(
                onPressed: () async {
                  print(phoneNumber);
                  Navigator.pop(context);

                  await auth.updateUserPhoneNumber(
                    uid: userData['uid'],
                    phoneNumber: phoneNumber,
                  );

                  Map _userData = await HiveMethods().getUserData();
                  _userData['phoneNumber'] = phoneNumber;
                  AuthService().saveUserDataToDb(userData: _userData);
                  userData = _userData;
                  setState(() {});

                  Fluttertoast.showToast(msg: 'Phone Number Update!');
                },
                child: Text('Submit'),
              ),
            ],
          );
        });
  }

  void _showEditUniDailog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Uni'),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.55,
            child: FutureBuilder(
              future: getUniList(),
              builder: (context, snapshot) {
                print(snapshot.data);
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                print(snapshot.data);
                Map data = snapshot.data;
                return Container(
                  width: double.maxFinite,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      List<String> uniList = data.keys.toList();
                      uniList.sort();
                      Map currentUniDetails = data[uniList[index]];

                      return Column(
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(left: 10.0, right: 10.0),
                              child: ListTile(
                                onTap: () {
                                  print(currentUniDetails);
                                  updateUni(uniDetails: currentUniDetails);
                                },
                                title: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.grey,
                                    ),
                                    Expanded(
                                      child: Text(
                                        '${currentUniDetails['name']}',
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Text(
                                  '${currentUniDetails['abbr']}',
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.grey,
                                  ),
                                ),
                              )),
                          Divider(),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> updateUni({@required Map uniDetails}) async {
    await auth.updateUserUniversity(
      uid: userData['uid'],
      uniDetail: uniDetails,
    );

    Navigator.pop(context);

    Map _userData = await HiveMethods().getUserData();
    _userData['uniDetails'] = uniDetails;
    AuthService().saveUserDataToDb(userData: _userData);
    userData = _userData;
    setState(() {});

    Fluttertoast.showToast(msg: 'UNiversity Updated!');
  }

  Future getUniList() async {
    String url = "https://quiz-demo-de79d.appspot.com/hostel_api/searchKeys";
    var response = await http.get(url);
    var result = json.decode(response.body);
    print(result);
    return result;
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        centerTitle: true,
        title: Text(
          "Profile",
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
      body: isLoading ? Center(child: CircularProgressIndicator()) : body(),
    );
  }

  Widget body() {
    UserModel userModel = UserModel.fromMap(userData.cast<String, dynamic>());
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8),
                      child: Stack(
                        children: [
                          userModel.profilePicUrl == null
                              ? CircleAvatar(
                                  backgroundColor: Colors.blueGrey[400],
                                  radius: 80,
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.grey[400],
                                  ))
                              : Container(
                                  height: 120,
                                  width: 120,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(160),
                                    child: ExtendedImage.network(
                                      userData['profilePicUrl'],
                                      fit: BoxFit.cover,
                                      handleLoadingProgress: true,
                                      shape: BoxShape.rectangle,
                                      cache: false,
                                      enableMemoryCache: true,
                                    ),
                                  ),
                                ),
                          Positioned(
                            bottom: 3.0,
                            right: 3.0,
                            child: CircleAvatar(
                              backgroundColor: Color(0xffebf1ef),
                              child: isUpdatingPic
                                  ? CircularProgressIndicator()
                                  : IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.deepOrange,
                                      ),
                                      onPressed: () {
//                              print(userData);
                                        pickImage();
                                      },
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${userModel.fullName}",
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.deepOrange,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                    radius: 16,
                                    backgroundColor: Color(0xffebf1ef),
                                    child: Icon(
                                      Icons.phone,
                                      size: 16,
                                    )),
                                SizedBox(
                                  width: 16,
                                ),
                                Text(
                                  "${userModel.phoneNumber}",
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                    radius: 16,
                                    backgroundColor: Color(0xffebf1ef),
                                    child: Icon(
                                      Icons.email,
                                      size: 16,
                                    )),
                                SizedBox(
                                  width: 16,
                                ),
                                Expanded(
                                  child: Text(
                                    "${userModel.email}",
                                    style: TextStyle(fontSize: 15),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              children: [
                                CircleAvatar(
                                    backgroundColor: Color(0xffebf1ef),
                                    child: Icon(
                                      Icons.location_on,
                                      size: 16,
                                    ),
                                    radius: 16),
                                SizedBox(
                                  width: 16,
                                ),
                                Expanded(
                                  child: Text(
                                    "${userModel.uniDetails['name']}",
                                    style: TextStyle(fontSize: 15),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 40,
            ),
//            Items(
//              Icons.attach_money,
//              "Wallet",
//              action: WalletHome(),
//            ),
            Divider(),
            ExpansionTile(
              childrenPadding: EdgeInsets.symmetric(horizontal: 16),
              trailing: Icon(Icons.arrow_forward_ios),
              key: GlobalKey(),
              title: Text('Edit Profile Details'),
              leading: CircleAvatar(
                  backgroundColor: Color(0xffebf1ef),
                  radius: 37,
                  child: Icon(Icons.edit)),
              children: <Widget>[
                SizedBox(
//                  height: MediaQuery.of(context).size.height * .30,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      List optionList = [
                        'Change Phone Number',
                        'Change University',
                      ];
                      return ListTile(
                        title: Text('${optionList[index]}'),
                        subtitle: Text('Tap To Edit'),
                        onTap: () {
                          editingController(index: index);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            Items(Icons.lock_outline, "Privacy & Services"),
            Items(
              Icons.info_outline,
              "Legal",
            ),
            Divider(),
            ListTile(
              leading: CircleAvatar(
                  radius: 37,
                  backgroundColor: Color(0xffebf1ef),
                  child: Icon(
                    Icons.exit_to_app,
                    size: 30,
                  )),
              title: Text('Log Out'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () async {
                await AuthService().signOut();
                Navigator.pop(context);
              },
            ),
            Divider()
          ],
        ),
      ),
    );
  }
}

class Items extends StatefulWidget {
  final IconData _icon;
  final String _title;
  final Widget action;

  Items(this._icon, this._title, {this.action});

  @override
  _ItemsState createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  void _navigate() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                widget.action != null ? widget.action : Homepage()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Divider(),
          ListTile(
            leading: CircleAvatar(
                radius: 37,
                backgroundColor: Color(0xffebf1ef),
                child: Icon(
                  widget._icon,
                  size: 30,
                )),
            title: Text(widget._title),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              _navigate();
            },
          ),
        ],
      ),
    );
  }
}
