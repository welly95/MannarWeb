import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mannar_web/bloc/booking/booking_cubit.dart';
import 'package:mannar_web/bloc/cities/cities_cubit.dart';
import 'package:mannar_web/bloc/country/country_cubit.dart';
import 'package:mannar_web/bloc/service_provider/service_provider_cubit.dart';
import 'package:mannar_web/bloc/user/user_cubit.dart';
import 'package:mannar_web/models/aboutUsModel.dart';
import 'package:mannar_web/models/rateService.dart';
import 'package:mannar_web/repository/booking_repository.dart';
import 'package:mannar_web/repository/cities_repository.dart';
import 'package:mannar_web/repository/countries_repository.dart';
import 'package:mannar_web/repository/service_provider_repository.dart';
import 'package:mannar_web/repository/user_repository.dart';
import 'package:mannar_web/screens/aboutUs/about_us.dart';
import 'package:mannar_web/screens/chat/chats_page.dart';
import 'package:mannar_web/screens/contactUS/contact_us.dart';
import 'package:mannar_web/screens/lawyer/lawyer_profile.dart';
import 'package:mannar_web/screens/profile/profile_information.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/filter_data.dart';
import '../../models/lawyers.dart';
import '../../models/sliders.dart';

import '../../bloc/lawyer/lawyer_cubit.dart';
import '../../bloc/services/services_cubit.dart';
import '../../repository/lawyer_repository.dart';
import '../../repository/services_repository.dart';
import '../../bloc/main_departments/main_departments_cubit.dart';
import '../../constants/size_config.dart';
import '../../constants/styles.dart';
import '../../repository/main_departments_repository.dart';
import '../../repository/web_services.dart';
import '../../screens/lawyer/search_lawyer.dart';
import '../../widgets/carousel_slider.dart';
import '../../widgets/grid_of_gride_service/main_departments_grid.dart';

class HomeScreen extends StatefulWidget {
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  TextEditingController emailController = TextEditingController();
  late FilterData _filterData;
  late List<Lawyer> _lawyersList;
  late List<Sliders> _slidersList;
  late AboutUsModel _aboutUsModel;
  List<RateService> _rateServiceList = [];
  @override
  void initState() {
    Future.delayed(Duration(seconds: 0)).then((_) async {
      _filterData = await BlocProvider.of<ServicesCubit>(context).getFilterData();
      _lawyersList = await BlocProvider.of<LawyerCubit>(context).getLawyersList('');
      _slidersList = await BlocProvider.of<ServicesCubit>(context).getSliders();
      _aboutUsModel = await BlocProvider.of<ServicesCubit>(context).getAboutUs();
      _rateServiceList = await BlocProvider.of<ServicesCubit>(context).getRateServices();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return BlocBuilder<ServicesCubit, ServicesState>(
      builder: (context, state) {
        if (state is GetAboutUsState || state is GetRateServicesState) {
          return BlocBuilder<ServicesCubit, ServicesState>(
            builder: (context, stateRate) {
              if (stateRate is GetRateServicesState) {
                return AnnotatedRegion<SystemUiOverlayStyle>(
                  value: SystemUiOverlayStyle.dark,
                  child: SafeArea(
                    bottom: false,
                    child: Scaffold(
                      body: SingleChildScrollView(
                        child: GestureDetector(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
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
                                                      create: (BuildContext context) => ServiceProviderCubit(
                                                          ServiceProviderRepository(WebServices())),
                                                    ),
                                                    BlocProvider(
                                                        create: (context) =>
                                                            ServicesCubit(ServicesRepo(WebServices()))),
                                                  ],
                                                  child: ProfileInfromation(
                                                      false, _aboutUsModel, _filterData, _lawyersList),
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
                                                builder: (context) =>
                                                    ChatsPage(_aboutUsModel, _filterData, _lawyersList),
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
                                          onPressed: null,
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
                                padding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.04),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: SizeConfig.screenHeight * 0.45,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            height: SizeConfig.screenHeight * 0.45,
                                            width: SizeConfig.screenWidth * 0.5,
                                            child: CarouselSliderWidget(_slidersList),
                                          ),
                                          Container(
                                            width: SizeConfig.screenWidth * 0.40,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'احجز استشارتك الآن و تكلم مع محاميين بخبرات كبيرة',
                                                  style: TextStyles.h2Bold.copyWith(fontSize: 25),
                                                  textAlign: TextAlign.right,
                                                ),
                                                SizedBox(
                                                  height: SizeConfig.screenHeight * 0.02,
                                                ),
                                                Container(
                                                  child: Text(
                                                    'لوريم ايبسوم هو نموذج افتراضي يوضع في التصاميم لتعرض على العميل ليتصور طريقه وضع النصوص بالتصاميم سواء كانت تصاميم مطبوعه ... بروشور او فلاير على سبيل المثال ... او نماذج مواقع انترنت ...',
                                                    style: TextStyles.textFieldsLabels.copyWith(fontSize: 20),
                                                    textAlign: TextAlign.center,
                                                    overflow: TextOverflow.clip,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: SizeConfig.screenHeight * 0.04,
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        width: SizeConfig.screenWidth * 0.35,
                                        height: SizeConfig.screenHeight * 0.08,
                                        child: GestureDetector(
                                          onTap: () {
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
                                          child: Stack(
                                            children: [
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Container(
                                                  width: SizeConfig.screenWidth * 0.08,
                                                  height: SizeConfig.screenHeight * 0.1,
                                                  margin: EdgeInsets.symmetric(vertical: 2),
                                                  decoration: BoxDecoration(
                                                      color: Colors.teal,
                                                      borderRadius: BorderRadius.all(Radius.circular(10))),
                                                  child: Center(
                                                    child: Text(
                                                      'ابحث',
                                                      style: TextStyles.h2Bold.copyWith(color: Colors.white),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.centerRight,
                                                child: Container(
                                                  width: SizeConfig.screenWidth * 0.28,
                                                  child: TextFormField(
                                                    autofocus: false,
                                                    textAlignVertical: TextAlignVertical.center,
                                                    textAlign: TextAlign.right,
                                                    maxLines: 1,
                                                    enabled: false,
                                                    cursorColor: Colors.grey,
                                                    keyboardType: TextInputType.text,
                                                    style: GoogleFonts.elMessiri(color: Colors.black, fontSize: 16.0),
                                                    decoration: InputDecoration(
                                                        hintStyle: GoogleFonts.elMessiri(
                                                            color: const Color(0xff03564C), fontSize: 13.0),
                                                        border: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(10.0),
                                                          borderSide: BorderSide(color: Colors.grey),
                                                        ),
                                                        fillColor: Colors.grey[200],
                                                        filled: true,
                                                        hintText: '..ابحث عن محامي',
                                                        suffixIcon: Icon(
                                                          FontAwesomeIcons.search,
                                                          color: Colors.teal,
                                                        )),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: SizeConfig.screenHeight * 0.02,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "الخدمات",
                                            style: TextStyles.h2Bold.copyWith(fontSize: 24),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: SizeConfig.screenHeight * 0.04,
                                    ),
                                    MultiBlocProvider(
                                      providers: [
                                        BlocProvider(
                                          create: (context) => MainDepartmentsCubit(
                                            MainDepartmentsRepository(
                                              WebServices(),
                                            ),
                                          ),
                                        ),
                                        BlocProvider(
                                          create: (context) => BookingCubit(BookingRepository(WebServices())),
                                        ),
                                      ],
                                      child: MainDepartmentsGrid(
                                        _lawyersList,
                                        _filterData,
                                        _aboutUsModel,
                                      ),
                                    ),
                                    SizedBox(
                                      height: SizeConfig.screenHeight * 0.02,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
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
                                              "مشاهده المزيد",
                                              style: TextStyles.h2.copyWith(fontSize: 20),
                                            ),
                                          ),
                                          Text(
                                            "المحاميين",
                                            style: TextStyles.h2Bold.copyWith(fontSize: 24),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: SizeConfig.screenHeight * 0.04,
                                    ),
                                    Container(
                                      height: SizeConfig.screenHeight * 0.35,
                                      width: SizeConfig.screenWidth * 0.85,
                                      child: Center(
                                        child: ListView.separated(
                                          separatorBuilder: (BuildContext context, int index) {
                                            return SizedBox(width: SizeConfig.screenWidth * 0.02);
                                          },
                                          itemCount: (_lawyersList.length >= 4) ? 4 : _lawyersList.length,
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) => MultiBlocProvider(
                                                      providers: [
                                                        BlocProvider(
                                                          create: (context) => CountryCubit(
                                                            CountriesRepository(
                                                              WebServices(),
                                                            ),
                                                          ),
                                                        ),
                                                        BlocProvider(
                                                          create: (context) => CitiesCubit(
                                                            CitiesRepository(
                                                              WebServices(),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                      child: LawyerProfile(
                                                        false,
                                                        0,
                                                        _lawyersList[index],
                                                        false,
                                                        '',
                                                        '0',
                                                        [],
                                                        _lawyersList,
                                                        _filterData,
                                                        _aboutUsModel,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                width: SizeConfig.screenWidth * 0.18,
                                                child: Card(
                                                  elevation: 10,
                                                  color: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(15),
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      CircleAvatar(
                                                        backgroundImage: NetworkImage(_lawyersList[index].imageurl!),
                                                        backgroundColor: Colors.transparent,
                                                        radius: 50,
                                                      ),
                                                      SizedBox(
                                                        height: SizeConfig.screenHeight * 0.02,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Icon(
                                                            Icons.star,
                                                            color: Color(0xffF7CC19),
                                                          ),
                                                          SizedBox(width: SizeConfig.screenWidth * 0.005),
                                                          Text(
                                                            (_lawyersList[index].rate == 0.0)
                                                                ? ''
                                                                : (_lawyersList[index].rate!).toString(),
                                                            style: TextStyles.h4.copyWith(
                                                              color: Color(0xffF7CC19),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: SizeConfig.screenHeight * 0.01,
                                                      ),
                                                      Text(
                                                        _lawyersList[index].name!,
                                                        style: TextStyles.h2,
                                                      ),
                                                      SizedBox(
                                                        height: SizeConfig.screenHeight * 0.01,
                                                      ),
                                                      Text(
                                                        _lawyersList[index].internalExternal!,
                                                        style: TextStyles.h2,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: SizeConfig.screenHeight * 0.04,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "اراء العملاء",
                                            style: TextStyles.h2Bold.copyWith(fontSize: 24),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: SizeConfig.screenHeight * 0.04,
                                    ),
                                    Container(
                                      height: SizeConfig.screenHeight * 0.5,
                                      child: Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: Wrap(
                                          runSpacing: 2,
                                          spacing: 2,
                                          alignment: WrapAlignment.center,
                                          direction: Axis.horizontal,
                                          children: List.generate(
                                            _rateServiceList.length,
                                            (index) {
                                              return (_rateServiceList[index].comment == null)
                                                  ? Container()
                                                  : Container(
                                                      width: SizeConfig.screenWidth * 0.25,
                                                      margin: EdgeInsets.all(10),
                                                      child: Card(
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(15),
                                                          side: BorderSide(
                                                            color: Colors.grey,
                                                            width: 1,
                                                          ),
                                                        ),
                                                        color: Colors.white,
                                                        elevation: 10,
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(10),
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                (_rateServiceList[index].comment == null)
                                                                    ? ''
                                                                    : _rateServiceList[index].comment!,
                                                                style: TextStyles.h3,
                                                                textAlign: TextAlign.center,
                                                              ),
                                                              SizedBox(
                                                                height: SizeConfig.screenHeight * 0.02,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Column(
                                                                    children: [
                                                                      Text(
                                                                        (_rateServiceList[index].user != null)
                                                                            ? _rateServiceList[index].user!.name!
                                                                            : '',
                                                                        textAlign: TextAlign.right,
                                                                        style: TextStyles.h3
                                                                            .copyWith(fontSize: 16, color: Colors.teal),
                                                                      ),
                                                                      SizedBox(
                                                                        height: SizeConfig.screenHeight * 0.005,
                                                                      ),
                                                                      Text(
                                                                        'عميل',
                                                                        textAlign: TextAlign.right,
                                                                        style: TextStyles.textFieldsLabels,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  RatingBar(
                                                                    itemSize: 15,
                                                                    ratingWidget: RatingWidget(
                                                                      full: Icon(
                                                                        Icons.star,
                                                                        color: Colors.yellow,
                                                                      ),
                                                                      half: Icon(
                                                                        Icons.star_half,
                                                                        color: Colors.yellow,
                                                                      ),
                                                                      empty: Icon(
                                                                        Icons.star_border,
                                                                        color: Colors.grey,
                                                                      ),
                                                                    ),
                                                                    onRatingUpdate: (update) {},
                                                                    allowHalfRating: true,
                                                                    initialRating:
                                                                        _rateServiceList[index].rate!.toDouble(),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: SizeConfig.screenHeight * 0.04,
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
                                                      builder: (context) =>
                                                          ChatsPage(_aboutUsModel, _filterData, _lawyersList),
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
                                                onPressed: null,
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
                  ),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
