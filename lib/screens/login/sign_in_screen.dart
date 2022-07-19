import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mannar_web/bloc/lawyer/lawyer_cubit.dart';
import 'package:mannar_web/repository/lawyer_repository.dart';
import '../../screens/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../bloc/service_provider/service_provider_cubit.dart';
import '../../bloc/services/services_cubit.dart';
import '../../bloc/user/user_cubit.dart';
import '../../constants/size_config.dart';
import '../../constants/styles.dart';
import '../../repository/service_provider_repository.dart';
import '../../repository/services_repository.dart';
import '../../repository/user_repository.dart';
import '../../repository/web_services.dart';
import '../../screens/chat/lawyer_chats_page.dart';
import '../../screens/login/create_account.dart';
import '../../screens/profile/forget_password.dart';
import '../../widgets/buttons/basic_button.dart';
import '../../widgets/textfields/basic_textfield.dart';
import '../../widgets/textfields/obscure_textfield.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  late SharedPreferences _pref;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isUser = true;
  bool _isLawyer = false;

  @override
  void initState() {
    Future.delayed(Duration(seconds: 0)).then((_) async {
      _pref = await SharedPreferences.getInstance();
    });
    BlocProvider.of<UserCubit>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                          mainAxisAlignment: MainAxisAlignment.center,
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
                              height: SizeConfig.screenHeight * 0.2,
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
                                ValueKey('password'),
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
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => BlocProvider(
                                            create: (BuildContext context) => UserCubit(UserRepository(WebServices())),
                                            child: ForgetPassword(),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      ' هل نسيت كلمه المرور ؟',
                                      style: TextStyles.h4.copyWith(
                                        fontSize: 13,
                                        color: Color(0xffFF0000),
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.screenHeight * 0.15,
                            ),
                            SizedBox(
                              height: SizeConfig.screenHeight * 0.07,
                              width: SizeConfig.screenWidth * 0.5,
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      // height: SizeConfig.screenHeight * 0.08,
                                      width: SizeConfig.screenWidth * 0.15,
                                      child: CheckboxListTile(
                                          value: _isUser,
                                          dense: true,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          title: Text(
                                            'مستخدم خدمة',
                                            style: TextStyles.h3,
                                          ),
                                          onChanged: (value) {
                                            print(value.toString());
                                            setState(() {
                                              _isUser = value!;
                                              _isLawyer = !value;
                                            });
                                          }),
                                    ),
                                    SizedBox(
                                      // height: SizeConfig.screenHeight * 0.08,
                                      width: SizeConfig.screenWidth * 0.15,
                                      child: CheckboxListTile(
                                          value: _isLawyer,
                                          dense: true,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          title: Text(
                                            'مقدم خدمة',
                                            style: TextStyles.h3,
                                          ),
                                          onChanged: (value) {
                                            print(value.toString());
                                            setState(() {
                                              _isLawyer = value!;
                                              _isUser = !value;
                                            });
                                          }),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: SizeConfig.screenWidth * 0.30,
                              height: SizeConfig.screenHeight * 0.08,
                              child: BasicButton(
                                buttonName: 'تسجيل دخول',
                                onPressedFunction: () async {
                                  if (_isUser) {
                                    await BlocProvider.of<UserCubit>(context)
                                        .loginUser(
                                      emailController.text.trim(),
                                      passwordController.text.trim(),
                                    )
                                        .then((value) {
                                      if (value == true) {
                                        if (_pref.getBool('isLoggedIn')!) {
                                          Navigator.of(context).push(
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
                                          );
                                        }
                                      } else {
                                        Fluttertoast.showToast(
                                          msg: _pref.getString('errorOfLogin').toString(),
                                          gravity: ToastGravity.TOP,
                                          toastLength: Toast.LENGTH_LONG,
                                          timeInSecForIosWeb: 5,
                                        );
                                      }
                                    });
                                  } else {
                                    await BlocProvider.of<ServiceProviderCubit>(context)
                                        .serviceProviderLogin(
                                      emailController.text.trim(),
                                      passwordController.text.trim(),
                                    )
                                        .then(
                                      (value) {
                                        if (value == true) {
                                          if (_pref.getBool('isLoggedIn')!) {
                                            Navigator.of(context).push(MaterialPageRoute(
                                                builder: (context) => MultiBlocProvider(
                                                        providers: [
                                                          BlocProvider(
                                                            create: (context) =>
                                                                ServicesCubit(ServicesRepo(WebServices())),
                                                          ),
                                                          BlocProvider(
                                                            create: (context) => ServiceProviderCubit(
                                                                ServiceProviderRepository(WebServices())),
                                                          ),
                                                        ],
                                                        child: LawyerChatsPage(_pref.getString('lawyerId')!,
                                                            _pref.getString('lawyerToken')!))));
                                          }
                                        } else {
                                          Fluttertoast.showToast(
                                            msg: _pref.getString('errorOfLogin').toString(),
                                            gravity: ToastGravity.TOP,
                                            toastLength: Toast.LENGTH_LONG,
                                            timeInSecForIosWeb: 5,
                                          );
                                        }
                                      },
                                    );
                                  }
                                },
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) => BlocProvider(
                                              create: (BuildContext context) =>
                                                  UserCubit(UserRepository(WebServices())),
                                              child: CreateAccount()),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "انشاء حساب",
                                      style: TextStyles.h3.copyWith(
                                        fontSize: 13,
                                        color: Color(0xff03564C),
                                      ),
                                    )),
                                Text(
                                  "ليس لديك حساب بالفعل؟ ",
                                  style: TextStyles.h3,
                                )
                              ],
                            ),
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
      ),
    );
  }
}
