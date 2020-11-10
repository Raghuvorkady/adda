import 'package:adda/ActivityScreens/LogicScreen.dart';
import 'package:adda/HelperClass/HelperFunctions.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userIsLoggedIn;

  @override
  void initState() {
    getLoggedStatus();
    super.initState();
  }

  getLoggedStatus() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      setState(() {
        userIsLoggedIn = value;
        print("USER LOGGED IN STATUS $userIsLoggedIn");
      });
    });
  }

  //PushNotificationService pushNotificationService = new PushNotificationService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LogicScreenClass(
        isUserLoggedIn: userIsLoggedIn,
      ),
    );
  }
}
