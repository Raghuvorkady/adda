import 'package:adda/Widgets/MessageBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyDatabaseClass {
  getUserByUsername(String username) async {
    return await Firestore.instance
        .collection("users")
        .where("name", isEqualTo: username)
        .getDocuments()
        .catchError((e) => print(e.toString()));
  }

  getUserByUserEmail(String userEmail) async {
    return await Firestore.instance
        .collection("users")
        .where("email", isEqualTo: userEmail)
        .getDocuments()
        .catchError((e) => print(e.toString()));
  }

  uploadUserInfo(userMap) {
    Firestore.instance.collection("users").add(userMap).catchError((e) {
      print(e.toString());
    });
  }

  createChatRoom(String chatRoomId, chatRoomMap) {
    Firestore.instance
        .collection("ChatRoom")
        .document(chatRoomId)
        .setData(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  addConversationMessages(chatRoomId, Map<String, dynamic> messageMap) {
    Firestore.instance
        .collection("ChatRoom")
        .document(chatRoomId)
        .collection("chats")
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getConversationMessages(chatRoomId) async {
    return await Firestore.instance
        .collection("ChatRoom")
        .document(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: true)
        .limit(MessageBarClass.limit)
        .snapshots();
  }

  getChatRooms(String userName) async {
    return await Firestore.instance
        .collection("ChatRoom")
        .where("users", arrayContains: userName)
        .snapshots();
  }

  getUserInfo() async {
    return await Firestore.instance.collection("users").getDocuments();
  }

  getUserInfoByUserId(String userID) async {
    return await Firestore.instance
        .collection("users")
        .where("userID", isEqualTo: userID)
        .snapshots();
  }
/*checkForEmail(String email) async {
    return await Firestore.instance
        .collection("users")
        .where("email", isEqualTo: email);
  }*/

}
