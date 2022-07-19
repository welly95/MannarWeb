import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mannar_web/bloc/lawyer/lawyer_cubit.dart';
import 'package:mannar_web/bloc/services/services_cubit.dart';
import 'package:mannar_web/repository/lawyer_repository.dart';
import 'package:mannar_web/repository/services_repository.dart';
import 'package:mannar_web/screens/home/home_screen.dart';
import '../../bloc/country/country_cubit.dart';
import '../../models/countries.dart';
import '../../models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/size_config.dart';
import '../../constants/styles.dart';
import '../../bloc/user/user_cubit.dart';
import '../../repository/user_repository.dart';
import '../../repository/web_services.dart';
import '../../screens/profile/change_password.dart';
import '../../widgets/buttons/basic_button.dart';
import '../../widgets/textfields/basic_textfield.dart';

class CompleteProfileScreen extends StatefulWidget {
  final userToken;
  CompleteProfileScreen(this.userToken);
  @override
  _CompleteProfileScreenState createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController countryIdController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? userToken;
  User? userFromApi;
  late SharedPreferences _pref;
  late List<Countries> _countriesList;

  @override
  void initState() {
    Future.delayed(Duration(seconds: 0)).then((_) async {
      _pref = await SharedPreferences.getInstance();
      _countriesList = await BlocProvider.of<CountryCubit>(context).getCountriesList();
      userFromApi = await BlocProvider.of<UserCubit>(context).getProfileUser(widget.userToken);
      nameController.text = userFromApi!.name!.toString();
      emailController.text = userFromApi!.email!.toString();
      phoneNumberController.text = userFromApi!.phoneNumber!.toString();
      countryIdController.text = '';
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: SizeConfig.screenWidth * 0.55,
                height: SizeConfig.screenHeight * 0.65,
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.04),
                child: Column(
                  children: [
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.02,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "الصفحة الشخصية",
                            style: TextStyles.h2Bold.copyWith(fontSize: 24),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'اكمل الصفحة الشخصية الخاصة بك',
                      style: TextStyles.textFieldsHint,
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.02,
                    ),
                    BlocBuilder<UserCubit, UserState>(
                      builder: (context, state) {
                        return BlocBuilder<CountryCubit, CountryState>(
                          builder: (context, countryState) {
                            if (state is GetProfileUserState && countryState is GetCountriesListState) {
                              return Form(
                                key: _formKey,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: SizeConfig.screenWidth * 0.55,
                                      height: SizeConfig.screenHeight * 0.08,
                                      child: BasicTextField(
                                        ValueKey('name'),
                                        nameController,
                                        'الأسم',
                                        TextInputType.name,
                                        (value) {
                                          return null;
                                          // nameController.text = value!;
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: SizeConfig.screenHeight * 0.02,
                                    ),
                                    // SizedBox(
                                    //   width: SizeConfig.screenWidth * 0.55,
                                    //   child: DescriptionTextField(
                                    //     ValueKey('description'),
                                    //     descriptionController,
                                    //     'الوصف',
                                    //     TextInputType.text,
                                    //     (value) { return null;},
                                    //   ),
                                    // ),
                                    // SizedBox(
                                    //   height: SizeConfig.screenHeight * 0.02,
                                    // ),
                                    SizedBox(
                                      width: SizeConfig.screenWidth * 0.55,
                                      height: SizeConfig.screenHeight * 0.08,
                                      child: BasicTextField(
                                        ValueKey('email'),
                                        emailController,
                                        'البريد الإلكتروني',
                                        TextInputType.emailAddress,
                                        (value) {
                                          return null;
                                          // emailController.text = value!;
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: SizeConfig.screenHeight * 0.02,
                                    ),
                                    SizedBox(
                                      width: SizeConfig.screenWidth * 0.55,
                                      height: SizeConfig.screenHeight * 0.08,
                                      child: BasicTextField(
                                        ValueKey('age'),
                                        ageController,
                                        'ادخل عمرك',
                                        TextInputType.number,
                                        (value) {
                                          return null;
                                          // ageController.text = value!;
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: SizeConfig.screenHeight * 0.02,
                                    ),
                                    SizedBox(
                                      width: SizeConfig.screenWidth * 0.55,
                                      height: SizeConfig.screenHeight * 0.08,
                                      child: Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: DropdownButtonFormField(
                                          decoration: InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.grey, width: 1.0),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            disabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.grey, width: 1.0),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.grey, width: 1.0),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            fillColor: Colors.white70,
                                            filled: true,
                                            hintText: 'الجنسية',
                                            hintStyle: TextStyles.textFieldsHint,
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              countryIdController.text = value.toString();
                                            });
                                            print(countryIdController.text);
                                          },
                                          items: _countriesList
                                              .map(
                                                (countries) => DropdownMenuItem(
                                                  child: Text(
                                                    countries.nationality!,
                                                    style: TextStyles.textFieldsHint,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  value: countries.id!,
                                                ),
                                              )
                                              .toList(),
                                        ),
                                      ),
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
                                            'هل تريد تغيير كلمة المرور؟',
                                            style: TextStyles.h3,
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) => BlocProvider(
                                                    create: (BuildContext context) =>
                                                        UserCubit(UserRepository(WebServices())),
                                                    child: ChangePassword(),
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              'تغيير كلمة المرور',
                                              style: TextStyles.h4,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: SizeConfig.screenWidth * 0.55,
                                      height: SizeConfig.screenHeight * 0.08,
                                      child: BasicButton(
                                        buttonName: 'حفظ',
                                        onPressedFunction: () async {
                                          await BlocProvider.of<UserCubit>(context)
                                              .completeProfile(
                                                  '',
                                                  nameController.text,
                                                  emailController.text,
                                                  phoneNumberController.text,
                                                  ageController.text.toString(),
                                                  countryIdController.text,
                                                  widget.userToken)
                                              .then((value) {
                                            if (value == true) {
                                              Fluttertoast.showToast(
                                                msg: 'Your Informations Saved Successfully',
                                                gravity: ToastGravity.TOP,
                                                toastLength: Toast.LENGTH_LONG,
                                                timeInSecForIosWeb: 5,
                                              );
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
                                                  (Route<dynamic> route) => false);
                                            } else {
                                              Fluttertoast.showToast(
                                                msg: _pref.getString('errorOfCompleteProfile').toString(),
                                                gravity: ToastGravity.TOP,
                                                toastLength: Toast.LENGTH_LONG,
                                                timeInSecForIosWeb: 5,
                                              );
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: SizeConfig.screenHeight * 0.02,
                                    ),
                                  ],
                                ),
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
                        );
                      },
                    ),
                  ],
                ),
              ),
              //   SizedBox(
              //     height: SizeConfig.screenHeight * 0.1,
              //   ),
              //   Stack(
              //     children: [
              //       Container(
              //         height: SizeConfig.screenHeight * 0.4,
              //         width: SizeConfig.screenWidth,
              //         decoration: BoxDecoration(
              //           image: DecorationImage(
              //             image: AssetImage(
              //               'assets/images/background.jpg',
              //             ),
              //             fit: BoxFit.cover,
              //           ),
              //         ),
              //       ),
              //       Container(
              //         height: SizeConfig.screenHeight * 0.4,
              //         width: SizeConfig.screenWidth,
              //         decoration: BoxDecoration(
              //           color: Colors.black.withOpacity(0.3),
              //         ),
              //       ),
              //       Column(
              //         children: [
              //           SizedBox(
              //             height: SizeConfig.screenHeight * 0.08,
              //           ),
              //           Row(
              //             // mainAxisAlignment: MainAxisAlignment.end,
              //             children: [
              //               Container(
              //                 height: SizeConfig.screenHeight * 0.28,
              //                 width: SizeConfig.screenWidth * 0.3,
              //                 child: Column(
              //                   crossAxisAlignment: CrossAxisAlignment.end,
              //                   children: [
              //                     Text(
              //                       'تواصل',
              //                       style: TextStyles.h2.copyWith(color: Colors.white),
              //                     ),
              //                     Text(
              //                       widget._aboutUsModel.email!,
              //                       style: TextStyles.h2.copyWith(color: Colors.white),
              //                     ),
              //                     Row(
              //                       mainAxisAlignment: MainAxisAlignment.end,
              //                       children: [
              //                         Text(
              //                           widget._aboutUsModel.whatsapp!,
              //                           style: TextStyles.h2.copyWith(color: Colors.white),
              //                         ),
              //                         SizedBox(
              //                           width: 5,
              //                         ),
              //                         Icon(
              //                           FontAwesomeIcons.whatsapp,
              //                           color: Colors.green,
              //                         ),
              //                       ],
              //                     ),
              //                     SizedBox(
              //                       height: SizeConfig.screenHeight * 0.02,
              //                     ),
              //                     Divider(
              //                       color: Colors.grey,
              //                       indent: SizeConfig.screenWidth * 0.2,
              //                       // endIndent: SizeConfig.screenWidth * 0.05,
              //                     ),
              //                     Text(
              //                       'تواصل معنا',
              //                       style: TextStyles.h2.copyWith(color: Colors.white),
              //                     ),
              //                     Align(
              //                       alignment: Alignment.center,
              //                       child: Row(
              //                         mainAxisAlignment: MainAxisAlignment.end,
              //                         children: [
              //                           CircleAvatar(
              //                             backgroundColor: Colors.white,
              //                             child: IconButton(
              //                               onPressed: () {},
              //                               icon: Icon(
              //                                 FontAwesomeIcons.facebookF,
              //                                 color: Colors.teal,
              //                               ),
              //                             ),
              //                           ),
              //                           SizedBox(width: SizeConfig.screenWidth * 0.01),
              //                           CircleAvatar(
              //                             backgroundColor: Colors.white,
              //                             child: IconButton(
              //                               onPressed: () {},
              //                               icon: Icon(
              //                                 FontAwesomeIcons.twitter,
              //                                 color: Colors.teal,
              //                               ),
              //                             ),
              //                           ),
              //                           SizedBox(width: SizeConfig.screenWidth * 0.01),
              //                           CircleAvatar(
              //                             backgroundColor: Colors.white,
              //                             child: IconButton(
              //                               onPressed: () {},
              //                               icon: Icon(
              //                                 FontAwesomeIcons.linkedinIn,
              //                                 color: Colors.teal,
              //                               ),
              //                             ),
              //                           ),
              //                           SizedBox(width: SizeConfig.screenWidth * 0.01),
              //                         ],
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ],
              //       ),
              //       Positioned(
              //         bottom: 0,
              //         child: Container(
              //           padding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.04),
              //           height: SizeConfig.screenHeight * 0.06,
              //           width: SizeConfig.screenWidth,
              //           decoration: BoxDecoration(color: Colors.grey.withOpacity(0.6)),
              //           child: Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             children: [
              //               Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //                 children: [
              //                   TextButton(
              //                     onPressed: () {
              //                       Navigator.of(context).push(
              //                         MaterialPageRoute(
              //                           builder: (context) => MultiBlocProvider(
              //                             providers: [
              //                               BlocProvider(
              //                                 create: (context) => ServicesCubit(
              //                                   ServicesRepo(
              //                                     WebServices(),
              //                                   ),
              //                                 ),
              //                               ),
              //                               BlocProvider(
              //                                 create: (context) => UserCubit(
              //                                   UserRepository(
              //                                     WebServices(),
              //                                   ),
              //                                 ),
              //                               ),
              //                             ],
              //                             child: ContactUs(),
              //                           ),
              //                         ),
              //                       );
              //                     },
              //                     child: Text(
              //                       'تواصل معنا',
              //                       style: TextStyles.textFieldsHint.copyWith(color: Colors.white),
              //                     ),
              //                   ),
              //                   SizedBox(
              //                     width: SizeConfig.screenWidth * 0.04,
              //                   ),
              //                   TextButton(
              //                     onPressed: () {
              //                       Navigator.of(context).push(
              //                         MaterialPageRoute(
              //                           builder: (context) => BlocProvider(
              //                             create: (context) => ServicesCubit(ServicesRepo(WebServices())),
              //                             child: AboutUs(),
              //                           ),
              //                         ),
              //                       );
              //                     },
              //                     child: Text(
              //                       'عن المنار',
              //                       style: TextStyles.textFieldsHint.copyWith(color: Colors.white),
              //                     ),
              //                   ),
              //                   SizedBox(
              //                     width: SizeConfig.screenWidth * 0.04,
              //                   ),
              //                   TextButton(
              //                     onPressed: null,
              //                     //   Navigator.of(context).push(
              //                     //     MaterialPageRoute(
              //                     //       builder: (context) => ChatsPage(),
              //                     //     ),
              //                     //   );
              //                     // },
              //                     child: Text(
              //                       'الدردشات',
              //                       style: TextStyles.textFieldsHint.copyWith(color: Colors.white),
              //                     ),
              //                   ),
              //                   SizedBox(
              //                     width: SizeConfig.screenWidth * 0.04,
              //                   ),
              //                   TextButton(
              //                     onPressed: null,
              //                     //   Navigator.of(context).push(
              //                     //     MaterialPageRoute(
              //                     //       builder: (context) => MultiBlocProvider(
              //                     //         providers: [
              //                     //           BlocProvider(
              //                     //             lazy: false,
              //                     //             create: (BuildContext context) => ServicesCubit(
              //                     //               ServicesRepo(WebServices()),
              //                     //             ),
              //                     //           ),
              //                     //           BlocProvider(
              //                     //             lazy: false,
              //                     //             create: (BuildContext context) => LawyerCubit(
              //                     //               LawyerRepository(WebServices()),
              //                     //             ),
              //                     //           ),
              //                     //         ],
              //                     //         child: SearchLawyer(widget._filterData, widget._lawyersList),
              //                     //       ),
              //                     //     ),
              //                     //   );
              //                     // },
              //                     child: Text(
              //                       'المحاميين',
              //                       style: TextStyles.textFieldsHint.copyWith(color: Colors.white),
              //                     ),
              //                   ),
              //                   SizedBox(
              //                     width: SizeConfig.screenWidth * 0.04,
              //                   ),
              //                   TextButton(
              //                     onPressed: () {
              //                       Navigator.of(context).pushAndRemoveUntil(
              //                           MaterialPageRoute(
              //                             builder: (context) => MultiBlocProvider(
              //                               providers: [
              //                                 BlocProvider(
              //                                   create: (BuildContext context) => LawyerCubit(
              //                                     LawyerRepository(
              //                                       WebServices(),
              //                                     ),
              //                                   ),
              //                                 ),
              //                                 BlocProvider(
              //                                   lazy: false,
              //                                   create: (BuildContext context) => ServicesCubit(
              //                                     ServicesRepo(
              //                                       WebServices(),
              //                                     ),
              //                                   ),
              //                                 ),
              //                               ],
              //                               child: HomeScreen(),
              //                             ),
              //                           ),
              //                           (route) => false);
              //                     },
              //                     child: Text(
              //                       'الرئيسية',
              //                       style: TextStyles.textFieldsHint.copyWith(color: Colors.white),
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //               Text(
              //                 'جميع الحقوق محفوظة لمنار 2021',
              //                 style: TextStyles.textFieldsHint.copyWith(color: Colors.white),
              //               )
              //             ],
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
            ],
          ),
        ),
      ),
    );
  }
}
