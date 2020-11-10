import 'dart:async';

import 'package:adda/HelperClass/Constants.dart';
import 'package:adda/Resources/Colors.dart';
import 'package:adda/Resources/Icons.dart';
import 'package:adda/Resources/Strings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

TextStyle generalText() => TextStyle(
      fontSize: 14.0,
      letterSpacing: 0.5,
      color: HexColor("#444444"),
    );

TextStyle timeStampStyle() => TextStyle(
      fontSize: 10.0,
      letterSpacing: 0.5,
      color: HexColor("#777777"),
    );

Widget chatScreenAppBar(String photoUrl, bool isOnline) {
  //TODO AssertImage, will be change to NetworkImage
  print("PHOTOURL : $photoUrl");
  return AppBar(
    elevation: 1,
    title: ListTile(
      leading: photoUrl != null
          ? CachedNetworkImage(
              width: 40,
              height: 40,
              imageUrl: photoUrl,
              errorWidget: (context, url, error) => Image.network(
                    defaultProfile,
                    color: Colors.grey,
                  ),
              imageBuilder: (context, imageProvider) => Container(
                    child: CircleAvatar(
                      backgroundImage: imageProvider,
                      radius: 20,
                    ),
                  ))
          : CircularProgressIndicator(),
      title: Text(
        ConstantsClass.chatName,
        style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            color: appLightBlack),
      ),
      subtitle: Text(
        isOnline ? "online" : "offline",
        style: TextStyle(
            fontSize: 12.0,
            letterSpacing: 0.5,
            color: isOnline ? Colors.green : HexColor("#777777")),
      ),
    ),
    backgroundColor: Colors.white.withOpacity(1),
    centerTitle: false,
  );
}

Widget verifyAndForgotAppBar(String titleText) {
  return AppBar(
    title: Text(
      titleText,
      style: TextStyle(
          fontSize: 20.0,
          letterSpacing: 0.5,
          fontWeight: FontWeight.bold,
          color: HexColor("#7998DF")),
    ),
    backgroundColor: Colors.white,
    centerTitle: true,
  );
}

class UserNameTextFieldClass extends StatefulWidget {
  final String hintText;

  UserNameTextFieldClass({this.hintText});

  @override
  _UserNameTextFieldClassState createState() => _UserNameTextFieldClassState();
}

class _UserNameTextFieldClassState extends State<UserNameTextFieldClass> {
  TextEditingController _userNameTextEditingController;
  final _userNameFormKey = GlobalKey<FormState>();
  bool _userNameValidated = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: HexColor("#52575D").withOpacity(0.7),
      ),
      child: Form(
        key: _userNameFormKey,
        child: TextFormField(
          style: TextStyle(
              color: Colors.white, fontSize: 18.0, letterSpacing: 0.5),
          controller: _userNameTextEditingController,
          textInputAction: TextInputAction.next,
          //focusNode: SignUpClass.focus,
          onFieldSubmitted: (s) {
            _userNameFormKey.currentState.validate()
                ? _userNameValidated = true
                : _userNameValidated = false;
            print("USERNAME $_userNameValidated");
            /*_userNameValidated
                ? FocusScope.of(context).requestFocus(SignUpClass.focus)
                : print("USERNAME false");*/
          },
          enableSuggestions: true,
          decoration: InputDecoration(
            border: InputBorder.none,
            errorMaxLines: null,
            errorStyle: TextStyle(color: Colors.grey[50]),
            hintStyle: TextStyle(
                fontSize: 18.0, letterSpacing: 0.5, color: HexColor("#F4F4F4")),
            hintText: widget.hintText,
          ),
        ),
      ),
    );
  }
}

class EmailTextFieldClass extends StatefulWidget {
  final String hintText;
  final focusEmail;

  EmailTextFieldClass({this.hintText, this.focusEmail});

  @override
  _EmailTextFieldClassState createState() => _EmailTextFieldClassState();
}

class _EmailTextFieldClassState extends State<EmailTextFieldClass> {
  TextEditingController _emailTextEditingController;
  final _emailFormKey = GlobalKey<FormState>();
  bool _emailValidated = false;

  String emailValidator(email) {
    String _emailPattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp _regExp = new RegExp(_emailPattern);
    return _regExp.hasMatch(email) ? null : "please enter a valid email";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: HexColor("#52575D").withOpacity(0.7),
      ),
      child: Form(
        key: _emailFormKey,
        child: TextFormField(
          style: TextStyle(
              color: Colors.white, fontSize: 18.0, letterSpacing: 0.5),
          controller: _emailTextEditingController,
          textInputAction: TextInputAction.next,
          focusNode: widget.focusEmail,
          onFieldSubmitted: (s) {
            _emailFormKey.currentState.validate()
                ? _emailValidated = true
                : _emailValidated = false;
            print("EMAIL $_emailValidated");
            _emailValidated
                ? FocusScope.of(context)
                    .requestFocus(PasswordFieldClass().focusPassword)
                : print("EMAIL false");
          },
          validator: (email) {
            return emailValidator(email);
          },
          enableSuggestions: true,
          decoration: InputDecoration(
            border: InputBorder.none,
            errorMaxLines: null,
            errorStyle: TextStyle(color: Colors.grey[50]),
            hintStyle: TextStyle(
                fontSize: 18.0, letterSpacing: 0.5, color: HexColor("#F4F4F4")),
            hintText: widget.hintText,
          ),
        ),
      ),
    );
  }
}

Widget submitButton(String submitText) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
    child: SizedBox(
      width: double.infinity,
      height: 50,
      child: RaisedButton(
        color: appBlack,
        splashColor: appLightBlack,
        onPressed: () {},
        child: Text(
          submitText,
          style: TextStyle(
              color: Colors.white,
              letterSpacing: 0.5,
              fontSize: 18.0,
              fontWeight: FontWeight.bold),
        ),
      ),
    ),
  );
}

Widget textInAuthenticatePage(text) {
  return Text(
    text,
    style: TextStyle(color: appLightBlack, letterSpacing: 0.5, fontSize: 14.0),
  );
}

Widget verifyOtp(otpState) {
  return Icon(
    Icons.check_circle_outline,
    color: otpState ? Colors.green : Colors.red,
  );
}

class PasswordFieldClass extends StatefulWidget {
  final String hintText;
  final focusPassword;

  PasswordFieldClass({this.hintText, this.focusPassword});

  @override
  _PasswordFieldClassState createState() => _PasswordFieldClassState();
}

class _PasswordFieldClassState extends State<PasswordFieldClass> {
  bool _showPassword = false;
  bool _passwordEye = false;
  bool _passwordValidated = false;
  TextEditingController passwordTextEditingController;
  final _passwordFormKey = GlobalKey<FormState>();

  //creating a constructor, or assigning static?

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  String passwordValidator(password) {
    String passwordPattern = r'^(?=.*?[a-z][A-Z][0-9]).{8,}$';
    RegExp regExp = new RegExp(passwordPattern);
    return regExp.hasMatch(password)
        ? null
        : "please provide at least 8 character alphanumeric password";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      padding: EdgeInsets.fromLTRB(20, 5, 10, 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: appLightBlack.withOpacity(0.7),
      ),
      child: Form(
        key: _passwordFormKey,
        child: TextFormField(
          focusNode: widget.focusPassword,
          controller: passwordTextEditingController,
          textInputAction: TextInputAction.next,
          cursorColor: Colors.grey[100],
          onFieldSubmitted: (string) {
            _passwordFormKey.currentState.validate()
                ? _passwordValidated = true
                : _passwordValidated = false;
            _passwordValidated
                ? Focus.of(context).requestFocus(widget.focusPassword)
                : print("EMAIL false");
          },
          validator: (password) {
            return passwordValidator(password);
          },
          style: TextStyle(
              color: Colors.white, fontSize: 18.0, letterSpacing: 0.5),
          obscureText: !_showPassword,
          decoration: InputDecoration(
            errorStyle: TextStyle(color: Colors.grey[50]),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  print("PRESSED $_showPassword");
                  _showPassword = !_showPassword;
                  _passwordEye = !_passwordEye;
                });
              },
              icon: _passwordEye ? Image.asset(eyeOff) : Image.asset(eyeOn),
            ),
            border: InputBorder.none,
            hintStyle: TextStyle(
                fontSize: 18.0, letterSpacing: 0.5, color: appLightGrey),
            hintText: widget.hintText,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    passwordTextEditingController.dispose();
    super.dispose();
  }
}

void handlePress() {
  HapticFeedback.vibrate();
}

class OtpTextField extends StatefulWidget {
  @override
  _OtpTextFieldState createState() => _OtpTextFieldState();
}

class _OtpTextFieldState extends State<OtpTextField> {
  TextEditingController textEditingController;

  // ignore: close_sinks
  StreamController errorStreamController;
  String currentText;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 40.0),
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: PinCodeTextField(
        length: 4,
        obsecureText: false,
        animationType: AnimationType.fade,
        textInputType: TextInputType.number,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(5),
          fieldHeight: 50,
          fieldWidth: 40,
          selectedColor: Colors.blue[400],
          activeColor: appPrimaryColor,
          selectedFillColor: Colors.white,
          inactiveColor: appLightBlack,
          inactiveFillColor: Colors.white,
          activeFillColor: Colors.white,
        ),
        animationDuration: Duration(milliseconds: 300),
        backgroundColor: Colors.transparent,
        enableActiveFill: true,
        errorAnimationController: errorStreamController,
        controller: textEditingController,
        onCompleted: (v) {
          print("OTP Completed");
        },
        onChanged: (value) {
          print(value);
          setState(() {
            currentText = value;
          });
        },
        beforeTextPaste: (text) {
          print("Allowing to paste $text");
          //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
          //but you can show anything you want here, like your pop up saying wrong paste format or etc
          return true;
        },
      ),
    );
  }

/*@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    textEditingController.dispose();
    errorStreamController.close();
  }*/
}
