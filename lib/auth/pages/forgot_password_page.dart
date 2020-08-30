import 'package:Ohstel_app/auth/methods/auth_methods.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgetPasswordPage extends StatefulWidget {
  @override
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  String email;
  bool loading = false;
  final formKey = GlobalKey<FormState>();

  BoxDecoration _textField = BoxDecoration(
    borderRadius: BorderRadius.circular(15),
    color: Colors.green[50],
  );

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
      await AuthService().restEmail(email: email);
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
      popUp();
    } else {
      Fluttertoast.showToast(msg: 'Invaild Inputs');
      setState(() {
        loading = false;
      });
    }
    print(loading);
  }

  void popUp() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              child: Text(
                'A Link Has Been Sent To Your The Email Address $email, Click On The Link To Reset Your PassWord',
                style: TextStyle(
//                  color: Colors.red[300],
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            actions: [
              FlatButton(
                onPressed: () async {
                  Navigator.pop(context);
                },
                child: Text(
                  'Ok',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.19),
                  Text(
                    'Reset Password',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 24.0,
                        fontWeight: FontWeight.normal),
                  ),
                  Text('Input Your Email Address Below',
                      style: TextStyle(color: Colors.black)),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  ),
                  emailInputFieldBox(),
                  loading ? CircularProgressIndicator() : resetButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget resetButton() {
    return InkWell(
      onTap: () {
        validateAndSave();
      },
      child: Container(
        width: MediaQuery.of(context).size.width * .50,
        height: 60,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              "Reset PassWord",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
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

  Widget emailInputFieldBox() {
    return Container(
      margin: EdgeInsets.all(20.0),
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
}
