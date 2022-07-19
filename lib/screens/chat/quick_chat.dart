import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mannar_web/screens/chat/quick_chat_messages_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../bloc/booking/booking_cubit.dart';
import '../../bloc/country/country_cubit.dart';
import '../../bloc/lawyer/lawyer_cubit.dart';
import '../../bloc/service_provider/service_provider_cubit.dart';
import '../../bloc/services/services_cubit.dart';
import '../../bloc/user/user_cubit.dart';
import '../../constants/size_config.dart';
import '../../constants/styles.dart';
import '../../models/aboutUsModel.dart';
import '../../models/filter_data.dart';
import '../../models/lawyers.dart';
import '../../repository/booking_repository.dart';
import '../../repository/countries_repository.dart';
import '../../repository/lawyer_repository.dart';
import '../../repository/service_provider_repository.dart';
import '../../repository/services_repository.dart';
import '../../repository/user_repository.dart';
import '../../repository/web_services.dart';
import '../../widgets/buttons/basic_button.dart';
import '../../widgets/textfields/number_textfield.dart';
import '../aboutUs/about_us.dart';
import '../contactUS/contact_us.dart';
import '../home/home_screen.dart';
import '../lawyer/search_lawyer.dart';
import '../profile/profile_information.dart';

class QuickChat extends StatefulWidget {
  final List<Lawyer> lawyersList;
  final FilterData filterData;
  final AboutUsModel aboutUsModel;

  QuickChat(this.aboutUsModel, this.filterData, this.lawyersList);
  @override
  State<QuickChat> createState() => _QuickChatState();
}

class _QuickChatState extends State<QuickChat> {
  late SharedPreferences _pref;
  bool statusOfQuickChat = false;
  TextEditingController _verifyController = TextEditingController();
  @override
  void initState() {
    Future.delayed(Duration(seconds: 0)).then((_) async {
      _pref = await SharedPreferences.getInstance();
      BlocProvider.of<UserCubit>(context).getAvailableLawyers(_pref.getString('userToken')!).then((value) {
        if (value.id != 0) {
          setState(() {
            statusOfQuickChat = true;
          });
          return statusOfQuickChat;
        } else if (value.id == 0) {
          statusOfQuickChat = false;
          return statusOfQuickChat;
        }
      });
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
                width: SizeConfig.screenWidth * 0.45,
                child: Stack(
                  children: [
                    Container(
                      height: SizeConfig.screenHeight * 0.35,
                      width: SizeConfig.screenWidth * 0.45,
                      child: Image.asset(
                        'assets/images/Group13112.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(Icons.arrow_back_ios_new),
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    (statusOfQuickChat)
                        ? Container(
                            height: SizeConfig.screenHeight * 0.9,
                            width: SizeConfig.screenWidth * 0.95,
                            alignment: Alignment.topCenter,
                            child: BlocBuilder<UserCubit, UserState>(
                              builder: (context, state) {
                                if (state is GetAvailableLawyersState) {
                                  if (state.lawyer.id == 0) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 190.0),
                                      child: Container(
                                        height: SizeConfig.screenHeight * 0.99,
                                        width: SizeConfig.screenWidth * 0.95,
                                        alignment: Alignment.center,
                                        child: Image.asset(
                                          "assets/images/Group13118.png",
                                          height: SizeConfig.screenHeight * 0.50,
                                          width: SizeConfig.screenWidth * 0.50,
                                        ),
                                      ),
                                    );
                                  } else {
                                    // timer(state.lawyerId.toString());
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        top: SizeConfig.screenHeight * 0.35,
                                      ),
                                      child: InkWell(
                                        onTap: () async {
                                          _pref.setString('lawyerId', state.lawyer.id!.toString());
                                          await BlocProvider.of<BookingCubit>(context).bookingServiceWithoutLawyers(
                                            _pref.getString('userToken')!,
                                            _pref.getInt('mainId')!.toString(),
                                            '',
                                            '',
                                            '',
                                            [],
                                          ).then(
                                            (value) {
                                              if (value.startsWith('https://')) {
                                                launch(
                                                  value,
                                                  enableJavaScript: true,
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
                                                                    borderRadius: BorderRadius.circular(15),
                                                                    color: Colors.white),
                                                                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: [
                                                                    Align(
                                                                      alignment: Alignment.topLeft,
                                                                      child: IconButton(
                                                                        icon: Icon(Icons.cancel, color: Colors.teal),
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
                                                                              Navigator.of(context)
                                                                                  .pushReplacement(MaterialPageRoute(
                                                                                builder: (context) => BlocProvider(
                                                                                  create: (context) => UserCubit(
                                                                                    UserRepository(
                                                                                      WebServices(),
                                                                                    ),
                                                                                  ),
                                                                                  child: QuickChatMessagesScreen(
                                                                                    widget.aboutUsModel,
                                                                                    widget.filterData,
                                                                                    widget.lawyersList,
                                                                                  ),
                                                                                ),
                                                                              ));
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
                                              } else {
                                                Fluttertoast.showToast(
                                                  msg: value,
                                                  gravity: ToastGravity.TOP,
                                                  toastLength: Toast.LENGTH_LONG,
                                                );
                                              }
                                            },
                                          );
                                        },
                                        highlightColor: Colors.teal,
                                        focusColor: Colors.teal,
                                        hoverColor: Colors.teal,
                                        borderRadius: BorderRadius.circular(10.0),
                                        child: Container(
                                          width: SizeConfig.screenWidth * 0.9,
                                          height: SizeConfig.screenHeight * 0.1,
                                          color: Colors.transparent,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey[300]!,
                                                width: 1,
                                              ),
                                              color: Colors.transparent,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10.0),
                                              ),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Icon(
                                                        Icons.star,
                                                        color: Color(0xffF7CC19),
                                                      ),
                                                      Text(
                                                        (state.lawyer.rate == 0.0)
                                                            ? ''
                                                            : (state.lawyer.rate).toString(),
                                                        style: TextStyles.h4.copyWith(
                                                          color: Color(0xffF7CC19),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        children: [
                                                          Container(
                                                            alignment: Alignment.topRight,
                                                            child: Text(
                                                              state.lawyer.name!,
                                                              style: TextStyles.h3,
                                                            ),
                                                          ),
                                                          Container(
                                                            //alignment: Alignment.topRight,
                                                            child: Text(
                                                              state.lawyer.type!,
                                                              style: TextStyles.h3,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        width: SizeConfig.screenWidth * 0.04,
                                                      ),
                                                      CircleAvatar(
                                                        radius: 30,
                                                        backgroundColor: Colors.transparent,
                                                        backgroundImage: NetworkImage(
                                                          state.lawyer.imageurl!,
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
                                  }
                                } else {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 190.0),
                                    child: Container(
                                      height: SizeConfig.screenHeight * 0.99,
                                      width: SizeConfig.screenWidth * 0.95,
                                      alignment: Alignment.center,
                                      child: Image.asset(
                                        "assets/images/Group13119.png",
                                        height: SizeConfig.screenHeight * 0.50,
                                        width: SizeConfig.screenWidth * 0.50,
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          )
                        : Container(
                            height: SizeConfig.screenHeight * 0.99,
                            width: SizeConfig.screenWidth * 0.95,
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 190.0),
                              child: Container(
                                height: SizeConfig.screenHeight * 0.99,
                                width: SizeConfig.screenWidth * 0.95,
                                alignment: Alignment.center,
                                child: Image.asset(
                                  "assets/images/Group13118.png",
                                  height: SizeConfig.screenHeight * 0.50,
                                  width: SizeConfig.screenWidth * 0.50,
                                ),
                              ),
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
