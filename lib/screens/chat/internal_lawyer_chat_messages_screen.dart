import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../bloc/booking/booking_cubit.dart';
import '../../bloc/lawyer/lawyer_cubit.dart';
import '../../bloc/services/services_cubit.dart';
import '../../bloc/user/user_cubit.dart';
import '../../models/aboutUsModel.dart';
import '../../models/chatWithAttachments.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/size_config.dart';
import '../../constants/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/filter_data.dart';
import '../../models/lawyers.dart';
import '../../repository/lawyer_repository.dart';
import '../../repository/services_repository.dart';
import '../../repository/user_repository.dart';
import '../../repository/web_services.dart';
import '../aboutUs/about_us.dart';
import '../contactUS/contact_us.dart';
import '../home/home_screen.dart';
import '../lawyer/search_lawyer.dart';
import 'chats_page.dart';

class InternalLawyerChatMessagesScreen extends StatefulWidget {
  final AboutUsModel _aboutUsModel;
  final FilterData _filterData;
  final List<Lawyer> _lawyersList;
  final String bookingId;
  const InternalLawyerChatMessagesScreen(this.bookingId, this._aboutUsModel, this._filterData, this._lawyersList,
      {Key? key})
      : super(key: key);

  @override
  _InternalLawyerChatMessagesScreenState createState() => _InternalLawyerChatMessagesScreenState();
}

class _InternalLawyerChatMessagesScreenState extends State<InternalLawyerChatMessagesScreen> {
  TextEditingController _controller = TextEditingController();
  String message = '';
  late int _totalDuration;
  late int _currentDuration;
  double _completedPercentage = 0.0;
  bool _isPlaying = false;
  late SharedPreferences _pref;
  late bool isMe;
  bool checkQuickChat = false;
  List<String> records = [];
  List<ChatWithAttachments> _messages = [];
  late Directory appDirectory;
  late Dio dio;
  String? voiceNotePath = '';

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

  @override
  void initState() {
    Future.delayed(Duration(seconds: 0)).then((_) async {
      _pref = await SharedPreferences.getInstance();
      dio = Dio(options);

      await BlocProvider.of<BookingCubit>(context)
          .getChatWithAttachments(_pref.getString('userToken')!, widget.bookingId);
    });
    super.initState();
  }

  void sendMessage() async {
    FocusScope.of(context).unfocus();

    FormData formData = FormData.fromMap({
      // "attachments": await MultipartFile.fromFile(file.path, filename: name),
      'booking_id': _pref.getString('bookingId'),
      'message': message,
    });
    await dio
        .post(
      "add_booking_attachments",
      data: formData,
      options: Options(
        headers: {
          'Accept': '*/*',
          HttpHeaders.authorizationHeader: _pref.getString('userToken')!,
        },
      ),
    )
        .then(
      (val) {
        if (val.data['message'] == 'success') {
          setState(() {
            _messages = [];
            BlocProvider.of<BookingCubit>(context)
                .getChatWithAttachments(_pref.getString('userToken')!, widget.bookingId)
                .then((value) => setState(() {
                      _messages.addAll(value);
                    }));
          });
        }
      },
    );
    _controller.clear();
  }

  void sendFile(File file, String name) async {
    FocusScope.of(context).unfocus();
    FormData formData = FormData.fromMap({
      "attachments": await MultipartFile.fromFile(file.path, filename: name),
      'booking_id': _pref.getString('bookingId'),
      'message': name,
    });
    await dio
        .post(
          "add_booking_attachments",
          data: formData,
          options: Options(
            headers: {
              'Accept': '*/*',
              HttpHeaders.authorizationHeader: _pref.getString('userToken')!,
            },
          ),
        )
        .then(
          (_) => setState(
            () {
              _messages = [];
              BlocProvider.of<BookingCubit>(context)
                  .getChatWithAttachments(_pref.getString('userToken')!, widget.bookingId)
                  .then(
                    (value) => setState(
                      () {
                        _messages.addAll(value);
                      },
                    ),
                  );
            },
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                height: SizeConfig.screenHeight * 0.06,
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.04),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.call_outlined,
                          color: Colors.teal,
                        ),
                        SizedBox(
                          width: SizeConfig.screenWidth * 0.005,
                        ),
                        Text(
                          widget._aboutUsModel.phone!,
                          style: TextStyles.textFieldsHint,
                        ),
                        SizedBox(
                          width: SizeConfig.screenWidth * 0.01,
                        ),
                        VerticalDivider(
                          color: Colors.grey,
                          endIndent: 10,
                          indent: 10,
                        ),
                        Icon(
                          FontAwesomeIcons.envelope,
                          color: Colors.teal,
                        ),
                        SizedBox(
                          width: SizeConfig.screenWidth * 0.005,
                        ),
                        Text(
                          widget._aboutUsModel.email!,
                          style: TextStyles.textFieldsHint,
                        ),
                        SizedBox(
                          width: SizeConfig.screenWidth * 0.02,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            launch(widget._aboutUsModel.facebook!);
                          },
                          icon: Icon(
                            FontAwesomeIcons.facebookF,
                            color: Colors.teal,
                          ),
                        ),
                        SizedBox(width: SizeConfig.screenWidth * 0.01),
                        IconButton(
                          onPressed: () {
                            launch(widget._aboutUsModel.twitter!);
                          },
                          icon: Icon(
                            FontAwesomeIcons.twitter,
                            color: Colors.teal,
                          ),
                        ),
                        SizedBox(width: SizeConfig.screenWidth * 0.01),
                        IconButton(
                          onPressed: () {
                            launch(widget._aboutUsModel.linkedIn!);
                          },
                          icon: Icon(
                            FontAwesomeIcons.linkedinIn,
                            color: Colors.teal,
                          ),
                        ),
                        SizedBox(width: SizeConfig.screenWidth * 0.01),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.04),
                height: SizeConfig.screenHeight * 0.1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: null,
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            backgroundImage: AssetImage('assets/images/profile_icon.jpg'),
                            radius: 25,
                          ),
                        ),
                        SizedBox(
                          width: SizeConfig.screenWidth * 0.04,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => MultiBlocProvider(
                                  providers: [
                                    BlocProvider(
                                      create: (context) => ServicesCubit(
                                        ServicesRepo(
                                          WebServices(),
                                        ),
                                      ),
                                    ),
                                    BlocProvider(
                                      create: (context) => UserCubit(
                                        UserRepository(
                                          WebServices(),
                                        ),
                                      ),
                                    ),
                                  ],
                                  child: ContactUs(widget._lawyersList, widget._filterData, widget._aboutUsModel),
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'تواصل معنا',
                            style: TextStyles.textFieldsHint,
                          ),
                        ),
                        SizedBox(
                          width: SizeConfig.screenWidth * 0.04,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) => ServicesCubit(ServicesRepo(WebServices())),
                                  child: AboutUs(widget._lawyersList, widget._filterData, widget._aboutUsModel),
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'عن المنار',
                            style: TextStyles.textFieldsHint,
                          ),
                        ),
                        SizedBox(
                          width: SizeConfig.screenWidth * 0.04,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    ChatsPage(widget._aboutUsModel, widget._filterData, widget._lawyersList),
                              ),
                            );
                          },
                          child: Text(
                            'الدردشات',
                            style: TextStyles.textFieldsHint,
                          ),
                        ),
                        SizedBox(
                          width: SizeConfig.screenWidth * 0.04,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => MultiBlocProvider(
                                  providers: [
                                    BlocProvider(
                                      lazy: false,
                                      create: (BuildContext context) => ServicesCubit(
                                        ServicesRepo(WebServices()),
                                      ),
                                    ),
                                    BlocProvider(
                                      lazy: false,
                                      create: (BuildContext context) => LawyerCubit(
                                        LawyerRepository(WebServices()),
                                      ),
                                    ),
                                  ],
                                  child: SearchLawyer(widget._filterData, widget._lawyersList, widget._aboutUsModel),
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'المحاميين',
                            style: TextStyles.textFieldsHint,
                          ),
                        ),
                        SizedBox(
                          width: SizeConfig.screenWidth * 0.04,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => MultiBlocProvider(
                                    providers: [
                                      BlocProvider(
                                        create: (BuildContext context) => LawyerCubit(
                                          LawyerRepository(
                                            WebServices(),
                                          ),
                                        ),
                                      ),
                                      BlocProvider(
                                        lazy: false,
                                        create: (BuildContext context) => ServicesCubit(
                                          ServicesRepo(
                                            WebServices(),
                                          ),
                                        ),
                                      ),
                                    ],
                                    child: HomeScreen(),
                                  ),
                                ),
                                (route) => false);
                          },
                          child: Text(
                            'الرئيسية',
                            style: TextStyles.textFieldsHint.copyWith(color: Colors.teal),
                          ),
                        ),
                      ],
                    ),
                    Image.asset(
                      'assets/images/mannar_logo.png',
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
              Divider(
                color: Colors.grey.shade300,
              ),
              Container(
                width: SizeConfig.screenWidth * 0.65,
                height: SizeConfig.screenHeight * 0.8,
                child: Column(
                  children: [
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          BackButton(color: Color(0xff03564C)),
                          Expanded(child: Container()),
                          Text(
                            'المنار للإستشارات',
                            style: TextStyles.h2Bold,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(width: 15),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.02,
                    ),
                    BlocListener<BookingCubit, BookingState>(
                      listener: (context, state) {
                        if (state is GetChatWithAttachments) {
                          _messages.addAll(state.chatsList);
                        }
                      },
                      child: BlocBuilder<BookingCubit, BookingState>(
                        builder: (context, state) {
                          if (state is GetChatWithAttachments) {
                            return Expanded(
                              child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                reverse: true,
                                itemCount: _messages.length,
                                itemBuilder: (context, index) {
                                  if (_messages[index].serviceBookingId == int.parse(widget.bookingId)) {
                                    isMe = true;
                                  } else {
                                    isMe = false;
                                  }
                                  if (_messages[index].attachment != '' || _messages[index].attachment != null) {
                                    if (_messages[index].attachment!.endsWith('.aac')) {
                                      return Row(
                                        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(16),
                                            margin: EdgeInsets.all(16),
                                            constraints: BoxConstraints(maxWidth: 180),
                                            decoration: BoxDecoration(
                                              color: isMe ? Colors.grey[100] : Colors.blue,
                                              borderRadius: isMe
                                                  ? BorderRadius.all(Radius.circular(12))
                                                      .subtract(BorderRadius.only(bottomRight: Radius.circular(12)))
                                                  : BorderRadius.all(Radius.circular(12))
                                                      .subtract(BorderRadius.only(bottomLeft: Radius.circular(12))),
                                            ),
                                            child: Directionality(
                                              textDirection: (isMe) ? TextDirection.ltr : TextDirection.rtl,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 100,
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
                                                        audioPlayer.play(_messages[index].attachment!, isLocal: false);
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
                                                            _completedPercentage =
                                                                _currentDuration.toDouble() / _totalDuration.toDouble();
                                                          });
                                                        });
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    } else if (_messages[index].attachment!.endsWith('.pdf') ||
                                        _messages[index].attachment!.endsWith('.docx')) {
                                      return GestureDetector(
                                        onTap: () async {
                                          launch(_messages[index].attachment!);
                                        },
                                        child: Row(
                                          mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              padding: EdgeInsets.all(16),
                                              margin: EdgeInsets.all(16),
                                              constraints: BoxConstraints(maxWidth: SizeConfig.screenWidth * 0.65),
                                              decoration: BoxDecoration(
                                                color: isMe ? Colors.grey[100] : Colors.blue,
                                                borderRadius: isMe
                                                    ? BorderRadius.all(Radius.circular(12))
                                                        .subtract(BorderRadius.only(bottomRight: Radius.circular(12)))
                                                    : BorderRadius.all(Radius.circular(12))
                                                        .subtract(BorderRadius.only(bottomLeft: Radius.circular(12))),
                                              ),
                                              child: Text(
                                                _messages[index].message!,
                                                style: TextStyle(
                                                    color: isMe ? Colors.blue : Colors.white,
                                                    decoration: TextDecoration.underline),
                                                textAlign: isMe ? TextAlign.end : TextAlign.start,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  } else {
                                    return Row(
                                      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.all(16),
                                          margin: EdgeInsets.all(16),
                                          constraints: BoxConstraints(maxWidth: SizeConfig.screenWidth * 0.65),
                                          decoration: BoxDecoration(
                                            color: isMe ? Colors.grey[100] : Colors.blue,
                                            borderRadius: isMe
                                                ? BorderRadius.all(Radius.circular(12))
                                                    .subtract(BorderRadius.only(bottomRight: Radius.circular(12)))
                                                : BorderRadius.all(Radius.circular(12))
                                                    .subtract(BorderRadius.only(bottomLeft: Radius.circular(12))),
                                          ),
                                          child: buildMessage(_messages[index].message!, isMe),
                                        ),
                                      ],
                                    );
                                  }
                                  return Row(
                                    mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(16),
                                        margin: EdgeInsets.all(16),
                                        constraints: BoxConstraints(maxWidth: SizeConfig.screenWidth * 0.65),
                                        decoration: BoxDecoration(
                                          color: isMe ? Colors.grey[100] : Colors.blue,
                                          borderRadius: isMe
                                              ? BorderRadius.all(Radius.circular(12))
                                                  .subtract(BorderRadius.only(bottomRight: Radius.circular(12)))
                                              : BorderRadius.all(Radius.circular(12))
                                                  .subtract(BorderRadius.only(bottomLeft: Radius.circular(12))),
                                        ),
                                        child: buildMessage(_messages[index].message!, isMe),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            );
                          } else {
                            return Expanded(
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(8),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: TextField(
                                    controller: _controller,
                                    textCapitalization: TextCapitalization.sentences,
                                    autocorrect: true,
                                    textDirection: TextDirection.rtl,
                                    enableSuggestions: true,
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
                              SizedBox(width: 20),
                              GestureDetector(
                                onTap: message.trim().isEmpty ? null : sendMessage,
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.blue,
                                  ),
                                  child: Icon(
                                    Icons.send,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  var _docPath = await FilePicker.platform.pickFiles(
                                    allowMultiple: false,
                                    type: FileType.custom,
                                    dialogTitle: 'اختر الملف',
                                    allowedExtensions: ['pdf', 'docx'],
                                  );
                                  if (_docPath != null && _docPath.files.single.path != null) {
                                    sendFile(File(_docPath.files.single.path!), _docPath.files[0].name);
                                  }
                                },
                                icon: Icon(Icons.file_copy_outlined),
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: SizeConfig.screenHeight * 0.04,
              ),
              Stack(
                children: [
                  Container(
                    height: SizeConfig.screenHeight * 0.4,
                    width: SizeConfig.screenWidth,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/images/background.jpg',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    height: SizeConfig.screenHeight * 0.4,
                    width: SizeConfig.screenWidth,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: SizeConfig.screenHeight * 0.08,
                      ),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: SizeConfig.screenHeight * 0.28,
                            width: SizeConfig.screenWidth * 0.3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'تواصل',
                                  style: TextStyles.h2.copyWith(color: Colors.white),
                                ),
                                Text(
                                  widget._aboutUsModel.email!,
                                  style: TextStyles.h2.copyWith(color: Colors.white),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      widget._aboutUsModel.whatsapp!,
                                      style: TextStyles.h2.copyWith(color: Colors.white),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      FontAwesomeIcons.whatsapp,
                                      color: Colors.green,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: SizeConfig.screenHeight * 0.02,
                                ),
                                Divider(
                                  color: Colors.grey,
                                  indent: SizeConfig.screenWidth * 0.2,
                                  // endIndent: SizeConfig.screenWidth * 0.05,
                                ),
                                Text(
                                  'تواصل معنا',
                                  style: TextStyles.h2.copyWith(color: Colors.white),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: IconButton(
                                          onPressed: () {
                                            launch(widget._aboutUsModel.facebook!);
                                          },
                                          icon: Icon(
                                            FontAwesomeIcons.facebookF,
                                            color: Colors.teal,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: SizeConfig.screenWidth * 0.01),
                                      CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: IconButton(
                                          onPressed: () {
                                            launch(widget._aboutUsModel.twitter!);
                                          },
                                          icon: Icon(
                                            FontAwesomeIcons.twitter,
                                            color: Colors.teal,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: SizeConfig.screenWidth * 0.01),
                                      CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: IconButton(
                                          onPressed: () {
                                            launch(widget._aboutUsModel.linkedIn!);
                                          },
                                          icon: Icon(
                                            FontAwesomeIcons.linkedinIn,
                                            color: Colors.teal,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: SizeConfig.screenWidth * 0.01),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.04),
                      height: SizeConfig.screenHeight * 0.06,
                      width: SizeConfig.screenWidth,
                      decoration: BoxDecoration(color: Colors.grey.withOpacity(0.6)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => MultiBlocProvider(
                                        providers: [
                                          BlocProvider(
                                            create: (context) => ServicesCubit(
                                              ServicesRepo(
                                                WebServices(),
                                              ),
                                            ),
                                          ),
                                          BlocProvider(
                                            create: (context) => UserCubit(
                                              UserRepository(
                                                WebServices(),
                                              ),
                                            ),
                                          ),
                                        ],
                                        child: ContactUs(widget._lawyersList, widget._filterData, widget._aboutUsModel),
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  'تواصل معنا',
                                  style: TextStyles.textFieldsHint.copyWith(color: Colors.white),
                                ),
                              ),
                              SizedBox(
                                width: SizeConfig.screenWidth * 0.04,
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => BlocProvider(
                                        create: (context) => ServicesCubit(ServicesRepo(WebServices())),
                                        child: AboutUs(widget._lawyersList, widget._filterData, widget._aboutUsModel),
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  'عن المنار',
                                  style: TextStyles.textFieldsHint.copyWith(color: Colors.white),
                                ),
                              ),
                              SizedBox(
                                width: SizeConfig.screenWidth * 0.04,
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ChatsPage(widget._aboutUsModel, widget._filterData, widget._lawyersList),
                                    ),
                                  );
                                },
                                child: Text(
                                  'الدردشات',
                                  style: TextStyles.textFieldsHint.copyWith(color: Colors.white),
                                ),
                              ),
                              SizedBox(
                                width: SizeConfig.screenWidth * 0.04,
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => MultiBlocProvider(
                                        providers: [
                                          BlocProvider(
                                            lazy: false,
                                            create: (BuildContext context) => ServicesCubit(
                                              ServicesRepo(WebServices()),
                                            ),
                                          ),
                                          BlocProvider(
                                            lazy: false,
                                            create: (BuildContext context) => LawyerCubit(
                                              LawyerRepository(WebServices()),
                                            ),
                                          ),
                                        ],
                                        child:
                                            SearchLawyer(widget._filterData, widget._lawyersList, widget._aboutUsModel),
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  'المحاميين',
                                  style: TextStyles.textFieldsHint.copyWith(color: Colors.white),
                                ),
                              ),
                              SizedBox(
                                width: SizeConfig.screenWidth * 0.04,
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (context) => MultiBlocProvider(
                                          providers: [
                                            BlocProvider(
                                              create: (BuildContext context) => LawyerCubit(
                                                LawyerRepository(
                                                  WebServices(),
                                                ),
                                              ),
                                            ),
                                            BlocProvider(
                                              lazy: false,
                                              create: (BuildContext context) => ServicesCubit(
                                                ServicesRepo(
                                                  WebServices(),
                                                ),
                                              ),
                                            ),
                                          ],
                                          child: HomeScreen(),
                                        ),
                                      ),
                                      (route) => false);
                                },
                                child: Text(
                                  'الرئيسية',
                                  style: TextStyles.textFieldsHint.copyWith(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'جميع الحقوق محفوظة لمنار 2021',
                            style: TextStyles.textFieldsHint.copyWith(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMessage(String message, bool isMe) => Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            message,
            style: TextStyle(color: isMe ? Colors.black : Colors.white),
            textAlign: isMe ? TextAlign.end : TextAlign.start,
          ),
        ],
      );

  Widget buildText(String text) => Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 24),
        ),
      );
}
