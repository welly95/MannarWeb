import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../bloc/service_provider/service_provider_cubit.dart';
import '../../bloc/services/services_cubit.dart';
import '../../bloc/user/user_cubit.dart';
import '../../constants/size_config.dart';
import '../../models/chat_user.dart';
import '../../repository/service_provider_repository.dart';
import '../../repository/user_repository.dart';
import '../../repository/web_services.dart';
import '../../screens/chat/lawyer_quick_chat.dart';
import '../../screens/profile/lawyer_profile_information.dart';
import '../../widgets/Chat/lawyer_chat_header_widget.dart';
import '../../widgets/Chat/lawyer_chats_body_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/firebase_api.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class LawyerChatsPage extends StatefulWidget {
  final String lawyerId;
  final String lawyerToken;
  const LawyerChatsPage(this.lawyerId, this.lawyerToken, {key}) : super(key: key);

  @override
  State<LawyerChatsPage> createState() => _LawyerChatsPageState();
}

class _LawyerChatsPageState extends State<LawyerChatsPage> {
  late SharedPreferences _pref;
  late String lawyerId;
  @override
  void initState() {
    Future.delayed(Duration(seconds: 0)).then((_) async {
      _pref = await SharedPreferences.getInstance();
      // setState(() {
      //   lawyerId = _pref.getString('lawyerId')!;
      // });
    });
    super.initState();
  }

  updateStatus() {
    Future.delayed(Duration(seconds: 2)).then((_) async => await BlocProvider.of<ServiceProviderCubit>(context)
        .updateAvailableForServiceProvider(widget.lawyerToken, '1'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.chat_outlined,
        ),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (ctx) => MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) => UserCubit(UserRepository(WebServices())),
                      ),
                      BlocProvider(
                        create: (context) => ServiceProviderCubit(ServiceProviderRepository(WebServices())),
                      ),
                    ],
                    child: LawyerQuickChat(),
                  )));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      body: SafeArea(
        child: StreamBuilder<List<User>>(
          stream: FirebaseApi.getLawyerChats(widget.lawyerId),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError) {
                  print('===============>' + snapshot.error.toString());
                  return Column(
                    children: [
                      SizedBox(
                        height: SizeConfig.screenHeight * 0.02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
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
                            icon: Icon(
                              Icons.person_outline,
                              color: Color(0xff03564C),
                            ),
                          ),
                          Image.asset(
                            'assets/images/logo_text.png',
                            height: SizeConfig.screenHeight * 0.07,
                            width: SizeConfig.screenWidth * 0.2,
                            fit: BoxFit.contain,
                          ),
                          IconButton(
                              onPressed: () async {
                                _pref = await SharedPreferences.getInstance();
                                var lawyerToken = _pref.getString('lawyerToken');
                                if (_pref.getString('lawyerToken') != null || _pref.getString('lawyerToken') != '') {
                                  await BlocProvider.of<ServicesCubit>(context).logOut(lawyerToken!).then((value) {
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
                                          timeInSecForIosWeb: 5);
                                    }
                                  });
                                }
                              },
                              icon: Icon(
                                Icons.exit_to_app,
                                color: Color(0xff03564C),
                              )),
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig.screenHeight * 0.02,
                      ),
                      Expanded(child: buildText('Something Went Wrong Try later')),
                    ],
                  );
                } else {
                  updateStatus();
                  final users = snapshot.data;
                  print(users.toString());
                  if (users!.isEmpty) {
                    return buildText('No Users Found');
                  } else {
                    return Column(
                      children: [LawyerChatHeaderWidget(users: users), LawyerChatBodyWidget(users: users)],
                    );
                  }
                }
            }
          },
        ),
      ),
    );
  }

  Widget buildText(String text) => Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 24, color: Color(0xff03564C)),
        ),
      );
}
