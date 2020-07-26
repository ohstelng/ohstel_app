import 'package:Ohstel_app/auth/methods/auth_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
  String _password;
  String _passwordAgain;
  String uniName;
  String userName;
  String phoneNumber;
  String schoolLocation;
  Timestamp timeCreated;

  String fullName;
  String password;

  Future<void> validateAndSave() async {
    final form = formKey.currentState;
    if (form.validate()) {
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: loading == false
            ? Container(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                          height: 100,
                          child: Center(
                            child: Text(
                              'SignUp',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20.0),
                            ),
                          )),
                      Container(
                        child: TextFormField(
                          validator: (value) {
                            if (value.trim().isEmpty) {
                              return 'First Name Can\'t Be Empty';
                            } else if (value.trim().length < 3) {
                              return 'First Name Must Be More Than 2 Characters';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'First Name',
                          ),
                          onSaved: (value) => firstName = value.trim(),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 15),
//                                decoration: BoxDecoration(
//                                    border: Border(
//                                        bottom: BorderSide(
//                                            color: Colors.grey[200]))),
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, bottom: 15),
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
                              labelText: 'Last Name',
                            ),
                            onSaved: (value) => lastName = value.trim(),
                          ),
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, bottom: 15),
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
                              labelText: 'UserName',
                            ),
                            onSaved: (value) => userName = value.trim(),
                          ),
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, bottom: 15),
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
                            ),
                            onSaved: (value) => phoneNumber = value.trim(),
                          ),
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, bottom: 15),
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
                            ),
                            onSaved: (value) => schoolLocation = value.trim(),
                          ),
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, bottom: 15),
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
                              labelText: 'Email',
                            ),
                            onSaved: (value) => email = value.trim(),
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, bottom: 10),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.info_outline,
                                size: 18,
                                color: Colors.blue,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  child: Text(
                                    'Be sure to submit a vaild/correct email address as this email will be use if there is a case of forgotten paswword.',
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, bottom: 15),
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
                            ),
//                                    obscureText: true,
                            onSaved: (value) {
                              _password = value.trim();
                            },
                            keyboardType: TextInputType.visiblePassword,
                          ),
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, bottom: 15),
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
                              labelText: 'Password Again!',
                            ),
                            onSaved: (value) {
                              _passwordAgain = value.trim();
                            },
                            keyboardType: TextInputType.visiblePassword,
//                                    obscureText: notshowPassword,
                          ),
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, bottom: 15),
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
                              labelText: 'Password Again!',
                            ),
                            onSaved: (value) {
                              uniName = value.trim();
                            },
                            keyboardType: TextInputType.visiblePassword,
//                                    obscureText: notshowPassword,
                          ),
                        ),
                      ),
                      signUpButton(),
                      logInButton(),
                    ],
                  ),
                ),
              )
            : Container(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(),
                      Text('Loading......')
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget signUpButton() {
    return Container(
      margin: EdgeInsets.all(20),
      height: 60,
      width: MediaQuery.of(context).size.width * 0.80,
      decoration: BoxDecoration(
          color: Colors.green, borderRadius: BorderRadius.circular(15)),
      child: RaisedButton(
        onPressed: () {
          validateAndSave();
        },
        child: Center(
          child: Text(
            'Create account',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget logInButton() {
    return Container(
      margin: EdgeInsets.all(20),
      height: 60,
      width: MediaQuery.of(context).size.width * 0.80,
      decoration: BoxDecoration(
          color: Colors.green, borderRadius: BorderRadius.circular(15)),
      child: RaisedButton(
        onPressed: () {
          widget.toggleView();
        },
        child: Center(
          child: Text(
            'login',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
