import 'package:adda/HelperClass/ImageViewer.dart';
import 'package:adda/HelperClass/Widget.dart';
import 'package:adda/Resources/Colors.dart';
import 'package:adda/Resources/Icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:io';
import 'dart:async';

class ChatBubbleContactClass extends StatefulWidget {
  final String message, fileName, fileExtension;
  final messageType;
  final DateTime timeStamp;

  ChatBubbleContactClass(
      {this.message,
      this.messageType,
      this.fileName,
      this.fileExtension,
      this.timeStamp});

  @override
  _ChatBubbleContactClassState createState() => _ChatBubbleContactClassState();
}

class _ChatBubbleContactClassState extends State<ChatBubbleContactClass> {
  bool downloading = false;
  bool downloaded = false;
  bool isProgressIndicatorVisible = false;

  String fileLocation;
  double progress = 0;

  createDownloadTask(
      {String downloadUrl,
      String fileName,
      String fileExtension,
      context}) async {
    setState(() {
      isProgressIndicatorVisible = true;
    });

    Dio dio = new Dio();
    String folder;
    Directory directoryRoot = await getExternalStorageDirectory();
    String file = "$fileName$fileExtension";

    Directory directory = new Directory(directoryRoot.path + '/' + 'Documents');

    if (!(await directory.exists())) {
      await directory.create(recursive: true)
          // The created directory is returned as a Future.
          .then((Directory directory) {
        setState(() {
          folder = directory.path;
          fileLocation = "$folder";
        });
        print('Path of New Dir: ' + folder);
      });
    } else {
      setState(() {
        folder = directory.path;
        fileLocation = "$folder";
      });
    }

    File filePath = File("$folder/$file");
    if (!(await filePath.exists())) {
      //String dirToBeCreated = "Adda";
      //String folder = join(baseDir.path, dirToBeCreated);
      try {
        await dio.download(downloadUrl, "$folder/$file",
            onReceiveProgress: (receive, total) {
          print("Receive : $receive, Total : $total");

          setState(() {
            downloading = true;
            isProgressIndicatorVisible = true;
            //progress = (receive / total * 100).toStringAsFixed(0) + "%";
            progress = (receive / total);
          });
          print("Progress: $progress");
        });
      } catch (e) {
        print(e);
      }

      if (await filePath.exists()) {
        setState(() {
          downloaded = true;
          isProgressIndicatorVisible = false;
        });
        print("DOWNLOAD completed");
        SnackBar snackBar = SnackBar(
          content: Text("Download completed\nLocation: $folder/$file"),
          duration: Duration(seconds: 1),
        );
        Scaffold.of(context).showSnackBar(snackBar);
      }
    } else {
      setState(() {
        downloaded = true;
        isProgressIndicatorVisible = false;
      });
      openFile(fileName: fileName, fileExtension: fileExtension);
    }
  }

  Future<void> openFile({String fileName, String fileExtension}) async {
    String filePath = "$fileLocation/$fileName$fileExtension";
    await OpenFile.open(filePath);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 3),
      padding: EdgeInsets.only(left: 20.0, right: 0.0),
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.only(top: 0, bottom: 0, left: 10, right: 10),
        margin: EdgeInsets.only(right: 80),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  blurRadius: 1.0,
                  offset: Offset(-1.0, 1.0),
                  color: Colors.black12)
            ],
            color: contactChatBubbleColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            widget.messageType == 0
                ? Flexible(
                    child: Container(
                      constraints: BoxConstraints(
                        minWidth: 80.0,
                      ),
                      margin:
                          EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 0),
                      child: SelectableText(
                        widget.message,
                        cursorColor: appLightBlack,
                        toolbarOptions:
                            ToolbarOptions(copy: true, selectAll: true),
                        showCursor: true,
                        style: TextStyle(
                          fontSize: 14.0,
                          letterSpacing: 0.5,
                          color: HexColor("#444444"),
                        ),
                      ),
                    ),
                  )
                : widget.messageType == 1
                    ? Container(
                        decoration: BoxDecoration(
                          color: appLightGrey,
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          border:
                              Border.all(width: 0.1, style: BorderStyle.solid),
                        ),
                        //padding: EdgeInsets.only(top: 5, bottom: 2),
                        margin: EdgeInsets.only(
                            top: 10, left: 4, right: 4, bottom: 1),
                        child: Material(
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ImageViewerClass(
                                      imageToView: widget.message,
                                      fileName: widget.fileName,
                                      fileExtension: widget.fileExtension),
                                )),
                            child: CachedNetworkImage(
                              placeholder: (context, url) => Container(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      appPrimaryColor),
                                ),
                                width: 200.0,
                                height: 200.0,
                                padding: EdgeInsets.all(70.0),
                              ),
                              errorWidget: (context, url, error) => Material(
                                child: Image.asset(
                                  noImage,
                                  width: 200.0,
                                  height: 200.0,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                                clipBehavior: Clip.hardEdge,
                              ),
                              imageUrl: widget.message,
                              width: 200.0,
                              height: 200.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          clipBehavior: Clip.hardEdge,
                        ))
                    : Flexible(
                        child: Container(
                            constraints: BoxConstraints(
                              minWidth: 80.0,
                            ),
                            child: FlatButton.icon(
                                onPressed: () {
                                  !downloaded
                                      ? createDownloadTask(
                                          downloadUrl: widget.message,
                                          fileName: widget.fileName,
                                          fileExtension: widget.fileExtension,
                                          context: context)
                                      : openFile(
                                          fileName: widget.fileName,
                                          fileExtension: widget.fileExtension);
                                },
                                icon: Icon(
                                  Icons.insert_drive_file,
                                  color: Colors.purple[300],
                                ),
                                label: Flexible(
                                  child: Text(
                                    "${widget.fileName}${widget.fileExtension}",
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      letterSpacing: 0.5,
                                      color: appBlack,
                                    ),
                                  ),
                                ))),
                      ),
            Padding(
              padding: EdgeInsets.only(top: 2, left: 5, right: 8, bottom: 2),
              child: Text.rich(
                TextSpan(style: timeStampStyle(), children: [
                  TextSpan(
                    text: new DateFormat("h:mm a").format(widget.timeStamp),
                  ),
                  WidgetSpan(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Visibility(
                        visible: isProgressIndicatorVisible,
                        child: SizedBox(
                          width: 15,
                          height: 15,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.green[300]),
                            backgroundColor: Colors.redAccent,
                            value: progress,
                          ),
                        ),
                        /* CircularPercentIndicator(
                              percent: progress,
                              lineWidth: 4.0,
                              animation: true,
                              circularStrokeCap: CircularStrokeCap.round,
                              */ /*animationDuration: received == 0
                                ? 1
                                : (totalFileSize / received * 100).round(),
                            */ /*center: Text(progress.toStringAsFixed(1),
                              style: TextStyle(
                                  fontSize: 10.0
                              ),
                            ),
                              progressColor: Colors.green, radius: 40,
                            ),*/
                      ),
                    ),
                  ),
                ]),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
