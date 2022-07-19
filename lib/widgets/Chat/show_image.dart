import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';

class ShowImage extends StatefulWidget {
  final String? image;

  ShowImage({this.image});

  @override
  _ShowImageState createState() => _ShowImageState();
}

class _ShowImageState extends State<ShowImage> {
  late bool hideAppBar;
  @override
  void initState() {
    super.initState();
    hideAppBar = false;
  }

  @override
  Widget build(BuildContext context) {
    print(widget.image);
    return Scaffold(
      appBar: hideAppBar
          ? null
          : AppBar(
              backgroundColor: Colors.transparent,
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
              // actions: [
              //   IconButton(
              //       icon: Icon(Icons.save),
              //       onPressed: () async {
              //         await GallerySaver.saveImage(widget.image, albumName: 'Fin!Chic');
              //       }),
              // ],
            ),
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: InkWell(
        onTap: () {
          setState(() {
            hideAppBar = !hideAppBar;
          });
        },
        child: PhotoView(
          imageProvider: CachedNetworkImageProvider(widget.image!),
          enableRotation: false,
          minScale: PhotoViewComputedScale.contained,
          // onTapDown: (context, details, controllerValue) {
          //   Navigator.of(context).pop();
          // },
        ),
      ),
    );
  }
}
