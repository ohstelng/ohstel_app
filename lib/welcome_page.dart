import 'package:Ohstel_app/auth/pages/login_page.dart';
import 'package:Ohstel_app/auth/pages/sigup_page.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 8,
                ),
                Text("Welcome to OHSTEL",style: TextStyle(fontSize: 20),),
                SizedBox(height: 80,),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpPage(toggleView: null,)));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xff1F2430)),
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 55,
                    child: Center(
                      child: Text(
                        "Sign Up",
                        style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30,),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>LogInPage()));
                      },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).primaryColor,),
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 55,
                    child: Center(
                      child: Text(
                        "Sign In",
                        style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 60,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
