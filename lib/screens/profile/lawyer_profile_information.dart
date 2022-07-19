import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_switch/flutter_switch.dart';
import '../../bloc/service_provider/service_provider_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/styles.dart';
import '../../constants/size_config.dart';

class LawyerProfileInformation extends StatefulWidget {
  @override
  _LawyerProfileInformationState createState() => _LawyerProfileInformationState();
}

class _LawyerProfileInformationState extends State<LawyerProfileInformation> {
  late SharedPreferences _pref;
  String? lawyerToken;
  late bool status;
  @override
  void initState() {
    Future.delayed(Duration(seconds: 0)).then((_) async {
      _pref = await SharedPreferences.getInstance();

      setState(() {
        lawyerToken = _pref.getString('lawyerToken');
        status = true;
        print('Lawyer Token is ---->' + lawyerToken!);
      });
      BlocProvider.of<ServiceProviderCubit>(context).getServiceProviderProfile(lawyerToken!);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      top: false,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.04),
                height: SizeConfig.screenHeight * 0.1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.teal,
                      ),
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
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.04),
                child: Column(
                  children: [
                    BlocBuilder<ServiceProviderCubit, ServiceProviderState>(
                      builder: (context, state) {
                        if (state is GetServiceProviderProfileState) {
                          return Column(
                            children: [
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: 50,
                                        backgroundColor: Colors.transparent,
                                        child: ClipOval(
                                          child: Image.network(
                                            (state).serviceProvider.imageurl!,
                                            height: 100,
                                            width: 100,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: SizeConfig.screenHeight * 0.02,
                                  ),
                                  Text(
                                    (state).serviceProvider.name!,
                                    style: TextStyles.h3.copyWith(fontSize: 13),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Text(
                                      "لوريم ايبسوم هو نموذج افتراضي يوضع في التصاميم لتعرض على العميل ليتصور طريقه وضع النصوص بالتصاميم",
                                      style: TextStyles.h3.copyWith(color: Colors.grey),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(
                                    height: SizeConfig.screenHeight * 0.03,
                                  ),
                                  Divider(
                                    thickness: 1,
                                    indent: 50,
                                    endIndent: 50,
                                    color: Colors.grey[300],
                                  ),
                                  SizedBox(
                                    height: SizeConfig.screenHeight * 0.02,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Align(
                                      // padding: const EdgeInsets.only(
                                      //   right: 10.0,
                                      // ),
                                      alignment: Alignment.centerRight,
                                      child: Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'البريد الإلكتروني',
                                              style: TextStyles.textFieldsLabels,
                                            ),
                                            Text(
                                              (state).serviceProvider.email!,
                                              style: TextStyles.h2.copyWith(fontSize: 13),
                                            ),
                                            SizedBox(
                                              height: SizeConfig.screenHeight * 0.02,
                                            ),
                                            Text(
                                              'رقم الجوال',
                                              style: TextStyles.textFieldsLabels,
                                            ),
                                            Text(
                                              (state).serviceProvider.phone!,
                                              style: TextStyles.h2.copyWith(fontSize: 13),
                                              textDirection: TextDirection.ltr,
                                            ),
                                            SizedBox(
                                              height: SizeConfig.screenHeight * 0.02,
                                            ),
                                            Text(
                                              'الوظيفة',
                                              style: TextStyles.textFieldsLabels,
                                            ),
                                            Text(
                                              (state).serviceProvider.type == null
                                                  ? "مقدم خدمة "
                                                  : (state).serviceProvider.type!,
                                              style: TextStyles.h2.copyWith(fontSize: 13),
                                            ),
                                            SizedBox(
                                              height: SizeConfig.screenHeight * 0.02,
                                            ),

                                            //If there is two accounts for users or lawyers
                                            //----------------------------------------------
                                            Text(
                                              'الحاله',
                                              style: TextStyles.textFieldsLabels,
                                            ),
                                            SizedBox(
                                              height: SizeConfig.screenHeight * 0.01,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(left: 10),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "متصل",
                                                    style: TextStyles.h2.copyWith(fontSize: 13),
                                                  ),
                                                  SizedBox(
                                                    width: SizeConfig.screenWidth * 0.15,
                                                  ),
                                                  FlutterSwitch(
                                                    width: 40.0,
                                                    height: 20.0,
                                                    toggleSize: 20.0,
                                                    value: status,
                                                    activeTextColor: Colors.black,
                                                    // inactiveTextColor: Colors.blue,
                                                    toggleColor: Color(0xff03564C),
                                                    //  showOnOff: true,
                                                    onToggle: (val) async {
                                                      setState(() {
                                                        status = val;
                                                      });
                                                      if (val == true) {
                                                        await BlocProvider.of<ServiceProviderCubit>(context)
                                                            .updateAvailableForServiceProvider(lawyerToken!, '1');
                                                      } else if (val == false) {
                                                        await BlocProvider.of<ServiceProviderCubit>(context)
                                                            .updateAvailableForServiceProvider(lawyerToken!, '0');
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        } else {
                          return Container(
                            height: SizeConfig.screenHeight * 0.9,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
