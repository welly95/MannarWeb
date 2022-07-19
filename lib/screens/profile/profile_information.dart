// ignore_for_file: body_might_complete_normally_nullable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mannar_web/screens/chat/quick_chat_messages_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../bloc/country/country_cubit.dart';
import '../../bloc/user/user_cubit.dart';
import '../../constants/styles.dart';
import '../../models/countries.dart';
import '../../repository/user_repository.dart';
import '../../repository/web_services.dart';
import '../../screens/chat/tech_support.dart';
import '../../screens/profile/change_password.dart';
import '../../widgets/textfields/basic_textfield.dart';
import '../../widgets/textfields/number_textfield.dart';
import '../../constants/size_config.dart';
import '../../bloc/booking/booking_cubit.dart';
import '../../bloc/lawyer/lawyer_cubit.dart';
import '../../bloc/service_provider/service_provider_cubit.dart';
import '../../bloc/services/services_cubit.dart';
import '../../models/aboutUsModel.dart';
import '../../models/filter_data.dart';
import '../../models/lawyers.dart';
import '../../repository/booking_repository.dart';
import '../../repository/countries_repository.dart';
import '../../repository/lawyer_repository.dart';
import '../../repository/service_provider_repository.dart';
import '../../repository/services_repository.dart';
import '../../screens/QNA/qna_screen.dart';
import '../../screens/RatingScreen/rating_screen.dart';
import '../../screens/aboutUs/about_us.dart';
import '../../screens/allServices/all_services_screen.dart';
import '../../screens/chat/chats_page.dart';
import '../../screens/contactUS/contact_us.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/lawyer/search_lawyer.dart';
import '../../screens/login/create_account.dart';
import '../../screens/notification/notification.dart';
import '../../widgets/buttons/basic_button.dart';

class ProfileInfromation extends StatefulWidget {
  final bool initEdit;
  final AboutUsModel _aboutUsModel;
  final FilterData _filterData;
  final List<Lawyer> _lawyersList;
  ProfileInfromation(this.initEdit, this._aboutUsModel, this._filterData, this._lawyersList);

  @override
  _ProfileInfromationState createState() => _ProfileInfromationState();
}

class _ProfileInfromationState extends State<ProfileInfromation> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _canEdit = false;
  bool _letterVisible = false;
  bool status = false;
  late SharedPreferences _pref;
  String? userToken;
  // String? lawyerToken;
  late List<Countries> _countriesList;
  @override
  void initState() {
    Future.delayed(Duration(seconds: 0)).then((_) async {
      if (widget.initEdit == true) {
        timer();
      } else {
        _pref = await SharedPreferences.getInstance();
        // if (_pref.getBool('isUser')!) {
        setState(() {
          userToken = _pref.getString('userToken');
          print('User Token is ---->' + userToken!);
        });
        BlocProvider.of<UserCubit>(context).getProfileUser(userToken!);
        // } else {
        //   setState(() {
        //     lawyerToken = _pref.getString('lawyerToken');
        //     print('Lawyer Token is ---->' + lawyerToken!);
        //   });
        //   BlocProvider.of<ServiceProviderCubit>(context).getServiceProviderProfile(lawyerToken!);
        // }
        BlocProvider.of<CountryCubit>(context).getCountriesList();
      }
    });
    super.initState();
  }

  timer() async {
    await Future.delayed(Duration(seconds: 0));
    setState(() {
      _letterVisible = true;
    });
    await Future.delayed(Duration(seconds: 5));
    setState(() {
      _letterVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double square = SizeConfig.screenWidth * 0.13;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                height: SizeConfig.screenHeight * 0.06,
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.04),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.call_outlined,
                          color: Colors.teal,
                        ),
                        SizedBox(
                          width: SizeConfig.screenWidth * 0.005,
                        ),
                        Text(
                          widget._aboutUsModel.phone!,
                          style: TextStyles.textFieldsHint,
                        ),
                        SizedBox(
                          width: SizeConfig.screenWidth * 0.01,
                        ),
                        VerticalDivider(
                          color: Colors.grey,
                          endIndent: 10,
                          indent: 10,
                        ),
                        Icon(
                          FontAwesomeIcons.envelope,
                          color: Colors.teal,
                        ),
                        SizedBox(
                          width: SizeConfig.screenWidth * 0.005,
                        ),
                        Text(
                          widget._aboutUsModel.email!,
                          style: TextStyles.textFieldsHint,
                        ),
                        SizedBox(
                          width: SizeConfig.screenWidth * 0.02,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            launch(widget._aboutUsModel.facebook!);
                          },
                          icon: Icon(
                            FontAwesomeIcons.facebookF,
                            color: Colors.teal,
                          ),
                        ),
                        SizedBox(width: SizeConfig.screenWidth * 0.01),
                        IconButton(
                          onPressed: () {
                            launch(widget._aboutUsModel.twitter!);
                          },
                          icon: Icon(
                            FontAwesomeIcons.twitter,
                            color: Colors.teal,
                          ),
                        ),
                        SizedBox(width: SizeConfig.screenWidth * 0.01),
                        IconButton(
                          onPressed: () {
                            launch(widget._aboutUsModel.linkedIn!);
                          },
                          icon: Icon(
                            FontAwesomeIcons.linkedinIn,
                            color: Colors.teal,
                          ),
                        ),
                        SizedBox(width: SizeConfig.screenWidth * 0.01),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.04),
                height: SizeConfig.screenHeight * 0.1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: null,
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (context) => MultiBlocProvider(
                          //       providers: [
                          //         BlocProvider(
                          //           // lazy: false,
                          //           create: (BuildContext context) =>
                          //               UserCubit(UserRepository(WebServices())),
                          //         ),
                          //         BlocProvider(
                          //           lazy: false,
                          //           create: (BuildContext context) =>
                          //               CountryCubit(CountriesRepository(WebServices())),
                          //         ),
                          //         BlocProvider(
                          //           // lazy: false,
                          //           create: (BuildContext context) =>
                          //               ServiceProviderCubit(ServiceProviderRepository(WebServices())),
                          //         ),
                          //       ],
                          //       child: ProfileInfromation(false),
                          //     ),
                          //   ),
                          // );
                          // },
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            backgroundImage: AssetImage('assets/images/profile_icon.jpg'),
                            radius: 25,
                          ),
                        ),
                        SizedBox(
                          width: SizeConfig.screenWidth * 0.04,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => MultiBlocProvider(
                                  providers: [
                                    BlocProvider(
                                      create: (context) => ServicesCubit(
                                        ServicesRepo(
                                          WebServices(),
                                        ),
                                      ),
                                    ),
                                    BlocProvider(
                                      create: (context) => UserCubit(
                                        UserRepository(
                                          WebServices(),
                                        ),
                                      ),
                                    ),
                                  ],
                                  child: ContactUs(widget._lawyersList, widget._filterData, widget._aboutUsModel),
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'تواصل معنا',
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
                                builder: (context) => BlocProvider(
                                  create: (context) => ServicesCubit(ServicesRepo(WebServices())),
                                  child: AboutUs(widget._lawyersList, widget._filterData, widget._aboutUsModel),
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'عن المنار',
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
                                builder: (context) =>
                                    ChatsPage(widget._aboutUsModel, widget._filterData, widget._lawyersList),
                              ),
                            );
                          },
                          child: Text(
                            'الدردشات',
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
                                builder: (context) => MultiBlocProvider(
                                  providers: [
                                    BlocProvider(
                                      lazy: false,
                                      create: (BuildContext context) => ServicesCubit(
                                        ServicesRepo(WebServices()),
                                      ),
                                    ),
                                    BlocProvider(
                                      lazy: false,
                                      create: (BuildContext context) => LawyerCubit(
                                        LawyerRepository(WebServices()),
                                      ),
                                    ),
                                  ],
                                  child: SearchLawyer(widget._filterData, widget._lawyersList, widget._aboutUsModel),
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'المحاميين',
                            style: TextStyles.textFieldsHint,
                          ),
                        ),
                        SizedBox(
                          width: SizeConfig.screenWidth * 0.04,
                        ),
                        TextButton(
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
                            'الرئيسية',
                            style: TextStyles.textFieldsHint.copyWith(color: Colors.teal),
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
              SizedBox(
                height: SizeConfig.screenHeight * 0.02,
                width: SizeConfig.screenWidth,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.04),
                child: BlocBuilder<UserCubit, UserState>(
                  builder: (context2, state) {
                    return BlocBuilder<CountryCubit, CountryState>(
                      builder: (context2, countryState) {
                        if (state is GetProfileUserState && countryState is GetCountriesListState ||
                            state is GetProfileUserState &&
                                countryState is GetCountriesListState &&
                                state is EditProfileState) {
                          _countriesList = (countryState).countries;
                          return Column(
                            children: [
                              (_canEdit)
                                  ? Form(
                                      key: _formKey,
                                      child: Column(
                                        // mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              InkWell(
                                                onTap: () async {
                                                  print('I\'m Form' + _canEdit.toString());
                                                  if (_canEdit == true) {
                                                    await BlocProvider.of<UserCubit>(context2)
                                                        .editProfile(
                                                      '',
                                                      nameController.text.trim(),
                                                      emailController.text.trim(),
                                                      phoneNumberController.text.trim(),
                                                      userToken!,
                                                    )
                                                        .then((value) {
                                                      if (value == true) {
                                                        Fluttertoast.showToast(
                                                          msg: 'Your Informations Changed Successfully',
                                                          gravity: ToastGravity.TOP,
                                                          toastLength: Toast.LENGTH_LONG,
                                                          timeInSecForIosWeb: 5,
                                                        );
                                                        Navigator.of(context).pushReplacement(
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
                                                                  create: (BuildContext context) =>
                                                                      CountryCubit(CountriesRepository(WebServices())),
                                                                ),
                                                                BlocProvider(
                                                                  // lazy: false,
                                                                  create: (BuildContext context) =>
                                                                      ServiceProviderCubit(
                                                                          ServiceProviderRepository(WebServices())),
                                                                ),
                                                                BlocProvider(
                                                                    create: (context) =>
                                                                        ServicesCubit(ServicesRepo(WebServices()))),
                                                              ],
                                                              child: ProfileInfromation(
                                                                false,
                                                                widget._aboutUsModel,
                                                                widget._filterData,
                                                                widget._lawyersList,
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      } else if (value == false) {
                                                        Fluttertoast.showToast(
                                                          msg: _pref.getString('errorOfEditProfile').toString(),
                                                          gravity: ToastGravity.TOP,
                                                          toastLength: Toast.LENGTH_LONG,
                                                          timeInSecForIosWeb: 5,
                                                        );
                                                        return;
                                                      }
                                                    });
                                                  }
                                                },
                                                child: Row(
                                                  children: [
                                                    (_canEdit)
                                                        ? Text(
                                                            '   حفظ ',
                                                            style: TextStyles.h4,
                                                          )
                                                        : Text(
                                                            ' تعديل ',
                                                            style: TextStyles.h4,
                                                          ),
                                                    (_canEdit)
                                                        ? Icon(
                                                            Icons.check,
                                                            color: TextStyles.h4.color,
                                                            size: 16,
                                                          )
                                                        : Icon(
                                                            Icons.edit,
                                                            color: TextStyles.h4.color,
                                                            size: 16,
                                                          ),
                                                  ],
                                                ),
                                              ),
                                              CircleAvatar(
                                                radius: 40,
                                                backgroundColor: Colors.transparent,
                                                backgroundImage: AssetImage(
                                                  'assets/images/profile_icon.jpg',
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    ' تعديل ',
                                                    style: TextStyles.h4.copyWith(color: Colors.transparent),
                                                  ),
                                                  Icon(
                                                    Icons.edit,
                                                    color: Colors.transparent,
                                                    size: 16,
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: SizeConfig.screenHeight * 0.04,
                                          ),
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
                                              },
                                            ),
                                          ),
                                          // SizedBox(
                                          //   height: SizeConfig.screenHeight * 0.02,
                                          // ),
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
                                          SizedBox(
                                            height: SizeConfig.screenHeight * 0.03,
                                          ),
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
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            height: SizeConfig.screenHeight * 0.03,
                                          ),
                                          SizedBox(
                                            width: SizeConfig.screenWidth * 0.55,
                                            height: SizeConfig.screenHeight * 0.08,
                                            child: NumberTextField(
                                              ValueKey('phoneNumber'),
                                              phoneNumberController,
                                              'رقم الهاتف',
                                              (value) {
                                                return null;
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            height: SizeConfig.screenHeight * 0.08,
                                          ),
                                          Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'هل تريد تغيير كلمة المرور؟ ؟',
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
                                        ],
                                      ),
                                    )
                                  : Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                if (_canEdit == false) {
                                                  setState(() {
                                                    _canEdit = true;

                                                    nameController.text = (state).user.name!;

                                                    emailController.text = (state).user.email!;
                                                    phoneNumberController.text = (state).user.phoneNumber!;
                                                  });
                                                } else {}
                                              },
                                              child: Row(
                                                children: [
                                                  (_canEdit)
                                                      ? Text(
                                                          '   حفظ ',
                                                          style: TextStyles.h4,
                                                        )
                                                      : Text(
                                                          ' تعديل ',
                                                          style: TextStyles.h4,
                                                        ),
                                                  (_canEdit)
                                                      ? Icon(
                                                          Icons.check,
                                                          color: TextStyles.h4.color,
                                                          size: 16,
                                                        )
                                                      : Icon(
                                                          Icons.edit,
                                                          color: TextStyles.h4.color,
                                                          size: 16,
                                                        ),
                                                ],
                                              ),
                                            ),
                                            CircleAvatar(
                                              radius: 40,
                                              backgroundColor: Colors.transparent,
                                              backgroundImage: AssetImage(
                                                'assets/images/profile_icon.jpg',
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  ' تعديل ',
                                                  style: TextStyles.h4.copyWith(color: Colors.transparent),
                                                ),
                                                Icon(
                                                  Icons.edit,
                                                  color: Colors.transparent,
                                                  size: 16,
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: SizeConfig.screenHeight * 0.02,
                                        ),
                                        Text(
                                          (state).user.name!,
                                          style: TextStyles.h3.copyWith(fontSize: 13),
                                        ),
                                        // Padding(
                                        //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                        //   child: Text(
                                        //     "لوريم ايبسوم هو نموذج افتراضي يوضع في التصاميم لتعرض على العميل ليتصور طريقه وضع النصوص بالتصاميم",
                                        //     style: TextStyles.h3.copyWith(color: Colors.grey),
                                        //     textAlign: TextAlign.center,
                                        //   ),
                                        // ),
                                        // SizedBox(
                                        //   height: SizeConfig.screenHeight * 0.03,
                                        // ),
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
                                                    (state).user.email!,
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
                                                    (state).user.phoneNumber!,
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
                                                    (state).user.job == null ? "مستخدم الخدمة" : (state).user.job!,
                                                    style: TextStyles.h2.copyWith(fontSize: 13),
                                                  ),
                                                  // SizedBox(
                                                  //   height: SizeConfig.screenHeight * 0.02,
                                                  // ),
                                                  // Text(
                                                  //   'عمرك',
                                                  //   style: TextStyles.textFieldsLabels,
                                                  // ),
                                                  // Text(
                                                  //   (state).user.age == null ? '0' : (state).user.age!,
                                                  //   style: TextStyles.h2.copyWith(fontSize: 13),
                                                  // ),
                                                  SizedBox(
                                                    height: SizeConfig.screenHeight * 0.02,
                                                  ),
                                                  Text(
                                                    'الجنسية',
                                                    style: TextStyles.textFieldsLabels,
                                                  ),
                                                  Text(
                                                    ((state).user.countryId == null)
                                                        ? ''
                                                        : _countriesList[(state).user.countryId! - 1].nationality!,
                                                    style: TextStyles.h2.copyWith(fontSize: 13),
                                                  ),
                                                  SizedBox(
                                                    height: SizeConfig.screenHeight * 0.035,
                                                  ),
                                                  (_letterVisible)
                                                      ? Center(
                                                          child: Text(
                                                            "تم الحفظ بنجاح!",
                                                            style: TextStyles.h4,
                                                          ),
                                                        )
                                                      : Container(),
                                                  SizedBox(
                                                    height: SizeConfig.screenHeight * 0.02,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: SizeConfig.screenWidth * 0.6,
                                          // height: SizeConfig.screenHeight * 0.35,
                                          child: Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: Wrap(
                                              runSpacing: 4,
                                              spacing: 4,
                                              alignment: WrapAlignment.center,
                                              direction: Axis.horizontal,
                                              children: List.generate(
                                                8,
                                                (index) {
                                                  if (index == 0) {
                                                    return Container(
                                                      height: square,
                                                      width: square,
                                                      child: Card(
                                                        color: Colors.white,
                                                        elevation: 10,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(15),
                                                        ),
                                                        child: InkWell(
                                                          hoverColor: Colors.teal,
                                                          highlightColor: Colors.teal,
                                                          borderRadius: BorderRadius.circular(15),
                                                          onTap: () {
                                                            Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                builder: (context) => BlocProvider(
                                                                  create: (context) =>
                                                                      BookingCubit(BookingRepository(WebServices())),
                                                                  child: AllServicesScreen(widget._aboutUsModel,
                                                                      widget._filterData, widget._lawyersList),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          child: Center(
                                                            child: Text(
                                                              'خدماتي',
                                                              style: TextStyles.h2Bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  } else if (index == 1) {
                                                    return Container(
                                                      height: square,
                                                      width: square,
                                                      child: Card(
                                                        color: Colors.white,
                                                        elevation: 10,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(15),
                                                        ),
                                                        child: InkWell(
                                                          hoverColor: Colors.teal,
                                                          highlightColor: Colors.teal,
                                                          borderRadius: BorderRadius.circular(15),
                                                          onTap: () {
                                                            Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                builder: (context) => ChatsPage(widget._aboutUsModel,
                                                                    widget._filterData, widget._lawyersList),
                                                              ),
                                                            );
                                                          },
                                                          child: Center(
                                                            child: Text(
                                                              'الدردشات',
                                                              style: TextStyles.h2Bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  } else if (index == 2) {
                                                    return Container(
                                                      height: square,
                                                      width: square,
                                                      child: Card(
                                                        color: Colors.white,
                                                        elevation: 10,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(15),
                                                        ),
                                                        child: InkWell(
                                                          hoverColor: Colors.teal,
                                                          highlightColor: Colors.teal,
                                                          borderRadius: BorderRadius.circular(15),
                                                          onTap: () {
                                                            Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                builder: (context) => BlocProvider(
                                                                  create: (context) =>
                                                                      ServicesCubit(ServicesRepo(WebServices())),
                                                                  child: NotificationScreen(widget._aboutUsModel,
                                                                      widget._filterData, widget._lawyersList),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          child: Center(
                                                            child: Text(
                                                              'الإشعارات',
                                                              style: TextStyles.h2Bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  } else if (index == 3) {
                                                    return Container(
                                                      height: square,
                                                      width: square,
                                                      child: Card(
                                                        color: Colors.white,
                                                        elevation: 10,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(15),
                                                        ),
                                                        child: InkWell(
                                                          hoverColor: Colors.teal,
                                                          highlightColor: Colors.teal,
                                                          borderRadius: BorderRadius.circular(15),
                                                          onTap: () {
                                                            Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                builder: (context) => BlocProvider(
                                                                  create: (context) =>
                                                                      UserCubit(UserRepository(WebServices())),
                                                                  child: QuickChatMessagesScreen(widget._aboutUsModel,
                                                                      widget._filterData, widget._lawyersList),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          child: Center(
                                                            child: Text(
                                                              'دردشة فورية',
                                                              style: TextStyles.h2Bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  } else if (index == 4) {
                                                    return Container(
                                                      height: square,
                                                      width: square,
                                                      child: Card(
                                                        color: Colors.white,
                                                        elevation: 10,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(15),
                                                        ),
                                                        child: InkWell(
                                                          hoverColor: Colors.teal,
                                                          highlightColor: Colors.teal,
                                                          borderRadius: BorderRadius.circular(15),
                                                          onTap: () {
                                                            Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                builder: (context) => QNAScreen(
                                                                  widget._aboutUsModel,
                                                                  widget._filterData,
                                                                  widget._lawyersList,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          child: Center(
                                                            child: Text(
                                                              'اسئلة و أجوبة',
                                                              style: TextStyles.h2Bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  } else if (index == 5) {
                                                    return Container(
                                                      height: square,
                                                      width: square,
                                                      child: Card(
                                                        color: Colors.white,
                                                        elevation: 10,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(15),
                                                        ),
                                                        child: InkWell(
                                                          hoverColor: Colors.teal,
                                                          highlightColor: Colors.teal,
                                                          borderRadius: BorderRadius.circular(15),
                                                          onTap: () {
                                                            Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                builder: (ctx) => BlocProvider(
                                                                  lazy: false,
                                                                  create: (context) =>
                                                                      ServicesCubit(ServicesRepo(WebServices())),
                                                                  child: TechSupport(widget._aboutUsModel,
                                                                      widget._filterData, widget._lawyersList),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          child: Center(
                                                            child: Text(
                                                              'الدعم الفنـــــي',
                                                              style: TextStyles.h2Bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  } else if (index == 6) {
                                                    return Container(
                                                      height: square,
                                                      width: square,
                                                      child: Card(
                                                        color: Colors.white,
                                                        elevation: 10,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(15),
                                                        ),
                                                        child: InkWell(
                                                          hoverColor: Colors.teal,
                                                          highlightColor: Colors.teal,
                                                          borderRadius: BorderRadius.circular(15),
                                                          onTap: () {
                                                            Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                builder: (context) => BlocProvider(
                                                                  create: (context) =>
                                                                      ServicesCubit(ServicesRepo(WebServices())),
                                                                  child: RatingScreen(
                                                                    widget._aboutUsModel,
                                                                    widget._filterData,
                                                                    widget._lawyersList,
                                                                    lawyerId: 0,
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          child: Center(
                                                            child: Text(
                                                              'التقييم',
                                                              style: TextStyles.h2Bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  } else {
                                                    return Container(
                                                      height: square,
                                                      width: square,
                                                      child: Card(
                                                        color: Colors.white,
                                                        elevation: 10,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(15),
                                                        ),
                                                        child: InkWell(
                                                          hoverColor: Colors.teal,
                                                          highlightColor: Colors.teal,
                                                          borderRadius: BorderRadius.circular(15),
                                                          onTap: () {
                                                            showDialog(
                                                              context: context,
                                                              barrierDismissible: false,
                                                              useRootNavigator: true,
                                                              useSafeArea: false,
                                                              builder: (_) => MultiBlocProvider(
                                                                providers: [
                                                                  BlocProvider(
                                                                    create: (context) =>
                                                                        UserCubit(UserRepository(WebServices())),
                                                                  ),
                                                                  BlocProvider(
                                                                    create: (context) =>
                                                                        ServicesCubit(ServicesRepo(WebServices())),
                                                                  ),
                                                                ],
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
                                                                            borderRadius: BorderRadius.circular(15),
                                                                            color: Colors.white),
                                                                        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                                                                        child: Column(
                                                                          children: [
                                                                            SizedBox(
                                                                              height: SizeConfig.screenHeight * 0.02,
                                                                            ),
                                                                            Icon(
                                                                              Icons.shield_outlined,
                                                                              color: Color(0xffE2C069),
                                                                              size: 40,
                                                                            ),
                                                                            SizedBox(
                                                                              height: SizeConfig.screenHeight * 0.02,
                                                                            ),
                                                                            Text(
                                                                              "هل تريد تآكيد الخروج !",
                                                                              style: TextStyles.h2,
                                                                            ),
                                                                            SizedBox(
                                                                              height: SizeConfig.screenHeight * 0.02,
                                                                            ),
                                                                            SizedBox(
                                                                              width: SizeConfig.screenWidth * 0.8,
                                                                              child: Text(
                                                                                "سوف يتم اعاده تحويلك علي صفحه تسجيل الدخول مره اخري لتتمكن من تصفح التطبيق.",
                                                                                style: TextStyles.h3.copyWith(
                                                                                  color: Color(0xFF717171),
                                                                                ),
                                                                                textAlign: TextAlign.center,
                                                                                textDirection: TextDirection.rtl,
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              height: SizeConfig.screenHeight * 0.08,
                                                                            ),
                                                                            SizedBox(
                                                                              width: SizeConfig.screenWidth * 0.3,
                                                                              height: SizeConfig.screenHeight * 0.08,
                                                                              child: BlocProvider(
                                                                                create: (context) => ServicesCubit(
                                                                                    ServicesRepo(WebServices())),
                                                                                child: BasicButton(
                                                                                  buttonName: "تسجيل خروج",
                                                                                  onPressedFunction: () async {
                                                                                    _pref = await SharedPreferences
                                                                                        .getInstance();
                                                                                    var _isUser =
                                                                                        _pref.getBool('isUser');
                                                                                    var lawyerToken =
                                                                                        _pref.getString('lawyerToken');
                                                                                    var userToken =
                                                                                        _pref.getString('userToken');

                                                                                    if (_isUser!) {
                                                                                      await BlocProvider.of<
                                                                                              ServicesCubit>(context)
                                                                                          .logOut(userToken!)
                                                                                          .then((value) {
                                                                                        if (value == true) {
                                                                                          _pref
                                                                                              .setString(
                                                                                                  'userToken', '')
                                                                                              .then(
                                                                                            (_) {
                                                                                              _pref.clear();

                                                                                              Navigator.of(context)
                                                                                                  .pushAndRemoveUntil(
                                                                                                      MaterialPageRoute(
                                                                                                        builder:
                                                                                                            (context) =>
                                                                                                                BlocProvider(
                                                                                                          create: (BuildContext
                                                                                                                  context) =>
                                                                                                              UserCubit(
                                                                                                                  UserRepository(
                                                                                                                      WebServices())),
                                                                                                          child:
                                                                                                              CreateAccount(),
                                                                                                        ),
                                                                                                      ),
                                                                                                      (route) => false);
                                                                                            },
                                                                                          );
                                                                                        } else {
                                                                                          Fluttertoast.showToast(
                                                                                            msg: _pref.getString(
                                                                                                'errorOfLogOut')!,
                                                                                            gravity: ToastGravity.TOP,
                                                                                            toastLength:
                                                                                                Toast.LENGTH_LONG,
                                                                                            timeInSecForIosWeb: 5,
                                                                                          );
                                                                                        }
                                                                                      });
                                                                                    } else if (_pref.getString(
                                                                                                'lawyerToken') !=
                                                                                            null ||
                                                                                        _pref.getString(
                                                                                                'lawyerToken') !=
                                                                                            '') {
                                                                                      await BlocProvider.of<
                                                                                              ServicesCubit>(context)
                                                                                          .logOut(lawyerToken!)
                                                                                          .then((value) {
                                                                                        if (value == true) {
                                                                                          _pref
                                                                                              .setString(
                                                                                                  'lawyerToken', '')
                                                                                              .then(
                                                                                            (_) {
                                                                                              _pref.clear();

                                                                                              Navigator.of(context)
                                                                                                  .pushAndRemoveUntil(
                                                                                                      MaterialPageRoute(
                                                                                                        builder:
                                                                                                            (context) =>
                                                                                                                BlocProvider(
                                                                                                          create: (BuildContext
                                                                                                                  context) =>
                                                                                                              UserCubit(
                                                                                                                  UserRepository(
                                                                                                                      WebServices())),
                                                                                                          child:
                                                                                                              CreateAccount(),
                                                                                                        ),
                                                                                                      ),
                                                                                                      (route) => false);
                                                                                            },
                                                                                          );
                                                                                        } else {
                                                                                          Fluttertoast.showToast(
                                                                                            msg: _pref.getString(
                                                                                                'errorOfLogOut')!,
                                                                                            gravity: ToastGravity.TOP,
                                                                                            toastLength:
                                                                                                Toast.LENGTH_LONG,
                                                                                            timeInSecForIosWeb: 5,
                                                                                          );
                                                                                        }
                                                                                      });
                                                                                    }
                                                                                  },
                                                                                ),
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
                                                          },
                                                          child: Center(
                                                            child: Text(
                                                              'تسجيل خروج',
                                                              style: TextStyles.h2Bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                        )
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
                    );
                  },
                ),
              ),
              SizedBox(
                height: SizeConfig.screenHeight * 0.1,
              ),
              Stack(
                children: [
                  Container(
                    height: SizeConfig.screenHeight * 0.4,
                    width: SizeConfig.screenWidth,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/images/background.jpg',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    height: SizeConfig.screenHeight * 0.4,
                    width: SizeConfig.screenWidth,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: SizeConfig.screenHeight * 0.08,
                      ),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: SizeConfig.screenHeight * 0.28,
                            width: SizeConfig.screenWidth * 0.3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'تواصل',
                                  style: TextStyles.h2.copyWith(color: Colors.white),
                                ),
                                Text(
                                  widget._aboutUsModel.email!,
                                  style: TextStyles.h2.copyWith(color: Colors.white),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      widget._aboutUsModel.whatsapp!,
                                      style: TextStyles.h2.copyWith(color: Colors.white),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      FontAwesomeIcons.whatsapp,
                                      color: Colors.green,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: SizeConfig.screenHeight * 0.02,
                                ),
                                Divider(
                                  color: Colors.grey,
                                  indent: SizeConfig.screenWidth * 0.2,
                                  // endIndent: SizeConfig.screenWidth * 0.05,
                                ),
                                Text(
                                  'تواصل معنا',
                                  style: TextStyles.h2.copyWith(color: Colors.white),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: IconButton(
                                          onPressed: () {
                                            launch(widget._aboutUsModel.facebook!);
                                          },
                                          icon: Icon(
                                            FontAwesomeIcons.facebookF,
                                            color: Colors.teal,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: SizeConfig.screenWidth * 0.01),
                                      CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: IconButton(
                                          onPressed: () {
                                            launch(widget._aboutUsModel.twitter!);
                                          },
                                          icon: Icon(
                                            FontAwesomeIcons.twitter,
                                            color: Colors.teal,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: SizeConfig.screenWidth * 0.01),
                                      CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: IconButton(
                                          onPressed: () {
                                            launch(widget._aboutUsModel.linkedIn!);
                                          },
                                          icon: Icon(
                                            FontAwesomeIcons.linkedinIn,
                                            color: Colors.teal,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: SizeConfig.screenWidth * 0.01),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.04),
                      height: SizeConfig.screenHeight * 0.06,
                      width: SizeConfig.screenWidth,
                      decoration: BoxDecoration(color: Colors.grey.withOpacity(0.6)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => MultiBlocProvider(
                                        providers: [
                                          BlocProvider(
                                            create: (context) => ServicesCubit(
                                              ServicesRepo(
                                                WebServices(),
                                              ),
                                            ),
                                          ),
                                          BlocProvider(
                                            create: (context) => UserCubit(
                                              UserRepository(
                                                WebServices(),
                                              ),
                                            ),
                                          ),
                                        ],
                                        child: ContactUs(widget._lawyersList, widget._filterData, widget._aboutUsModel),
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  'تواصل معنا',
                                  style: TextStyles.textFieldsHint.copyWith(color: Colors.white),
                                ),
                              ),
                              SizedBox(
                                width: SizeConfig.screenWidth * 0.04,
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => BlocProvider(
                                        create: (context) => ServicesCubit(ServicesRepo(WebServices())),
                                        child: AboutUs(widget._lawyersList, widget._filterData, widget._aboutUsModel),
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  'عن المنار',
                                  style: TextStyles.textFieldsHint.copyWith(color: Colors.white),
                                ),
                              ),
                              SizedBox(
                                width: SizeConfig.screenWidth * 0.04,
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ChatsPage(widget._aboutUsModel, widget._filterData, widget._lawyersList),
                                    ),
                                  );
                                },
                                child: Text(
                                  'الدردشات',
                                  style: TextStyles.textFieldsHint.copyWith(color: Colors.white),
                                ),
                              ),
                              SizedBox(
                                width: SizeConfig.screenWidth * 0.04,
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => MultiBlocProvider(
                                        providers: [
                                          BlocProvider(
                                            lazy: false,
                                            create: (BuildContext context) => ServicesCubit(
                                              ServicesRepo(WebServices()),
                                            ),
                                          ),
                                          BlocProvider(
                                            lazy: false,
                                            create: (BuildContext context) => LawyerCubit(
                                              LawyerRepository(WebServices()),
                                            ),
                                          ),
                                        ],
                                        child:
                                            SearchLawyer(widget._filterData, widget._lawyersList, widget._aboutUsModel),
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  'المحاميين',
                                  style: TextStyles.textFieldsHint.copyWith(color: Colors.white),
                                ),
                              ),
                              SizedBox(
                                width: SizeConfig.screenWidth * 0.04,
                              ),
                              TextButton(
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
                                  'الرئيسية',
                                  style: TextStyles.textFieldsHint.copyWith(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'جميع الحقوق محفوظة لمنار 2021',
                            style: TextStyles.textFieldsHint.copyWith(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
