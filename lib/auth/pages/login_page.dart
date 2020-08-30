import 'package:Ohstel_app/auth/methods/auth_methods.dart';
import 'package:Ohstel_app/auth/pages/forgot_password_page.dart';
import 'package:Ohstel_app/auth/pages/sigup_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

  var _user = "Timmy";
  bool _obscureText = true;
  BoxDecoration _textField = BoxDecoration(
    borderRadius: BorderRadius.circular(15),
    color: Colors.green[50],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      resizeToAvoidBottomPadding: false,
      body: loading != true
          ? SingleChildScrollView(
              child: Container(
                child: Form(
                  key: formKey,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
//                    crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
//                      IconButton(
//                          icon: Icon(Icons.arrow_back), onPressed: () {}),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.19),
                        Row(
                          children: <Widget>[
                            Text(
                              'Welcome, ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.normal),
                            ),
                            Text(
                              "$_user",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text('Cheers! On becoming an',
                                style: TextStyle(color: Colors.black)),
                            Text(' OHSTELLER',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor))
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 70, horizontal: 20),
                          child: Column(
                            children: <Widget>[
                              emailInputFieldBox(),
                              SizedBox(
                                height: 20,
                              ),
                              passwordInputFieldBox(),
                              SizedBox(
                                height: 38,
                              ),
                              logInButton(),
                              SizedBox(
                                height: 14,
                              ),
                              moreOptions(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : Center(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
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
          if (value.trim().isEmpty) {
            return 'Email Can\'t Be Empty';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          labelText: "Email",
          suffixIcon: Icon(Icons.person),
          border: InputBorder.none,
        ),
        onSaved: (value) => email = value.trim(),
        keyboardType: TextInputType.emailAddress,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 15,
      ),
      decoration: _textField,
    );
  }

  Widget passwordInputFieldBox() {
    return Container(
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
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
              border: InputBorder.none,
              labelText: 'Password',
              suffixIcon: GestureDetector(
                child: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility),
                onTap: () {
                  setState(() => _obscureText = !_obscureText);
                },
              )),
          obscureText: _obscureText,
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
        width: MediaQuery.of(context).size.width,
        height: 60,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              "Sign In",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.normal),
            ),
            SizedBox(
              width: 10,
            ),
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
        width: MediaQuery.of(context).size.width,
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

  Widget moreOptions() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ForgetPasswordPage(),
                  ),
                );
              },
              child: Text(
                'Forgot Password ?',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: InkWell(
              onTap: () {
                widget.toggleView();
              },
              child: Text(
                ' Create New Account ',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
