import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewerClass extends StatelessWidget {
  final String imageToView, fileName, fileExtension;

  ImageViewerClass({this.imageToView, this.fileName, this.fileExtension});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$fileName$fileExtension"),
        centerTitle: true,
        backgroundColor: Colors.white.withOpacity(0.8),
      ),
      body: GestureDetector(
        //onVerticalDragEnd: (details) => Navigator.pop(context),
        child: Container(
          child: CachedNetworkImage(
            imageUrl: imageToView ?? null,
            imageBuilder: (context, imageProvider) => Container(
              child: PhotoView(
                backgroundDecoration: BoxDecoration(color: Colors.transparent),
                imageProvider: NetworkImage(imageToView),
                minScale: PhotoViewComputedScale.contained,
              ),
            ),
            placeholder: (context, url) =>
                Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
      ),
    );
  }
}
