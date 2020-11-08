import 'dart:math' as math;
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact_picker/contact_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import 'package:adda/HelperClass/Constants.dart';
import 'package:adda/HelperClass/Resources.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:popup_menu/popup_menu.dart';

class MessageBarClass extends StatefulWidget {
  final myDatabase;
  final String chatRoomId, contactUserId;
  final ScrollController scrollController;
  static int limit = 20;
  static PopupMenu popupMenu;

  MessageBarClass(
      {this.myDatabase,
      this.chatRoomId,
      this.contactUserId,
      this.scrollController});

  @override
  _MessageBarState createState() => _MessageBarState();
}

class _MessageBarState extends State<MessageBarClass> {
  bool sendButtonState = false;
  PopupMenu menu;
  GlobalKey btnKey = GlobalKey();
  GlobalKey btnKey2 = GlobalKey();
  GlobalKey btnKey3 = GlobalKey();

  bool attachmentButtonState = false;
  String message;
  TextEditingController messageTextFieldController =
      new TextEditingController();

  File file;
  bool isLoading;
  bool isShowSticker;
  String fileUrl;
  Contact contact;

  final int _limitIncrement = 20;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    widget.scrollController.addListener(_scrollListener);

    //menu
    //MessageBarClass.popupMenu
    menu = PopupMenu(items: [
      MenuItem(
        title: 'Camera',
        image: Icon(
          Icons.photo_camera,
          color: Colors.grey[50],
        ),
      ),
      MenuItem(
          title: 'Gallery',
          image: Icon(
            Icons.photo_size_select_actual,
            color: Colors.grey[50],
          )),
      MenuItem(
          title: 'Document',
          image: Icon(
            Icons.insert_drive_file,
            color: Colors.grey[50],
          )),
      MenuItem(
        title: 'Contacts',
        image: Icon(
          Icons.account_circle,
          color: Colors.grey[50],
        ),
      )
    ], onClickMenu: onClickMenu, onDismiss: onDismiss, maxColumn: 4);
  }

  void stateChanged(bool isShow) {
    print('menu is ${isShow ? 'showing' : 'closed'}');
  }

  getFile(int fileType) async {
    //1 = camera, 2 = gallery, 3 = document, 4 = contact

    FilePickerResult result;
    //FilePicker.platform.pickFiles();
    ImagePicker imagePicker = ImagePicker();
    int messageType;
    switch (fileType) {
      case 1:
        PickedFile pickedFile = await imagePicker.getImage(
            source: ImageSource.camera, imageQuality: 50);
        result = pickedFile as FilePickerResult;
        File imageFilePath = File(pickedFile.path);
        messageType = 1;
        break;
      case 2:
        result = await FilePicker.platform
            .pickFiles(type: FileType.image, allowCompression: true);
        messageType = 2;
        break;
      case 3:
        result = await FilePicker.platform.pickFiles(
          type: FileType.any,
          allowCompression: true,
        );
        // onFileLoading:
        messageType = 3;
        break;
      case 4:
        final ContactPicker contactPicker = new ContactPicker();
        contact = await contactPicker.selectContact();
        messageType = 4;
        break;
    }

    if (messageType != 4) {
      if (result != null) {
        file = File(result.files.single.path);
        print("FILE ${file.toString()}");
        print(
            "FILE2 ${path.basenameWithoutExtension(file.path)} and EXT ${path.extension(file.path)}");

        uploadFile(path.basenameWithoutExtension(file.path),
            path.extension(file.path), messageType);
        //TODO close the file
      }
    } else if (messageType == 4) {
      sendMessage(
          myDatabase: widget.myDatabase,
          chatRoomId: widget.chatRoomId,
          content:
              "Name: ${contact.fullName}\nPhone: ${contact.phoneNumber.number}",
          fileName: "Text",
          fileExtension: ".txt",
          messageType: 0);
    }
  }

  Future uploadFile(fileName, fileExtension, messageType) async {
    print("FILE $fileName");
    int dateTime = DateTime.now().millisecondsSinceEpoch;
    String filePath;
    String cameraPath =
        "ChatRoom/${widget.chatRoomId}/${ConstantsClass.myUserId}/camera/${fileName}_$dateTime";
    String imagePath =
        "ChatRoom/${widget.chatRoomId}/${ConstantsClass.myUserId}/images/${fileName}_$dateTime";
    String docPath =
        "ChatRoom/${widget.chatRoomId}/${ConstantsClass.myUserId}/documents/${fileName}_$dateTime";
    String contactsPath =
        "ChatRoom/${widget.chatRoomId}/${ConstantsClass.myUserId}/contacts/${fileName}_$dateTime";

    print("IMAGE PATH : $imagePath");
    print("FILE PATH : $docPath");

    switch (messageType) {
      case 1:
        filePath = cameraPath;
        break;
      case 2:
        filePath = imagePath;
        break;
      case 3:
        filePath = docPath;
        break;
      case 4:
        filePath = contactsPath;
        break;
    }
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(filePath);
    StorageUploadTask uploadTask = storageReference.putFile(file);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      fileUrl = downloadUrl;
      setState(() {
        isLoading = false;
        Fluttertoast.showToast(msg: '$fileName image uploaded');
        sendMessage(
            myDatabase: widget.myDatabase,
            chatRoomId: widget.chatRoomId,
            content: fileUrl,
            fileName: fileName,
            fileExtension: fileExtension,
            messageType: messageType);
      });
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: 'This file is not an image');
    });
  }

  sendMessage(
      {myDatabase,
      chatRoomId,
      content,
      String fileName,
      String fileExtension,
      int messageType}) {
    // type: 0 = text, 1 = camera, 2 = gallery, 3 = document, 4 = contact
    print("FILENAME : $fileName");
    print("FILE EXTENSION : $fileExtension");

    String snackMessage = messageType == 0
        ? "$fileName$fileExtension camera image is uploading"
        : messageType == 1
            ? "$fileName$fileExtension gallery image is uploading"
            : messageType == 2
                ? "$fileName$fileExtension document is uploading"
                : "$fileName$fileExtension contact is uploading";
    SnackBar snackBar;
    if (snackMessage != null) {
      snackBar = SnackBar(
        content: Text(snackMessage),
        action: SnackBarAction(
          onPressed: () {},
          label: "Ok",
        ),
      );
    }

    DocumentReference documentReference =
        Firestore.instance.collection("ChatRoom").document(chatRoomId);

    switch (messageType) {
      case 0:
        if (content.isNotEmpty) {
          String message = content.toString().trim();
          Map<String, dynamic> chatMessageMap = {
            "message": message,
            "sendBy": ConstantsClass.myUserId,
            "sendTo": widget.contactUserId,
            "messageType": messageType,
            "fileName": "Text",
            "fileExtension": ".txt",
            "isDelivered": false,
            "time": DateTime.now().millisecondsSinceEpoch
          };

          Map<String, String> lastMessageMap = {"lastMessage": message};

          myDatabase.addConversationMessages(chatRoomId, chatMessageMap);
          documentReference.updateData(lastMessageMap);
        }
        break;
      case 1:
        Scaffold.of(context).showSnackBar(snackBar);

        Map<String, dynamic> chatMessageMap = {
          "message": content,
          "sendBy": ConstantsClass.myUserId,
          "sendTo": widget.contactUserId,
          "messageType": messageType,
          "fileName": fileName,
          "fileExtension": fileExtension,
          "isDelivered": false,
          "time": DateTime.now().millisecondsSinceEpoch
        };

        Map<String, String> lastMessageMap = {"lastMessage": "📷$fileName"};
        myDatabase.addConversationMessages(chatRoomId, chatMessageMap);
        documentReference.updateData(lastMessageMap);
        break;
      case 2:
        //TODO check for null
        Scaffold.of(context).showSnackBar(snackBar);

        Map<String, dynamic> chatMessageMap = {
          "message": content,
          "sendBy": ConstantsClass.myUserId,
          "sendTo": widget.contactUserId,
          "messageType": messageType,
          "fileName": fileName,
          "fileExtension": fileExtension,
          "isDelivered": false,
          "time": DateTime.now().millisecondsSinceEpoch
        };

        Map<String, String> lastMessageMap = {"lastMessage": "📸$fileName"};
        myDatabase.addConversationMessages(chatRoomId, chatMessageMap);
        documentReference.updateData(lastMessageMap);
        break;
      case 3:
        //TODO check for null
        Scaffold.of(context).showSnackBar(snackBar);

        Map<String, dynamic> chatMessageMap = {
          "message": content,
          "sendBy": ConstantsClass.myUserId,
          "sendTo": widget.contactUserId,
          "messageType": messageType,
          "fileName": fileName,
          "fileExtension": fileExtension,
          "isDelivered": false,
          "time": DateTime.now().millisecondsSinceEpoch
        };

        Map<String, String> lastMessageMap = {"lastMessage": "📁$fileName"};
        myDatabase.addConversationMessages(chatRoomId, chatMessageMap);
        documentReference.updateData(lastMessageMap);
        break;
      case 4:
        //TODO check for null
        Scaffold.of(context).showSnackBar(snackBar);

        Map<String, dynamic> chatMessageMap = {
          "message": content,
          "sendBy": ConstantsClass.myUserId,
          "sendTo": widget.contactUserId,
          "messageType": messageType,
          "fileName": fileName,
          "fileExtension": fileExtension,
          "isDelivered": false,
          "time": DateTime.now().millisecondsSinceEpoch
        };

        Map<String, String> lastMessageMap = {"lastMessage": "☎$fileName"};
        myDatabase.addConversationMessages(chatRoomId, chatMessageMap);
        documentReference.updateData(lastMessageMap);
        break;
    }
    setState(() {
      content = null;
      fileName = null;
      messageType = null;
      sendButtonState = false;
    });
  }

  void onClickMenu(MenuItemProvider item) {
    switch (item.menuTitle) {
      case "Camera":
        getFile(1);
        break;
      case "Gallery":
        getFile(2);
        break;
      case "Document":
        getFile(3);
        break;
      case "Contacts":
        getFile(4);
        break;
    }
    print('Click menu -> ${item.menuTitle}');
  }

  void onDismiss() {
    print('Menu is dismiss');
    setState(() {
      attachmentButtonState = !attachmentButtonState;
    });
  }

  void onDismissOnlyBeCalledOnce() {
    menu.show(widgetKey: btnKey3);
  }

  void onGesturesDemo() {
    MessageBarClass.popupMenu.dismiss();
    menu.dismiss();
    return;
  }

  void checkState(BuildContext context) {
    final snackBar = new SnackBar(content: new Text('这是一个SnackBar!'));

    Scaffold.of(context).showSnackBar(snackBar);
  }

  void maxColumn() {
    PopupMenu menu = PopupMenu(
        // backgroundColor: Colors.teal,
        // lineColor: Colors.tealAccent,
        maxColumn: 3,
        items: [
          MenuItem(
              title: 'Power',
              image: Icon(
                Icons.power,
                color: Colors.white,
              )),
          MenuItem(
              title: 'Setting',
              image: Icon(
                Icons.settings,
                color: Colors.white,
              )),
          MenuItem(
              title: 'PopupMenu',
              image: Icon(
                Icons.menu,
                color: Colors.white,
              ))
        ],
        onClickMenu: onClickMenu,
        stateChanged: stateChanged,
        onDismiss: onDismiss);
    menu.show(widgetKey: btnKey);
  }

  void customBackground() {
    PopupMenu menu = PopupMenu(
        // backgroundColor: Colors.teal,
        // lineColor: Colors.tealAccent,
        // maxColumn: 2,
        items: [
          MenuItem(title: 'Copy', image: Image.asset('assets/copy.png')),
          MenuItem(
              title: 'Home',
              // textStyle: TextStyle(fontSize: 10.0, color: Colors.tealAccent),
              image: Icon(
                Icons.home,
                color: Colors.white,
              )),
          MenuItem(
              title: 'Mail',
              image: Icon(
                Icons.mail,
                color: Colors.white,
              )),
          MenuItem(
              title: 'Power',
              image: Icon(
                Icons.power,
                color: Colors.white,
              )),
          MenuItem(
              title: 'Setting',
              image: Icon(
                Icons.settings,
                color: Colors.white,
              )),
          MenuItem(
              title: 'PopupMenu',
              image: Icon(
                Icons.menu,
                color: Colors.white,
              ))
        ],
        onClickMenu: onClickMenu,
        stateChanged: stateChanged,
        onDismiss: onDismiss);
    menu.show(widgetKey: btnKey2);
  }

  _scrollListener() {
    if (widget.scrollController.offset >=
            widget.scrollController.position.maxScrollExtent &&
        !widget.scrollController.position.outOfRange) {
      print("reach the bottom");
      setState(() {
        print("reach the bottom");
        MessageBarClass.limit += _limitIncrement;
        //widget.scrollController.position.maxScrollExtent;
      });
    }
    if (widget.scrollController.offset <=
            widget.scrollController.position.minScrollExtent &&
        !widget.scrollController.position.outOfRange) {
      print("reach the top");
      setState(() {
        print("reach the top");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    PopupMenu.context = context;
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            width: double.infinity,
            alignment: Alignment.bottomCenter,
            color: Colors.white,
            padding: EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 2),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: 0.0,
                maxHeight: 100,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,
                        border: Border.all(
                          width: 0.2,
                          color: HexColor("#999999"),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.4),
                            spreadRadius: 0.2,
                            blurRadius: 2,
                            offset: Offset(0, 1), // changes position of shadow
                          ),
                        ],
                      ),
                      child: TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        autofocus: false,
                        controller: messageTextFieldController,
                        onChanged: (text) {
                          if (text.isNotEmpty) {
                            setState(() {
                              sendButtonState = true;
                            });
                          } else if (text.isEmpty || text == null) {
                            setState(() {
                              sendButtonState = false;
                            });
                          }
                        },
                        style: TextStyle(
                          fontSize: 14.0,
                          letterSpacing: 0.5,
                          color: HexColor("#444444"),
                        ),
                        //TODO collapsed?
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: messageBoxHint,
                          contentPadding: const EdgeInsets.all(0.0),
                          hintStyle: TextStyle(
                            letterSpacing: 0.5,
                            fontSize: 14,
                            color: HexColor("#999999"),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                          key: btnKey3,
                          onTap: () {
                            setState(() {
                              attachmentButtonState = !attachmentButtonState;
                              onDismissOnlyBeCalledOnce();
                            });
                          },
                          child: attachmentIcon(attachmentButtonState)),
                      SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (sendButtonState) {
                            HapticFeedback.lightImpact();
                            sendMessage(
                                myDatabase: widget.myDatabase,
                                chatRoomId: widget.chatRoomId,
                                content: messageTextFieldController.text,
                                messageType: 0);
                            setState(() {
                              messageTextFieldController.clear();
                              sendButtonState = false;
                              widget.scrollController.animateTo(
                                  widget.scrollController.position
                                      .maxScrollExtent,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeOut);
                            });
                          } else {}
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 5),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: sendButtonState
                                ? buttonEnabledColor
                                : sendButtonDisabledColor,
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.3),
                                spreadRadius: 0.2,
                                blurRadius: 1,
                                offset:
                                    Offset(0, 1), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget attachmentIcon(bool attachmentButtonState) {
  return Transform.rotate(
    angle: attachmentButtonState ? 0 * math.pi / 180 : 180 * math.pi / 180,
    child: Icon(
      Icons.attach_file,
      size: 28,
      color: attachmentButtonState
          ? buttonEnabledColor
          : attachButtonDisabledColor,
    ),
  );
}
