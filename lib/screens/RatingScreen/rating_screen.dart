import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../bloc/country/country_cubit.dart';
import '../../bloc/lawyer/lawyer_cubit.dart';
import '../../bloc/service_provider/service_provider_cubit.dart';
import '../../bloc/user/user_cubit.dart';
import '../../models/aboutUsModel.dart';
import '../../models/filter_data.dart';
import '../../models/lawyers.dart';
import '../../repository/countries_repository.dart';
import '../../repository/lawyer_repository.dart';
import '../../repository/service_provider_repository.dart';
import '../../repository/services_repository.dart';
import '../../repository/user_repository.dart';
import '../../repository/web_services.dart';
import '../../screens/aboutUs/about_us.dart';
import '../../screens/chat/chats_page.dart';
import '../../screens/contactUS/contact_us.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/lawyer/search_lawyer.dart';
import '../../screens/profile/profile_information.dart';
import '../../bloc/services/services_cubit.dart';
import '../../constants/size_config.dart';
import '../../constants/styles.dart';
import '../../widgets/buttons/basic_button.dart';
import '../../widgets/textfields/description_textfield.dart';

class RatingScreen extends StatefulWidget {
  final int? lawyerId;
  final AboutUsModel _aboutUsModel;
  final FilterData _filterData;
  final List<Lawyer> _lawyersList;

  RatingScreen(this._aboutUsModel, this._filterData, this._lawyersList, {this.lawyerId});
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<RatingScreen> {
  TextEditingController commentController = TextEditingController();

  // double _userRating = 2.5;

  // bool _isVertical = false;

  // IconData? _selectedIcon;

  late SharedPreferences _pref;

  int _lawyerRating = 0;
  int _serviceRating = 0;
  int _appRating = 0;

  void rateLawyer(int rating) {
    setState(() {
      _lawyerRating = rating;
    });
  }

  void rateService(int rating) {
    //Other actions based on rating such as api calls.
    setState(() {
      _serviceRating = rating;
    });
  }

  void rateApp(int rating) {
    //Other actions based on rating such as api calls.
    setState(() {
      _appRating = rating;
    });
  }

  @override
  void initState() {
    Future.delayed(Duration(seconds: 0)).then((_) async {
      _pref = await SharedPreferences.getInstance();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        // drawer: AppDrawer(),
        backgroundColor: Colors.white,
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
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topRight,
                        child: Text(
                          'تقييم صاحب الخدمه',
                          style: TextStyles.h2,
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.screenHeight * 0.02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            child: Icon(
                              Icons.star,
                              size: SizeConfig.screenWidth * 0.05,
                              color: _lawyerRating >= 1 ? Colors.amber : Colors.grey,
                            ),
                            onTap: () => rateLawyer(1),
                          ),
                          GestureDetector(
                            child: Icon(
                              Icons.star,
                              size: SizeConfig.screenWidth * 0.05,
                              color: _lawyerRating >= 2 ? Colors.amber : Colors.grey,
                            ),
                            onTap: () => rateLawyer(2),
                          ),
                          GestureDetector(
                            child: Icon(
                              Icons.star,
                              size: SizeConfig.screenWidth * 0.05,
                              color: _lawyerRating >= 3 ? Colors.amber : Colors.grey,
                            ),
                            onTap: () => rateLawyer(3),
                          ),
                          GestureDetector(
                            child: Icon(
                              Icons.star,
                              size: SizeConfig.screenWidth * 0.05,
                              color: _lawyerRating >= 4 ? Colors.amber : Colors.grey,
                            ),
                            onTap: () => rateLawyer(4),
                          ),
                          GestureDetector(
                            child: Icon(
                              Icons.star,
                              size: SizeConfig.screenWidth * 0.05,
                              color: _lawyerRating >= 5 ? Colors.amber : Colors.grey,
                            ),
                            onTap: () => rateLawyer(5),
                          )
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig.screenHeight * 0.04,
                      ),
                      Container(
                        alignment: Alignment.topRight,
                        child: Text(
                          'تقييم الخدمه',
                          style: TextStyles.h2,
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.screenHeight * 0.02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            child: Icon(
                              Icons.star,
                              size: SizeConfig.screenWidth * 0.05,
                              color: _serviceRating >= 1 ? Colors.amber : Colors.grey,
                            ),
                            onTap: () => rateService(1),
                          ),
                          GestureDetector(
                            child: Icon(
                              Icons.star,
                              size: SizeConfig.screenWidth * 0.05,
                              color: _serviceRating >= 2 ? Colors.amber : Colors.grey,
                            ),
                            onTap: () => rateService(2),
                          ),
                          GestureDetector(
                            child: Icon(
                              Icons.star,
                              size: SizeConfig.screenWidth * 0.05,
                              color: _serviceRating >= 3 ? Colors.amber : Colors.grey,
                            ),
                            onTap: () => rateService(3),
                          ),
                          GestureDetector(
                            child: Icon(
                              Icons.star,
                              size: SizeConfig.screenWidth * 0.05,
                              color: _serviceRating >= 4 ? Colors.amber : Colors.grey,
                            ),
                            onTap: () => rateService(4),
                          ),
                          GestureDetector(
                            child: Icon(
                              Icons.star,
                              size: SizeConfig.screenWidth * 0.05,
                              color: _serviceRating >= 5 ? Colors.amber : Colors.grey,
                            ),
                            onTap: () => rateService(5),
                          )
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig.screenHeight * 0.04,
                      ),
                      Container(
                        alignment: Alignment.topRight,
                        child: Text(
                          'تقييم التطبيق',
                          style: TextStyles.h2,
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.screenHeight * 0.02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            child: Icon(
                              Icons.star,
                              size: SizeConfig.screenWidth * 0.05,
                              color: _appRating >= 1 ? Colors.amber : Colors.grey,
                            ),
                            onTap: () => rateApp(1),
                          ),
                          GestureDetector(
                            child: Icon(
                              Icons.star,
                              size: SizeConfig.screenWidth * 0.05,
                              color: _appRating >= 2 ? Colors.amber : Colors.grey,
                            ),
                            onTap: () => rateApp(2),
                          ),
                          GestureDetector(
                            child: Icon(
                              Icons.star,
                              size: SizeConfig.screenWidth * 0.05,
                              color: _appRating >= 3 ? Colors.amber : Colors.grey,
                            ),
                            onTap: () => rateApp(3),
                          ),
                          GestureDetector(
                            child: Icon(
                              Icons.star,
                              size: SizeConfig.screenWidth * 0.05,
                              color: _appRating >= 4 ? Colors.amber : Colors.grey,
                            ),
                            onTap: () => rateApp(4),
                          ),
                          GestureDetector(
                            child: Icon(
                              Icons.star,
                              size: SizeConfig.screenWidth * 0.05,
                              color: _appRating >= 5 ? Colors.amber : Colors.grey,
                            ),
                            onTap: () => rateApp(5),
                          )
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig.screenHeight * 0.05,
                      ),
                      SizedBox(
                        height: SizeConfig.screenHeight * 0.15,
                        width: SizeConfig.screenWidth * 0.55,
                        child: DescriptionTextField(
                          ValueKey('description'),
                          commentController,
                          'التعليق',
                          TextInputType.text,
                          (value) {
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.screenHeight * 0.02,
                      ),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "تقييم لاحقا !",
                            style: TextStyles.h3.copyWith(
                              color: Color(0xffFF0000),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.screenHeight * 0.02,
                      ),
                      SizedBox(
                        height: SizeConfig.screenHeight * 0.09,
                        width: SizeConfig.screenWidth * 0.55,
                        child: BasicButton(
                          buttonName: "تقييم",
                          onPressedFunction: () {
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
                                        height: SizeConfig.screenHeight * 0.55,
                                        decoration:
                                            BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.white),
                                        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: SizeConfig.screenHeight * 0.02,
                                            ),
                                            Icon(
                                              Icons.circle_notifications_outlined,
                                              color: Color(0xffE2C069),
                                              size: 40,
                                            ),
                                            SizedBox(
                                              height: SizeConfig.screenHeight * 0.02,
                                            ),
                                            Text(
                                              "تم التآكيد !",
                                              style: TextStyles.h2,
                                            ),
                                            SizedBox(
                                              height: SizeConfig.screenHeight * 0.02,
                                            ),
                                            SizedBox(
                                              width: SizeConfig.screenWidth * 0.8,
                                              child: Text(
                                                "تم التآكيد وتسجيل اجاباتك بنجاح برجاء الانتظار حتي يتم التآكيد من مقدم الخدمه.",
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
                                              height: SizeConfig.screenHeight * 0.02,
                                            ),
                                            SizedBox(
                                              height: SizeConfig.screenHeight * 0.09,
                                              width: SizeConfig.screenWidth * 0.9,
                                              child: BasicButton(
                                                  buttonName: "الرئيسيه",
                                                  onPressedFunction: () async {
                                                    await BlocProvider.of<ServicesCubit>(context).rateAndCOmment(
                                                        _pref.getString('userToken')!,
                                                        (widget.lawyerId == 0) ? '' : widget.lawyerId!.toString(),
                                                        _lawyerRating.toString(),
                                                        _serviceRating.toString(),
                                                        _appRating.toString(),
                                                        commentController.text);
                                                    Navigator.pop(context);
                                                  }),
                                            ),
                                            SizedBox(
                                              height: SizeConfig.screenHeight * 0.02,
                                            ),
                                            SizedBox(
                                              height: SizeConfig.screenHeight * 0.09,
                                              width: SizeConfig.screenWidth * 0.9,
                                              child: TextButton(
                                                  child: Text(
                                                    "الغاء",
                                                    style: TextStyles.h2Bold.copyWith(color: Colors.black),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context);
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
                          },
                        ),
                      ),
                    ],
                  ),
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
