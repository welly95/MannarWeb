// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mannar_web/bloc/country/country_cubit.dart';
import 'package:mannar_web/bloc/lawyer/lawyer_cubit.dart';
import 'package:mannar_web/bloc/service_provider/service_provider_cubit.dart';
import 'package:mannar_web/bloc/services/services_cubit.dart';
import 'package:mannar_web/bloc/user/user_cubit.dart';
import 'package:mannar_web/constants/styles.dart';
import 'package:mannar_web/models/aboutUsModel.dart';
import 'package:mannar_web/models/filter_data.dart';
import 'package:mannar_web/models/lawyers.dart';
import 'package:mannar_web/repository/booking_repository.dart';
import 'package:mannar_web/repository/countries_repository.dart';
import 'package:mannar_web/repository/lawyer_repository.dart';
import 'package:mannar_web/repository/service_provider_repository.dart';
import 'package:mannar_web/repository/services_repository.dart';
import 'package:mannar_web/repository/user_repository.dart';
import 'package:mannar_web/repository/web_services.dart';
import 'package:mannar_web/screens/aboutUs/about_us.dart';
import 'package:mannar_web/screens/chat/chats_page.dart';
import 'package:mannar_web/screens/contactUS/contact_us.dart';
import 'package:mannar_web/screens/home/home_screen.dart';
import 'package:mannar_web/screens/lawyer/search_lawyer.dart';
import 'package:mannar_web/screens/profile/profile_information.dart';
import 'package:mannar_web/widgets/textfields/number_textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../bloc/booking/booking_cubit.dart';
import '../../constants/size_config.dart';
import '../../screens/home/sub_departments_screen.dart';
import '../../screens/lawyer/lawyer_screen.dart';
import '../../widgets/buttons/basic_button.dart';
import '../../widgets/textfields/basic_textfield.dart';

class CourtQuestion extends StatefulWidget {
  final question;
  final mainDepartmentId;
  final mainDepartmentName;
  final courtName;
  final courtId;
  final bool hasSubServices;
  final bool hasLawyers;
  final bool hasQuestions;
  final List chatArray;
  final String pay;
  final int price;
  final List<Lawyer> _lawyersList;
  final FilterData _filterData;
  final AboutUsModel _aboutUsModel;

  const CourtQuestion(
    this.question,
    this.mainDepartmentId,
    this.mainDepartmentName,
    this.courtName,
    this.courtId,
    this.hasSubServices,
    this.hasLawyers,
    this.hasQuestions,
    this.chatArray,
    this.pay,
    this.price,
    this._lawyersList,
    this._filterData,
    this._aboutUsModel,
  );

  @override
  _CourtQuestionState createState() => _CourtQuestionState();
}

class _CourtQuestionState extends State<CourtQuestion> {
  TextEditingController _controller = TextEditingController();
  TextEditingController _verifyController = TextEditingController();
  late SharedPreferences _pref;
  @override
  void initState() {
    _controller.clear();
    _verifyController.clear();
    Future.delayed(Duration(seconds: 0)).then((_) async => _pref = await SharedPreferences.getInstance());

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
                                    BlocProvider(create: (context) => ServicesCubit(ServicesRepo(WebServices()))),
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
              Container(
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.04),
                child: Column(
                  children: [
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.02,
                    ),
                    Container(
                      height: SizeConfig.screenHeight * 0.07,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: SizeConfig.screenWidth * 0.2,
                              height: SizeConfig.screenHeight * 0.07,
                              child: Card(
                                color: Colors.teal[700],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        widget.mainDepartmentName,
                                        style: TextStyles.h1,
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                        },
                                        icon: Icon(
                                          Icons.cancel,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: SizeConfig.screenWidth * 0.02,
                            ),
                            Container(
                              width: SizeConfig.screenWidth * 0.2,
                              height: SizeConfig.screenHeight * 0.07,
                              child: Card(
                                color: Colors.teal[700],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        widget.courtName,
                                        style: TextStyles.h1,
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                        },
                                        icon: Icon(
                                          Icons.cancel,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: SizeConfig.screenWidth * 0.02,
                            ),
                            Container(
                              width: SizeConfig.screenWidth * 0.2,
                              height: SizeConfig.screenHeight * 0.07,
                              child: Card(
                                color: Colors.teal[700],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'سؤال المحكمة',
                                        style: TextStyles.h1,
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        icon: Icon(
                                          Icons.cancel,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
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
                            "من فضلك أجب علي سؤال المحكمة",
                            style: TextStyles.h2Bold.copyWith(fontSize: 24),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.04,
                    ),
                    Container(
                      height: SizeConfig.screenHeight * 0.12,
                      width: SizeConfig.screenWidth * 0.55,
                      child: BasicTextField(
                        ValueKey(
                          widget.question,
                        ),
                        _controller,
                        widget.question,
                        TextInputType.text,
                        (value) {
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.08,
                      width: SizeConfig.screenWidth * 0.55,
                      child: BasicButton(
                        buttonName: "تآكيد",
                        onPressedFunction: () async {
                          if (_controller.text.trim() == null || _controller.text.trim() == '') {
                            Fluttertoast.showToast(
                              msg: 'من فضلك أجب علي سؤال المحكمة',
                              gravity: ToastGravity.TOP,
                              toastLength: Toast.LENGTH_LONG,
                              timeInSecForIosWeb: 5,
                            );
                          } else {
                            if (widget.hasSubServices) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => SubDepartmentsScreen(
                                    widget.mainDepartmentId,
                                    widget.mainDepartmentName,
                                    widget.courtId,
                                    widget.courtName,
                                    true,
                                    _controller.text,
                                    widget.chatArray,
                                    widget.hasLawyers,
                                    widget.hasQuestions,
                                    widget.pay,
                                    widget.price,
                                    widget._lawyersList,
                                    widget._filterData,
                                    widget._aboutUsModel,
                                  ),
                                ),
                              );
                            } else if (!widget.hasSubServices && widget.hasLawyers) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => LawyerScreen(
                                    true,
                                    widget.mainDepartmentId,
                                    widget.mainDepartmentName,
                                    '',
                                    0,
                                    widget.courtName,
                                    widget.courtId,
                                    true,
                                    _controller.text.trim(),
                                    widget.chatArray,
                                    widget.pay,
                                    widget._lawyersList,
                                    widget._filterData,
                                    widget._aboutUsModel,
                                  ),
                                ),
                              );
                            } else {
                              BlocProvider.of<BookingCubit>(context).bookingServiceWithoutLawyers(
                                _pref.getString('userToken')!,
                                widget.mainDepartmentId.toString(),
                                widget.courtId.toString(),
                                '',
                                _controller.text.trim(),
                                [],
                              ).then(
                                (value) => launch(
                                  value,
                                  enableJavaScript: true,
                                ),
                              );
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                useRootNavigator: true,
                                useSafeArea: false,
                                builder: (context) => BlocProvider(
                                  create: (_) => BookingCubit(BookingRepository(WebServices())),
                                  child: StatefulBuilder(
                                    builder: (context, setStateDialog) => Dialog(
                                      backgroundColor: Colors.transparent,
                                      insetPadding: EdgeInsets.all(10),
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: <Widget>[
                                          Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: Container(
                                              width: SizeConfig.screenWidth * 0.35,
                                              height: SizeConfig.screenHeight * 0.4,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(15), color: Colors.white),
                                              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Align(
                                                    alignment: Alignment.topLeft,
                                                    child: IconButton(
                                                      icon: Icon(Icons.arrow_back, color: Colors.teal),
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                    ),
                                                  ),
                                                  Text(
                                                    'ادخل رمز تآكيد عملية الدفع حتي يتم الحجز',
                                                    style: TextStyles.h2Bold,
                                                  ),
                                                  SizedBox(
                                                    height: SizeConfig.screenHeight * 0.02,
                                                  ),
                                                  SizedBox(
                                                    height: SizeConfig.screenHeight * 0.1,
                                                    width: SizeConfig.screenWidth * 0.3,
                                                    child: NumberTextField(
                                                      ValueKey('verify'),
                                                      _verifyController,
                                                      'رمز تآكيد الدفع',
                                                      (val) {
                                                        return null;
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: SizeConfig.screenHeight * 0.02,
                                                  ),
                                                  SizedBox(
                                                    height: SizeConfig.screenHeight * 0.08,
                                                    width: SizeConfig.screenWidth * 0.55,
                                                    child: BasicButton(
                                                      buttonName: "تآكيد",
                                                      onPressedFunction: () async {
                                                        print(_verifyController.text.trim() +
                                                            '-----' +
                                                            _pref.getString('bookingId')!);
                                                        await BlocProvider.of<BookingCubit>(context)
                                                            .verifyServicePayment(
                                                          _pref.getString('userToken')!,
                                                          _pref.getString('bookingId')!,
                                                          _verifyController.text.trim(),
                                                        )
                                                            .then((value) {
                                                          print(value);
                                                          if (value == true) {
                                                            Fluttertoast.showToast(
                                                                msg: 'تم الحجز بنجاح',
                                                                gravity: ToastGravity.TOP,
                                                                toastLength: Toast.LENGTH_LONG,
                                                                timeInSecForIosWeb: 5);
                                                            Navigator.of(context).pushAndRemoveUntil(
                                                                MaterialPageRoute(builder: (context) => HomeScreen()),
                                                                (route) => false);
                                                          } else {
                                                            Fluttertoast.showToast(
                                                                msg: 'الرمز الذي ادخلته غير صحيح',
                                                                gravity: ToastGravity.TOP,
                                                                toastLength: Toast.LENGTH_LONG,
                                                                timeInSecForIosWeb: 5);
                                                          }
                                                        });
                                                      },
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
                                ),
                              );
                            }
                          }
                        },
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
