import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mannar_web/bloc/lawyer/lawyer_cubit.dart';
import 'package:mannar_web/repository/lawyer_repository.dart';
import '../../bloc/services/services_cubit.dart';
import '../../repository/services_repository.dart';
import '../../screens/home/home_screen.dart';
import '../../repository/user_repository.dart';
import '../../repository/web_services.dart';
import '../login/sign_in_screen.dart';
import 'forget_password.dart';
import '../../bloc/user/user_cubit.dart';

import '../../constants/size_config.dart';
import '../../constants/styles.dart';
import '../../widgets/buttons/basic_button.dart';
import '../../widgets/textfields/obscure_textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController passwordOldController = TextEditingController();
  TextEditingController passwordNew1Controller = TextEditingController();
  TextEditingController passwordNew2Controller = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late SharedPreferences _pref;
  String? userToken;

  @override
  void initState() {
    BlocProvider.of<UserCubit>(context);
    Future.delayed(Duration(seconds: 0)).then((_) async {
      _pref = await SharedPreferences.getInstance();
      setState(() {
        userToken = _pref.getString('userToken');
        print('User Token is ---->' + userToken!);
      });
      BlocProvider.of<UserCubit>(context).getProfileUser(userToken!);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      top: false,
      child: Scaffold(
        body: Row(
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
                        children: [
                          Text(
                            'تغيير كلمة المرور',
                            style: TextStyles.h2Bold,
                          ),
                          SizedBox(
                            height: SizeConfig.screenHeight * 0.1,
                          ),
                          SizedBox(
                            width: SizeConfig.screenWidth * 0.30,
                            height: SizeConfig.screenHeight * 0.08,
                            child: ObscureTextField(
                              ValueKey('passwordOld'),
                              passwordOldController,
                              'كلمة المرور القديمة',
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
                            height: SizeConfig.screenHeight * 0.04,
                          ),
                          SizedBox(
                            width: SizeConfig.screenWidth * 0.30,
                            height: SizeConfig.screenHeight * 0.08,
                            child: ObscureTextField(
                              ValueKey('passwordNew1'),
                              passwordNew1Controller,
                              'كلمة المرور الجديدة',
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
                            height: SizeConfig.screenHeight * 0.04,
                          ),
                          SizedBox(
                            width: SizeConfig.screenWidth * 0.30,
                            height: SizeConfig.screenHeight * 0.08,
                            child: ObscureTextField(
                              ValueKey('passwordNew2'),
                              passwordNew2Controller,
                              'تأكيد كلمة المرور الجديدة',
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
                          Expanded(
                            child: Container(),
                          ),
                          SizedBox(
                            width: SizeConfig.screenWidth * 0.30,
                            height: SizeConfig.screenHeight * 0.08,
                            child: BasicButton(
                              buttonName: 'حفظ',
                              onPressedFunction: () {
                                _formKey.currentState!.validate();
                                if (_formKey.currentState!.validate() &&
                                    passwordNew1Controller.text.trim() == passwordNew2Controller.text.trim()) {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    useRootNavigator: true,
                                    useSafeArea: false,
                                    builder: (ctx) => BlocProvider(
                                      create: (context) => UserCubit(UserRepository(WebServices())),
                                      child: Dialog(
                                        backgroundColor: Colors.transparent,
                                        insetPadding: EdgeInsets.all(10),
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: <Widget>[
                                            Container(
                                              width: SizeConfig.screenWidth * 0.35,
                                              height: SizeConfig.screenHeight * 0.42,
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
                                                    'حفظ كلمة المرور!',
                                                    style: TextStyles.h2,
                                                    textDirection: TextDirection.rtl,
                                                  ),
                                                  SizedBox(
                                                    height: SizeConfig.screenHeight * 0.02,
                                                  ),
                                                  SizedBox(
                                                    width: SizeConfig.screenWidth * 0.8,
                                                    child: Text(
                                                      'اذا تم حفظ كلمة المرور الجديدة سوف يتم تسجيل الدخول مرة أخري، برجاء تأكيد الحفظ ',
                                                      style: TextStyles.h3.copyWith(
                                                        color: Color(0xFF717171),
                                                      ),
                                                      textAlign: TextAlign.center,
                                                      textDirection: TextDirection.rtl,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: SizeConfig.screenHeight * 0.03,
                                                  ),
                                                  SizedBox(
                                                    width: SizeConfig.screenWidth * 0.30,
                                                    height: SizeConfig.screenHeight * 0.08,
                                                    child: BasicButton(
                                                      buttonName: 'حفظ',
                                                      onPressedFunction: () async {
                                                        await BlocProvider.of<UserCubit>(context)
                                                            .changePassword(
                                                          passwordOldController.text.trim(),
                                                          passwordNew1Controller.text.trim(),
                                                          userToken!,
                                                        )
                                                            .then((value) {
                                                          print('--------->>>' + value.toString());
                                                          if (value == true) {
                                                            print(value.toString());
                                                            Navigator.of(context, rootNavigator: true).push(
                                                              MaterialPageRoute(
                                                                builder: (context) => BlocProvider(
                                                                  create: (context) =>
                                                                      UserCubit(UserRepository(WebServices())),
                                                                  child: SignInScreen(),
                                                                ),
                                                              ),
                                                            );
                                                            Fluttertoast.showToast(
                                                              msg: 'Your Password Changed Successfully',
                                                              gravity: ToastGravity.TOP,
                                                              toastLength: Toast.LENGTH_LONG,
                                                              timeInSecForIosWeb: 5,
                                                            );
                                                          } else {
                                                            print(value.toString());
                                                            Navigator.of(ctx).pop();

                                                            Fluttertoast.showToast(
                                                              msg: _pref.getString('errorOfChangePassword').toString(),
                                                              gravity: ToastGravity.TOP,
                                                              toastLength: Toast.LENGTH_LONG,
                                                              timeInSecForIosWeb: 5,
                                                            );
                                                            return;
                                                          }
                                                        });

                                                        // Navigator.of(ctx, rootNavigator: true)
                                                        //     .push(MaterialPageRoute(builder: (context) => SignInScreen()));
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
                                } else {
                                  Fluttertoast.showToast(
                                    msg: 'Your New Passwords doesn\'t match!',
                                    gravity: ToastGravity.TOP,
                                    toastLength: Toast.LENGTH_LONG,
                                    timeInSecForIosWeb: 5,
                                  );
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            height: SizeConfig.screenHeight * 0.02,
                          ),
                          SizedBox(
                            height: SizeConfig.screenHeight * 0.02,
                          ),
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'لا تتذكر كلمة المرور القديمة ',
                                  style: TextStyles.textFieldsLabels,
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => ForgetPassword()),
                                    );
                                  },
                                  child: Text(
                                    'استعادة كلمة المرور؟',
                                    style: TextStyles.textFieldsHint,
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
    );
  }
}
