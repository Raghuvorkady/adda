import 'package:adda/ActivityScreens/HomeScreen.dart';
import 'package:adda/HelperClass/Constants.dart';
import 'package:adda/HelperClass/HelperFunctions.dart';
import 'package:adda/HelperClass/Resources.dart';
import 'package:adda/Services/MyDatabase.dart';
import 'package:adda/Services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:uuid/uuid.dart';

class SignUpClass extends StatefulWidget {
  final Function toggle;

  SignUpClass(this.toggle);

  @override
  _SignUpClassState createState() => _SignUpClassState();
}

class _SignUpClassState extends State<SignUpClass> {
  final FocusNode userNameFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  final FocusNode confirmPasswordFocus = FocusNode();

  TextEditingController userNameTextEditingController =
      new TextEditingController();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();
  TextEditingController confirmPasswordTextEditingController =
      new TextEditingController();

  final _userNameFormKey = GlobalKey<FormState>();
  final _emailFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  final _confirmPasswordFormKey = GlobalKey<FormState>();

  bool _userNameValidated = false;
  bool _emailValidated = false;
  bool _passwordValidated = false;
  bool _confirmPasswordValidated = false;

  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _passwordEye = false;
  bool _confirmPasswordEye = false;

  bool isLoading = false;

  AuthMethodsClass authMethods = new AuthMethodsClass();
  MyDatabaseClass myDatabase = new MyDatabaseClass();
  HelperFunctions helperFunctions = new HelperFunctions();

  var uuid = Uuid();

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

  String emailValidator(email) {
    String _emailPattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp _regExp = new RegExp(_emailPattern);
    return _regExp.hasMatch(email) ? null : "please enter a valid email";
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

  signMeUp() async {
    String _userName = userNameTextEditingController.text;
    String _userEmail = emailTextEditingController.text;

    if (_userNameFormKey.currentState.validate() &&
        _emailFormKey.currentState.validate() &&
        _passwordFormKey.currentState.validate() &&
        _confirmPasswordFormKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      await authMethods
          .signUpWithEmailAndPassword(emailTextEditingController.text,
              passwordTextEditingController.text)
          .then((value) {
        if (value != null) {
          DocumentReference documentReference =
              Firestore.instance.collection("users").document();

          //ConstantsClass.myUserId = uuid.v4();
          ConstantsClass.myUserId = documentReference.documentID;

          Map<String, String> userInfoMap = {
            "name": _userName,
            "email": _userEmail,
            "userID": ConstantsClass.myUserId,
            "photoUrl": defaultProfile,
          };

          documentReference.setData(userInfoMap);

          print("USER-INFO-MAP ${userInfoMap["name"]}");
          print("USER-INFO-MAP ${userInfoMap["email"]}");
          print("USER-INFO-MAP ${userInfoMap["userID"]}");
          print("USER-INFO-MAP ${userInfoMap["token"]}");
          print("CONTACT CLASS USER ID ${ConstantsClass.myUserId}");

          // myDatabase.uploadUserInfo(userInfoMap);
          HelperFunctions.setUserLoggedInSharedPreference(true);
          HelperFunctions.setUserNameSharedPreference(_userName);
          HelperFunctions.setUserEmailSharedPreference(_userEmail);
          HelperFunctions.setUserIDSharedPreference(ConstantsClass.myUserId);

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreenClass(),
              ));
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
                      height: 50,
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
                        key: _userNameFormKey,
                        child: TextFormField(
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                              letterSpacing: 0.5),
                          controller: userNameTextEditingController,
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.words,
                          focusNode: userNameFocus,
                          onFieldSubmitted: (s) {
                            _userNameFormKey.currentState.validate()
                                ? _userNameValidated = true
                                : _userNameValidated = false;
                            print("USERNAME $_userNameValidated");
                            _userNameValidated
                                ? _fieldFocusChange(
                                    context, userNameFocus, emailFocus)
                                : print("USERNAME false");
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
                            hintText: "username",
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
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
                              color: Colors.black,
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
                      margin: EdgeInsets.symmetric(horizontal: 20.0),
                      padding: EdgeInsets.fromLTRB(15, 1, 10, 0),
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
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (string) {
                            _passwordFormKey.currentState.validate()
                                ? _passwordValidated = true
                                : _passwordValidated = false;
                            _passwordValidated
                                ? _fieldFocusChange(context, passwordFocus,
                                    confirmPasswordFocus)
                                : print("PASSWORD false");
                          },
                          validator: (password) {
                            return passwordValidator(password);
                          },
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                              letterSpacing: 0.5),
                          obscureText: !_showPassword,
                          decoration: InputDecoration(
                            errorStyle: TextStyle(color: Colors.red),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  print("PRESSED $_showPassword");
                                  _showPassword = !_showPassword;
                                  _passwordEye = !_passwordEye;
                                });
                              },
                              icon: _passwordEye
                                  ? Image.asset(eyeOff, width: 20, height: 20,)
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
                      height: 12,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.0),
                      padding: EdgeInsets.fromLTRB(15, 1, 10, 1),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(color: HexColor("#777777")),
                        color: Colors.white,
                      ),
                      child: Form(
                        key: _confirmPasswordFormKey,
                        child: TextFormField(
                          focusNode: confirmPasswordFocus,
                          controller: confirmPasswordTextEditingController,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (string) {
                            _confirmPasswordFormKey.currentState.validate()
                                ? _confirmPasswordValidated = true
                                : _confirmPasswordValidated = false;
                            _confirmPasswordValidated
                                ? Focus.of(context).unfocus()
                                : print(
                                    "CONFIRM PASSWORD $_confirmPasswordValidated");
                          },
                          validator: (confirmPassword) {
                            if (passwordTextEditingController.text !=
                                confirmPassword) {
                              print(" passwords do not match");
                              return "passwords do not match";
                            } else {
                              print(" passwords match");
                              return null;
                            }
                          },
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                              letterSpacing: 0.5),
                          obscureText: !_showConfirmPassword,
                          decoration: InputDecoration(
                            errorStyle: TextStyle(color: Colors.red),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  print("PRESSED $_showConfirmPassword");
                                  _showConfirmPassword = !_showConfirmPassword;
                                  _confirmPasswordEye = !_confirmPasswordEye;
                                });
                              },
                              icon: _confirmPasswordEye
                                  ? Image.asset(eyeOff, width: 20, height: 20,)
                                  : Image.asset(eyeOn, width: 20, height: 20),
                            ),
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                                fontSize: 14.0,
                                letterSpacing: 0.5,
                                color: HexColor("#999999")),
                            hintText: "confirm password",
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
                            signMeUp();
                          },
                          child: Text(
                            "Sign up",
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
                      height: 30,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.center,
                      child: Text(yesAccount,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: HexColor("#777777"),
                              letterSpacing: 0.5)),
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          color: HexColor("#7998DF"),
                          splashColor: HexColor("#6A92ED"),
                          onPressed: () {
                            widget.toggle();
                          },
                          child: Text(
                            "Sign in",
                            style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 0.5,
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
