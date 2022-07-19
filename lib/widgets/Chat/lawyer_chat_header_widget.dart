import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../bloc/service_provider/service_provider_cubit.dart';
import '../../bloc/services/services_cubit.dart';
import '../../constants/size_config.dart';
import '../../constants/styles.dart';
import '../../models/chat_user.dart';
import '../../repository/service_provider_repository.dart';
import '../../repository/web_services.dart';
import '../../screens/chat/lawyer_chat_page.dart';
import '../../screens/profile/lawyer_profile_information.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

// ignore: must_be_immutable
class LawyerChatHeaderWidget extends StatelessWidget {
  final List<User> users;

  LawyerChatHeaderWidget({required this.users});

  Future<String> createChatRoomName(String idUser, String recieverId) async {
    return 'chatRoom:-${idUser}_to_$recieverId';
  }

  late SharedPreferences _pref;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Column(
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
        Divider(
          color: Colors.grey.shade300,
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.screenWidth * 0.04,
          ),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: SizeConfig.screenHeight * 0.02,
              ),
              SizedBox(
                height: 80,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];

                      return Container(
                        margin: const EdgeInsets.only(right: 12),
                        child: GestureDetector(
                          onTap: () async {
                            await createChatRoomName('1', users[index].idUser!).then(
                              (chatRoomName) => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => LawyerChatPage(
                                    user: users[index],
                                    chatRoomName: chatRoomName,
                                    lawyerName: users[index].lawyerName,
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundImage: NetworkImage(user.urlAvatar),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                user.name,
                                style: TextStyles.h3.copyWith(color: Colors.black),
                                textAlign: TextAlign.center,
                                textDirection: TextDirection.ltr,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: SizeConfig.screenHeight * 0.02,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
