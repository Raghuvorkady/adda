import 'dart:async';

import 'package:adda/ActivityScreens/HomeScreen.dart';
import 'package:adda/HelperClass/Constants.dart';
import 'package:adda/HelperClass/Resources.dart';
import 'package:adda/examples/line_painter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

Widget homeScreenAppBar() {
  return AppBar(
    title: Image.asset(
      logoWithName,
      height: 100,
      width: 120,
    ),
    backgroundColor: appYellow,
    centerTitle: true,
    actions: [
      GestureDetector(
        onTap: () {},
      )
    ],
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
          activeColor: appYellow,
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

class ContactCard extends StatelessWidget {
  //final name,sms, msges, date, img;
  final name, sms;

  ContactCard({this.name, this.sms});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: LinePainter(),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: AssetImage(rkm2),
                      radius: 30,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          name ?? "Name is loading...",
                          style: TextStyle(
                              fontSize: 18.0,
                              color: appBlack,
                              letterSpacing: 0.5,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          sms ?? "Last message is loading...",
                          style: TextStyle(
                              fontSize: 14.0,
                              letterSpacing: 0.5,
                              color: appLightBlack.withOpacity(0.9)),
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Aug 24",
                      style: TextStyle(
                          fontSize: 12.0,
                          letterSpacing: 0.5,
                          color: appLightBlack.withOpacity(0.9)),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                        constraints:
                            BoxConstraints(minHeight: 24, minWidth: 24),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: appYellow,
                            borderRadius: BorderRadius.circular(30)),
                        child: Wrap(
                          direction: Axis.horizontal,
                          alignment: WrapAlignment.center,
                          children: [
                            Text(
                              "1",
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ))
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 2,
          )
          //Divider(),
        ],
      ),
    );
  }
}

class ChatBubbleMine extends StatefulWidget {
  final String msg;

  ChatBubbleMine({this.msg});

  @override
  _ChatBubbleMineState createState() => _ChatBubbleMineState();
}

class _ChatBubbleMineState extends State<ChatBubbleMine> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.0),
      padding: EdgeInsets.only(left: 0, right: 24.0),
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 10),
        margin: EdgeInsets.only(left: 30),
        decoration: BoxDecoration(
            color: appChatOrange,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0))),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Flexible(
              fit: FlexFit.loose,
              child: Text(
                widget.msg,
                textAlign: TextAlign.start,
                /*controller: messageTextEditingController,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,*/
                style: TextStyle(
                  fontSize: 16.0,
                  letterSpacing: 0.5,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0, left: 8),
              child: Row(
                children: <Widget>[
                  Text(
                    "8.00pm",
                    style: TextStyle(
                        fontSize: 12.0, color: Colors.red, letterSpacing: 0.5),
                  ),
                  SizedBox(width: 5),
                  Icon(
                    Icons.check,
                    size: 15,
                    color: Colors.red,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatBubbleContact extends StatefulWidget {
  @override
  _ChatBubbleContactState createState() => _ChatBubbleContactState();
}

class _ChatBubbleContactState extends State<ChatBubbleContact> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.0),
      padding: EdgeInsets.only(left: 24, right: 0),
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.only(top: 10, bottom: 10, left: 18, right: 10),
        margin: EdgeInsets.only(right: 30),
        decoration: BoxDecoration(
            color: appChatGreen,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0))),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              fit: FlexFit.loose,
              child: Text(
                forgotPwd,
                textAlign: TextAlign.start,
                maxLines: null,
                /*controller: messageTextEditingController,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,*/
                style: TextStyle(
                  fontSize: 16.0,
                  letterSpacing: 0.5,
                  color: appBlack,
                ),
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(height: 2),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        "8.05pm",
                        style: TextStyle(
                            fontSize: 12.0,
                            color: appLightBlack.withOpacity(.9),
                            letterSpacing: 0.5),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.check,
                        size: 15,
                        color: appLightBlack.withOpacity(0.9),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class NewChatB extends StatefulWidget {
  final String sms;

  NewChatB({this.sms});

  @override
  _NewChatBState createState() => _NewChatBState();
}

class _NewChatBState extends State<NewChatB> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.5),
      padding: EdgeInsets.only(left: 0, right: 24.0),
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.only(top: 10, bottom: 5, left: 20, right: 10),
        margin: EdgeInsets.only(left: 30),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  blurRadius: 4.0,
                  offset: Offset(4.0, 2.0),
                  color: Colors.black54)
            ],
            color: appChatOrange,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text.rich(
              buildTextSpan(),
              strutStyle: StrutStyle(fontSize: 18.0),
            ),
            /*Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "8.00pm",
                  style: TextStyle(
                      fontSize: 12.0,
                      color: appLightBlack.withOpacity(.8),
                      letterSpacing: 0.5),
                ),
                SizedBox(
                  width: 5,
                ),
                Icon(
                  Icons.check,
                  size: 15,
                  color: appLightBlack.withOpacity(0.9),
                )
              ],
            ),*/
          ],
        ),
      ),
    );
  }

  TextSpan buildTextSpan() {
    return TextSpan(
      style: TextStyle(
        fontSize: 16.0,
        letterSpacing: 0.5,
        color: appBlack,
      ),
      children: [
        TextSpan(text: widget.sms),
        WidgetSpan(
          alignment: PlaceholderAlignment.bottom,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
            child: Text(
              "8.05pm",
              style: TextStyle(
                  fontSize: 12.0,
                  color: appLightBlack.withOpacity(0.8),
                  letterSpacing: 0.5),
            ),
          ),
        ),
        WidgetSpan(
          child: Icon(
            Icons.check,
            size: 14,
            color: appLightBlack.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}

class CustomCard extends StatelessWidget {
  final String msg = "OTP has been sent to your registered mail id";
  final String additionalInfo = "Aug 25";

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  //real message
                  TextSpan(
                    text: msg + "    ",
                    style: Theme.of(context).textTheme.subtitle2,
                  ),

                  //fake additionalInfo as placeholder
                  TextSpan(
                      text: additionalInfo,
                      style:
                          TextStyle(color: Color.fromRGBO(255, 255, 255, 1))),
                ],
              ),
            ),
          ),

          //real additionalInfo
          Positioned(
            child: Row(
              children: <Widget>[
                Text(
                  additionalInfo,
                  style: TextStyle(
                    fontSize: 12.0,
                  ),
                ),
                Icon(
                  Icons.check,
                  size: 15,
                  color: appLightBlack.withOpacity(0.9),
                )
              ],
            ),
            right: 8.0,
            bottom: 4.0,
          )
        ],
      ),
    );
  }
}

class ChatBubbleNewMine extends StatelessWidget {
  final msg;

  ChatBubbleNewMine(this.msg);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2),
      padding: EdgeInsets.only(left: 0, right: 20.0),
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
        margin: EdgeInsets.only(left: 80),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  blurRadius: 1.0,
                  offset: Offset(1.0, 1.0),
                  color: Colors.black38)
            ],
            color: appChatOrange,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0))),
        child: Wrap(
          alignment: WrapAlignment.end,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                left: 2,
                right: 2,
                top: 2,
              ),
              child: Text(
                msg,
                style: TextStyle(
                  fontSize: 16.0,
                  letterSpacing: 0.5,
                  color: appBlack,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2, left: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                verticalDirection: VerticalDirection.down,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "10:0 am ",
                    style: TextStyle(
                        fontSize: 12.0,
                        color: appLightBlack.withOpacity(0.8),
                        letterSpacing: 0.5),
                  ),
                  Icon(
                    Icons.check,
                    size: 14,
                    color: appLightBlack.withOpacity(0.8),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatBubbleNewContact extends StatelessWidget {
  final msg;

  ChatBubbleNewContact(this.msg);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2),
      padding: EdgeInsets.only(left: 20, right: 0.0),
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
        margin: EdgeInsets.only(right: 80),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  blurRadius: 1.0,
                  offset: Offset(-1.0, 1.0),
                  color: Colors.black38)
            ],
            color: appChatGreen,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0))),
        child: Wrap(
          alignment: WrapAlignment.end,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(
                left: 2,
                right: 2,
                top: 2,
              ),
              child: Text(
                msg,
                style: TextStyle(
                  fontSize: 16.0,
                  letterSpacing: 0.5,
                  color: appBlack,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 5, bottom: 0),
              padding: const EdgeInsets.only(top: 6, left: 4),
              child: Text(
                "10:0 am ",
                textAlign: TextAlign.end,
                style: TextStyle(
                    fontSize: 12.0,
                    color: appLightBlack.withOpacity(0.8),
                    letterSpacing: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AttachmentIconClass extends StatefulWidget {
  @override
  _AttachmentIconClassState createState() => _AttachmentIconClassState();
}

class _AttachmentIconClassState extends State<AttachmentIconClass> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(top: 3, bottom: 3, right: 20, left: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: appLightBlack,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(
            Icons.photo_camera,
            color: appBackground,
          ),
          Icon(
            Icons.photo_size_select_actual,
            color: appBackground,
          ),
          Icon(
            Icons.insert_drive_file,
            color: appBackground,
          ),
          Icon(
            Icons.account_circle,
            color: appBackground,
          ),
        ],
      ),
    );
  }
}
