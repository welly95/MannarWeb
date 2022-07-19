import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../bloc/service_provider/service_provider_cubit.dart';
import '../../bloc/services/services_cubit.dart';
import '../../constants/size_config.dart';
import '../../constants/styles.dart';
import '../../main.dart';
import '../../repository/service_provider_repository.dart';
import '../../repository/web_services.dart';
import '../../screens/chat/lawyer_quick_chat_user_messages.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../profile/lawyer_profile_information.dart';

class LawyerQuickChat extends StatefulWidget {
  const LawyerQuickChat({Key? key}) : super(key: key);

  @override
  _LawyerQuickChatState createState() => _LawyerQuickChatState();
}

class _LawyerQuickChatState extends State<LawyerQuickChat> {
  late SharedPreferences _pref;
  String? userId;
  @override
  void initState() {
    Future.delayed(Duration(seconds: 0)).then((_) async {
      _pref = await SharedPreferences.getInstance();
      await BlocProvider.of<ServiceProviderCubit>(context).getQuickChatUsers(_pref.getString('lawyerToken')!);
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    Future.delayed(Duration(seconds: 0)).then((_) async {
      _pref = await SharedPreferences.getInstance();
      await BlocProvider.of<ServiceProviderCubit>(context).getQuickChatUsers(_pref.getString('lawyerToken')!);
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white.withOpacity(0.95),
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
            DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/images/S1.png',
                  ),
                  fit: BoxFit.fitWidth,
                ),
              ),
              position: DecorationPosition.background,
              child: Container(
                height: SizeConfig.screenHeight * 0.2,
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.04),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(Icons.arrow_back),
                          color: Colors.white,
                        ),
                        Icon(
                          Icons.notifications_outlined,
                          color: Colors.transparent,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.04,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        'قائمة الدردشات',
                        style: TextStyles.h2.copyWith(color: Colors.white),
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        'دردشات فورية....',
                        style: TextStyles.h2.copyWith(color: Colors.white),
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: SizeConfig.screenHeight * 0.02,
            ),
            Expanded(
              child: BlocBuilder<ServiceProviderCubit, ServiceProviderState>(
                builder: (context, state) {
                  if (state is GetQuickChatUsersState) {
                    return Container(
                      width: SizeConfig.screenWidth * 0.55,
                      child: ListView.builder(
                        itemCount: state.quickChatUserModel.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              ListTile(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                                tileColor: Colors.white,
                                hoverColor: Colors.teal,
                                selectedColor: Colors.teal,
                                selectedTileColor: Colors.teal,
                                onTap: () async {
                                  await BlocProvider.of<ServiceProviderCubit>(context)
                                      .getQuickChatForLawyer(_pref.getString('lawyerToken')!,
                                          state.quickChatUserModel[index].id.toString())
                                      .then(
                                        (_) => Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) => BlocProvider(
                                              create: (context) =>
                                                  ServiceProviderCubit(ServiceProviderRepository(WebServices())),
                                              child: LawyerQuickChatUserMessages(
                                                  state.quickChatUserModel[index].id.toString(),
                                                  state.quickChatUserModel[index].name!),
                                            ),
                                          ),
                                        ),
                                      );
                                },
                                title: Text(
                                  state.quickChatUserModel[index].name!,
                                  style: TextStyles.h1.copyWith(color: Colors.black),
                                  textDirection: TextDirection.ltr,
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              )
                            ],
                          );
                        },
                      ),
                    );
                  } else {
                    return Expanded(
                        child: Center(
                      child: CircularProgressIndicator(),
                    ));
                  }
                },
              ),
            ),

            // Padding(
            //   padding: const EdgeInsets.only(top: 190.0),
            //   child: Container(
            //     height: SizeConfig.screenHeight * 0.99,
            //     width: SizeConfig.screenWidth * 0.95,
            //     alignment: Alignment.center,
            //     child: Image.asset(
            //       "assets/images/Group13119.png",
            //       height: SizeConfig.screenHeight * 0.50,
            //       width: SizeConfig.screenWidth * 0.50,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
