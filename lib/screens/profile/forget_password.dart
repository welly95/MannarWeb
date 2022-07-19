// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mannar_web/bloc/lawyer/lawyer_cubit.dart';
import 'package:mannar_web/bloc/services/services_cubit.dart';
import 'package:mannar_web/repository/lawyer_repository.dart';
import 'package:mannar_web/repository/services_repository.dart';
import 'package:mannar_web/repository/web_services.dart';
import 'package:mannar_web/screens/home/home_screen.dart';
import '../../bloc/user/user_cubit.dart';

import '../../constants/size_config.dart';
import '../../constants/styles.dart';
import '../../widgets/buttons/basic_button.dart';
import '../../widgets/textfields/number_textfield.dart';
import '../../widgets/textfields/obscure_textfield.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController passwordNewController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                          children: [
                            SizedBox(
                              height: SizeConfig.screenHeight * 0.04,
                              width: SizeConfig.screenWidth,
                            ),
                            Center(
                              child: Text(
                                'استعادة كلمة المرور',
                                style: TextStyles.h2Bold,
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.screenHeight * 0.04,
                            ),
                            Center(
                              child: Text(
                                'ادخل رقم الهاتف المسجل لدينا في المنار للإستشارات، وسوف يتم إرسال كود ليتم تعيين كلمة سر جديدة.',
                                style: TextStyles.h2,
                                overflow: TextOverflow.clip,
                                textAlign: TextAlign.center,
                                textDirection: TextDirection.rtl,
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
                              height: SizeConfig.screenHeight * 0.04,
                            ),
                            SizedBox(
                              width: SizeConfig.screenWidth * 0.30,
                              height: SizeConfig.screenHeight * 0.08,
                              child: BasicButton(
                                  buttonName: 'أرسل الكود',
                                  onPressedFunction: () async {
                                    if (phoneNumberController.text != null || phoneNumberController.text != '') {
                                      await BlocProvider.of<UserCubit>(context)
                                          .forgetPasswod('+966' + phoneNumberController.text, '');
                                    }
                                  }),
                            ),
                            SizedBox(
                              height: SizeConfig.screenHeight * 0.04,
                            ),
                            SizedBox(
                              width: SizeConfig.screenWidth * 0.30,
                              height: SizeConfig.screenHeight * 0.08,
                              child: NumberTextField(
                                ValueKey('otp'),
                                codeController,
                                'ادخل الكود',
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
                                ValueKey('passwordNew'),
                                passwordNewController,
                                ' كلمة المرور الجديدة',
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
                              height: SizeConfig.screenHeight * 0.15,
                            ),
                            SizedBox(
                              width: SizeConfig.screenWidth * 0.30,
                              height: SizeConfig.screenHeight * 0.08,
                              child: BasicButton(
                                buttonName: 'حفظ',
                                onPressedFunction: () {
                                  _formKey.currentState!.validate();
                                  if (_formKey.currentState!.validate()) {
                                    showModalBottomSheet(
                                      context: context,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30),
                                      )),
                                      builder: (ctx) {
                                        return Container(
                                          height: SizeConfig.screenHeight * 0.35,
                                          child: Column(
                                            children: [
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
                                                height: SizeConfig.screenHeight * 0.02,
                                              ),
                                              SizedBox(
                                                width: SizeConfig.screenWidth * 0.30,
                                                height: SizeConfig.screenHeight * 0.08,
                                                child: BasicButton(
                                                  buttonName: 'حفظ',
                                                  onPressedFunction: () async {
                                                    if ((codeController.text != null || codeController.text != '') &&
                                                        (passwordNewController.text != null ||
                                                            passwordNewController.text != '')) {
                                                      await BlocProvider.of<UserCubit>(context)
                                                          .resetPasswod(
                                                              codeController.text, passwordNewController.text, '')
                                                          .then((value) {
                                                        if (value == true) {
                                                          Navigator.of(context).pop();
                                                          Navigator.of(context).pop();
                                                        }
                                                      });
                                                    }
                                                    // Navigator.of(ctx, rootNavigator: true)
                                                    //     .push(MaterialPageRoute(builder: (context) => SignInScreen()));
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.screenHeight * 0.02,
                              child: Container(),
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
