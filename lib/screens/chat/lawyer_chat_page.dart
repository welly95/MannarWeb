import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../bloc/service_provider/service_provider_cubit.dart';
import '../../bloc/services/services_cubit.dart';
import '../../constants/size_config.dart';
import '../../constants/styles.dart';
import '../../main.dart';
import '../../models/chat_user.dart';
import '../../repository/service_provider_repository.dart';
import '../../repository/web_services.dart';
import '../../widgets/Chat/lawyer_messages_widget.dart';
import '../../widgets/Chat/lawyer_new_message_widget.dart';
import '../../widgets/Chat/profile_header_widget.dart';

import 'package:flutter/material.dart';

import '../profile/lawyer_profile_information.dart';

class LawyerChatPage extends StatefulWidget {
  final User user;
  final String chatRoomName;
  final String lawyerName;

  const LawyerChatPage({
    required this.user,
    required this.chatRoomName,
    required this.lawyerName,
    Key? key,
  }) : super(key: key);

  @override
  _LawyerChatPageState createState() => _LawyerChatPageState();
}

class _LawyerChatPageState extends State<LawyerChatPage> {
  late SharedPreferences _pref;
  @override
  void initState() {
    Future.delayed(Duration(seconds: 0)).then((_) async {
      _pref = await SharedPreferences.getInstance();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('from chat page =====>' + widget.chatRoomName);
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
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
                  ProfileHeaderWidget(name: widget.user.name),
                  Expanded(
                    child: Material(
                      elevation: 20,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                          ),
                        ),
                        child: LawyerMessagesWidget(
                            idUser: widget.user.recieverId,
                            recieverId: widget.user.idUser!,
                            chatRoomName: widget.chatRoomName),
                      ),
                    ),
                  ),
                  LawyerNewMessageWidget(
                    user: widget.user,
                    lawyerName: widget.lawyerName,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
