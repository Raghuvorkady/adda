import 'package:adda/HelperClass/Resources.dart';
import 'package:adda/HelperClass/Widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class VerifyYourAccountClass extends StatefulWidget {
  final String registeredEmail;

  VerifyYourAccountClass({this.registeredEmail});

  @override
  _VerifyYourAccountClassState createState() => _VerifyYourAccountClassState();
}

class _VerifyYourAccountClassState extends State<VerifyYourAccountClass> {
  //TODO just initialise with email
  bool otpVerificationState = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: verifyAndForgotAppBar("Verify your account"),
      backgroundColor: appBackground,
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 60,
            ),
            RichText(
                textAlign: TextAlign.center,
                strutStyle: StrutStyle(height: 2),
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 14.0,
                    letterSpacing: 0.5,
                    color: appBlack.withOpacity(0.9),
                  ),
                  children: <TextSpan>[
                    TextSpan(text: otpSent),
                    TextSpan(
                      text: "widget.registeredEmail",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        color: appBlack,
                      ),
                    ),
                  ],
                )),
            SizedBox(
              height: 40,
            ),
            Column(
              children: [
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
              ],
            ),
            SizedBox(
              height: 60,
            ),
            RichText(
                textAlign: TextAlign.center,
                strutStyle: StrutStyle(height: 2),
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 14.0,
                    letterSpacing: 0.5,
                    color: appBlack.withOpacity(0.9),
                  ),
                  children: <TextSpan>[
                    TextSpan(text: otpResend),
                    TextSpan(
                        text: "\nResend code",
                        recognizer: new TapGestureRecognizer()
                          ..onTap = () {
                            print("TAPPED");
                            handlePress();
                            setState(() {
                              otpVerificationState = !otpVerificationState;
                            });
                          },
                        style: TextStyle(
                            letterSpacing: 0.5,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ],
                )),
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
