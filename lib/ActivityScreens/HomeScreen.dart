import 'package:adda/ActivityScreens/ProfileScreen.dart';
import 'package:adda/ActivityScreens/Search.dart';
import 'package:adda/ActivityScreens/Settings.dart';
import 'package:adda/HelperClass/Authenticate.dart';
import 'package:adda/HelperClass/Constants.dart';
import 'package:adda/HelperClass/HelperFunctions.dart';
import 'package:adda/HelperClass/SharedPref.dart';
import 'package:adda/Model/ChatRoomTileInfo.dart';
import 'package:adda/Resources/Choice.dart';
import 'package:adda/Resources/Colors.dart';
import 'package:adda/Resources/UserInfo.dart';
import 'package:adda/Services/MyDatabase.dart';
import 'package:adda/Services/auth.dart';
import 'package:adda/Widgets/ContactCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreenClass extends StatefulWidget {
  static List<UserInfoClass> usersInfo = [];

  @override
  _HomeScreenClassState createState() => _HomeScreenClassState();
}

class _HomeScreenClassState extends State<HomeScreenClass>
    with WidgetsBindingObserver {
  AuthMethodsClass authMethods = new AuthMethodsClass();
  MyDatabaseClass database = new MyDatabaseClass();
  Stream chatRoomsStream;
  bool isLoading = true;

  FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  DocumentReference documentReference =
      Firestore.instance.collection("users").document(ConstantsClass.myUserId);
  QuerySnapshot querySnapshot;
  var chatRoomId;

  //List<UserInfoClass> usersInfo = [];
  List<UserInfoClass> userInfoObject = [];
  List<ChatRoomTileInfoClass> chatRoomInfo = [];

  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var length = snapshot.data.documents.length;
                  String userName, profilePhotoUrl;
                  bool isOnline = false;

                  print("\n CHECK CONTACT ID : ${ConstantsClass.myUserId}\n");

                  var contactUserID = snapshot
                      .data.documents[index].data["chatRoomId"]
                      .toString()
                      .replaceAll("_", "")
                      .replaceAll(ConstantsClass.myUserId, "");

                  /*int contactsLength = snapshot.data.documents.length;
                  database.getUserInfoByUserId(contactUserID).then((value){
                    chatRoomInfo.add(ChatRoomTileInfoClass(
                      userName: value.documents[0].data["name"],
                      email: value.documents[0].data["email"],
                      userID: value.documents[0].data["userID"],
                      chatRoomId:snapshot.data.documents[index].data["chatRoomId"],
                      lastMessage: snapshot.data.documents[index].data["lastMessage"],
                      photoUrl: value.documents[0].data["photoUrl"],
                    ));
                  });*/

                  /*if (_usersInfo.contains(contactUserID)) {
                      ${_usersInfo[i].userID}
                    _usersInfo.indexOf();
                  }*/

                  if (HomeScreenClass.usersInfo.length == null) {
                    return Container(child: CircularProgressIndicator());
                  } else {
                    if (HomeScreenClass.usersInfo.length != null) {
                      for (int i = 0;
                          i < HomeScreenClass.usersInfo.length;
                          i++) {
                        if (contactUserID ==
                            HomeScreenClass.usersInfo[i].userID) {
                          userName = HomeScreenClass.usersInfo[i].userName;
                          profilePhotoUrl =
                              HomeScreenClass.usersInfo[i].photoUrl;
                          isOnline = HomeScreenClass.usersInfo[i].isOnline;
                          print("MY CHAT ROOM CONTACTS : $userName");
                        }
                      }
                    }
                  }

                  CollectionReference reference =
                      Firestore.instance.collection('users');
                  reference.snapshots().listen((querySnapshot) async {
                    querySnapshot.documentChanges.forEach((change) {
                      // Do something with change
                      /* print("Doc changes (isOnline) $isOnline");
                      print(change.document.data["name"]);*/
                      for (int i = 0; i < length; i++) {
                        if (HomeScreenClass.usersInfo[i].userID ==
                            change.document.documentID) {
                          setState(() {
                            HomeScreenClass.usersInfo[i].isOnline =
                                change.document.data["isOnline"] ?? false;
                            //TODO HomeScreenClass.usersInfo[i].userName
                            isOnline = HomeScreenClass.usersInfo[i].isOnline;
                          });
                        }
                      }
                    });
                  });
                  //TODO
                  // var userName1 = snapshot.data.documents[index].data["chatRoomId"];
                  return ChatRoomTile(
                      userName: userName,
                      //chatRoomInfo[index].userName,
                      /*snapshot.data.documents[index].data["chatRoomId"]
                            .toString()
                            .replaceAll("_", "")
                            .replaceAll(ConstantsClass.myUserId, "")*/
                      chatRoomId: // chatRoomInfo[index].chatRoomId,
                          snapshot.data.documents[index].data["chatRoomId"],
                      contactUserId: // chatRoomInfo[index].userID,
                          contactUserID,
                      photoUrl: profilePhotoUrl,
                      isOnline: isOnline,
                      //chatRoomInfo[index].photoUrl
                      lastMessage: //chatRoomInfo[index].lastMessage
                          snapshot.data.documents[index].data["lastMessage"]);
                })
            : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfoFromDatabase();
    getUserInfoChats();
    requestPermission();
    configureFCM();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  requestPermission() async {
    var storagePermissionStatus = await Permission.storage.status;
    var contactsPermissionStatus = await Permission.contacts.status;
    var cameraPermissionStatus = await Permission.camera.status;
    //var notificationPermissionStatus = await Permission.notification.status;

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

  getToken() async {
    await firebaseMessaging.getToken().then((fcmToken) async {
      print("TOKEN $fcmToken");
      Map<String, dynamic> userInfoMap = {'token': fcmToken};
      await documentReference
          .updateData(userInfoMap)
          .then((value) => print("success"))
          .catchError((onError) {
        print("error");
      });
    });
  }

  configureFCM() {
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
      /*onBackgroundMessage: (Map<String, dynamic> message) async {
        print("onBackgroundMessage: $message");
      },*/
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        updateStatus(true);
        print("resumed state");
        break;
      case AppLifecycleState.inactive:
        updateStatus(false);
        print("inactive state");
        break;
      case AppLifecycleState.paused:
        //updateStatus(false);
        print("paused state");
        break;
      case AppLifecycleState.detached:
        //updateStatus(false);
        print("detached state");
        break;
    }
  }

  updateStatus(bool status) async {
    Map<String, bool> userInfoMap = {
      'isOnline': status,
    };
    await documentReference
        .updateData(userInfoMap)
        .then((value) => print("success"))
        .catchError((onError) {
      print("error");
    });
  }

  getUserInfoFromDbUsingStream() {
    /*StreamBuilder streamBuilder;
    List<UserInfoClass> userInfoObject = [];
    database.getChatRooms(ConstantsClass.myUserId).then((snapshots) {
      StreamBuilder(
        stream: snapshots,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return snapshot.hasData?ListView.builder(
            itemCount: snapshot.data.documents.length,
              shrinkWrap: true,
              // ignore: missing_return
              itemBuilder: (context, index){

              },)
        },);
    });*/
  }

  getUserInfoFromDatabase() async {
    database.getUserInfo().then((snapshot) {
      setState(() {
        querySnapshot = snapshot;
        int len = querySnapshot.documents.length;
        HomeScreenClass.usersInfo = new List<UserInfoClass>(len);
        print("USER INFO MAP size: ${HomeScreenClass.usersInfo.length}");
        for (int i = 0; i < len; i++) {
          HomeScreenClass.usersInfo[i] = UserInfoClass(
              userName: querySnapshot.documents[i].data["name"],
              email: querySnapshot.documents[i].data["email"],
              userID: querySnapshot.documents[i].data["userID"],
              isOnline: querySnapshot.documents[i].data["isOnline"],
              photoUrl: querySnapshot.documents[i].data["photoUrl"]);
          print(
              "\nUSERs FROM DATABASE\nUSER NAME : ${HomeScreenClass.usersInfo[i].userName}");
          print("USER EMAIL : ${HomeScreenClass.usersInfo[i].email}");
          print("USER ID : ${HomeScreenClass.usersInfo[i].userID}");
        }
        /*Map<String, String> userInfo = {
          "userName": querySnapshot.documents[0].data["name"],
          "email": querySnapshot.documents[0].data["email"],
          "profilePic": querySnapshot.documents[0].data["profilePicUrl"],
        };
        print("USERINFO ${userInfo["userName"]}");*/
      });
    });
  }

  getUserInfoChats() async {
    ConstantsClass.myName = await HelperFunctions.getUserNameSharedPreference();
    ConstantsClass.myUserId = await HelperFunctions.getUserIDSharedPreference();

    print("MY USER NAME in HOME SCREEN" + ConstantsClass.myName);
    print("MY USER ID in HOME SCREEN " + ConstantsClass.myUserId);

    database.getChatRooms(ConstantsClass.myUserId).then((snapshots) {
      setState(() {
        chatRoomsStream = snapshots;
        print(
            "we got the data + ${chatRoomsStream.toString()}\nthis is name  ${ConstantsClass.myName}\nthis is user ID ${ConstantsClass.myUserId}");
      });
    });
    updateStatus(true);
    getToken();
  }

  final List<ChoiceClass> choices = const <ChoiceClass>[
    const ChoiceClass(title: "Profile", icon: Icons.account_circle),
    const ChoiceClass(title: 'Settings', icon: Icons.settings),
    const ChoiceClass(title: 'Log out', icon: Icons.exit_to_app),
  ];

  void onItemMenuPress(ChoiceClass choice) {
    switch (choice.title) {
      case "Profile":
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ProfileScreenClass()));
        break;
      case "Settings":
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ChatSettings()));
        break;
      case "Log out":
      default:
        handleSignOut();
    }
  }

  Future<Null> handleSignOut() async {
    /*this.setState(() {
      isLoading = true;
    });*/

    await HelperFunctions.setUserLoggedInSharedPreference(false);

    await FirebaseAuth.instance.signOut();

    await SharedPreferencesClass.sharedPreferences.setString("nickname", null);
    await SharedPreferencesClass.sharedPreferences.setString("aboutMe", null);
    await SharedPreferencesClass.sharedPreferences.setString("photoUrl", null);

    /*await googleSignIn.disconnect();
    await googleSignIn.signOut();*/
    /* this.setState(() {
      isLoading = false;
    });*/

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => AuthenticateClass()),
        (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        shadowColor: Colors.white,
        title: Text(
          "adda",
          style: TextStyle(
            fontSize: 30,
            letterSpacing: 4,
            fontWeight: FontWeight.bold,
            color: HexColor("#7998DF"),
          ),
        ),
        /*Image.asset(
          logoWithName,
          height: 100,
          width: 120,
        )*/
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<ChoiceClass>(
            onSelected: onItemMenuPress,
            color: appLightGrey,
            itemBuilder: (BuildContext context) {
              return choices.map((ChoiceClass choice) {
                return PopupMenuItem<ChoiceClass>(
                    value: choice,
                    child: Row(
                      children: <Widget>[
                        Icon(
                          choice.icon,
                          color: appLightBlack,
                        ),
                        Container(
                          width: 10.0,
                        ),
                        Text(
                          choice.title,
                          style: TextStyle(color: appBlack),
                        ),
                      ],
                    ));
              }).toList();
            },
          ),
        ],
        /*actions: <Widget>[
        GestureDetector(
          onTap: () {
            authMethods.signOut();
            HelperFunctions.setUserLoggedInSharedPreference(false);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => AuthenticateClass(),
                ));
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Icon(Icons.exit_to_app),
          ),
        ),
      ],*/
      ),
      backgroundColor: Colors.grey[50],
      body: Container(
        child: SingleChildScrollView(
          child: chatRoomList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => SearchClass(),
              ));
        },
        backgroundColor: appPrimaryColor,
        tooltip: "Search",
        child: Icon(
          Icons.search,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  void dispose() {
    updateStatus(false);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}

class ChatRoomTile extends StatelessWidget {
  final String userName, chatRoomId, photoUrl, lastMessage, contactUserId;
  final bool isOnline;

  ChatRoomTile(
      {this.userName,
      this.chatRoomId,
      this.photoUrl,
      this.contactUserId,
      this.lastMessage,
      this.isOnline});

  getChatRoomId() => chatRoomId;

  /*Future<void> readLastSms() async {
    final fireStoreInstance = Firestore.instance;
    fireStoreInstance
        .collection("ChatRoom")
        .getDocuments()
        .collection("chats")
        .getDocuments()
        .then((querySnapshot) {
      querySnapshot.documents.forEach((result) {
        print("FIRESTORE: ${result["message"]}");
      });
    });
  }*/

  @override
  Widget build(BuildContext context) {
    /*return ListTile(
      leading: CachedNetworkImage(
        width: 50,
        height: 50,
        imageUrl: photoUrl ?? defaultProfile,
        imageBuilder: (context, imageProvider) =>Container(
          child: CircleAvatar(
            radius: 28.0,
            backgroundImage: imageProvider,
          ),
        ),
      ),
      title: Text(userName ?? "loading..."),
    );*/
    return ContactCardClass(
      name: userName,
      photoUrl: photoUrl,
      lastMessage: lastMessage,
      chatRoomId: chatRoomId,
      contactUserId: contactUserId,
      isOnline: isOnline,
    );
  }
}
