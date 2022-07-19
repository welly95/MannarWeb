import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../models/chat_user.dart';
import '../../widgets/Chat/messages_widget.dart';
import '../../widgets/Chat/new_message_widget.dart';
import 'package:mannar_web/bloc/country/country_cubit.dart';
import 'package:mannar_web/bloc/lawyer/lawyer_cubit.dart';
import 'package:mannar_web/bloc/service_provider/service_provider_cubit.dart';
import 'package:mannar_web/bloc/services/services_cubit.dart';
import 'package:mannar_web/bloc/user/user_cubit.dart';
import 'package:mannar_web/constants/size_config.dart';
import 'package:mannar_web/constants/styles.dart';
import 'package:mannar_web/models/aboutUsModel.dart';
import 'package:mannar_web/models/filter_data.dart';
import 'package:mannar_web/models/lawyers.dart';
import 'package:mannar_web/repository/countries_repository.dart';
import 'package:mannar_web/repository/lawyer_repository.dart';
import 'package:mannar_web/repository/service_provider_repository.dart';
import 'package:mannar_web/repository/services_repository.dart';
import 'package:mannar_web/repository/user_repository.dart';
import 'package:mannar_web/repository/web_services.dart';
import 'package:mannar_web/screens/aboutUs/about_us.dart';
import 'package:mannar_web/screens/contactUS/contact_us.dart';
import 'package:mannar_web/screens/home/home_screen.dart';
import 'package:mannar_web/screens/lawyer/search_lawyer.dart';
import 'package:mannar_web/screens/profile/profile_information.dart';

class ChatPage extends StatefulWidget {
  final User user;
  final String chatRoomName;
  final String lawyerName;
  final Lawyer lawyer;
  final AboutUsModel aboutUsModel;
  final FilterData filterData;
  final List<Lawyer> lawyersList;

  const ChatPage({
    required this.user,
    required this.chatRoomName,
    required this.lawyerName,
    required this.lawyer,
    required this.aboutUsModel,
    required this.filterData,
    required this.lawyersList,
    Key? key,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // @override
  // void initState() {
  //   super.initState();
  // }

  Widget build(BuildContext context) {
    print('from chat page =====>' + widget.lawyer.toString());
    SizeConfig().init(context);

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
                          widget.aboutUsModel.phone!,
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
                          widget.aboutUsModel.email!,
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
                            launch(widget.aboutUsModel.facebook!);
                          },
                          icon: Icon(
                            FontAwesomeIcons.facebookF,
                            color: Colors.teal,
                          ),
                        ),
                        SizedBox(width: SizeConfig.screenWidth * 0.01),
                        IconButton(
                          onPressed: () {
                            launch(widget.aboutUsModel.twitter!);
                          },
                          icon: Icon(
                            FontAwesomeIcons.twitter,
                            color: Colors.teal,
                          ),
                        ),
                        SizedBox(width: SizeConfig.screenWidth * 0.01),
                        IconButton(
                          onPressed: () {
                            launch(widget.aboutUsModel.linkedIn!);
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
                          borderRadius: BorderRadius.circular(15),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => MultiBlocProvider(
                                  providers: [
                                    BlocProvider(
                                      // lazy: false,
                                      create: (BuildContext context) => UserCubit(UserRepository(WebServices())),
                                    ),
                                    BlocProvider(
                                      lazy: false,
                                      create: (BuildContext context) =>
                                          CountryCubit(CountriesRepository(WebServices())),
                                    ),
                                    BlocProvider(
                                      // lazy: false,
                                      create: (BuildContext context) =>
                                          ServiceProviderCubit(ServiceProviderRepository(WebServices())),
                                    ),
                                  ],
                                  child: ProfileInfromation(
                                      false, widget.aboutUsModel, widget.filterData, widget.lawyersList),
                                ),
                              ),
                            );
                          },
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
                                  child: ContactUs(widget.lawyersList, widget.filterData, widget.aboutUsModel),
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
                                  child: AboutUs(widget.lawyersList, widget.filterData, widget.aboutUsModel),
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
                          onPressed: null,
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
                                  child: SearchLawyer(widget.filterData, widget.lawyersList, widget.aboutUsModel),
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
              Container(
                height: SizeConfig.screenHeight * 0.9,
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.04),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                    Container(
                      width: SizeConfig.screenWidth * 0.2,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.screenWidth * 0.02,
                            ),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                  left: BorderSide(
                                    color: Colors.grey.shade300,
                                    width: 1,
                                  ),
                                  right: BorderSide(
                                    color: Colors.grey.shade300,
                                    width: 1,
                                  ),
                                  bottom: BorderSide(
                                    color: Colors.grey.shade300,
                                    width: 1,
                                  ),
                                  top: BorderSide(
                                    color: Colors.grey.shade300,
                                    width: 1,
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(5)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: SizeConfig.screenHeight * 0.02),
                                CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: NetworkImage(
                                    (widget.lawyer.imageurl == null) ? '' : widget.lawyer.imageurl!,
                                  ),
                                ),
                                SizedBox(height: SizeConfig.screenHeight * 0.02),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            (widget.lawyer.rate == null) ? '' : (widget.lawyer.rate!).toString(),
                                            style: TextStyles.h4.copyWith(
                                              color: Color(0xffF7CC19),
                                            ),
                                            // textDirection: TextDirection.rtl,
                                          ),
                                          Icon(
                                            Icons.star,
                                            color: Color(0xffF7CC19),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      widget.lawyer.name!,
                                      style: TextStyles.h3.copyWith(fontSize: 18),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                                SizedBox(height: SizeConfig.screenHeight * 0.02),
                                Text(
                                  (widget.lawyer.bio == null) ? '' : widget.lawyer.bio!,
                                  style: TextStyles.h3.copyWith(color: Colors.grey),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: SizeConfig.screenHeight * 0.02),
                                Divider(color: Colors.grey.shade400, indent: 20, endIndent: 20),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'البريد الإلكتروني',
                                        style: TextStyles.textFieldsLabels,
                                      ),
                                      Text(
                                        widget.lawyer.email!,
                                        style: TextStyles.h2.copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: SizeConfig.screenHeight * 0.02),
                                      Text(
                                        'رقم الجوال',
                                        style: TextStyles.textFieldsLabels,
                                      ),
                                      Text(
                                        widget.lawyer.phone!,
                                        style: TextStyles.h2.copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: SizeConfig.screenHeight * 0.02),
                                      Text(
                                        'سنوات الخبرة',
                                        style: TextStyles.textFieldsLabels,
                                      ),
                                      Text(
                                        widget.lawyer.experience!,
                                        style: TextStyles.h2.copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: SizeConfig.screenHeight * 0.02),
                                      Text(
                                        'رقم الرخصة',
                                        style: TextStyles.textFieldsLabels,
                                      ),
                                      Text(
                                        widget.lawyer.licenseNum.toString(),
                                        style: TextStyles.h2.copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: SizeConfig.screenHeight * 0.02),
                                      Text(
                                        'تاريخ الرخصة',
                                        style: TextStyles.textFieldsLabels,
                                      ),
                                      Text(
                                        widget.lawyer.licenseDate!,
                                        style: TextStyles.h2.copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: SizeConfig.screenHeight * 0.04),
                              ],
                            ),
                          ),
                          SizedBox(height: SizeConfig.screenHeight * 0.04),
                          InkWell(
                            onTap: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'إبلاغ',
                                  style: TextStyles.h2.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(Icons.report_sharp, color: Colors.redAccent),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: SizeConfig.screenWidth * 0.02,
                    ),
                    Container(
                      width: SizeConfig.screenWidth * 0.65,
                      child: Column(
                        children: [
                          // ProfileHeaderWidget(name: widget.user.lawyerName),
                          Expanded(
                            child: Material(
                              elevation: 20,
                              color: Colors.transparent,
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(25),
                                    topRight: Radius.circular(25),
                                  ),
                                ),
                                child: MessagesWidget(
                                    idUser: widget.user.idUser!,
                                    recieverId: widget.user.recieverId,
                                    chatRoomName: widget.chatRoomName),
                              ),
                            ),
                          ),
                          NewMessageWidget(
                            user: widget.user,
                            lawyerName: widget.lawyerName,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
                                  widget.aboutUsModel.email!,
                                  style: TextStyles.h2.copyWith(color: Colors.white),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      widget.aboutUsModel.whatsapp!,
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
                                            launch(widget.aboutUsModel.facebook!);
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
                                            launch(widget.aboutUsModel.twitter!);
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
                                            launch(widget.aboutUsModel.linkedIn!);
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
                                        child: ContactUs(widget.lawyersList, widget.filterData, widget.aboutUsModel),
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
                                        child: AboutUs(widget.lawyersList, widget.filterData, widget.aboutUsModel),
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
                                onPressed: null,
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
                                        child: SearchLawyer(widget.filterData, widget.lawyersList, widget.aboutUsModel),
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
