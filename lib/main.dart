import 'package:Ohstel_app/SplashScreen.dart';
import 'package:Ohstel_app/auth/methods/auth_methods.dart';
import 'package:Ohstel_app/auth/models/login_user_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'hive_methods/hive_class.dart';

Future<void> main() async {
  // init hive
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await InitHive().startHive(boxName: 'userDataBox');
  await InitHive().startCartHiveDb();
  await InitHive().startMarketCartHiveDb();
  await InitHive().startLocationHive();
  await InitHive().startFoodAddressDetailHive();
  await InitHive().startLaundryBasketHive();
  await InitHive().startLaundryAddressDetailHive();
//  Admob.initialize(AdManager.appId);

  // run app
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // provider is being used here at the top most widget tree so we can notify
    // every other sub widget down the widget tree.
    return StreamProvider<LoginUserModel>.value(
      value: AuthService().userStream,
      child: GetMaterialApp(
        title: 'Ohstel',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // fontFamily: 'Lato',
          primaryColor: Color(0xfff27507),
          primarySwatch: Colors.deepOrange,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
       home: SplashScreen(),
//         home: Wrapper(),
      ),
    );
  }
}
