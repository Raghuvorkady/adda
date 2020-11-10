import 'dart:async';

import 'package:adda/HelperClass/Authenticate.dart';
import 'package:adda/Resources/Icons.dart';
import 'package:flutter/material.dart';

import 'HomeScreen.dart';

class LogicScreenClass extends StatefulWidget {
  final bool isUserLoggedIn;

  LogicScreenClass({this.isUserLoggedIn});

  @override
  _LogicScreenClassState createState() => _LogicScreenClassState();
}

class _LogicScreenClassState extends State<LogicScreenClass> {
  logic() {
    return widget.isUserLoggedIn != null
        ? widget.isUserLoggedIn
            ? HomeScreenClass()
            : AuthenticateClass()
        : Container(
            child: Center(
              child: AuthenticateClass(),
            ),
          );
  }

  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 1),
        () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => logic())));
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Image.asset(
            logoWithName,
            height: height / 5,
            width: width / 2,
          ),
        ),
      ),
    );
  }
}
