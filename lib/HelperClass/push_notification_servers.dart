

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class PushNotificationService extends StatefulWidget {
  @override
  _PushNotificationServiceState createState() => _PushNotificationServiceState();
}

class _PushNotificationServiceState extends State<PushNotificationService> {
  final Firestore db = Firestore.instance;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firebaseMessaging.configure(
      //called when the app is in the foreground and we receive a push notification
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage: $message");

          final snackBar = SnackBar(
            content: Text(message["notification"]["title"]),
            action: SnackBarAction(
              onPressed: () {  }, label: "Go",),
          );
          
          Scaffold.of(context).showSnackBar(snackBar);
        },
        //called when the app is closed completely and it's opened from the push notification directly
        onLaunch: (Map<String, dynamic> message) async {
          print("onMessage: $message");
        },
        //called when the app is in the background and it's opened from the push notification directly
        onResume: (Map<String, dynamic> message) async {
          print("onMessage: $message");
        });
  }

  saveDeviceToken() async{
    //String uid = "jeff123";

    String fcmToken = await firebaseMessaging.getToken();

    if(fcmToken!=null){
      //var tokenRef =
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(

    );
  }
}

