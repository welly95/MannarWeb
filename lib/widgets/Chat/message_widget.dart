import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../constants/size_config.dart';
import '../../models/message.dart';

import 'package:flutter/material.dart';
import '../../widgets/Chat/show_image.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageWidget extends StatefulWidget {
  final Message message;
  final bool isMe;

  const MessageWidget({
    Key? key,
    required this.message,
    required this.isMe,
  }) : super(key: key);

  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  late int _totalDuration;
  late int _currentDuration;
  double _completedPercentage = 0.0;
  bool _isPlaying = false;
  @override
  Widget build(BuildContext context) {
    final radius = Radius.circular(12);
    final borderRadius = BorderRadius.all(radius);
    SizeConfig().init(context);

    return Row(
      mainAxisAlignment: widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.all(16),
          constraints: BoxConstraints(maxWidth: SizeConfig.screenWidth * 0.3),
          decoration: BoxDecoration(
            color: widget.isMe ? Colors.grey[100] : Colors.blue,
            borderRadius: widget.isMe
                ? borderRadius.subtract(BorderRadius.only(bottomRight: radius))
                : borderRadius.subtract(BorderRadius.only(bottomLeft: radius)),
          ),
          child: buildMessage(context),
        ),
      ],
    );
  }

  Widget buildMessage(BuildContext context) {
    if (widget.message.type == 'document') {
      return GestureDetector(
        onTap: () async {
          // var _path = await getExternalStorageDirectory();
          // print(_path!.path);
          // final id = await FlutterDownloader.enqueue(
          //   url:
          //       "https://firebasestorage.googleapis.com/v0/b/storage-3cff8.appspot.com/o/2020-05-29%2007-18-34.mp4?alt=media&token=841fffde-2b83-430c-87c3-2d2fd658fd41",
          //   savedDir: _path.path,
          //   fileName: "download",
          //   showNotification: true,
          //   openFileFromNotification: true,
          // );
          launch(widget.message.message);
        },
        child: Column(
          crossAxisAlignment: widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.message.title!,
              style: TextStyle(color: widget.isMe ? Colors.blue : Colors.white, decoration: TextDecoration.underline),
              textAlign: widget.isMe ? TextAlign.end : TextAlign.start,
            ),
          ],
        ),
      );
    } else if (widget.message.type == 'image') {
      return GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => ShowImage(
                image: widget.message.message,
              ),
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: SizeConfig.screenHeight * 0.35,
              width: SizeConfig.screenWidth * 0.25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(widget.message.message),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      );
    } else if (widget.message.type == 'voiceNote') {
      return Directionality(
        textDirection: (widget.isMe) ? TextDirection.ltr : TextDirection.rtl,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: SizeConfig.screenWidth * 0.2,
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: LinearProgressIndicator(
                  minHeight: 5,
                  backgroundColor: Colors.grey,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  value: _completedPercentage,
                ),
              ),
            ),
            IconButton(
              icon: _isPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
              onPressed: () async {
                AudioPlayer audioPlayer = AudioPlayer();

                if (!_isPlaying) {
                  audioPlayer.play(widget.message.message, isLocal: false);
                  setState(() {
                    _completedPercentage = 0.0;
                    _isPlaying = true;
                  });

                  audioPlayer.onPlayerCompletion.listen((_) {
                    setState(() {
                      _isPlaying = false;
                      _completedPercentage = 0.0;
                    });
                  });
                  audioPlayer.onDurationChanged.listen((duration) {
                    setState(() {
                      _totalDuration = duration.inMicroseconds;
                    });
                  });

                  audioPlayer.onAudioPositionChanged.listen((duration) {
                    setState(() {
                      _currentDuration = duration.inMicroseconds;
                      _completedPercentage = _currentDuration.toDouble() / _totalDuration.toDouble();
                    });
                  });
                }
                // } else if (!_isPlaying && _completedPercentage != 0.0) {
                //   audioPlayer.resume();
                //   print('resume');
                // } else {
                //   print('pause');
                //   setState(() {
                //     _isPlaying = false;
                //   });
                //   await audioPlayer.pause().then((value) {
                //     setState(() {
                //       _currentDuration = (value / _totalDuration) as int;
                //       print(_completedPercentage);
                //     });
                //   });
                // }
              },
            ),
          ],
        ),
      );
    } else {
      return Column(
        crossAxisAlignment: widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.message.message,
            style: TextStyle(color: widget.isMe ? Colors.black : Colors.white),
            textAlign: widget.isMe ? TextAlign.end : TextAlign.start,
          ),
        ],
      );
    }
  }
}
