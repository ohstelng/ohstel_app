import 'package:Ohstel_app/utilities/app_style.dart';
import 'package:flutter/material.dart';

final formKey = GlobalKey<FormState>();

showUserDetailsBottomSheet(
  BuildContext context, {
  @required userDetails,
  @required finalAmount,
}) {
  return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 20.0,
              right: 20.0,
              top: 20.0,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Ticket Details',
                    style: heading2,
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
                    child: TextFormField(
                      initialValue: userDetails['fullName'],
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return 'Name Can\'t Be Empty';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        labelText: "Name",
                        suffixIcon: Icon(Icons.person),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    padding: EdgeInsets.only(
                      left: 15,
                      right: 15,
                    ),
                    color: Colors.green[50],
                    child: TextFormField(
                      initialValue: userDetails['email'],
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return 'Email Can\'t Be Empty';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        labelText: "Email",
                        suffixIcon: Icon(Icons.email),
                        border: InputBorder.none,
                      ),
                      // onSaved: (value) => email = value.trim(),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    padding: EdgeInsets.only(
                      left: 15,
                      right: 15,
                    ),
                    color: Colors.green[50],
                    child: TextFormField(
                      initialValue: userDetails['phoneNumber'],
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return 'Phone No. Can\'t Be Empty';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        labelText: "Phone No.",
                        suffixIcon: Icon(Icons.phone),
                        border: InputBorder.none,
                      ),
                      // onSaved: (value) => email = value.trim(),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    padding: EdgeInsets.only(
                      left: 15,
                      right: 15,
                    ),
                    color: Colors.green[50],
                    child: TextFormField(
                      initialValue: userDetails['uniDetails']['name'],
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return 'University Can\'t Be Empty';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        labelText: "University",
                        suffixIcon: Icon(Icons.school),
                        border: InputBorder.none,
                      ),
                      // onSaved: (value) => email = value.trim(),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    padding: EdgeInsets.only(
                      left: 15,
                      right: 15,
                    ),
                    color: Colors.green[50],
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "Department (Optional)",
                        suffixIcon: Icon(Icons.school),
                        border: InputBorder.none,
                      ),
                      // onSaved: (value) => email = value.trim(),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    width: double.infinity,
                    height: 50.0,
                    child: FlatButton(
                      onPressed: () => validateAndProceed(finalAmount),
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        'Pay Now',
                        style: body1.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
          ),
        );
      });
}

validateAndProceed(int finalAmount) {
  final form = formKey.currentState;
  if (form.validate()) {
    form.save();
    // TODO: TAKE USER TO PAYMENT SCREEN TO PAY FINAL AMOUNT
    print(finalAmount);
  }
}
