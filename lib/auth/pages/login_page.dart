import 'package:Ohstel_app/auth/methods/auth_methods.dart';
import 'package:Ohstel_app/auth/pages/sigup_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ToggleBetweenLoginAndSignUpPage extends StatefulWidget {
  @override
  _ToggleBetweenLoginAndSignUpPageState createState() =>
      _ToggleBetweenLoginAndSignUpPageState();
}

class _ToggleBetweenLoginAndSignUpPageState
    extends State<ToggleBetweenLoginAndSignUpPage> {
  bool showLogInPage = true;

  void toggleView() {
    setState(() {
      showLogInPage = !showLogInPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLogInPage) {
      return LogInPage(toggleView: toggleView);
    } else {
      return SignUpPage(toggleView: toggleView);
    }
  }
}

class LogInPage extends StatefulWidget {
  final Function toggleView;

  LogInPage({this.toggleView});

  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  String email;
  String password;
  final formKey = GlobalKey<FormState>();
  bool loading = false;

  AuthService authService = AuthService();

  Future<void> validateAndSave() async {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      setState(() {
        loading = true;
        print(loading);
      });
      print('From is vaild');
      print(email);
      print(password);
      await logInUser();
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    } else {
      Fluttertoast.showToast(msg: 'Invaild Inputs');
      setState(() {
        loading = false;
      });
    }
    print(loading);
  }

  Future<void> logInUser() async {
    await authService.loginWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: loading != true
          ? Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topCenter, colors: [
                Colors.deepOrange[800],
                Colors.deepOrange[400],
                Colors.deepOrange[100]
              ])),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 60, horizontal: 20),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Login',
                            style:
                                TextStyle(color: Colors.white, fontSize: 40.0),
                          ),
                          Text('Welcome Back to Ohstel',
                              style: TextStyle(color: Colors.white))
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 50, horizontal: 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(60),
                                topRight: Radius.circular(60))),
                        child: Column(
                          children: <Widget>[
                            emailInputFieldBox(),
                            SizedBox(
                              height: 20,
                            ),
                            passwordInputFieldBox(),
                            forgotPassword(),
                            SizedBox(
                              height: 30,
                            ),
                            logInButton(),
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              "New to Ohstel??",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold),
                            ),
                            signUpButton(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Center(
              child: Container(
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
            ),
    );
  }

  Widget emailInputFieldBox() {
    return Container(
      child: TextFormField(
        validator: (value) {
          if (value
              .trim()
              .isEmpty) {
            return 'Email Can\'t Be Empty';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
            labelText: "Email",
            border: InputBorder.none,
            prefixIcon: Icon(Icons.email)),
        onSaved: (value) => email = value.trim(),
        keyboardType: TextInputType.emailAddress,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 15,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Color.fromRGBO(
                225,
                95,
                27,
                .3,
              ),
              blurRadius: 20,
              offset: Offset(0, 10))
        ],
      ),
    );
  }

  Widget passwordInputFieldBox() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Color.fromRGBO(
                225,
                95,
                27,
                .3,
              ),
              blurRadius: 20,
              offset: Offset(0, 10))
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 15,
          right: 15,
        ),
        child: TextFormField(
          validator: (value) {
            if (value
                .trim()
                .isEmpty) {
              return 'Password Can\'t Be Empty';
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
              border: InputBorder.none,
              labelText: 'Password',
              prefixIcon: Icon(Icons.security),
              suffixIcon: GestureDetector(
                child: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off
                ),
                onTap: () {
                  setState(() => _obscureText = !_obscureText);
                },
              )),
          obscureText: !_obscureText,
          onSaved: (value) => password = value.trim(),
        ),
      ),
    );
  }

  Widget logInButton() {
    return InkWell(
      onTap: () {
        validateAndSave();
      },
      child: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: 60,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.deepOrange[400],
              Colors.deepOrange[500],
              Colors.deepOrange[500],
              Colors.deepOrange[400]
            ],
          ),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Center(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              "Login",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 10,
            ),
            Icon(
              Icons.account_balance,
              color: Colors.white,
              size: 30,
            )
          ]),
        ),
      ),
    );
  }

  Widget signUpButton() {
    return InkWell(
      onTap: () {
        widget.toggleView();
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: 60,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.deepOrange, width: 2.5),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Center(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              "Signup",
              style: TextStyle(
                  color: Colors.deepOrange,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 10,
            ),
            Icon(
              Icons.account_box,
              color: Colors.deepOrange,
              size: 30,
            )
          ]),
        ),
      ),
    );
  }

  Widget forgotPassword() {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      padding: EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
          widget.toggleView();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Forgot Password ??',
              style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.deepOrange[300],
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

