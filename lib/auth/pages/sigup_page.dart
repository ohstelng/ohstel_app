import 'dart:convert';

import 'package:Ohstel_app/auth/methods/auth_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class SignUpPage extends StatefulWidget {
  final Function toggleView;

  SignUpPage({@required this.toggleView});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool loading = false;
  final formKey = GlobalKey<FormState>();
  AuthService authService = AuthService();

  String firstName;
  String email;
  String lastName;
  String _passwordAgain;
  String uniName;
  String userName;
  String phoneNumber;
  String schoolLocation;
  Timestamp timeCreated;
  String _uniName = 'Selected Uni Name';
  bool _obscureText = true;

  String fullName;
  String password;
  Map uniDetails;

  Future<void> validateAndSave() async {
    final form = formKey.currentState;
    if (form.validate() && uniDetails != null) {
      form.save();
      setState(() {
        password = _passwordAgain;
        fullName = '$firstName $lastName';
        loading = true;
      });
      print('From is vaild');
      print(email);
      print(password);
      print(userName);
      print(phoneNumber);
      print(schoolLocation);
      await signUpUser();
      loading = false;
    } else {
      Fluttertoast.showToast(msg: 'Invaild Inputs');
    }
  }

  Future<void> signUpUser() async {
    await authService.registerWithEmailAndPassword(
      email: email,
      password: password,
      fullName: fullName,
      userName: userName,
      schoolLocation: schoolLocation,
      phoneNumber: phoneNumber,
      uniName: uniName,
      uniDetails: uniDetails,
    );
  }

  Future<Map> getAllUniNamesFromApi() async {
    String url = "https://quiz-demo-de79d.appspot.com/hostel_api/searchKeys";
    var response = await http.get(url);
    Map data = json.decode(response.body);

    return data;
  }

  BoxDecoration _textField = BoxDecoration(
    borderRadius: BorderRadius.circular(15),
    color: Colors.green[50],
  );

  TextStyle _underline = TextStyle(decoration: TextDecoration.underline);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          bottom: PreferredSize(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Create your Account",
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 24)),
                    Text(
                      "Let's get to know you better",
                      style: TextStyle(
                          fontSize: 10, fontWeight: FontWeight.normal),
                    )
                  ],
                ),
              ),
              preferredSize: Size.fromHeight(30)),
          elevation: 0,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () => widget.toggleView())),
//      resizeToAvoidBottomPadding: false,
      body: loading == false
          ? SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: _textField,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: TextFormField(
                          validator: (value) {
                            if (value.trim().isEmpty) {
                              return 'Last Name Can\'t Be Empty';
                            } else if (value.trim().length < 3) {
                              return 'Last Name Must Be More Than 2 Characters';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                              labelText: 'First Name',
                              border: InputBorder.none),
                          onSaved: (value) => firstName = value.trim(),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      decoration: _textField,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: TextFormField(
                          validator: (value) {
                            if (value.trim().isEmpty) {
                              return 'Last Name Can\'t Be Empty';
                            } else if (value.trim().length < 3) {
                              return 'Last Name Must Be More Than 2 Characters';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                              labelText: 'Last Name', border: InputBorder.none),
                          onSaved: (value) => lastName = value.trim(),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      decoration: _textField,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 15,
                          right: 15,
                        ),
                        child: TextFormField(
                          validator: (value) {
                            if (value.trim().isEmpty) {
                              return 'UserName Can\'t Be Empty';
                            } else if (value.trim().length <= 3) {
                              return 'UserName Must Be More Than 3 Characters';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                              labelText: 'User Name', border: InputBorder.none),
                          onSaved: (value) => userName = value.trim(),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      decoration: _textField,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 15,
                          right: 15,
                        ),
                        child: TextFormField(
                          validator: (value) {
                            if (value.trim().isEmpty) {
                              return 'Field Can\'t Be Empty';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                              labelText: 'Phone Number',
                              border: InputBorder.none),
                          onSaved: (value) => phoneNumber = value.trim(),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context).primaryColor)),
                      child: ExpansionTile(
                        key: GlobalKey(),
                        title: Text('$_uniName'),
                        leading: Icon(Icons.location_on),
                        children: <Widget>[
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .30,
                            child: FutureBuilder(
                              future: getAllUniNamesFromApi(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else {
                                  Map uniNameMaps = snapshot.data;
                                  List uniList = uniNameMaps.keys.toList();
                                  return ListView.builder(
                                    physics: BouncingScrollPhysics(),
                                    itemCount: uniNameMaps.length,
                                    itemBuilder: (context, index) {
                                      Map currentUniName =
                                          uniNameMaps[uniList[index]];
                                      return InkWell(
                                        onTap: () {
                                          if (mounted) {
                                            setState(() {
                                              _uniName = currentUniName['name'];
                                              uniDetails = currentUniName;
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
                                              Expanded(
                                                child: Text(
                                                  '${currentUniName['name']}',
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
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
                    SizedBox(height: 8),
                    Container(
                      decoration: _textField,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 15,
                          right: 15,
                        ),
                        child: TextFormField(
                          validator: (value) {
                            if (value.trim().isEmpty) {
                              return 'Field Can\'t Be Empty';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                              labelText: 'School Location',
                              border: InputBorder.none),
                          onSaved: (value) => schoolLocation = value.trim(),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      decoration: _textField,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 15,
                          right: 15,
                        ),
                        child: TextFormField(
                          validator: (value) {
                            if (value.trim().isEmpty) {
                              return 'Email Can\'t Be Empty';
//                    } else if (!EmailValidator.validate(value.trim())) {
//                      return 'Not a vaild Email';
                            } else if (!value.trim().endsWith('.com')) {
                              return 'Invalid Email';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                              labelText: 'Email', border: InputBorder.none),
                          onSaved: (value) => email = value.trim(),
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      decoration: _textField,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 15,
                          right: 15,
                        ),
                        child: TextFormField(
                          validator: (value) {
                            if (value.trim().isEmpty) {
                              return 'Password Can\'t Be Empty';
                            } else if (value.trim().length < 6) {
                              return 'Password Must Be More Than 6 Characters';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                              labelText: 'Password',
                              border: InputBorder.none,
                              suffixIcon: GestureDetector(
                                child: Icon(_obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onTap: () {
                                  setState(() => _obscureText = !_obscureText);
                                },
                              )),
                          obscureText: !_obscureText,
                          onSaved: (value) {
                            _passwordAgain = value.trim();
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text("By clicking on 'Create Account', you agree to"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('our '),
                        Text(
                          'Terms and Conditions',
                          style: _underline,
                        ),
                        Text(' and '),
                        Text(
                          'Privacy policy',
                          style: _underline,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    signUpButton(),
                    SizedBox(height: 8),
                    logInButton(),
                  ],
                ),
              ),
            )
          : Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SpinKitChasingDots(
                    color: Colors.deepOrange,
                    size: 50.0,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text('Loading......')
                ],
              ),
            ),
    );
  }

  Widget signUpButton() {
    return InkWell(
      onTap: () {
        validateAndSave();
      },
      child: Container(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              "Create Account",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.normal),
            ),
          ]),
          width: MediaQuery.of(context).size.width,
          height: 60,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(15),
          )),
    );
  }

  Widget logInButton() {
    return InkWell(
      onTap: () {
        widget.toggleView();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Center(
          child: Text(
            "Already have an account ? Sign in",
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
