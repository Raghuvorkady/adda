import 'package:adda/ActivityScreens/HomeScreen.dart';
import 'package:adda/HelperClass/Constants.dart';
import 'package:adda/HelperClass/Resources.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class ChatScreenAppBarStateLess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChatScreenAppBarClass();
  }
}

class ChatScreenAppBarClass extends StatefulWidget {
  final String photoUrl;
  final bool isOnline;
  ChatScreenAppBarClass({this.photoUrl, this.isOnline});

  @override
  _ChatScreenAppBarClassState createState() => _ChatScreenAppBarClassState();
}

class _ChatScreenAppBarClassState extends State<ChatScreenAppBarClass> {
  bool isOnline = false;
  @override
  Widget build(BuildContext context) {
    print("PHOTO_URL : ${widget.photoUrl}");
    CollectionReference reference =
    Firestore.instance.collection('users');
    reference.snapshots().listen((querySnapshot) {
      querySnapshot.documentChanges.forEach((change) {
        var type = change.type.toString();
        var a1 = change.document.reference;
        var a2 = change.document.exists;
        var a = change.document.data["name"];
        var online = change.document.data["isOnline"];
        var oldIndex = change.oldIndex;
        var newIndex = change.newIndex;
        for (int i = 0; i < HomeScreenClass.usersInfo.length; i++) {
          if (HomeScreenClass.usersInfo[i].userID == change.document.documentID) {
            var isOnlineTemp = change.document.data["isOnline"];
            setState(() {
              HomeScreenClass.usersInfo[i].isOnline = isOnlineTemp??false;
              isOnline =  HomeScreenClass.usersInfo[i].isOnline;
            });
          }
        }
      });
    });
    return AppBar(
      elevation: 1,
      title: ListTile(
        leading: widget.photoUrl != null
            ? CachedNetworkImage(
            width: 40,
            height: 40,
            imageUrl: widget.photoUrl,
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
}
