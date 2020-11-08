import 'package:adda/ActivityScreens/Settings.dart';
import 'package:adda/HelperClass/Authenticate.dart';
import 'package:adda/HelperClass/Resources.dart';
import 'package:adda/Resources/Choice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreenAppBarClass extends StatefulWidget {

  @override
  _HomeScreenAppBarClassState createState() => _HomeScreenAppBarClassState();
}

class _HomeScreenAppBarClassState extends State<HomeScreenAppBarClass> {
  final List<ChoiceClass> choices = const <ChoiceClass>[
    const ChoiceClass(title: 'Settings', icon: Icons.settings),
    const ChoiceClass(title: 'Log out', icon: Icons.exit_to_app),
  ];

  void onItemMenuPress(ChoiceClass choice) {
    if (choice.title == 'Log out') {
      handleSignOut();
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SettingsScreen()));
    }
  }

  Future<Null> handleSignOut() async {
    /*this.setState(() {
      isLoading = true;
    });
*/
    await FirebaseAuth.instance.signOut();
    /*await googleSignIn.disconnect();
    await googleSignIn.signOut();*/

   /* this.setState(() {
      isLoading = false;
    });
*/
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => AuthenticateClass()),
            (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Image.asset(
        logoWithName,
        height: 100,
        width: 120,
      ),
      backgroundColor: appYellow,
      centerTitle: true,
      actions: <Widget>[
        PopupMenuButton<ChoiceClass>(
          onSelected: onItemMenuPress,
          itemBuilder: (BuildContext context) {
            return choices.map((ChoiceClass choice) {
              return PopupMenuItem<ChoiceClass>(
                  value: choice,
                  child: Row(
                    children: <Widget>[
                      Icon(
                        choice.icon,
                        color: appYellow,
                      ),
                      Container(
                        width: 10.0,
                      ),
                      Text(
                        choice.title,
                        style: TextStyle(color: appYellow),
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
    );
  }
}
