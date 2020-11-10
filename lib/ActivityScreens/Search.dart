import 'package:adda/ActivityScreens/Conversation.dart';
import 'package:adda/HelperClass/Constants.dart';
import 'package:adda/HelperClass/Widget.dart';
import 'package:adda/Resources/Colors.dart';
import 'package:adda/Resources/Strings.dart';
import 'package:adda/Services/MyDatabase.dart';
import 'package:adda/examples/line_painter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class SearchClass extends StatefulWidget {
  @override
  _SearchClassState createState() => _SearchClassState();
}

class _SearchClassState extends State<SearchClass> {
  TextEditingController searchTextEditingController =
      new TextEditingController();
  MyDatabaseClass myDatabase = new MyDatabaseClass();
  QuerySnapshot searchSnapshot;

  bool isLoading = false;
  bool haveUserSearched = false;

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              print(
                  "USER NAME BY SEARCH ${searchSnapshot.documents[index].data["name"]}");
              print(
                  "USER EMAIL BY SEARCH ${searchSnapshot.documents[index].data["email"]}");
              print(
                  "USER ID BY SEARCH ${searchSnapshot.documents[index].data["userID"]}");

              return searchTile(
                  userName: searchSnapshot.documents[index].data["name"],
                  userEmail: searchSnapshot.documents[index].data["email"],
                  photoUrl: searchSnapshot.documents[index].data["photoUrl"],
                  userID: searchSnapshot.documents[index].data["userID"]);
            },
            itemCount: searchSnapshot.documents.length,
          )
        : Container();
  }

  initiateSearch() {
    String searchText = searchTextEditingController.text;
    if (searchText.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
    }
    myDatabase.getUserByUsername(searchText).then((value) {
      setState(() {
        searchSnapshot = value;
        isLoading = false;
        haveUserSearched = true;
      });
    });
    print("Search: $searchSnapshot");
  }

  createChatRoomAndConversation(
      {String userName, String photoUrl, String userID}) {
    print("MY NAME IN SEARCH ${ConstantsClass.myName}");
    print("MY USER ID IN SEARCH ${ConstantsClass.myUserId}");
    print("CONTACT NAME IN SEARCH ${ConstantsClass.chatName}");
    print("CONTACT ID IN SEARCH ${ConstantsClass.contactUserId}");

    print(ConstantsClass.myUserId);

    String contactUerId = userID;

    String chatRoomId = getChatRoomId(userName, ConstantsClass.myName);
    String chatRoomId1 = getChatRoomId(userID, ConstantsClass.myUserId);

    print("CHATROOMID : $chatRoomId");
    print("CHATROOMID1 : $chatRoomId1");

    List<String> users1 = [userID, ConstantsClass.myUserId];
    List<String> users = [userName, ConstantsClass.myName];

    Map<String, dynamic> chatRoomMap1 = {
      "users": users1,
      "chatRoomId": chatRoomId1
    };

    Map<String, dynamic> chatRoomMap = {
      "users": users,
      "chatRoomId": chatRoomId
    };

    print("CHATROOMMAP : $chatRoomMap");
    print("CHATROOMMAP1 : $chatRoomMap1");

    if (userID != ConstantsClass.myUserId) {
      print("CHAT ROOM CREATED!");
      MyDatabaseClass().createChatRoom(chatRoomId1, chatRoomMap1);

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConversationClass(
              chatRoomId: chatRoomId1,
              photoUrl: photoUrl,
              contactUserId: contactUerId,
            ),
          ));
    } else {
      print("CHAT ROOM NOT CREATED!");
      print("you cannot send message to yourself");
    }
  }

  Widget searchTile(
      {String userName, String userEmail, String photoUrl, String userID}) {
    return CustomPaint(
      painter: LinePainter(),
      child: ListTile(
        onTap: () {
          createChatRoomAndConversation(
              userName: userName, photoUrl: photoUrl, userID: userID);
          ConstantsClass.chatName = searchTextEditingController.text;
        },
        contentPadding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 16.0),
        leading: CachedNetworkImage(
          imageUrl: photoUrl ?? defaultProfile,
          placeholder: (context, url) => CircularProgressIndicator(),
          imageBuilder: (context, imageProvider) => Container(
            child: CircleAvatar(
              radius: 28.0,
              backgroundImage: imageProvider,
            ),
          ),
        ),
        title: Text(
          userName ?? "Name is loading...",
          style: TextStyle(
              fontSize: 18.0,
              color: appBlack,
              letterSpacing: 0.5,
              fontWeight: FontWeight.w600),
        ),
        subtitle: Row(
          children: <Widget>[
            /*iconSubtitle == null
                ? Container()
                : Padding(
                padding: EdgeInsets.only(right: 2.0), child: iconSubtitle),*/
            /*Flexible(
              child: Text(
                "userName",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 14.0,
                    letterSpacing: 0.5,
                    color: appLightBlack.withOpacity(0.9)),
              ),
            ),*/
          ],
        ),
        trailing: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            /*Text(
              new DateFormat('dd/MM/yy').format(DateTime.now()),
              style: TextStyle(
                  fontSize: 12.0,
                  letterSpacing: 0.5,
                  color: appLightBlack.withOpacity(0.9)),
            ),*/
            Container(
                constraints: BoxConstraints(minHeight: 24, minWidth: 24),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: HexColor("#7998DF"),
                    borderRadius: BorderRadius.circular(30)),
                child: Text(
                  "tap to chat!",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: verifyAndForgotAppBar("Search Contacts"),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              padding: EdgeInsets.only(left: 20, bottom: 8, right: 8, top: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: searchTextEditingController,
                      style: TextStyle(
                          fontSize: 16.0, letterSpacing: 0.5, color: appBlack),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search username ...",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      customBorder: new CircleBorder(),
                      onTap: () {
                        initiateSearch();
                      },
                      splashColor: splashColor,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          Icons.search,
                          color: appLightBlack,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            searchList(),
          ],
        ),
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.length > b.length) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
