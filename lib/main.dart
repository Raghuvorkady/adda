import 'dart:async';

import 'package:adda/ActivityScreens/HomeScreen.dart';
import 'package:adda/ActivityScreens/LogicScreen.dart';
import 'package:adda/HelperClass/Authenticate.dart';
import 'package:adda/HelperClass/HelperFunctions.dart';
import 'package:adda/HelperClass/Resources.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userIsLoggedIn;

  @override
  void initState() {
    getLoggedStatus();
    requestPermission();
    super.initState();
  }

  getLoggedStatus() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      setState(() {
        userIsLoggedIn = value;
        print("USER LOGGED IN STATUS $userIsLoggedIn");
      });
    });
  }

  //PushNotificationService pushNotificationService = new PushNotificationService();

  requestPermission() async {
    var storagePermissionStatus = await Permission.storage.status;
    var contactsPermissionStatus = await Permission.contacts.status;
    var cameraPermissionStatus = await Permission.camera.status;
    var notificationPermissionStatus = await Permission.notification.status;

    if (storagePermissionStatus.isUndetermined ||
        storagePermissionStatus.isDenied ||
        contactsPermissionStatus.isUndetermined ||
        contactsPermissionStatus.isDenied ||
        cameraPermissionStatus.isUndetermined ||
        cameraPermissionStatus.isDenied) {
      // You can request multiple permissions at once.

      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
        Permission.contacts,
        Permission.camera
      ].request();
      print(statuses[
          Permission.storage]); // it should print PermissionStatus.granted
      print(statuses[
          Permission.contacts]); // it should print PermissionStatus.granted
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LogicScreenClass(isUserLoggedIn: userIsLoggedIn,),
    );
  }
}
