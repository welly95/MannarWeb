import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mannar_web/bloc/country/country_cubit.dart';
import 'package:mannar_web/bloc/lawyer/lawyer_cubit.dart';
import 'package:mannar_web/bloc/service_provider/service_provider_cubit.dart';
import 'package:mannar_web/bloc/services/services_cubit.dart';
import 'package:mannar_web/bloc/user/user_cubit.dart';
import 'package:mannar_web/models/aboutUsModel.dart';
import 'package:mannar_web/models/filter_data.dart';
import 'package:mannar_web/models/lawyers.dart';
import 'package:mannar_web/repository/countries_repository.dart';
import 'package:mannar_web/repository/lawyer_repository.dart';
import 'package:mannar_web/repository/service_provider_repository.dart';
import 'package:mannar_web/repository/services_repository.dart';
import 'package:mannar_web/repository/user_repository.dart';
import 'package:mannar_web/screens/aboutUs/about_us.dart';
import 'package:mannar_web/screens/chat/chats_page.dart';
import 'package:mannar_web/screens/contactUS/contact_us.dart';
import 'package:mannar_web/screens/home/home_screen.dart';
import 'package:mannar_web/screens/lawyer/search_lawyer.dart';
import 'package:mannar_web/screens/profile/profile_information.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../bloc/qna/qna_cubit.dart';
import '../../constants/size_config.dart';
import '../../constants/styles.dart';
import '../../repository/qna_repository.dart';
import '../../repository/web_services.dart';
import '../../widgets/grid_of_gride_service/QNA_grid.dart';
import 'package:flutter/material.dart';

class QNAScreen extends StatelessWidget {
  final List<Lawyer> _lawyersList;
  final FilterData _filterData;
  final AboutUsModel _aboutUsModel;

  QNAScreen(this._aboutUsModel, this._filterData, this._lawyersList);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
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
                            _aboutUsModel.phone!,
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
                            _aboutUsModel.email!,
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
                              launch(_aboutUsModel.facebook!);
                            },
                            icon: Icon(
                              FontAwesomeIcons.facebookF,
                              color: Colors.teal,
                            ),
                          ),
                          SizedBox(width: SizeConfig.screenWidth * 0.01),
                          IconButton(
                            onPressed: () {
                              launch(_aboutUsModel.twitter!);
                            },
                            icon: Icon(
                              FontAwesomeIcons.twitter,
                              color: Colors.teal,
                            ),
                          ),
                          SizedBox(width: SizeConfig.screenWidth * 0.01),
                          IconButton(
                            onPressed: () {
                              launch(_aboutUsModel.linkedIn!);
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
                                      BlocProvider(create: (context) => ServicesCubit(ServicesRepo(WebServices()))),
                                    ],
                                    child: ProfileInfromation(false, _aboutUsModel, _filterData, _lawyersList),
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
                                    child: ContactUs(_lawyersList, _filterData, _aboutUsModel),
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
                                    child: AboutUs(_lawyersList, _filterData, _aboutUsModel),
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
                                  builder: (context) => ChatsPage(_aboutUsModel, _filterData, _lawyersList),
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
                                    child: SearchLawyer(_filterData, _lawyersList, _aboutUsModel),
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.04),
                  child: Align(
                    alignment: Alignment.centerLeft,
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
                ),
                Container(
                  width: SizeConfig.screenWidth * 0.55,
                  height: SizeConfig.screenHeight * 0.65,
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topRight,
                        child: Text(
                          'اسئله وآجوبه',
                          style: TextStyles.h2Bold.copyWith(fontSize: 24),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.screenHeight * 0.02,
                      ),
                      Container(
                        width: SizeConfig.screenWidth * 0.55,
                        child: BlocProvider(
                          lazy: false,
                          create: (context) => QnaCubit(QNARepository(WebServices())),
                          child: QNAGrid(),
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
                                    _aboutUsModel.email!,
                                    style: TextStyles.h2.copyWith(color: Colors.white),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        _aboutUsModel.whatsapp!,
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
                                              launch(_aboutUsModel.facebook!);
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
                                              launch(_aboutUsModel.twitter!);
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
                                              launch(_aboutUsModel.linkedIn!);
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
                                          child: ContactUs(_lawyersList, _filterData, _aboutUsModel),
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
                                          child: AboutUs(_lawyersList, _filterData, _aboutUsModel),
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
                                        builder: (context) => ChatsPage(_aboutUsModel, _filterData, _lawyersList),
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
                                          child: SearchLawyer(_filterData, _lawyersList, _aboutUsModel),
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
      ),
    );
  }
}
