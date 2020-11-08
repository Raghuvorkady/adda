import 'package:adda/ActivityScreens/SignIn.dart';
import 'package:adda/ActivityScreens/SignUp.dart';
import 'package:flutter/material.dart';

class AuthenticateClass extends StatefulWidget {
  @override
  _AuthenticateClassState createState() => _AuthenticateClassState();
}

class _AuthenticateClassState extends State<AuthenticateClass> {
  bool showSignIn = true;

  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignInClass(toggleView);
    } else {
      return SignUpClass(toggleView);
    }
  }
}
