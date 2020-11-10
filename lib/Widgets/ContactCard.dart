import 'package:adda/Resources/Colors.dart';
import 'package:adda/Resources/Strings.dart';
import 'package:adda/ActivityScreens/Conversation.dart';
import 'package:adda/HelperClass/Constants.dart';
import 'package:adda/examples/line_painter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class ContactCardClass extends StatelessWidget {
  final String name, photoUrl, chatRoomId, contactUserId, lastMessage;
  final bool isOnline;

  ContactCardClass(
      {this.name,
      this.photoUrl,
      this.chatRoomId,
      this.contactUserId,
      this.lastMessage,
      this.isOnline});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: LinePainter(),
      child: ListTile(
        onTap: () {
          print("USER " + name);
          ConstantsClass.chatName = name;
          ConstantsClass.contactUserId = contactUserId;
          print("CONTACT NAME FOR CONTACT CARD : " + ConstantsClass.chatName);
          print("CONTACT USER ID FOR CONTACT CARD : " +
              ConstantsClass.contactUserId);

          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ConversationClass(
                    chatRoomId: chatRoomId,
                    photoUrl: photoUrl,
                    contactUserId: contactUserId,
                    isOnline: isOnline ?? false),
              ));
        },
        contentPadding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 16.0),
        leading: InkWell(
          onTap: () => _showProfilePic(context, photoUrl),
          child: Container(
            //tag: "profilePicTag",
            child: photoUrl != null
                ? Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: new BoxDecoration(
                          color: isOnline ?? false
                              ? Colors.green
                              : HexColor("#999999"),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Container(
                        width: 45,
                        height: 45,
                        decoration: new BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      CachedNetworkImage(
                        width: 42,
                        height: 42,
                        /* progressIndicatorBuilder: (context, url, downloadProgress) =>
                CircularProgressIndicator(value: downloadProgress.progress),*/
                        imageUrl: photoUrl ?? null,
                        imageBuilder: (context, imageProvider) => Container(
                          child: CircleAvatar(
                            radius: 30.0,
                            backgroundImage: imageProvider,
                          ),
                        ),
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Image.network(
                          defaultProfile,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  )
                : CircularProgressIndicator(),
          ),
        ),
        title: Text(
          name ?? "Name is loading...",
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
            Flexible(
              child: Text(
                lastMessage ?? "Last message is loading...",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 14.0,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.w400,
                    color: HexColor("#777777")),
              ),
            ),
          ],
        ),
        /*trailing: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              new DateFormat('dd/MM/yy').format(timestamp),
              style: TextStyle(
                  fontSize: 13.0,
                  letterSpacing: 0,
                  fontWeight: FontWeight.w400,
                  color: HexColor("#777777")),
            ),
            */ /*Container(
                constraints: BoxConstraints(minHeight: 24, minWidth: 24),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: HexColor("#7998DF"),
                    borderRadius: BorderRadius.circular(30)),
                child: Text(
                  "1",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                  textAlign: TextAlign.center,
                ))*/ /*
          ],
        ),*/
      ),
    );
  }

  _showProfilePic(BuildContext context, photoUrl) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white.withOpacity(0.8),
              ),
              backgroundColor: Colors.transparent,
              body: Center(
                  child: CachedNetworkImage(
                imageUrl: photoUrl ?? null,
                imageBuilder: (context, imageProvider) => Container(
                  child: Image(
                    image: imageProvider,
                  ),
                ),
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Image.network(
                  defaultProfile,
                  color: Colors.grey,
                ),
              )),
            )));
  }
}
