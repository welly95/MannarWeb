import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mannar_web/bloc/lawyer/lawyer_cubit.dart';
import 'package:mannar_web/repository/lawyer_repository.dart';
import '../../bloc/services/services_cubit.dart';
import '../../repository/services_repository.dart';
import '../home/home_screen.dart';
import '../../bloc/country/country_cubit.dart';
import '../../bloc/user/user_cubit.dart';
import '../../repository/countries_repository.dart';
import '../../repository/user_repository.dart';
import '../../repository/web_services.dart';
import '../../screens/profile/complete_profile_screen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/size_config.dart';
import '../../constants/styles.dart';
import '../../widgets/buttons/basic_button.dart';

class Otp extends StatefulWidget {
  final phoneNumber;
  final String email;
  final String password;
  Otp(this.phoneNumber, this.email, this.password);

  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  TextEditingController _otpController = TextEditingController();
  late SharedPreferences _pref;
  late bool _isActive;
  var _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<UserCubit>(context);
    Future.delayed(Duration(seconds: 0)).then((_) async {
      _pref = await SharedPreferences.getInstance();
    });
    _isActive = true;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    // ignore: unused_local_variable
    String otp;

    return SafeArea(
        top: false,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Row(
              children: [
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Material(
                      elevation: 20,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'ادخل كود التفعيل',
                              style: TextStyles.h2Bold,
                            ),
                            SizedBox(
                              height: SizeConfig.screenHeight * 0.02,
                            ),
                            Text(
                              'ادخل الكود المرسل علي رقم جوالك',
                              style: TextStyles.h2,
                            ),
                            SizedBox(
                              height: SizeConfig.screenHeight * 0.02,
                            ),
                            Text(
                              'ادخل الكود التفعيل',
                              style: TextStyles.h2Bold,
                            ),
                            SizedBox(
                              height: SizeConfig.screenHeight * 0.04,
                            ),
                            SizedBox(
                              width: SizeConfig.screenWidth * 0.4,
                              child: Directionality(
                                textDirection: TextDirection.ltr,
                                child: PinCodeTextField(
                                  showCursor: true,
                                  appContext: context,
                                  controller: _otpController,
                                  autoDisposeControllers: false,
                                  cursorColor: Colors.grey[300],
                                  pastedTextStyle: TextStyles.h2Bold,
                                  length: 6,
                                  textStyle: TextStyles.h3,
                                  enabled: _isActive ? true : false,
                                  animationType: AnimationType.fade,
                                  enablePinAutofill: false,
                                  pinTheme: PinTheme(
                                    shape: PinCodeFieldShape.box,
                                    borderRadius: BorderRadius.circular(5),
                                    fieldHeight: 50,
                                    fieldWidth: 45,
                                    activeFillColor: Colors.black,
                                    activeColor: Colors.black,
                                    selectedColor: Colors.black,
                                    disabledColor: Colors.grey,
                                    inactiveFillColor: Colors.grey,
                                    inactiveColor: Colors.grey,
                                  ),
                                  backgroundColor: Theme.of(context).canvasColor.withOpacity(0.3),
                                  autoFocus: true,
                                  keyboardType: TextInputType.number,
                                  onChanged: (_) {
                                    otp = _otpController.text;
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.screenHeight * 0.15,
                            ),
                            SizedBox(
                              width: SizeConfig.screenWidth * 0.30,
                              height: SizeConfig.screenHeight * 0.08,
                              child: BasicButton(
                                buttonName: 'إرسال',
                                onPressedFunction: () async {
                                  await BlocProvider.of<UserCubit>(context)
                                      .verifiyOTP(_otpController.text, widget.email, widget.password)
                                      .then((value) {
                                    if (value == true) {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        useRootNavigator: true,
                                        useSafeArea: false,
                                        builder: (_) => BlocProvider(
                                          create: (context) => UserCubit(UserRepository(WebServices())),
                                          child: Dialog(
                                            backgroundColor: Colors.transparent,
                                            insetPadding: EdgeInsets.all(10),
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: <Widget>[
                                                Container(
                                                  width: SizeConfig.screenWidth * 0.35,
                                                  height: SizeConfig.screenHeight * 0.45,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(15), color: Colors.white),
                                                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          IconButton(
                                                            onPressed: () {
                                                              Navigator.of(context).pop();
                                                            },
                                                            icon: Icon(Icons.cancel),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: SizeConfig.screenHeight * 0.02,
                                                      ),
                                                      Icon(
                                                        Icons.shield_outlined,
                                                        color: Colors.amber,
                                                        size: 40,
                                                      ),
                                                      SizedBox(
                                                        height: SizeConfig.screenHeight * 0.02,
                                                      ),
                                                      Text(
                                                        'تآكيد برقم الهاتف',
                                                        style: TextStyles.h2,
                                                      ),
                                                      SizedBox(
                                                        height: SizeConfig.screenHeight * 0.02,
                                                      ),
                                                      SizedBox(
                                                        width: SizeConfig.screenWidth * 0.8,
                                                        child: Text(
                                                          'تم تفعيل الحساب الخاص بك بنجاح. يمكنك تصفح الابليكشن الآن و حجز الخدمات',
                                                          style: TextStyles.h3.copyWith(
                                                            color: Color(0xFF717171),
                                                          ),
                                                          textAlign: TextAlign.center,
                                                          textDirection: TextDirection.rtl,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: SizeConfig.screenHeight * 0.02,
                                                      ),
                                                      SizedBox(
                                                        width: SizeConfig.screenWidth * 0.85,
                                                        height: SizeConfig.screenHeight * 0.08,
                                                        child: BasicButton(
                                                          buttonName: 'أكمل الصفحة الشخصية',
                                                          onPressedFunction: () {
                                                            Navigator.of(context, rootNavigator: false).push(
                                                              MaterialPageRoute(
                                                                builder: (context) => MultiBlocProvider(
                                                                  providers: [
                                                                    BlocProvider(
                                                                      // lazy: false,
                                                                      create: (BuildContext context) =>
                                                                          UserCubit(UserRepository(WebServices())),
                                                                    ),
                                                                    BlocProvider(
                                                                      lazy: false,
                                                                      create: (BuildContext context) => CountryCubit(
                                                                          CountriesRepository(WebServices())),
                                                                    ),
                                                                  ],
                                                                  child: CompleteProfileScreen(
                                                                      _pref.getString('userToken')),
                                                                ),
                                                              ),
                                                            );
                                                            // Navigator.of(ctx).push(
                                                            //   MaterialPageRoute(
                                                            //     builder: (context) => CompleteProfileScreen(),
                                                            //   ),
                                                            // );
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );

                                      //   showModalBottomSheet(
                                      //       context: context,
                                      //       shape: RoundedRectangleBorder(
                                      //           borderRadius: BorderRadius.only(
                                      //         topLeft: Radius.circular(30),
                                      //         topRight: Radius.circular(30),
                                      //       )),
                                      //       builder: (ctx) {
                                      //         return Container(
                                      //           height: SizeConfig.screenHeight * 0.35,
                                      //           child: Column(
                                      //             children: [
                                      //               SizedBox(
                                      //                 height: SizeConfig.screenHeight * 0.02,
                                      //               ),
                                      //               Icon(
                                      //                 Icons.shield_outlined,
                                      //                 color: Colors.amber,
                                      //                 size: 40,
                                      //               ),
                                      //               SizedBox(
                                      //                 height: SizeConfig.screenHeight * 0.02,
                                      //               ),
                                      //               Text(
                                      //                 'تآكيد برقم الهاتف',
                                      //                 style: TextStyles.h2,
                                      //               ),
                                      //               SizedBox(
                                      //                 height: SizeConfig.screenHeight * 0.02,
                                      //               ),
                                      //               SizedBox(
                                      //                 width: SizeConfig.screenWidth * 0.8,
                                      //                 child: Text(
                                      //                   'تم تفعيل الحساب الخاص بك بنجاح. يمكنك تصفح الابليكشن الآن و حجز الخدمات',
                                      //                   style: TextStyles.h3.copyWith(
                                      //                     color: Color(0xFF717171),
                                      //                   ),
                                      //                   textAlign: TextAlign.center,
                                      //                   textDirection: TextDirection.rtl,
                                      //                 ),
                                      //               ),
                                      //               SizedBox(
                                      //                 height: SizeConfig.screenHeight * 0.02,
                                      //               ),
                                      //               SizedBox(
                                      //                 width: SizeConfig.screenWidth * 0.85,
                                      //                 height: SizeConfig.screenHeight * 0.08,
                                      //                 child: BasicButton(
                                      //                   buttonName: 'أكمل الصفحة الشخصية',
                                      //                   onPressedFunction: () {
                                      //                     Navigator.of(context, rootNavigator: false).push(
                                      //                       MaterialPageRoute(
                                      //                         builder: (context) => MultiBlocProvider(
                                      //                           providers: [
                                      //                             BlocProvider(
                                      //                               // lazy: false,
                                      //                               create: (BuildContext context) =>
                                      //                                   UserCubit(UserRepository(WebServices())),
                                      //                             ),
                                      //                             BlocProvider(
                                      //                               lazy: false,
                                      //                               create: (BuildContext context) =>
                                      //                                   CountryCubit(CountriesRepository(WebServices())),
                                      //                             ),
                                      //                           ],
                                      //                           child:
                                      //                               CompleteProfileScreen(_pref.getString('userToken')),
                                      //                         ),
                                      //                       ),
                                      //                     );
                                      //                     // Navigator.of(ctx).push(
                                      //                     //   MaterialPageRoute(
                                      //                     //     builder: (context) => CompleteProfileScreen(),
                                      //                     //   ),
                                      //                     // );
                                      //                   },
                                      //                 ),
                                      //               ),
                                      //             ],
                                      //           ),
                                      //         );
                                      //       });
                                    } else {
                                      Fluttertoast.showToast(
                                        msg: _pref.getString('errorOfOTP').toString(),
                                        gravity: ToastGravity.TOP,
                                        toastLength: Toast.LENGTH_LONG,
                                        timeInSecForIosWeb: 5,
                                      );
                                      return;
                                    }
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.screenHeight * 0.04,
                            ),
                            buildTimer(context),
                            SizedBox(
                              height: SizeConfig.screenHeight * 0.02,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Image.asset(
                          'assets/images/logo_text.png',
                          height: SizeConfig.screenHeight * 0.07,
                          width: SizeConfig.screenWidth * 0.2,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(
                          height: SizeConfig.screenHeight * 0.05,
                        ),
                        Text(
                          'أهلاً بك في موقع المنار',
                          style: TextStyles.h2Bold.copyWith(color: Colors.teal[800]),
                        ),
                        Text(
                            'لوريم ايبسوم هو نموذج افتراضي يوضع في التصاميم لتعرض على العميل ليتصور طريقه وضع النصوص بالتصاميم سواء كانت تصاميم مطبوعه ... بروشور او فلاير على سبيل المثال ... او نماذج مواقع انترنت ...',
                            style: TextStyles.h2),
                        SizedBox(
                          height: SizeConfig.screenHeight * 0.2,
                        ),
                        Center(
                          child: TextButton(
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
                              ' تخطي',
                              style: TextStyles.h4.copyWith(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Widget buildTimer(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: (_isActive)
                ? null
                : () async {
                    await BlocProvider.of<UserCubit>(context).resendingOTP(widget.phoneNumber).then((value) {
                      if (value == true) {
                        setState(() {
                          _isActive = true;
                          _otpController.clear();
                        });
                      }
                    });
                  },
            style: ButtonStyle(enableFeedback: true),
            child: Text(
              '  إعادة إرسال الرمز ؟',
              style: TextStyles.h3.copyWith(
                fontSize: 16,
                // color: Colors.black,
              ),
            ),
          ),
          TweenAnimationBuilder(
            tween: Tween(begin: 60.0, end: 0.0),
            duration: Duration(seconds: 60),
            key: _key,
            //TODO: Adding reset for counter
            builder: (_, double value, child) => Text(
              "  00:${value.toInt().toString()}",
              style: TextStyles.h3.copyWith(
                fontSize: 16,
                color: Colors.blueAccent,
              ),
            ),
            onEnd: () {
              setState(() {
                _isActive = false;
              });
            },
          ),
        ],
      ),
    );
  }
}
