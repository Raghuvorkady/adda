import 'dart:async';

import 'package:adda/ActivityScreens/HomeScreen.dart';
import 'package:adda/HelperClass/Constants.dart';
import 'package:adda/HelperClass/Resources.dart';
import 'package:adda/HelperClass/Widget.dart';
import 'package:adda/Services/MyDatabase.dart';
import 'package:adda/Widgets/ChatBubbleContact.dart';
import 'package:adda/Widgets/ChatBubbleMine.dart';
import 'package:adda/Widgets/MessageBar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class ConversationClass extends StatefulWidget {
  final String chatRoomId, photoUrl, contactUserId;
  final bool isOnline;

  ConversationClass({this.chatRoomId, this.photoUrl, this.isOnline, this.contactUserId});

  @override
  _ConversationClassState createState() => _ConversationClassState();
}

class _ConversationClassState extends State<ConversationClass> {
  MyDatabaseClass myDatabase = new MyDatabaseClass();
  TextEditingController messageTextEditingController =
      new TextEditingController();

  ScrollController listViewScrollController = new ScrollController();
  Stream<QuerySnapshot> chatMessageStream;

  bool isOnline = false;

  Widget chatMessageList() {
    // After 1 second, it takes you to the bottom of the ListView
    Timer(
      Duration(seconds: 1),
      () => listViewScrollController
          .jumpTo(listViewScrollController.position.maxScrollExtent),
    );
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                controller: listViewScrollController,
                shrinkWrap: true,
                reverse: true,
                scrollDirection: Axis.vertical,
                //TODO new change here
                //physics: ClampingScrollPhysics(),
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  bool isSendByMe =
                      snapshot.data.documents[index].data["sendBy"] ==
                          ConstantsClass.myUserId;
                  if (isSendByMe) {
                    return ChatBubbleMineClass(
                        message: snapshot.data.documents[index].data["message"],
                        messageType:
                            snapshot.data.documents[index].data["messageType"],
                        fileName:
                            snapshot.data.documents[index].data["fileName"],
                        fileExtension: snapshot
                            .data.documents[index].data["fileExtension"],
                        isDelivered: snapshot.data.documents[index].data["isDelivered"],
                        timeStamp: new DateTime.fromMillisecondsSinceEpoch(
                            snapshot.data.documents[index].data["time"]));
                  } else {
                    return ChatBubbleContactClass(
                        message: snapshot.data.documents[index].data["message"],
                        messageType:
                            snapshot.data.documents[index].data["messageType"],
                        fileName:
                            snapshot.data.documents[index].data["fileName"],
                        fileExtension: snapshot
                            .data.documents[index].data["fileExtension"],
                        timeStamp: new DateTime.fromMillisecondsSinceEpoch(
                            snapshot.data.documents[index].data["time"]));
                  }
                },
              )
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  @override
  void initState() {
    myDatabase.getConversationMessages(widget.chatRoomId).then((value) {
      setState(() {
        chatMessageStream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //listViewScrollController.animateTo(listViewScrollController.position.maxScrollExtent, curve: Curves.fastOutSlowIn);
    CollectionReference reference =
    Firestore.instance.collection('users');
    reference.snapshots().listen((querySnapshot) {
      querySnapshot.documentChanges.forEach((change) async{
          if (widget.contactUserId == change.document.documentID) {
            setState(() {
              isOnline = change.document.data["isOnline"]??false;
            });
          }
      });
    });
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
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
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Scrollbar(
                  controller: listViewScrollController,
                  child: SingleChildScrollView(
                    child: chatMessageList(),
                  ),
                ),
              ),
              MessageBarClass(
                myDatabase: myDatabase,
                chatRoomId: widget.chatRoomId,
                contactUserId: widget.contactUserId,
                scrollController: listViewScrollController,
              ),
              /*Container(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 63),
                child: Scrollbar(controller: listViewScrollController,child: chatMessageList()),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MessageBar(
                    myDatabase: myDatabase,
                    chatRoomId: widget.chatRoomId,
                    scrollController: listViewScrollController,
                  ),
                ],
              ),
            ],

          ),
        ),*/
            ],
          ),
        ],
      ),
    );
  }

  // ignore: missing_return
  Future<bool> _onBackPressed() {
    MessageBarClass.popupMenu.dismiss();
//    return null;
    /*showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Text("NO"),
              ),
              SizedBox(height: 16),
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(true),
                child: Text("YES"),
              ),
            ],
          ),
        ) ??
        false;*/
  }
}
