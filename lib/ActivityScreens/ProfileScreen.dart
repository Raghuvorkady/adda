import 'package:adda/ActivityScreens/HomeScreen.dart';
import 'package:adda/HelperClass/Constants.dart';
import 'package:adda/Resources/Colors.dart';
import 'package:adda/Resources/UserInfo.dart';
import 'package:adda/Services/MyDatabase.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileScreenClass extends StatelessWidget {
  final num = 20;

  final bigFont = const TextStyle(fontSize: 18);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProfileContent(),
    );
  }
}

class ProfileContent extends StatefulWidget {
  @override
  _ProfileContentState createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent> {
  UserInfoClass userInfoClass = new UserInfoClass();

  getUserInfoFromClass() {
    Stopwatch stopwatch = new Stopwatch()..start();

    HomeScreenClass.usersInfo.forEach((element) {
      if (element.userID.contains(ConstantsClass.myUserId)) {
        userInfoClass.email = element.email;
        userInfoClass.userName = element.userName;
        userInfoClass.nickName = element.nickName;
        userInfoClass.photoUrl = element.photoUrl;
        userInfoClass.aboutMe = element.aboutMe;
      }
    });
    print('FOREACH executed in ${stopwatch.elapsed}\n');
    print("FOREACH UserName : ${userInfoClass.userName}");

    Stopwatch stopwatch1 = new Stopwatch()..start();
    for (int i = 0; i < HomeScreenClass.usersInfo.length; i++) {
      if (HomeScreenClass.usersInfo[i].userID == ConstantsClass.myUserId) {
        userInfoClass.email = HomeScreenClass.usersInfo[i].email;
        userInfoClass.userName = HomeScreenClass.usersInfo[i].userName;
        userInfoClass.aboutMe = HomeScreenClass.usersInfo[i].aboutMe;
        userInfoClass.nickName = HomeScreenClass.usersInfo[i].nickName;
        userInfoClass.photoUrl = HomeScreenClass.usersInfo[i].photoUrl;
      }
    }
    print('FOR executed in ${stopwatch1.elapsed}\n');
    print("FOR UserName : ${userInfoClass.userName}");
  }

  QuerySnapshot querySnapshotUserInfo;

  getUserInfo() async {
    querySnapshotUserInfo =
        await MyDatabaseClass().getUserInfoByUserId(ConstantsClass.myUserId);
    setState(() async {
      userInfoClass.userName =
          await querySnapshotUserInfo.documents[0].data["name"];
      userInfoClass.email =
          await querySnapshotUserInfo.documents[0].data["email"];
      userInfoClass.aboutMe =
          await querySnapshotUserInfo.documents[0].data["aboutMe"];
      userInfoClass.nickName =
          await querySnapshotUserInfo.documents[0].data["nickname"];
      userInfoClass.photoUrl =
          await querySnapshotUserInfo.documents[0].data["photoUrl"];
    });
    print("UserName : ${userInfoClass.userName}");
  }

  @override
  void initState() {
    getUserInfoFromClass();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            floating: true,
            snap: true,
            expandedHeight: 300,
            backgroundColor: Colors.white,
            /*automaticallyImplyLeading: true,
            leading: CircleAvatar(backgroundImage: AssetImage(rkm1),),*/
            brightness: Brightness.light,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                userInfoClass.userName ?? "loading",
                style: TextStyle(fontSize: 18, color: Colors.black87),
              ),
              background: CachedNetworkImage(
                imageUrl: userInfoClass.photoUrl ?? "loading",
                placeholder: (context, url) => Container(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(appPrimaryColor),
                  ),
                  width: 200.0,
                  height: 200.0,
                  padding: EdgeInsets.all(70.0),
                ),
                errorWidget: (context, url, error) => Material(
                  child: Image.asset(
                    userInfoClass.photoUrl,
                    width: 200.0,
                    height: 200.0,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  clipBehavior: Clip.hardEdge,
                ),
                width: 200.0,
                height: 200.0,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverFillRemaining(
            child: Container(
                margin: EdgeInsets.only(left: 15, top: 30, bottom: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Account",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userInfoClass.userName ?? "loading",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            /*Text(
                              "Tap here to change your name",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),*/
                          ],
                        )),
                    Divider(),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userInfoClass.email ?? "loading",
                                  style: TextStyle(
                                      fontSize: 18,
                                      letterSpacing: 0.5,
                                      color: Colors.grey[800],
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                /*Text(
                                  "Tap here to change your email ID",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),*/
                              ],
                            ),
                          ],
                        )),
                    Divider(),
                  ],
                )),
            /*ListView.builder(
              itemCount: num,
              itemBuilder: (context, int index) {
                if (index.isOdd) return Divider();
                return _buildRow(index);
              },
            ),*/
          ),
        ],
      ),
    );
  }
}
