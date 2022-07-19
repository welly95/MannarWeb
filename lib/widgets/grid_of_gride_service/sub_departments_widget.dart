import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mannar_web/models/aboutUsModel.dart';
import 'package:mannar_web/models/filter_data.dart';
import 'package:mannar_web/models/lawyers.dart';
import 'package:mannar_web/screens/home/home_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../bloc/booking/booking_cubit.dart';
import '../../bloc/sub_departments/sub_departments_cubit.dart';
import '../../constants/size_config.dart';
import '../../constants/styles.dart';
import 'package:flutter/material.dart';
import '../../models/sub_departments.dart';
import '../../repository/booking_repository.dart';
import '../../repository/sub_departments_repository.dart';
import '../../repository/web_services.dart';
import '../../screens/Reservation/reservation_screen.dart';
import '../../screens/lawyer/lawyer_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../buttons/basic_button.dart';
import '../textfields/number_textfield.dart';

class SubDepartmentsWidget extends StatefulWidget {
  final int mainId;
  final mainDepartmentName;
  final int? courtId;
  final String? courtName;
  final bool? fromCourt;
  final courtQuestionAnswer;
  final bool hasLawyers;
  final bool hasQuestions;
  final List chatArray;
  final String pay;
  final List<Lawyer> _lawyersList;
  final FilterData _filterData;
  final AboutUsModel _aboutUsModel;

  SubDepartmentsWidget(
    this.mainId,
    this.mainDepartmentName,
    this.courtId,
    this.courtName,
    this.fromCourt,
    this.courtQuestionAnswer,
    this.hasLawyers,
    this.hasQuestions,
    this.chatArray,
    this.pay,
    this._lawyersList,
    this._filterData,
    this._aboutUsModel,
  );

  @override
  State<SubDepartmentsWidget> createState() => _SubDepartmentsWidgetState();
}

class _SubDepartmentsWidgetState extends State<SubDepartmentsWidget> {
  List<SubDepartments> listItem = [];
  late SharedPreferences _pref;
  TextEditingController _verifyController = TextEditingController();
  // ignore: unused_field
  bool? _autoDirection;
  @override
  void initState() {
    Future.delayed(Duration(seconds: 0)).then((_) async {
      _pref = await SharedPreferences.getInstance();
      if (widget.fromCourt == true) {
        listItem = await BlocProvider.of<SubDepartmentsCubit>(context).getSubDepartmentsListFromCourt(widget.courtId!);
      } else {
        listItem = await BlocProvider.of<SubDepartmentsCubit>(context).getSubDepartmentsListFromMain(widget.mainId);
      }
    });
    super.initState();
  }

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
  Widget build(BuildContext context) {
    print('sub Department widget -------->' + widget.courtId.toString());
    print('fromCOURT----------->' + widget.fromCourt.toString());
    SizeConfig().init(context);
    return BlocBuilder<SubDepartmentsCubit, SubDepartmentsState>(
      builder: (context, state) {
        if (state is GetSubDepartmentsFromMainState) {
          return Container(
            width: SizeConfig.screenWidth * 0.85,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Wrap(
                runSpacing: 4,
                spacing: 4,
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                direction: Axis.horizontal,
                children: List.generate(
                  listItem.length,
                  (index) {
                    return Container(
                      height: SizeConfig.screenHeight * 0.12,
                      width: SizeConfig.screenWidth * 0.2,
                      child: Card(
                        color: Colors.white,
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: InkWell(
                          focusColor: Colors.teal,
                          hoverColor: Colors.teal,
                          borderRadius: BorderRadius.circular(2),
                          onTap: () {
                            print('SubDepartment id ========>' + (state).subDepartments[index].id.toString());

                            _pref.setInt('subId', (state).subDepartments[index].id!);
                            _pref.setInt('index', index);
                            if (widget.hasLawyers) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => LawyerScreen(
                                    true,
                                    widget.mainId,
                                    widget.mainDepartmentName,
                                    listItem[index].name!,
                                    listItem[index].id!,
                                    widget.courtId!,
                                    widget.courtName!,
                                    widget.fromCourt!,
                                    widget.courtQuestionAnswer,
                                    widget.chatArray,
                                    widget.pay,
                                    widget._lawyersList,
                                    widget._filterData,
                                    widget._aboutUsModel,
                                  ),
                                ),
                              );
                            } else if (!widget.hasLawyers && widget.hasQuestions) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => MultiBlocProvider(
                                    providers: [
                                      BlocProvider(
                                        lazy: false,
                                        create: (context) =>
                                            SubDepartmentsCubit(SubDepartmentsRepository(WebServices())),
                                      ),
                                      BlocProvider(
                                        lazy: false,
                                        create: (context) => BookingCubit(BookingRepository(WebServices())),
                                      ),
                                    ],
                                    child: ReservationScreen(
                                      widget._lawyersList,
                                      widget._filterData,
                                      widget._aboutUsModel,
                                      fromCourt: widget.fromCourt,
                                      courtAnswer: widget.courtQuestionAnswer,
                                      pay: widget.pay,
                                      hasLawyers: widget.hasLawyers,
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              BlocProvider.of<BookingCubit>(context).bookingServiceWithoutLawyers(
                                _pref.getString('userToken')!,
                                widget.mainId.toString(),
                                widget.courtId.toString(),
                                listItem[index].id!.toString(),
                                '',
                                [],
                              ).then(
                                (value) {
                                  if (value == 'success') {
                                    return Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(builder: (context) => HomeScreen()), (route) => false);
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
                                                                  Navigator.of(context).pushAndRemoveUntil(
                                                                      MaterialPageRoute(
                                                                          builder: (context) => HomeScreen()),
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
                          },
                          child: Container(
                            height: SizeConfig.screenHeight * 0.12,
                            width: SizeConfig.screenWidth * 0.2,
                            child: Center(
                              child: Text(
                                listItem[index].name!,
                                textAlign: TextAlign.center,
                                style: TextStyles.h3.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        } else if (state is GetSubDepartmentsFromCourtState) {
          return Container(
            width: SizeConfig.screenWidth * 0.85,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Wrap(
                runSpacing: 4,
                spacing: 4,
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                direction: Axis.horizontal,
                children: List.generate(
                  listItem.length,
                  (index) {
                    return Container(
                      height: SizeConfig.screenHeight * 0.12,
                      width: SizeConfig.screenWidth * 0.2,
                      child: Card(
                        color: Colors.white,
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: InkWell(
                          focusColor: Colors.teal,
                          hoverColor: Colors.teal,
                          borderRadius: BorderRadius.circular(2),
                          onTap: () {
                            print('SubDepartment index ========>' + (state).subDepartments[index].id.toString());

                            _pref.setInt('subId', listItem[index].id!);
                            _pref.setInt('index', index);
                            if (widget.hasLawyers) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => LawyerScreen(
                                    true,
                                    widget.mainId,
                                    widget.mainDepartmentName,
                                    listItem[index].name!,
                                    listItem[index].id!,
                                    widget.courtId!,
                                    widget.courtName!,
                                    !widget.fromCourt!,
                                    widget.courtQuestionAnswer,
                                    widget.chatArray,
                                    widget.pay,
                                    widget._lawyersList,
                                    widget._filterData,
                                    widget._aboutUsModel,
                                  ),
                                ),
                              );
                            } else if (!widget.hasLawyers && widget.hasQuestions) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => MultiBlocProvider(
                                    providers: [
                                      BlocProvider(
                                        lazy: false,
                                        create: (context) =>
                                            SubDepartmentsCubit(SubDepartmentsRepository(WebServices())),
                                      ),
                                      BlocProvider(
                                        lazy: false,
                                        create: (context) => BookingCubit(BookingRepository(WebServices())),
                                      ),
                                    ],
                                    child: ReservationScreen(
                                      widget._lawyersList,
                                      widget._filterData,
                                      widget._aboutUsModel,
                                      fromCourt: widget.fromCourt,
                                      courtAnswer: widget.courtQuestionAnswer,
                                      pay: widget.pay,
                                      hasLawyers: widget.hasLawyers,
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              BlocProvider.of<BookingCubit>(context).bookingServiceWithoutLawyers(
                                _pref.getString('userToken')!,
                                widget.mainId.toString(),
                                widget.courtId.toString(),
                                listItem[index].id!.toString(),
                                widget.courtQuestionAnswer,
                                [],
                              ).then(
                                (value) {
                                  if (value == 'success') {
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
                                                        height: SizeConfig.screenHeight * 0.02,
                                                      ),
                                                      Icon(
                                                        Icons.question_answer,
                                                        color: Color(0xffE2C069),
                                                        size: 40,
                                                      ),
                                                      SizedBox(
                                                        height: SizeConfig.screenHeight * 0.02,
                                                      ),
                                                      Text(
                                                        "تم التأكيد!",
                                                        style: TextStyles.h2,
                                                        textDirection: TextDirection.rtl,
                                                      ),
                                                      SizedBox(
                                                        height: SizeConfig.screenHeight * 0.02,
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
                                                        height: SizeConfig.screenHeight * 0.02,
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
                                                                  Navigator.of(context).pushAndRemoveUntil(
                                                                      MaterialPageRoute(
                                                                          builder: (context) => HomeScreen()),
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
                          },
                          child: Container(
                            height: SizeConfig.screenHeight * 0.12,
                            width: SizeConfig.screenWidth * 0.2,
                            child: Center(
                              child: Text(
                                listItem[index].name!,
                                textAlign: TextAlign.center,
                                style: TextStyles.h3.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        } else {
          return Container(
            height: SizeConfig.screenHeight * 0.15,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
