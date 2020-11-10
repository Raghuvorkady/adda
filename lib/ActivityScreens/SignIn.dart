import 'package:adda/ActivityScreens/ForgotPasswordEnterEmail.dart';
import 'package:adda/ActivityScreens/HomeScreen.dart';
import 'package:adda/HelperClass/HelperFunctions.dart';
import 'package:adda/Resources/Icons.dart';
import 'package:adda/Resources/Strings.dart';
import 'package:adda/Services/MyDatabase.dart';
import 'package:adda/Services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class SignInClass extends StatefulWidget {
  final Function toggle;

  SignInClass(this.toggle);

  @override
  _SignInClassState createState() => _SignInClassState();
}

class _SignInClassState extends State<SignInClass> {
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();

  bool isLoading = false;

  AuthMethodsClass authMethods = new AuthMethodsClass();
  MyDatabaseClass myDatabase = new MyDatabaseClass();

  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();
  final _emailFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  bool _emailValidated = false;
  bool _passwordValidated = false;

  bool _showPassword = false;
  bool _passwordEye = false;

  String emailValidator(email) {
    String _emailPattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp _regExp = new RegExp(_emailPattern);
    return _regExp.hasMatch(email) ? null : "please enter a valid email";
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  signInMethod() async {
    if (_emailFormKey.currentState.validate() &&
        _passwordFormKey.currentState.validate()) {
      String _userEmail = emailTextEditingController.text;
      String _password = passwordTextEditingController.text;

      HelperFunctions.setUserEmailSharedPreference(_userEmail);

      setState(() {
        isLoading = true;
      });

      await authMethods
          .signInWithEmailAndPassword(_userEmail, _password)
          .then((value) async {
        if (value != null) {
          QuerySnapshot querySnapshotUserInfo =
              await MyDatabaseClass().getUserByUserEmail(_userEmail);
          HelperFunctions.setUserLoggedInSharedPreference(true);
          HelperFunctions.setUserNameSharedPreference(
              querySnapshotUserInfo.documents[0].data["name"]);
          HelperFunctions.setUserEmailSharedPreference(
              querySnapshotUserInfo.documents[0].data["email"]);
          HelperFunctions.setUserIDSharedPreference(
              querySnapshotUserInfo.documents[0].data["userID"]);

          String userName = await HelperFunctions.getUserNameSharedPreference();
          String email = await HelperFunctions.getUserEmailSharedPreference();
          String userID = await HelperFunctions.getUserIDSharedPreference();

          print(
              "FROM SHARED PREF\nUSERNAME : $userName\nEMAIL : $email\nUSER ID : $userID");

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreenClass(),
              ));
        } else {
          setState(() {
            isLoading = false;
            //show snackbar
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : Container(
              height: height,
              margin: EdgeInsets.only(bottom: 15),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(height: height * .2),
                    Image.asset(
                      logoWithName,
                      height: height / 5,
                      width: width / 2,
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.0),
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 0.0),
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
                          controller: emailTextEditingController,
                          textInputAction: TextInputAction.next,
                          focusNode: emailFocus,
                          onFieldSubmitted: (s) {
                            _emailFormKey.currentState.validate()
                                ? _emailValidated = true
                                : _emailValidated = false;
                            print("EMAIL $_emailValidated");
                            _emailValidated
                                ? _fieldFocusChange(
                                    context, emailFocus, passwordFocus)
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
                      height: 12,
                    ),
                    Container(
                      height: 48,
                      margin: EdgeInsets.symmetric(horizontal: 20.0),
                      padding: EdgeInsets.fromLTRB(15, 1, 10, 1),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(color: HexColor("#777777")),
                        color: Colors.white,
                      ),
                      child: Form(
                        key: _passwordFormKey,
                        child: TextFormField(
                          focusNode: passwordFocus,
                          controller: passwordTextEditingController,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (string) {
                            _passwordFormKey.currentState.validate()
                                ? _passwordValidated = true
                                : _passwordValidated = false;
                            _passwordValidated
                                ? Focus.of(context).unfocus()
                                : print("EMAIL false");
                          },
                          style: TextStyle(
                              color: HexColor("#444444"),
                              fontSize: 14.0,
                              letterSpacing: 0.5),
                          obscureText: !_showPassword,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  print("PRESSED $_showPassword");
                                  _showPassword = !_showPassword;
                                  _passwordEye = !_passwordEye;
                                });
                              },
                              icon: _passwordEye
                                  ? Image.asset(
                                      eyeOff,
                                      width: 20,
                                      height: 20,
                                    )
                                  : Image.asset(eyeOn, width: 20, height: 20),
                            ),
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                                fontSize: 14.0,
                                letterSpacing: 0.5,
                                color: HexColor("#999999")),
                            hintText: "password",
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
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
                          onPressed: () {
                            signInMethod();
                          },
                          child: Text(
                            "Sign in",
                            style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 1,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ForgotPasswordEnterEmailClass(),
                          )),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(forgotPwd,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: HexColor("#777777"),
                                letterSpacing: 0.5)),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.center,
                      child: Text(noAccount,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.5,
                              color: HexColor("#777777"))),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: RaisedButton(
                          color: HexColor("#7998DF"),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          splashColor: HexColor("#6A92ED"),
                          onPressed: () {
                            widget.toggle();
                          },
                          child: Text(
                            "Sign up",
                            style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 1,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
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
