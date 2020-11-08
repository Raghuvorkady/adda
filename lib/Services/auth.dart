import 'package:adda/ActivityScreens/Conversation.dart';
import 'package:adda/Model/MyUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthMethodsClass {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //_ is used to make a variable private
  MyUserClass _userFromFirebaseUser(FirebaseUser firebaseUser) {
    return firebaseUser != null ? MyUserClass(uid: firebaseUser.uid) : null;
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      // ignore: deprecated_member_use
      FirebaseUser firebaseUser = result.user;
      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser firebaseUser = result.user;
      //firebaseUser.sendEmailVerification();
      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future resetPassword(String email) {
    try {
      return _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _firebaseAuth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<FirebaseUser> signInWithGoogle(BuildContext context) async {
    final GoogleSignIn _googleSignIn = new GoogleSignIn();

    final GoogleSignInAccount googleSignInAccount =
    await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    AuthResult result = await _firebaseAuth.signInWithCredential(credential);
    FirebaseUser userDetails = result.user;

    if (result == null) {
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => ConversationClass()));
    }
  }

}