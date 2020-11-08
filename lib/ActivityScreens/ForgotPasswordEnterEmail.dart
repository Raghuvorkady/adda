import 'package:adda/HelperClass/Resources.dart';
import 'package:adda/HelperClass/Widget.dart';
import 'package:adda/Services/auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class ForgotPasswordEnterEmailClass extends StatefulWidget {
  @override
  _ForgotPasswordEnterEmailClassState createState() =>
      _ForgotPasswordEnterEmailClassState();
}

class _ForgotPasswordEnterEmailClassState
    extends State<ForgotPasswordEnterEmailClass> {
  final FocusNode emailFocus = new FocusNode();
  TextEditingController _emailTextEditingController =
      new TextEditingController();
  final _emailFormKey = GlobalKey<FormState>();
  bool _emailValidated = false;
  bool isProceed = false;

  AuthMethodsClass authMethods = new AuthMethodsClass();

  String emailValidator(email) {
    String _emailPattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp _regExp = new RegExp(_emailPattern);
    return _regExp.hasMatch(email) ? null : "please enter a valid email";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: verifyAndForgotAppBar("Forgot password"),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 100,
              ),
              Text(
                enterRegisteredMail,
                style: TextStyle(
                  fontSize: 16.0,
                  letterSpacing: 0.5,
                  color: appBlack.withOpacity(0.9),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(color: HexColor("#777777")),
                  color: Colors.white,
                ),
                child: Form(
                  key: _emailFormKey,
                  child: TextFormField(
                    style: TextStyle(
                        color: HexColor("#444444"),
                        fontSize: 14.0,
                        letterSpacing: 0.5),
                    controller: _emailTextEditingController,
                    textInputAction: TextInputAction.done,
                    focusNode: emailFocus,
                    onFieldSubmitted: (s) {
                      _emailFormKey.currentState.validate()
                          ? _emailValidated = true
                          : _emailValidated = false;
                      print("EMAIL $_emailValidated");
                      _emailValidated
                          ? FocusScope.of(context).unfocus()
                          : print("EMAIL false");
                    },
                    validator: (email) {
                      return emailValidator(email);
                    },
                    enableSuggestions: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      errorMaxLines: null,
                      errorStyle: TextStyle(color: Colors.red),
                      hintStyle: TextStyle(
                          fontSize: 14.0,
                          letterSpacing: 0.5,
                          color: HexColor("#999999")),
                      hintText: "email",
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    color: HexColor("#7998DF"),
                    splashColor: HexColor("#6A92ED"),
                    onPressed: () async {
                      //isEmailExists();
                      setState(() {
                        isProceed = true;
                      });
                      await authMethods.resetPassword(_emailTextEditingController.text.toString().trim()).then((value) => null);
                      print("PASSWORD RESET sent");
                    },
                    child: Text(
                      "Proceed",
                      style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 0.5,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 100,
              ),
              Visibility(
                visible: isProceed,
                child: Text(
                  "OTP will be sent to the ${_emailTextEditingController.text} mail",
                  style: TextStyle(
                    fontSize: 14.0,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.w400,
                    color: HexColor("#999999"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
