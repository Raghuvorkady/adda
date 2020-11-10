import 'package:adda/HelperClass/Widget.dart';
import 'package:adda/Resources/Colors.dart';
import 'package:adda/Resources/Icons.dart';
import 'package:adda/Resources/Strings.dart';
import 'package:flutter/material.dart';

class ForgotPasswordEnterOtpClass extends StatefulWidget {
  @override
  _ForgotPasswordEnterOtpClassState createState() =>
      _ForgotPasswordEnterOtpClassState();
}

class _ForgotPasswordEnterOtpClassState
    extends State<ForgotPasswordEnterOtpClass> {
  bool otpVerificationState = false;

  final FocusNode passwordFocus = FocusNode();
  final FocusNode confirmPasswordFocus = FocusNode();

  TextEditingController passwordTextEditingController =
      new TextEditingController();
  TextEditingController confirmPasswordTextEditingController =
      new TextEditingController();

  final _passwordFormKey = GlobalKey<FormState>();
  final _confirmPasswordFormKey = GlobalKey<FormState>();

  bool _passwordValidated = false;
  bool _confirmPasswordValidated = false;

  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _passwordEye = false;
  bool _confirmPasswordEye = false;

  checkPasswordsForMatch() {
    if (passwordTextEditingController.text !=
        confirmPasswordTextEditingController.text) {
      print(" passwords do not match");
      return "passwords do not match";
    } else {
      print(" passwords match");
      return null;
    }
  }

  String passwordValidator(password) {
    String passwordPattern = r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$";
    RegExp regExp = new RegExp(passwordPattern);
    return regExp.hasMatch(password)
        ? null
        : "please provide at least 8 character alphanumeric password";
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: verifyAndForgotAppBar("Forgot password"),
      backgroundColor: appBackground,
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          /*  mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,*/
          children: [
            SizedBox(
              height: 100,
            ),
            Text(
              enterOtp,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.0,
                letterSpacing: 0.5,
                color: appBlack.withOpacity(0.9),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: OtpTextField()),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, right: 10),
                  child: verifyOtp(otpVerificationState),
                ),
              ],
            ),
            SizedBox(
              height: 60,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              padding: EdgeInsets.fromLTRB(20, 5, 10, 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: appLightBlack.withOpacity(0.7),
              ),
              child: Form(
                key: _passwordFormKey,
                child: TextFormField(
                  focusNode: passwordFocus,
                  controller: passwordTextEditingController,
                  textInputAction: TextInputAction.next,
                  cursorColor: Colors.grey[100],
                  onFieldSubmitted: (string) {
                    _passwordFormKey.currentState.validate()
                        ? _passwordValidated = true
                        : _passwordValidated = false;
                    _passwordValidated
                        ? _fieldFocusChange(
                            context, passwordFocus, confirmPasswordFocus)
                        : print("PASSWORD false");
                  },
                  validator: (password) {
                    return passwordValidator(password);
                  },
                  style: TextStyle(
                      color: Colors.white, fontSize: 18.0, letterSpacing: 1.0),
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
                      icon: _passwordEye
                          ? Image.asset(eyeOff)
                          : Image.asset(eyeOn),
                    ),
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                        fontSize: 18.0,
                        letterSpacing: 1.0,
                        color: appLightGrey),
                    hintText: "password",
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              padding: EdgeInsets.fromLTRB(20, 5, 10, 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: appLightBlack.withOpacity(0.7),
              ),
              child: Form(
                key: _confirmPasswordFormKey,
                child: TextFormField(
                  focusNode: confirmPasswordFocus,
                  controller: confirmPasswordTextEditingController,
                  textInputAction: TextInputAction.done,
                  cursorColor: Colors.grey[100],
                  onFieldSubmitted: (string) {
                    _confirmPasswordFormKey.currentState.validate()
                        ? _confirmPasswordValidated = true
                        : _confirmPasswordValidated = false;
                    _confirmPasswordValidated
                        ? Focus.of(context).unfocus()
                        : print("CONFIRM PASSWORD $_confirmPasswordValidated");
                  },
                  validator: (confirmPassword) {
                    if (passwordTextEditingController.text != confirmPassword) {
                      print(" passwords do not match");
                      return "passwords do not match";
                    } else {
                      print(" passwords match");
                      return null;
                    }
                  },
                  style: TextStyle(
                      color: Colors.white, fontSize: 18.0, letterSpacing: 1.0),
                  obscureText: !_showConfirmPassword,
                  decoration: InputDecoration(
                    errorStyle: TextStyle(color: Colors.grey[50]),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          print("PRESSED $_showConfirmPassword");
                          _showConfirmPassword = !_showConfirmPassword;
                          _confirmPasswordEye = !_confirmPasswordEye;
                        });
                      },
                      icon: _confirmPasswordEye
                          ? Image.asset(eyeOff)
                          : Image.asset(eyeOn),
                    ),
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                        fontSize: 18.0,
                        letterSpacing: 1.0,
                        color: appLightGrey),
                    hintText: "confirm password",
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            submitButton("Submit"),
          ],
        ),
      ),
    );
  }
}
