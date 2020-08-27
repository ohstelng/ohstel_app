import 'dart:io';

import 'package:Ohstel_app/auth/methods/auth_database_methods.dart';
import 'package:Ohstel_app/auth/methods/auth_methods.dart';
import 'package:Ohstel_app/auth/models/userModel.dart';
import 'package:Ohstel_app/hive_methods/hive_class.dart';
import 'package:Ohstel_app/landing_page/homepage.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
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
        child: Column(
          children: [
            Stack(
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
                        height: 160,
                        width: 160,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: ExtendedImage.network(
                            userData['profilePicUrl'],
                            fit: BoxFit.fill,
                            handleLoadingProgress: true,
                            shape: BoxShape.rectangle,
                            cache: false,
                            enableMemoryCache: true,
                          ),
                        ),
                      ),
                Positioned(
                  bottom: 0.0,
                  right: 0.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                    child: isUpdatingPic
                        ? CircularProgressIndicator()
                        : IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
//                              print(userData);
                              pickImage();
                            },
                          ),
                  ),
                ),
              ],
            ),
            Text(
              "${userModel.fullName}",
              style: TextStyle(fontSize: 24),
            ),
            Text(
              "${userModel.phoneNumber}",
              style: TextStyle(fontSize: 15),
            ),
            Text(
              "${userModel.email}",
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(
              height: 40,
            ),
            ListTile(
              leading: CircleAvatar(
                  radius: 37,
                  backgroundColor: Color(0xffebf1ef),
                  child: Icon(
                    Icons.exit_to_app,
                    color: Colors.black,
                    size: 30,
                  )),
              title: Text('Edit Profile Details'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () async {},
            ),
            Items(Icons.lock_outline, "Privacy & Services"),
            Items(
              Icons.info_outline,
              "Legal",
            ),
            Divider(),
            Expanded(
              child: ListTile(
                leading: CircleAvatar(
                    radius: 37,
                    backgroundColor: Color(0xffebf1ef),
                    child: Icon(
                      Icons.exit_to_app,
                      color: Colors.black,
                      size: 30,
                    )),
                title: Text('Log Out'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () async {
                  await AuthService().signOut();
                  Navigator.pop(context);
                },
              ),
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

  Items(
    this._icon,
    this._title,
  );

  @override
  _ItemsState createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  void _navigate() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Homepage()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Divider(),
          Expanded(
            child: ListTile(
              leading: CircleAvatar(
                  radius: 37,
                  backgroundColor: Color(0xffebf1ef),
                  child: Icon(
                    widget._icon,
                    color: Colors.black,
                    size: 30,
                  )),
              title: Text(widget._title),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                _navigate();
              },
            ),
          ),
        ],
      ),
    );
  }
}
