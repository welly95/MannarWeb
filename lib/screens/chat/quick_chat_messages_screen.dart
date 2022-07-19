import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../bloc/country/country_cubit.dart';
import '../../bloc/lawyer/lawyer_cubit.dart';
import '../../bloc/service_provider/service_provider_cubit.dart';
import '../../bloc/services/services_cubit.dart';
import '../../bloc/user/user_cubit.dart';
import '../../constants/size_config.dart';
import '../../constants/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/aboutUsModel.dart';
import '../../models/filter_data.dart';
import '../../models/lawyers.dart';
import '../../repository/countries_repository.dart';
import '../../repository/lawyer_repository.dart';
import '../../repository/service_provider_repository.dart';
import '../../repository/services_repository.dart';
import '../../repository/user_repository.dart';
import '../../repository/web_services.dart';
import '../aboutUs/about_us.dart';
import '../contactUS/contact_us.dart';
import '../home/home_screen.dart';
import '../lawyer/search_lawyer.dart';
import '../profile/profile_information.dart';

class QuickChatMessagesScreen extends StatefulWidget {
  final AboutUsModel _aboutUsModel;
  final FilterData _filterData;
  final List<Lawyer> _lawyersList;

  QuickChatMessagesScreen(this._aboutUsModel, this._filterData, this._lawyersList);
  @override
  _QuickChatMessagesScreenState createState() => _QuickChatMessagesScreenState();
}

class _QuickChatMessagesScreenState extends State<QuickChatMessagesScreen> {
  TextEditingController _controller = TextEditingController();
  String message = '';

  late SharedPreferences _pref;
  late bool isMe;

  @override
  void initState() {
    Future.delayed(Duration(seconds: 0)).then((_) async {
      _pref = await SharedPreferences.getInstance();
      await BlocProvider.of<UserCubit>(context).getQuickChatForUser(_pref.getString('userToken')!);
    });
    super.initState();
  }

  void sendMessage() async {
    FocusScope.of(context).unfocus();

    await BlocProvider.of<UserCubit>(context)
        .sendUserQuickChat(_pref.getString('userToken')!, message, _pref.getString('lawyerId')!)
        .then(
            (_) async => await BlocProvider.of<UserCubit>(context).getQuickChatForUser(_pref.getString('userToken')!));
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
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
                                      false, widget._aboutUsModel, widget._filterData, widget._lawyersList),
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
              Container(
                height: SizeConfig.screenHeight * 0.9,
                width: SizeConfig.screenWidth * 0.45,
                child: Column(
                  children: [
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          BackButton(color: Color(0xff03564C)),
                          Expanded(child: Container()),
                          Text(
                            'المنار للإستشارات',
                            style: TextStyles.h2Bold,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(width: 15),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.02,
                    ),
                    BlocBuilder<UserCubit, UserState>(
                      builder: (context, state) {
                        if (state is GetQuickChatForUser) {
                          _pref.setString('lawyerId', state.quickChatModel[0].lawyerId.toString());
                          return Expanded(
                            child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              reverse: true,
                              itemCount: state.quickChatModel.length,
                              itemBuilder: (context, index) {
                                if (state.quickChatModel[index].from == 'user') {
                                  isMe = true;
                                } else {
                                  isMe = false;
                                }
                                return Row(
                                  mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.all(16),
                                      margin: EdgeInsets.all(16),
                                      constraints: BoxConstraints(maxWidth: 140),
                                      decoration: BoxDecoration(
                                        color: isMe ? Colors.grey[100] : Colors.blue,
                                        borderRadius: isMe
                                            ? BorderRadius.all(Radius.circular(12))
                                                .subtract(BorderRadius.only(bottomRight: Radius.circular(12)))
                                            : BorderRadius.all(Radius.circular(12))
                                                .subtract(BorderRadius.only(bottomLeft: Radius.circular(12))),
                                      ),
                                      child: buildMessage(state.quickChatModel[index].message!, isMe),
                                    ),
                                  ],
                                );
                              },
                            ),
                          );
                        } else {
                          return Expanded(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                      },
                    ),
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(8),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: TextField(
                                controller: _controller,
                                textCapitalization: TextCapitalization.sentences,
                                autocorrect: true,
                                textDirection: TextDirection.rtl,
                                enableSuggestions: true,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                  labelText: 'اكتب رسالتك هنا...',
                                  labelStyle: TextStyles.h4,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(width: 0),
                                    gapPadding: 10,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                onChanged: (value) => setState(() {
                                  message = value;
                                }),
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          GestureDetector(
                            onTap: message.trim().isEmpty ? null : sendMessage,
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue,
                              ),
                              child: Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
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

  Widget buildMessage(String message, bool isMe) => Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            message,
            style: TextStyle(color: isMe ? Colors.black : Colors.white),
            textAlign: isMe ? TextAlign.end : TextAlign.start,
          ),
        ],
      );

  Widget buildText(String text) => Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 24),
        ),
      );
}
