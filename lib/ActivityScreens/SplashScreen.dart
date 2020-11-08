/*
import 'dart:async';
import 'package:adda/HelperClass/Resources.dart';
import 'package:flutter/material.dart';

class SplashScreenClass extends StatefulWidget {
  @override
  _SplashScreenClassState createState() => _SplashScreenClassState();
}

class _SplashScreenClassState extends State<SplashScreenClass> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 2),
            () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => HomePage())));
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Image.asset(logoWithName,
            height: height / 5,
            width: width / 2,
          ),
        ),
      ),
    );
  }
}
*/
