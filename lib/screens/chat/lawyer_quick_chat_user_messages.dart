import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../bloc/service_provider/service_provider_cubit.dart';
import '../../bloc/services/services_cubit.dart';
import '../../constants/size_config.dart';
import '../../constants/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../../repository/service_provider_repository.dart';
import '../../repository/web_services.dart';
import '../profile/lawyer_profile_information.dart';

class LawyerQuickChatUserMessages extends StatefulWidget {
  final String userId;
  final String userName;
  const LawyerQuickChatUserMessages(this.userId, this.userName, {Key? key}) : super(key: key);

  @override
  _LawyerQuickChatUserMessagesState createState() => _LawyerQuickChatUserMessagesState();
}

class _LawyerQuickChatUserMessagesState extends State<LawyerQuickChatUserMessages> {
  TextEditingController _controller = TextEditingController();
  String message = '';

  late SharedPreferences _pref;
  late bool isMe;

  @override
  void initState() {
    Future.delayed(Duration(seconds: 0)).then((_) async {
      _pref = await SharedPreferences.getInstance();
      await BlocProvider.of<ServiceProviderCubit>(context)
          .getQuickChatForLawyer(_pref.getString('lawyerToken')!, widget.userId);
    });
    super.initState();
  }

  void sendMessage() async {
    FocusScope.of(context).unfocus();

    await BlocProvider.of<ServiceProviderCubit>(context)
        .sendLawyerQuickMessage(_pref.getString('lawyerToken')!, message, widget.userId)
        .then((_) async => await BlocProvider.of<ServiceProviderCubit>(context)
            .getQuickChatForLawyer(_pref.getString('lawyerToken')!, widget.userId));
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        // extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.04),
              height: SizeConfig.screenHeight * 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      TextButton(
                        onPressed: () async {
                          _pref = await SharedPreferences.getInstance();
                          var lawyerToken = _pref.getString('lawyerToken');
                          if (lawyerToken != null || lawyerToken != '') {
                            await BlocProvider.of<ServicesCubit>(context).logOutLawyer(lawyerToken!).then((value) {
                              if (value == true) {
                                _pref.setString('lawyerToken', '').then(
                                  (_) {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(builder: (context) => MyApp()), (route) => false);
                                  },
                                );
                              } else {
                                Fluttertoast.showToast(
                                  msg: _pref.getString('errorOfLogOut')!,
                                  gravity: ToastGravity.TOP,
                                  toastLength: Toast.LENGTH_LONG,
                                  timeInSecForIosWeb: 5,
                                );
                              }
                            });
                          }
                        },
                        child: Text(
                          'تسجيل خروج',
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
                              builder: (context) => MultiBlocProvider(providers: [
                                BlocProvider(
                                  // lazy: false,
                                  create: (BuildContext context) =>
                                      ServiceProviderCubit(ServiceProviderRepository(WebServices())),
                                ),
                              ], child: LawyerProfileInformation()),
                            ),
                          );
                        },
                        child: Text(
                          'الملف الشخصي',
                          style: TextStyles.textFieldsHint,
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
            Container(
              width: SizeConfig.screenWidth * 0.75,
              height: SizeConfig.screenHeight * 0.85,
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
                          widget.userName,
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
                  BlocBuilder<ServiceProviderCubit, ServiceProviderState>(
                    builder: (context, state) {
                      if (state is GetQuickChatForLawyerState) {
                        print(state.quickChatModel);
                        return Expanded(
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            reverse: true,
                            itemCount: state.quickChatModel.length,
                            itemBuilder: (context, index) {
                              if (state.quickChatModel[index].from == 'lawyer') {
                                isMe = true;
                              } else {
                                isMe = false;
                              }
                              return Row(
                                mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(16),
                                    margin: EdgeInsets.all(16),
                                    constraints: BoxConstraints(maxWidth: 140),
                                    decoration: BoxDecoration(
                                      color: isMe ? Colors.grey[100] : Colors.blue,
                                      borderRadius: isMe
                                          ? BorderRadius.all(Radius.circular(12))
                                              .subtract(BorderRadius.only(bottomRight: Radius.circular(12)))
                                          : BorderRadius.all(Radius.circular(12))
                                              .subtract(BorderRadius.only(bottomLeft: Radius.circular(12))),
                                    ),
                                    child: buildMessage(state.quickChatModel[index].message!, isMe),
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
                  )
                ],
              ),
            ),
          ],
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
