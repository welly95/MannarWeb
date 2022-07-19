// ignore_for_file: body_might_complete_normally_nullable, unnecessary_null_comparison

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mannar_web/screens/home/home_screen.dart';
import '../../api/firebase_api.dart';
import '../../constants/size_config.dart';
import '../../constants/styles.dart';
import '../../widgets/buttons/basic_button.dart';
import '../../widgets/textfields/description_textfield.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UploadFiles extends StatefulWidget {
  final String lawyerId;
  final String lawyerName;
  final String lawyerUrl;
  final String wayToCommunicate;

  UploadFiles(this.lawyerId, this.lawyerName, this.lawyerUrl, this.wayToCommunicate, {Key? key}) : super(key: key);

  @override
  _UploadFilesState createState() => _UploadFilesState();
}

class _UploadFilesState extends State<UploadFiles> {
  late SharedPreferences _pref;
  late Dio dio;
  late FilePickerResult _docPath;

  BaseOptions options = BaseOptions(
      baseUrl: 'https://manar.alliedcon.net/api/',
      receiveDataWhenStatusError: true,
      connectTimeout: 20 * 1000,
      receiveTimeout: 20 * 1000,
      headers: {
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials": true, // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers":
            "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        "Access-Control-Allow-Methods": "POST, OPTIONS, GET"
      });

  bool _loading = false;
  String message = 'ارفع ملف من هنا';
  String title = '';
  late String url;
  String type = 'document';
  List<String> records = [];
  late Directory appDirectory;
  String filePath = '';
  String? _myToken;
  TextEditingController _basicController = TextEditingController();
  String? voiceNotePath = '';

  @override
  void initState() {
    super.initState();
    dio = Dio(options);

    Future.delayed(Duration(seconds: 0)).then((_) async {
      _myToken = await FirebaseMessaging.instance.getToken();
      _pref = await SharedPreferences.getInstance();
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
      if (widget.lawyerId != '') {
        FirebaseFirestore.instance
            .collection('chats')
            .doc('chatRoom:-${_pref.getString('userId')}_to_${widget.lawyerId}')
            .set({
          'idUser': _pref.getString('userId'),
          'recieverId': widget.lawyerId,
          'name': _pref.getString('userName'),
          'lawyerName': widget.lawyerName,
          'wayToChat': widget.wayToCommunicate,
          'urlAvatar': widget.lawyerUrl,
          'lastMessageTime': DateTime.now(),
        });
      }
    });
  }

  Future<String> sendMessage(String message) async {
    FocusScope.of(context).unfocus();
    if (widget.lawyerId == '') {
      FormData formData = FormData.fromMap({
        // "attachments": await MultipartFile.fromFile(file.path, filename: name),
        'booking_id': _pref.getString('bookingId'),
        'message': message,
      });
      await dio.post(
        "add_booking_attachments",
        data: formData,
        options: Options(
          headers: {
            'Accept': '*/*',
            HttpHeaders.authorizationHeader: _pref.getString('userToken')!,
          },
        ),
      );
      return 'تم ارسال رسالتك بنجاح';
    } else {
      await FirebaseApi.uploadMessage(_pref.getString('userId')!, widget.lawyerId, _pref.getString('userName')!, url,
          message, type, widget.lawyerName, _myToken!, '');
      return 'تم ارسال رسالتك بنجاح';
    }
  }

  Future<String> sendFile(File file, String name) async {
    FocusScope.of(context).unfocus();
    FormData formData = FormData.fromMap({
      "attachments": await MultipartFile.fromFile(file.path, filename: name),
      'booking_id': _pref.getString('bookingId'),
      'message': name,
    });
    Response response = await dio.post(
      "add_booking_attachments",
      data: formData,
      options: Options(
        headers: {
          'Accept': '*/*',
          HttpHeaders.authorizationHeader: _pref.getString('userToken')!,
        },
      ),
    );
    return response.data['message'];
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Directionality(
                textDirection: TextDirection.rtl,
                child: Container(
                  // height: SizeConfig.screenHeight - (SizeConfig.screenHeight * 0.1),
                  padding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.05),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: SizeConfig.screenHeight * 0.04,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: null,
                              icon: Icon(
                                Icons.menu,
                                color: Colors.transparent,
                              ),
                            ),
                            Image.asset(
                              'assets/images/logo_text.png',
                              height: SizeConfig.screenHeight * 0.07,
                              width: SizeConfig.screenWidth * 0.2,
                              fit: BoxFit.contain,
                            ),
                            IconButton(
                              onPressed: null,
                              icon: Icon(
                                Icons.menu,
                                color: Colors.transparent,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: SizeConfig.screenHeight * 0.02,
                        ),
                        Text(
                          'ارفع الملفات الخاصة بالاستشارة',
                          style: TextStyles.h2Bold.copyWith(color: Colors.black),
                        ),
                        SizedBox(
                          height: SizeConfig.screenHeight * 0.02,
                        ),
                        (message == 'ارفع ملف من هنا')
                            ? Container()
                            : ListTile(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  side: BorderSide(color: Colors.grey, width: 1),
                                ),
                                title: Text(
                                  message,
                                  style: TextStyles.h2.copyWith(color: Colors.red[600]),
                                ),
                                trailing: IconButton(
                                  onPressed: () async {
                                    setState(() {
                                      _loading = true;
                                    });
                                    if (widget.lawyerId == '') {
                                      _docPath.files.clear();
                                      setState(() {
                                        _loading = false;
                                        message = 'ارفع ملف من هنا';
                                      });
                                    } else {
                                      await FirebaseStorage.instance.refFromURL(url).delete().then((_) {
                                        setState(() {
                                          message = 'ارفع ملف من هنا';
                                          _loading = false;
                                        });
                                      });
                                    }
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                        SizedBox(
                          height: SizeConfig.screenHeight * 0.04,
                        ),
                        ListTile(
                          title: Text(
                            'ارفع ملف من هنا',
                            style: TextStyles.h2,
                          ),
                          trailing: IconButton(
                            onPressed: () async {
                              var docPath = await FilePicker.platform.pickFiles(
                                allowMultiple: false,
                                type: FileType.custom,
                                dialogTitle: 'اختر الملف',
                                allowedExtensions: ['pdf', 'docx'],
                              );
                              if (docPath != null && docPath.files.single.path != null) {
                                setState(() {
                                  message = docPath.files[0].name;
                                  _docPath = docPath;
                                });
                              }
                            },
                            icon: Icon(Icons.cloud_upload),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(color: Colors.grey, width: 1),
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.screenHeight * 0.02,
                        ),
                        SizedBox(
                          width: SizeConfig.screenWidth * 0.85,
                          height: SizeConfig.screenHeight * 0.08,
                          child: BasicButton(
                            buttonName: 'إرسال الملف',
                            onPressedFunction: () async {
                              if (_docPath != null && _docPath.files.single.path != null) {
                                final name = _docPath.files.single.path;
                                if (widget.lawyerId == '') {
                                  setState(() {
                                    _loading = true;
                                  });
                                  sendFile(File(_docPath.files.single.path!), _docPath.files[0].name).then((value) {
                                    setState(() {
                                      _loading = false;
                                    });
                                    return Fluttertoast.showToast(
                                      msg: value,
                                      gravity: ToastGravity.TOP,
                                      toastLength: Toast.LENGTH_LONG,
                                      timeInSecForIosWeb: 5,
                                    );
                                  });
                                } else {
                                  final ref = FirebaseStorage.instance
                                      .ref()
                                      .child('chat')
                                      .child(_pref.getString('userId')!)
                                      .child('docs')
                                      .child('$name');
                                  await ref.putFile(File(_docPath.files.single.path!));
                                  url = await ref.getDownloadURL();
                                  setState(() {
                                    message = _docPath.files[0].name;
                                    title = _docPath.files[0].name;
                                    type = 'document';
                                    _loading = false;
                                  });
                                }
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.screenHeight * 0.02,
                        ),
                        DescriptionTextField(
                          ValueKey('مساحة'),
                          _basicController,
                          'مساحة حرة لإضافة معلومات',
                          TextInputType.text,
                          (val) {},
                        ),
                        SizedBox(
                          height: SizeConfig.screenHeight * 0.02,
                        ),
                        SizedBox(
                          width: SizeConfig.screenWidth * 0.85,
                          height: SizeConfig.screenHeight * 0.08,
                          child: BasicButton(
                            buttonName: 'إرسال رسالة',
                            onPressedFunction: () {
                              setState(() {
                                _loading = true;
                              });
                              sendMessage(_basicController.text.trim()).then((value) {
                                setState(() {
                                  _loading = false;
                                });
                                return Fluttertoast.showToast(
                                  msg: value,
                                  gravity: ToastGravity.TOP,
                                  toastLength: Toast.LENGTH_LONG,
                                  timeInSecForIosWeb: 5,
                                );
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.screenHeight * 0.02,
                        ),
                        Text(
                          '* نأمل إرفاق وجميع المستندات ذات العلاقة.',
                          style: TextStyles.h2Bold,
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                        ),
                        SizedBox(
                          width: SizeConfig.screenWidth * 0.85,
                          height: SizeConfig.screenHeight * 0.08,
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (context) => HomeScreen()), (route) => false);
                            },
                            child: Text(
                              'إنهاء',
                              style: TextStyles.h2Bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: SizeConfig.screenWidth * 0.85,
                          height: SizeConfig.screenHeight * 0.08,
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (context) => HomeScreen()), (route) => false);
                            },
                            child: Text(
                              'إرسال لاحقًا',
                              style: TextStyles.h2Bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              (_loading)
                  ? Container(
                      height: SizeConfig.screenHeight,
                      width: SizeConfig.screenWidth,
                      color: Colors.grey.withOpacity(0.1),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Container(
                      height: 1,
                      width: 1,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
