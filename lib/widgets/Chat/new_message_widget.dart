// ignore_for_file: unnecessary_null_comparison

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mannar_web/constants/size_config.dart';
import 'package:mannar_web/widgets/buttons/basic_button.dart';
import 'package:path_provider/path_provider.dart';

import '../../api/firebase_api.dart';
import '../../api/SendNotifictionApi.dart';
import '../../constants/styles.dart';
import '../../models/chat_user.dart';

class NewMessageWidget extends StatefulWidget {
  final User user;
  final String lawyerName;

  const NewMessageWidget({
    required this.user,
    required this.lawyerName,
    Key? key,
  }) : super(key: key);

  @override
  _NewMessageWidgetState createState() => _NewMessageWidgetState();
}

class _NewMessageWidgetState extends State<NewMessageWidget> {
  final _controller = TextEditingController();
  String message = '';
  String type = 'message';
  String title = '';
  late Directory appDirectory;
  List<String> records = [];

  @override
  void initState() {
    super.initState();
    getApplicationDocumentsDirectory().then((value) {
      appDirectory = value;
      print(value);
      // appDirectory.list().listen((onData) {
      //   if (onData.path.contains('.aac')) records.add(onData.path);
      // }).onDone(() {
      //   records = records.reversed.toList();
      //   setState(() {});
      // });
    });
  }

  void sendMessage() async {
    FocusScope.of(context).unfocus();

    await FirebaseApi.uploadMessage(widget.user.idUser!, widget.user.recieverId, widget.user.name, message, title, type,
        widget.lawyerName, widget.user.userToken, widget.user.lawyerToken);
    if (type == 'message') {
      callOnFcmApiSendPushNotifications(widget.user.lawyerToken, widget.user.name, message);
    } else {
      callOnFcmApiSendPushNotifications(widget.user.lawyerToken, widget.user.name, type);
    }
    _controller.clear();
  }

  uploadVoiceNote(String voiceNotePath) async {
    final String name = Timestamp.now().toDate().toString();
    if (voiceNotePath != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('chat')
          .child(widget.user.idUser!)
          .child('voiceNotes')
          .child('$name.aac');
      await ref.putFile(File(voiceNotePath));
      final url = await ref.getDownloadURL();
      setState(() {
        message = url;
        type = 'voiceNote';
      });
      sendMessage();
    }
  }

  uploadImage(ImageSource source) async {
    ImagePicker().pickImage(source: source).then((xFile) async {
      if (source == ImageSource.camera) {
        Navigator.of(context, rootNavigator: true).pop();
        final String name = Timestamp.now().toDate().toString();
        if (xFile != null && xFile.path != null) {
          GallerySaver.saveImage(xFile.path, albumName: 'Mannar');
          final ref = FirebaseStorage.instance
              .ref()
              .child('chat')
              .child(widget.user.idUser!)
              .child('images')
              .child('$name.jpg');
          await ref.putFile(File(xFile.path));
          final url = await ref.getDownloadURL();
          setState(() {
            message = url;
            type = 'image';
          });
          sendMessage();
        }
      } else {
        Navigator.of(context, rootNavigator: true).pop();
        final String name = Timestamp.now().toDate().toString();
        if (xFile != null && xFile.path != null) {
          final ref = FirebaseStorage.instance
              .ref()
              .child('chat')
              .child(widget.user.idUser!)
              .child('images')
              .child('$name.jpg');
          await ref.putFile(File(xFile.path));
          final url = await ref.getDownloadURL();
          setState(() {
            message = url;
            type = 'image';
          });
          sendMessage();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              width: SizeConfig.screenWidth * 0.45,
              child: Stack(
                children: [
                  Expanded(
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextField(
                        controller: _controller,
                        textCapitalization: TextCapitalization.sentences,
                        autocorrect: true,
                        textDirection: TextDirection.rtl,
                        enableSuggestions: true,
                        maxLines: 4,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[100],
                          labelText: 'اكتب رسالتك هنا...',
                          labelStyle: TextStyles.h4,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(width: 0),
                            gapPadding: 10,
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        onChanged: (value) => setState(() {
                          message = value;
                        }),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // IconButton(
                        //   onPressed: () {
                        //     // Navigator.of(context)
                        //     //     .push(MaterialPageRoute(builder: (context) => VoiceRecordViews(records: records)));
                        //     setState(() {
                        //       _recording = true;
                        //     });
                        //   },
                        //   icon: Icon(Icons.headphones),
                        // ),
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                contentPadding: EdgeInsets.zero,
                                content: Container(
                                  child: Wrap(
                                    children: <Widget>[
                                      ListTile(
                                          leading: Icon(Icons.camera_alt),
                                          title: Text('Camera'),
                                          onTap: () => {uploadImage(ImageSource.camera)}),
                                      ListTile(
                                        leading: Icon(Icons.photo_album),
                                        title: Text('Gallery'),
                                        onTap: () => {uploadImage(ImageSource.gallery)},
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          icon: Icon(Icons.camera_alt),
                        ),
                        IconButton(
                          onPressed: () async {
                            var _docPath = await FilePicker.platform.pickFiles(
                              allowMultiple: false,
                              type: FileType.custom,
                              dialogTitle: 'اختر الملف',
                              allowedExtensions: ['pdf', 'docx'],
                            );
                            if (_docPath != null && _docPath.files.single.path != null) {
                              final name = _docPath.files.single.path;
                              final ref = FirebaseStorage.instance
                                  .ref()
                                  .child('chat')
                                  .child(widget.user.idUser!)
                                  .child('docs')
                                  .child('$name');
                              await ref.putFile(File(_docPath.files.single.path!));
                              final url = await ref.getDownloadURL();
                              setState(() {
                                message = url;
                                type = 'document';
                              });
                              sendMessage();
                            }
                          },
                          icon: Icon(Icons.file_copy_outlined),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            height: SizeConfig.screenHeight * 0.09,
            width: SizeConfig.screenWidth * 0.45,
            child: BasicButton(
              buttonName: "إرسال",
              onPressedFunction: message.trim().isEmpty ? () {} : sendMessage,
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
