import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mannar_web/bloc/country/country_cubit.dart';
import 'package:mannar_web/bloc/lawyer/lawyer_cubit.dart';
import 'package:mannar_web/bloc/service_provider/service_provider_cubit.dart';
import 'package:mannar_web/bloc/services/services_cubit.dart';
import 'package:mannar_web/bloc/user/user_cubit.dart';
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
import 'package:mannar_web/screens/profile/profile_information.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../bloc/booking/booking_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../bloc/sub_departments/sub_departments_cubit.dart';
import '../../constants/size_config.dart';
import '../../constants/styles.dart';
import '../../widgets/buttons/basic_button.dart';
import '../../widgets/textfields/basic_textfield.dart';
import '../../widgets/textfields/number_textfield.dart';

class ReservationScreen extends StatefulWidget {
  final String? appointmentId;
  final String? appointmentDate;
  final String? courtAnswer;
  final String? lawyerId;
  final String? lawyerName;
  final String? lawyerUrlImage;
  final String? pay;
  final String? wayToCommunicate;
  final bool? fromCourt;
  final bool? hasLawyers;
  final List<Lawyer> _lawyersList;
  final FilterData _filterData;
  final AboutUsModel _aboutUsModel;

  ReservationScreen(
    this._lawyersList,
    this._filterData,
    this._aboutUsModel, {
    this.appointmentId,
    this.appointmentDate,
    this.courtAnswer,
    this.lawyerId,
    this.lawyerName,
    this.lawyerUrlImage,
    this.pay,
    this.wayToCommunicate,
    this.fromCourt,
    this.hasLawyers,
  });

  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  // ignore: unused_field
  bool? _autoDirection;
  List<TextEditingController> _controllers = [];
  List<dynamic> listOfQuestions = [];
  late SharedPreferences _pref;
  List answers = [];
  TextEditingController _verifyController = TextEditingController();

  timer() async {
    await Future.delayed(Duration(seconds: 0));
    setState(() {
      _autoDirection = false;
    });
    await Future.delayed(Duration(seconds: 5));
    setState(() {
      _autoDirection = true;
      Navigator.of(context).pop();
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomeScreen()), (route) => false);
    });
  }

  @override
  void initState() {
    Future.delayed(Duration(seconds: 0)).then((_) async {
      _pref = await SharedPreferences.getInstance();
      print(
          '======>' + _pref.getInt('courtId')!.toString() + '++++++>' + _pref.getInt('index')!.toString() + '------->');
      print(widget.fromCourt);
      if (widget.fromCourt == true) {
        await BlocProvider.of<SubDepartmentsCubit>(context)
            .getQuestionsListFromCourt(_pref.getInt('courtId')!, _pref.getInt('index')!)
            .then((value) async {
          setState(() {
            listOfQuestions = value;
          });
          print('fromCourt' + value.toString());
          return value;
        });
      } else {
        // print('======>' + _pref.getInt('subId')!.toString() + '++++++>' + _pref.getInt('index')!.toString());

        await BlocProvider.of<SubDepartmentsCubit>(context)
            .getQuestionsListFromMain(_pref.getInt('mainId')!, _pref.getInt('index')!)
            .then((value) async {
          setState(() {
            listOfQuestions = value;
          });
          // if (value == []) {
          //   await BlocProvider.of<BookingCubit>(context)
          //       .bookingService(
          //           _pref.getString('userToken')!,
          //           widget.appointmentId,
          //           widget.lawyerId,
          //           _pref.getInt('subId')!.toString(),
          //           widget.appointmentDate,
          //           widget.courtAnswer,
          //           widget.wayToCommunicate,
          //           _pref.getInt('courtId')!.toString(),
          //           answers)
          //       .then((_) {
          //     FirebaseFirestore.instance
          //         .collection('chats')
          //         .doc('chatRoom:-${_pref.getString('userId')}_to_${widget.lawyerId}')
          //         .set({
          //       'idUser': _pref.getString('userId'),
          //       'recieverId': widget.lawyerId,
          //       'name': _pref.getString('userName'),
          //       'lawyerName': widget.lawyerName,
          //       'wayToChat': widget.wayToCommunicate,
          //       'lastMessageTime': DateTime.now(),
          //     });

          //     Navigator.pop(context);
          //     timer();
          //   });
          //   print('fromSub' + value.toString());

          //   return value;
          // } else {
          return value;
          // }
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return SafeArea(
      top: false,
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
                                      create: (BuildContext context) => CountryCubit(
                                        CountriesRepository(
                                          WebServices(),
                                        ),
                                      ),
                                    ),
                                    BlocProvider(
                                      // lazy: false,
                                      create: (BuildContext context) => ServiceProviderCubit(
                                        ServiceProviderRepository(
                                          WebServices(),
                                        ),
                                      ),
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
                          onPressed: null,
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
                            Navigator.of(context).push(
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
                            );
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
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(Icons.cancel),
                        tooltip: 'إلغاء الحجز',
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.04,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        right: (SizeConfig.screenWidth * 0.1),
                        left: (SizeConfig.screenWidth * 0.1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "الأســــئلة",
                            style: TextStyles.h2Bold.copyWith(fontSize: 24),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.02,
                    ),
                    SizedBox(
                      width: SizeConfig.screenWidth * 0.55,
                      child: BlocBuilder<SubDepartmentsCubit, SubDepartmentsState>(
                        builder: (context, state) {
                          if (state is GetQuestionsFromMainState || state is GetQuestionsFromCourtState) {
                            return (listOfQuestions.isEmpty)
                                ? SizedBox(
                                    height: SizeConfig.screenHeight * 0.4,
                                    child: Text(
                                      'لا يوجد أسئلة!\n إضغط علي حفظ لتأكيد الحجز',
                                      style: TextStyles.h2Bold.copyWith(color: Colors.black),
                                      textAlign: TextAlign.center,
                                      textDirection: TextDirection.rtl,
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: listOfQuestions.length,
                                    padding: const EdgeInsets.all(10.0),
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (BuildContext context, int index) {
                                      _controllers.add(TextEditingController());
                                      return Column(
                                        children: [
                                          InkWell(
                                            onTap: () {},
                                            borderRadius: BorderRadius.circular(10),
                                            child: BasicTextField(
                                                ValueKey(
                                                  listOfQuestions[index].name,
                                                ),
                                                _controllers[index],
                                                listOfQuestions[index].name!,
                                                TextInputType.text, (value) {
                                              return null;
                                            }),
                                          ),
                                          SizedBox(
                                            height: SizeConfig.screenHeight * 0.02,
                                          )
                                        ],
                                      );
                                    });
                          } else {
                            return SizedBox(
                              height: SizeConfig.screenHeight * 0.4,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      width: SizeConfig.screenWidth * 0.55,
                      height: SizeConfig.screenHeight * 0.08,
                      child: BasicButton(
                        buttonName: "حفظ",
                        onPressedFunction: () {
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
                                            height: SizeConfig.screenHeight * 0.45,
                                            width: SizeConfig.screenWidth * 0.45,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: SizeConfig.screenHeight * 0.02,
                                                ),
                                                Icon(
                                                  Icons.shield_outlined,
                                                  color: Color(0xffE2C069),
                                                  size: 50,
                                                ),
                                                SizedBox(
                                                  height: SizeConfig.screenHeight * 0.02,
                                                ),
                                                Text(
                                                  "تم الحفظ بنجاح !",
                                                  style: TextStyles.h2,
                                                  textDirection: TextDirection.rtl,
                                                ),
                                                SizedBox(
                                                  height: SizeConfig.screenHeight * 0.02,
                                                ),
                                                SizedBox(
                                                  width: SizeConfig.screenWidth * 0.8,
                                                  child: Text(
                                                    "سوف يتم إرسال الإجابات الخاصة بك للمحامي و سوف يتم الرد عليك بأسرع وقت بالتأكيد",
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
                                                  height: SizeConfig.screenHeight * 0.08,
                                                  width: SizeConfig.screenWidth * 0.4,
                                                  child: BasicButton(
                                                    buttonName: "تآكيد",
                                                    onPressedFunction: () async {
                                                      print('subID------->' +
                                                          _pref.getInt('subId').toString() +
                                                          '******>' +
                                                          _pref.getInt('courtId')!.toString());
                                                      if ((listOfQuestions.isEmpty)) {
                                                        answers = [];
                                                      } else {
                                                        for (int i = 0; i < listOfQuestions.length; i++) {
                                                          answers.add({
                                                            'sub_question_id': listOfQuestions[i].id,
                                                            'answer': _controllers[i].text.trim(),
                                                          });
                                                        }
                                                      }
                                                      if (listOfQuestions.isNotEmpty &&
                                                          _controllers.any((element) => element.text.isEmpty)) {
                                                        return Fluttertoast.showToast(
                                                          msg: 'من فضلك أجب علي جميع الأسئلة',
                                                          gravity: ToastGravity.TOP,
                                                          toastLength: Toast.LENGTH_LONG,
                                                          timeInSecForIosWeb: 5,
                                                        );
                                                      } else {
                                                        if (widget.hasLawyers!) {
                                                          await BlocProvider.of<BookingCubit>(context).bookingService(
                                                            _pref.getString('userToken')!,
                                                            widget.appointmentId!,
                                                            widget.lawyerId!,
                                                            _pref.getInt('subId')!.toString(),
                                                            _pref.getInt('mainId')!.toString(),
                                                            widget.appointmentDate!,
                                                            widget.courtAnswer!,
                                                            widget.wayToCommunicate!,
                                                            _pref.getInt('courtId')!.toString(),
                                                            widget.pay!,
                                                            [],
                                                          ).then(
                                                            (value) {
                                                              if (value == 'success') {
                                                                FirebaseFirestore.instance
                                                                    .collection('chats')
                                                                    .doc(
                                                                        'chatRoom:-${_pref.getString('userId')}_to_${widget.lawyerId}')
                                                                    .set({
                                                                  'idUser': _pref.getString('userId'),
                                                                  'recieverId': widget.lawyerId,
                                                                  'name': _pref.getString('userName'),
                                                                  'lawyerName': widget.lawyerName,
                                                                  'urlAvatar': widget.lawyerUrlImage!,
                                                                  'wayToChat': widget.wayToCommunicate,
                                                                  'lastMessageTime': DateTime.now(),
                                                                });

                                                                Navigator.pop(context);
                                                                timer();
                                                                showDialog(
                                                                  context: context,
                                                                  barrierDismissible: false,
                                                                  useRootNavigator: true,
                                                                  useSafeArea: false,
                                                                  builder: (_) => StatefulBuilder(
                                                                    builder: (context, setStateDialog) => Dialog(
                                                                      backgroundColor: Colors.transparent,
                                                                      insetPadding: EdgeInsets.all(10),
                                                                      child: Stack(
                                                                        alignment: Alignment.center,
                                                                        children: <Widget>[
                                                                          Directionality(
                                                                            textDirection: TextDirection.rtl,
                                                                            child: Container(
                                                                              height: SizeConfig.screenHeight * 0.25,
                                                                              width: SizeConfig.screenWidth * 0.45,
                                                                              decoration: BoxDecoration(
                                                                                color: Colors.white,
                                                                                borderRadius: BorderRadius.circular(15),
                                                                              ),
                                                                              child: Column(
                                                                                children: [
                                                                                  SizedBox(
                                                                                    height:
                                                                                        SizeConfig.screenHeight * 0.02,
                                                                                  ),
                                                                                  Icon(
                                                                                    Icons.question_answer,
                                                                                    color: Color(0xffE2C069),
                                                                                    size: 40,
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height:
                                                                                        SizeConfig.screenHeight * 0.02,
                                                                                  ),
                                                                                  Text(
                                                                                    "تم التأكيد!",
                                                                                    style: TextStyles.h2,
                                                                                    textDirection: TextDirection.rtl,
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height:
                                                                                        SizeConfig.screenHeight * 0.02,
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: SizeConfig.screenWidth * 0.8,
                                                                                    child: Text(
                                                                                      'تم التآكيد و تسجيل اجابتك بنجاح، برجاء الانتظار حتي يتم التآكيد من مقدم الخدمة',
                                                                                      style: TextStyles.h3.copyWith(
                                                                                        color: Color(0xFF717171),
                                                                                      ),
                                                                                      textAlign: TextAlign.center,
                                                                                      textDirection: TextDirection.rtl,
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height:
                                                                                        SizeConfig.screenHeight * 0.02,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              } else if (value.startsWith('https://')) {
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
                                                                    create: (_) =>
                                                                        BookingCubit(BookingRepository(WebServices())),
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
                                                                                    borderRadius:
                                                                                        BorderRadius.circular(15),
                                                                                    color: Colors.white),
                                                                                padding:
                                                                                    EdgeInsets.fromLTRB(20, 20, 20, 20),
                                                                                child: Column(
                                                                                  crossAxisAlignment:
                                                                                      CrossAxisAlignment.center,
                                                                                  mainAxisAlignment:
                                                                                      MainAxisAlignment.center,
                                                                                  children: [
                                                                                    Align(
                                                                                      alignment: Alignment.topLeft,
                                                                                      child: IconButton(
                                                                                        icon: Icon(Icons.cancel,
                                                                                            color: Colors.teal),
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
                                                                                      height: SizeConfig.screenHeight *
                                                                                          0.02,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height:
                                                                                          SizeConfig.screenHeight * 0.1,
                                                                                      width:
                                                                                          SizeConfig.screenWidth * 0.3,
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
                                                                                      height: SizeConfig.screenHeight *
                                                                                          0.02,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: SizeConfig.screenHeight *
                                                                                          0.08,
                                                                                      width:
                                                                                          SizeConfig.screenWidth * 0.55,
                                                                                      child: BasicButton(
                                                                                        buttonName: "تآكيد",
                                                                                        onPressedFunction: () async {
                                                                                          print(_verifyController.text
                                                                                                  .trim() +
                                                                                              '-----' +
                                                                                              _pref.getString(
                                                                                                  'bookingId')!);
                                                                                          await BlocProvider.of<
                                                                                                  BookingCubit>(context)
                                                                                              .verifyPayment(
                                                                                            _pref.getString(
                                                                                                'userToken')!,
                                                                                            _pref.getString(
                                                                                                'bookingId')!,
                                                                                            _verifyController.text
                                                                                                .trim(),
                                                                                          )
                                                                                              .then((value) {
                                                                                            print(value);
                                                                                            if (value == true) {
                                                                                              Fluttertoast.showToast(
                                                                                                  msg: 'تم الحجز بنجاح',
                                                                                                  gravity:
                                                                                                      ToastGravity.TOP,
                                                                                                  toastLength:
                                                                                                      Toast.LENGTH_LONG,
                                                                                                  timeInSecForIosWeb:
                                                                                                      5);
                                                                                              Navigator.of(context)
                                                                                                  .pushAndRemoveUntil(
                                                                                                      MaterialPageRoute(
                                                                                                          builder:
                                                                                                              (context) =>
                                                                                                                  HomeScreen()),
                                                                                                      (route) => false);
                                                                                            } else {
                                                                                              Fluttertoast.showToast(
                                                                                                  msg:
                                                                                                      'الرمز الذي ادخلته غير صحيح',
                                                                                                  gravity:
                                                                                                      ToastGravity.TOP,
                                                                                                  toastLength:
                                                                                                      Toast.LENGTH_LONG,
                                                                                                  timeInSecForIosWeb:
                                                                                                      5);
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
                                                                  timeInSecForIosWeb: 5,
                                                                );
                                                              }
                                                            },
                                                          );
                                                        } else {
                                                          await BlocProvider.of<BookingCubit>(context)
                                                              .bookingServiceWithoutLawyers(
                                                            _pref.getString('userToken')!,
                                                            _pref.getInt('mainId')!.toString(),
                                                            _pref.getInt('courtId')!.toString(),
                                                            _pref.getInt('subId')!.toString(),
                                                            widget.courtAnswer ?? '',
                                                            answers,
                                                          )
                                                              .then(
                                                            (value) {
                                                              if (value == 'success') {
                                                                Navigator.pop(context);
                                                                timer();
                                                                showDialog(
                                                                  context: context,
                                                                  barrierDismissible: false,
                                                                  useRootNavigator: true,
                                                                  useSafeArea: false,
                                                                  builder: (_) => StatefulBuilder(
                                                                    builder: (context, setStateDialog) => Dialog(
                                                                      backgroundColor: Colors.transparent,
                                                                      insetPadding: EdgeInsets.all(10),
                                                                      child: Stack(
                                                                        alignment: Alignment.center,
                                                                        children: <Widget>[
                                                                          Directionality(
                                                                            textDirection: TextDirection.rtl,
                                                                            child: Container(
                                                                              height: SizeConfig.screenHeight * 0.25,
                                                                              width: SizeConfig.screenWidth * 0.45,
                                                                              decoration: BoxDecoration(
                                                                                color: Colors.white,
                                                                                borderRadius: BorderRadius.circular(15),
                                                                              ),
                                                                              child: Column(
                                                                                children: [
                                                                                  SizedBox(
                                                                                    height:
                                                                                        SizeConfig.screenHeight * 0.02,
                                                                                  ),
                                                                                  Icon(
                                                                                    Icons.question_answer,
                                                                                    color: Color(0xffE2C069),
                                                                                    size: 40,
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height:
                                                                                        SizeConfig.screenHeight * 0.02,
                                                                                  ),
                                                                                  Text(
                                                                                    "تم التأكيد!",
                                                                                    style: TextStyles.h2,
                                                                                    textDirection: TextDirection.rtl,
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height:
                                                                                        SizeConfig.screenHeight * 0.02,
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: SizeConfig.screenWidth * 0.8,
                                                                                    child: Text(
                                                                                      'تم التآكيد و تسجيل اجابتك بنجاح، برجاء الانتظار حتي يتم التآكيد من مقدم الخدمة',
                                                                                      style: TextStyles.h3.copyWith(
                                                                                        color: Color(0xFF717171),
                                                                                      ),
                                                                                      textAlign: TextAlign.center,
                                                                                      textDirection: TextDirection.rtl,
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height:
                                                                                        SizeConfig.screenHeight * 0.02,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              } else if (value.startsWith('https://')) {
                                                                Navigator.pop(context);
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
                                                                    create: (_) =>
                                                                        BookingCubit(BookingRepository(WebServices())),
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
                                                                                    borderRadius:
                                                                                        BorderRadius.circular(15),
                                                                                    color: Colors.white),
                                                                                padding:
                                                                                    EdgeInsets.fromLTRB(20, 20, 20, 20),
                                                                                child: Column(
                                                                                  crossAxisAlignment:
                                                                                      CrossAxisAlignment.center,
                                                                                  mainAxisAlignment:
                                                                                      MainAxisAlignment.center,
                                                                                  children: [
                                                                                    Align(
                                                                                      alignment: Alignment.topLeft,
                                                                                      child: IconButton(
                                                                                        icon: Icon(Icons.cancel,
                                                                                            color: Colors.teal),
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
                                                                                      height: SizeConfig.screenHeight *
                                                                                          0.02,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height:
                                                                                          SizeConfig.screenHeight * 0.1,
                                                                                      width:
                                                                                          SizeConfig.screenWidth * 0.3,
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
                                                                                      height: SizeConfig.screenHeight *
                                                                                          0.02,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: SizeConfig.screenHeight *
                                                                                          0.08,
                                                                                      width:
                                                                                          SizeConfig.screenWidth * 0.55,
                                                                                      child: BasicButton(
                                                                                        buttonName: "تآكيد",
                                                                                        onPressedFunction: () async {
                                                                                          print(_verifyController.text
                                                                                                  .trim() +
                                                                                              '-----' +
                                                                                              _pref.getString(
                                                                                                  'bookingId')!);
                                                                                          await BlocProvider.of<
                                                                                                  BookingCubit>(context)
                                                                                              .verifyServicePayment(
                                                                                            _pref.getString(
                                                                                                'userToken')!,
                                                                                            _pref.getString(
                                                                                                'bookingId')!,
                                                                                            _verifyController.text
                                                                                                .trim(),
                                                                                          )
                                                                                              .then((value) {
                                                                                            print(value);
                                                                                            if (value == true) {
                                                                                              Fluttertoast.showToast(
                                                                                                  msg: 'تم الحجز بنجاح',
                                                                                                  gravity:
                                                                                                      ToastGravity.TOP,
                                                                                                  toastLength:
                                                                                                      Toast.LENGTH_LONG,
                                                                                                  timeInSecForIosWeb:
                                                                                                      5);
                                                                                              Navigator.of(context)
                                                                                                  .pushAndRemoveUntil(
                                                                                                      MaterialPageRoute(
                                                                                                          builder:
                                                                                                              (context) =>
                                                                                                                  HomeScreen()),
                                                                                                      (route) => false);
                                                                                            } else {
                                                                                              Fluttertoast.showToast(
                                                                                                  msg:
                                                                                                      'الرمز الذي ادخلته غير صحيح',
                                                                                                  gravity:
                                                                                                      ToastGravity.TOP,
                                                                                                  toastLength:
                                                                                                      Toast.LENGTH_LONG,
                                                                                                  timeInSecForIosWeb:
                                                                                                      5);
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
                                                        }
                                                      }
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: SizeConfig.screenHeight * 0.02,
                                                ),
                                                SizedBox(
                                                  height: SizeConfig.screenHeight * 0.08,
                                                  width: SizeConfig.screenWidth * 0.4,
                                                  child: TextButton(
                                                      child: Text(
                                                        "الغاء",
                                                        style: TextStyles.h2.copyWith(color: Colors.black),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      }),
                                                ),
                                              ],
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.04),
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
                                onPressed: null,
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
                                  Navigator.of(context).push(
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
                                  );
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
