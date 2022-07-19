import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mannar_web/bloc/lawyer/lawyer_cubit.dart';
import 'package:mannar_web/repository/lawyer_repository.dart';
import '../../bloc/services/services_cubit.dart';
import '../../repository/services_repository.dart';
import '../home/home_screen.dart';
import '../../bloc/service_provider/service_provider_cubit.dart';
import '../../repository/service_provider_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/size_config.dart';
import '../../constants/styles.dart';
import '../../screens/login/sign_in_screen.dart';
import '../../screens/login/otp.dart';
import '../../widgets/buttons/basic_button.dart';
import '../../widgets/textfields/basic_textfield.dart';
import '../../widgets/textfields/number_textfield.dart';
import '../../widgets/textfields/obscure_textfield.dart';
import '../../bloc/user/user_cubit.dart';
import '../../repository/user_repository.dart';
import '../../repository/web_services.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordController2 = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isAgree = false;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<UserCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

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
                      child: Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'إنشاء حساب',
                              style: TextStyles.h2Bold,
                            ),
                            SizedBox(
                              height: SizeConfig.screenHeight * 0.02,
                            ),
                            Text(
                              'سجل الدخول حتي تستطيع ان تتصفح الموقع',
                              style: TextStyles.h2,
                            ),
                            SizedBox(
                              height: SizeConfig.screenHeight * 0.02,
                            ),
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.transparent,
                              backgroundImage: AssetImage(
                                'assets/images/camera_icon.png',
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.screenHeight * 0.02,
                            ),
                            SizedBox(
                              width: SizeConfig.screenWidth * 0.30,
                              height: SizeConfig.screenHeight * 0.08,
                              child: BasicTextField(
                                ValueKey('name'),
                                fullNameController,
                                'الأسم بالكامل',
                                TextInputType.name,
                                (value) {
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.screenHeight * 0.02,
                            ),
                            SizedBox(
                              width: SizeConfig.screenWidth * 0.30,
                              height: SizeConfig.screenHeight * 0.08,
                              child: NumberTextField(
                                ValueKey('phoneNumber'),
                                phoneNumberController,
                                'رقم الجوال',
                                (value) {
                                  return null;
                                  // if (value!.isEmpty) {
                                  //   return 'برجاء ادخل رقم الهاتف';
                                  // } else if (!RegExp().hasMatch(value)) {
                                  //   return 'رقم الهاتف الذي ادخلته غير صحيح';
                                  // }
                                  // return null;
                                },
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.screenHeight * 0.02,
                            ),
                            SizedBox(
                              width: SizeConfig.screenWidth * 0.30,
                              height: SizeConfig.screenHeight * 0.08,
                              child: BasicTextField(
                                ValueKey('email'),
                                emailController,
                                'البريد الإلكتروني',
                                TextInputType.emailAddress,
                                (value) {
                                  return null;
                                  // if (value!.isEmpty) {
                                  //   return 'البريد الالكتروني الذي قمت بادخاله غير صحيح';
                                  // } else if (!RegExp('^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]').hasMatch(value)) {
                                  //   return 'البريد الالكتروني الذي قمت بادخاله غير صحيح';
                                  // }
                                  // return null;
                                },
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.screenHeight * 0.02,
                            ),
                            SizedBox(
                              width: SizeConfig.screenWidth * 0.30,
                              height: SizeConfig.screenHeight * 0.08,
                              child: ObscureTextField(
                                ValueKey('password1'),
                                passwordController,
                                'كلمة المرور',
                                (value) {
                                  return null;
                                  // if (value!.isEmpty) {
                                  //   return 'Please enter some text';
                                  // } else if (value.length < 8) {
                                  //   return 'Password is not less than 8 characters';
                                  // } else if (!RegExp('^[a-zA-Z0-9]').hasMatch(value)) {
                                  //   return 'Enter Valid Email';
                                  // }
                                  // return null;
                                },
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.screenHeight * 0.02,
                            ),
                            SizedBox(
                              width: SizeConfig.screenWidth * 0.30,
                              height: SizeConfig.screenHeight * 0.08,
                              child: ObscureTextField(
                                ValueKey('password2'),
                                passwordController2,
                                'تأكيد كلمة المرور',
                                (value) {
                                  return null;
                                  // if (value!.isEmpty) {
                                  //   return 'Please enter some text';
                                  // } else if (value.length < 8) {
                                  //   return 'Password is not less than 8 characters';
                                  // } else if (!RegExp('^[a-zA-Z0-9]').hasMatch(value)) {
                                  //   return 'Enter Valid Email';
                                  // }
                                  // return null;
                                },
                              ),
                            ),
                            // SizedBox(
                            //   height: SizeConfig.screenHeight * 0.02,
                            // ),
                            Center(
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: SizedBox(
                                  // height: SizeConfig.screenHeight * 0.08,
                                  width: SizeConfig.screenWidth * 0.5,
                                  child: CheckboxListTile(
                                      value: _isAgree,
                                      dense: true,
                                      controlAffinity: ListTileControlAffinity.leading,
                                      title: Row(
                                        children: [
                                          Text(
                                            'أوافق علي',
                                            style: TextStyles.h3,
                                            textAlign: TextAlign.center,
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              launch('https://manar.alliedcon.net/agreement');
                                            },
                                            child: Text(
                                              'شروط وسياسية الأستخدام.',
                                              style: TextStyles.h3.copyWith(
                                                decoration: TextDecoration.underline,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          _isAgree = value!;
                                        });
                                      }),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: SizeConfig.screenWidth * 0.30,
                              height: SizeConfig.screenHeight * 0.08,
                              child: BasicButton(
                                buttonName: 'إنشاء حساب',
                                onPressedFunction: () async {
                                  if (passwordController.text == passwordController2.text) {
                                    if (_isAgree) {
                                      SharedPreferences _pref = await SharedPreferences.getInstance();
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
                                                        width: SizeConfig.screenWidth * 0.3,
                                                        child: Text(
                                                          'سوف يتم ارسال رقم تآكيد للهاتف الخاص بك لتأكيد الحساب الخاص بك علي ابليكشن المنار.',
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
                                                        height: SizeConfig.screenHeight * 0.08,
                                                        width: SizeConfig.screenWidth * 0.35,
                                                        child: BasicButton(
                                                            buttonName: 'إرسال',
                                                            onPressedFunction: () async {
                                                              await BlocProvider.of<UserCubit>(context)
                                                                  .registerUser(
                                                                      'image',
                                                                      fullNameController.text.trim(),
                                                                      emailController.text.trim(),
                                                                      phoneNumberController.text.trim(),
                                                                      passwordController.text.trim())
                                                                  .then((value) {
                                                                if (value == true) {
                                                                  Navigator.of(context).push(
                                                                    MaterialPageRoute(
                                                                      builder: (context) => BlocProvider(
                                                                        create: (context) =>
                                                                            UserCubit(UserRepository(WebServices())),
                                                                        child: Otp(
                                                                            phoneNumberController.text,
                                                                            emailController.text,
                                                                            passwordController.text),
                                                                      ),
                                                                    ),
                                                                  );
                                                                } else {
                                                                  Fluttertoast.showToast(
                                                                    msg: _pref.getString('errorOfReg').toString(),
                                                                    gravity: ToastGravity.TOP,
                                                                    toastLength: Toast.LENGTH_LONG,
                                                                    timeInSecForIosWeb: 5,
                                                                  );
                                                                }
                                                              });
                                                            }),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return;
                                    }
                                  } else {
                                    Fluttertoast.showToast(
                                      msg: 'تآكد من كلمة المرور مرة أخرى',
                                      gravity: ToastGravity.TOP,
                                      toastLength: Toast.LENGTH_LONG,
                                      timeInSecForIosWeb: 5,
                                    );
                                    return;
                                  }

                                  // _formKey.currentState!.validate();
                                  // if (_formKey.currentState!.validate()) {
                                  //   showModalBottomSheet(
                                  //     context: context,
                                  //     shape: RoundedRectangleBorder(
                                  //         borderRadius: BorderRadius.only(
                                  //       topLeft: Radius.circular(30),
                                  //       topRight: Radius.circular(30),
                                  //     )),
                                  //     builder: (ctx) {
                                  //       return Container(
                                  //         height: SizeConfig.screenHeight * 0.35,
                                  // child: Column(
                                  //   children: [
                                  //     SizedBox(
                                  //       height: SizeConfig.screenHeight * 0.02,
                                  //     ),
                                  //     Icon(
                                  //       Icons.shield_outlined,
                                  //       color: Colors.amber,
                                  //       size: 40,
                                  //     ),
                                  //     SizedBox(
                                  //       height: SizeConfig.screenHeight * 0.02,
                                  //     ),
                                  //     Text(
                                  //       'تآكيد برقم الهاتف',
                                  //       style: TextStyles.h2,
                                  //     ),
                                  //     SizedBox(
                                  //       height: SizeConfig.screenHeight * 0.02,
                                  //     ),
                                  //     SizedBox(
                                  //       width: SizeConfig.screenWidth * 0.8,
                                  //       child: Text(
                                  //         'سوف يتم ارسال رقم تآكيد للهاتف الخاص بك لتأكيد الحساب الخاص بك علي ابليكشن المنار.',
                                  //         style: TextStyles.h3.copyWith(
                                  //           color: Color(0xFF717171),
                                  //         ),
                                  //         textAlign: TextAlign.center,
                                  //         textDirection: TextDirection.rtl,
                                  //       ),
                                  //     ),
                                  //     SizedBox(
                                  //       height: SizeConfig.screenHeight * 0.02,
                                  //     ),
                                  //             SizedBox(
                                  //               width: SizeConfig.screenWidth * 0.30,
                                  //               height: SizeConfig.screenHeight * 0.08,
                                  //               child: BasicButton(
                                  //                 buttonName: 'إرسال',
                                  //                 onPressedFunction: () {
                                  //                   Navigator.of(ctx).pop();
                                  //                   Navigator.of(ctx).push(
                                  //                     MaterialPageRoute(
                                  //                       builder: (context) => Otp(phoneNumberController.text),
                                  //                     ),
                                  //                   );
                                  //                 },
                                  //               ),
                                  //             ),
                                  //           ],
                                  //         ),
                                  //       );
                                  //     },
                                  //   );
                                  // }
                                },
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.screenHeight * 0.01,
                            ),
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    ' هل لديك حساب بالفعل؟',
                                    style: TextStyles.h3,
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) => MultiBlocProvider(
                                            providers: [
                                              BlocProvider(
                                                create: (BuildContext context) =>
                                                    UserCubit(UserRepository(WebServices())),
                                              ),
                                              BlocProvider(
                                                create: (context) =>
                                                    ServiceProviderCubit(ServiceProviderRepository(WebServices())),
                                              ),
                                            ],
                                            child: SignInScreen(),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'تسجيل دخول',
                                      style: TextStyles.h4,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
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
      ),
    );
  }
}
