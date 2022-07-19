// ignore_for_file: unnecessary_null_comparison

import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart' as intl;
import 'package:mannar_web/models/aboutUsModel.dart';
import 'package:mannar_web/models/filter_data.dart';
import 'package:mannar_web/screens/home/home_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../bloc/booking/booking_cubit.dart';
import '../../bloc/sub_departments/sub_departments_cubit.dart';
import '../../constants/size_config.dart';
import '../../constants/styles.dart';
import '../../models/lawyers.dart';
import '../../repository/booking_repository.dart';
import '../../repository/sub_departments_repository.dart';
import '../../repository/web_services.dart';
import '../../screens/Reservation/reservation_screen.dart';
import '../../widgets/buttons/basic_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

import '../textfields/number_textfield.dart';

class ReservationLawyer extends StatefulWidget {
  final Lawyer lawyer;
  final List<String> appointmentId;
  final int subDepartmentId;
  final bool fromCourt;
  final String courtAnswer;
  final List<int> ids;
  final List<String> days;
  final List times;
  final List chatArray;
  final String pay;
  final bool hasLawyers;
  final List<Lawyer> _lawyersList;
  final FilterData _filterData;
  final AboutUsModel _aboutUsModel;

  ReservationLawyer(
    this.lawyer,
    this.appointmentId,
    this.subDepartmentId,
    this.fromCourt,
    this.courtAnswer,
    this.ids,
    this.days,
    this.times,
    this.chatArray,
    this.pay,
    this.hasLawyers,
    this._lawyersList,
    this._filterData,
    this._aboutUsModel,
  );

  @override
  _ReservationLawyerState createState() => _ReservationLawyerState();
}

class _ReservationLawyerState extends State<ReservationLawyer> {
  // ignore: unused_field
  bool? _autoDirection;
  int? _selectedIndex;
  String? _selectedDay;
  String? wayToCommunication;
  bool? isChat;
  bool? isVoice;
  bool? isVedio;
  bool? isSelected;
  bool? isTimeSelected;
  late SharedPreferences _pref;
  TextEditingController _verifyController = TextEditingController();

  DateTime _focusedDay = DateTime.now();

  final Set<DateTime> _selectedDays = LinkedHashSet<DateTime>(
    equals: isSameDay,
    // hashCode: getHashCode,
  );

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (widget.ids.contains(selectedDay.weekday) &&
        widget.days.contains(selectedDay.toString().replaceFirst(' 00:00:00.000Z', ''))) {
      setState(() {
        _focusedDay = focusedDay;
        // Update values in a Set
        _selectedDays.clear();
        _selectedDays.add(selectedDay);
        _selectedDay = selectedDay.toString().replaceFirst(' 00:00:00.000Z', '');
        _selectedIndex = widget.days.indexOf(selectedDay.toString().replaceFirst(' 00:00:00.000Z', ''));
        isSelected = true;
        print(_selectedDays);
        print(widget.times.where((element) => element['day_date'] == _selectedDay));
      });
    } else {
      return;
    }
  }

  String replaceArabicNumber(String input) {
    const english = [
      '0',
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      'AM',
      'PM',
    ];
    const arabic = [
      '۰',
      '۱',
      '۲',
      '۳',
      '٤',
      '٥',
      '٦',
      '۷',
      '۸',
      '۹',
      'صباحًا',
      'مساءًا',
    ];

    for (int i = 0; i < english.length; i++) {
      input = input.replaceAll(english[i], arabic[i]);
    }

    return input;
  }

  String replaceArabicDays(String input) {
    const english = [
      1,
      2,
      3,
      4,
      5,
      6,
      7,
    ];
    const arabic = [
      'الأثنين',
      'الثلاثاء',
      'الأربعاء',
      'الخميس',
      'الجمعة',
      'السبت',
      'الأحد',
    ];

    for (int i = 0; i < english.length; i++) {
      input = input.replaceAll(english[i].toString(), arabic[i]);
    }

    return input;
  }

  String replaceArabicMonths(String input) {
    const english = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    const arabic = [
      'يناير',
      'فبراير',
      'مارس',
      'إبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];

    for (int i = 0; i < english.length; i++) {
      input = input.replaceAll(english[i], arabic[i]);
    }
    return input;
  }

  TimeOfDay convertStringToDate(String s) {
    TimeOfDay _startTime = TimeOfDay(hour: int.parse(s.split(":")[0]), minute: int.parse(s.split(":")[1]));
    return _startTime;
  }

  Iterable<TimeOfDay> getTimes(TimeOfDay startTime, TimeOfDay endTime, Duration step) sync* {
    var hour = startTime.hour;
    var minute = startTime.minute;

    do {
      yield TimeOfDay(hour: hour, minute: minute);
      minute += step.inMinutes;
      while (minute >= 60) {
        minute -= 60;
        hour++;
      }
    } while (hour < endTime.hour || (hour == endTime.hour && minute <= endTime.minute));
  }

  booking() async {
    await BlocProvider.of<BookingCubit>(context).bookingService(
      _pref.getString('userToken')!,
      widget.times
          .where((element) => element['day_date'] == _selectedDay)
          .toList()[_selectedIndex!]['appointment_id']
          .toString(),
      widget.lawyer.id!.toString(),
      _pref.getInt('mainId').toString(),
      '',
      widget.days
          .where((element) => element == _focusedDay.toString().replaceFirst(' 00:00:00.000Z', ''))
          .toList()[_selectedIndex!]
          .toString(),
      widget.courtAnswer,
      wayToCommunication!,
      _pref.getInt('courtId')!.toString(),
      widget.pay,
      [],
    ).then(
      (val) {
        if (val == 'success') {
          FirebaseFirestore.instance
              .collection('chats')
              .doc('chatRoom:-${_pref.getString('userId')}_to_${widget.lawyer.id!}')
              .set({
            'idUser': _pref.getString('userId'),
            'recieverId': widget.lawyer.id!,
            'name': _pref.getString('userName')!,
            'lawyerName': widget.lawyer.name!,
            'urlAvatar': widget.lawyer.imageurl!,
            'wayToChat': wayToCommunication,
            'lastMessageTime': DateTime.now(),
          });

          Navigator.pop(context);
          Navigator.of(context)
              .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomeScreen()), (route) => false);
        } else if (val.startsWith('https://')) {
          launch(
            val,
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
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.white),
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
                                    print(_verifyController.text.trim() + '-----' + _pref.getString('bookingId')!);
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
            msg: val,
            gravity: ToastGravity.TOP,
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 5,
          );
        }
      },
    );
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
      if (widget.fromCourt) {
        booking();
        //   showDialog(
        //     context: context,
        //     barrierDismissible: false,
        //     useRootNavigator: true,
        //     useSafeArea: false,
        //     builder: (context) => BlocProvider(
        //       create: (_) => BookingCubit(BookingRepository(WebServices())),
        //       child: StatefulBuilder(
        //         builder: (context, setStateDialog) => Dialog(
        //           backgroundColor: Colors.transparent,
        //           insetPadding: EdgeInsets.all(10),
        //           child: Stack(
        //             alignment: Alignment.center,
        //             children: <Widget>[
        //               Directionality(
        //                 textDirection: TextDirection.rtl,
        //                 child: Container(
        //                   width: SizeConfig.screenWidth * 0.35,
        //                   height: SizeConfig.screenHeight * 0.4,
        //                   decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.white),
        //                   padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
        //                   child: Column(
        //                     crossAxisAlignment: CrossAxisAlignment.center,
        //                     mainAxisAlignment: MainAxisAlignment.center,
        //                     children: [
        //                       Align(
        //                         alignment: Alignment.topLeft,
        //                         child: IconButton(
        //                           icon: Icon(Icons.arrow_back, color: Colors.teal),
        //                           onPressed: () {
        //                             Navigator.of(context).pop();
        //                           },
        //                         ),
        //                       ),
        //                       Text(
        //                         'ادخل رمز تآكيد عملية الدفع حتي يتم الحجز',
        //                         style: TextStyles.h2Bold,
        //                       ),
        //                       SizedBox(
        //                         height: SizeConfig.screenHeight * 0.02,
        //                       ),
        //                       SizedBox(
        //                         height: SizeConfig.screenHeight * 0.1,
        //                         width: SizeConfig.screenWidth * 0.3,
        //                         child: NumberTextField(
        //                           ValueKey('verify'),
        //                           _verifyController,
        //                           'رمز تآكيد الدفع',
        //                           (val) {
        //                             return null;
        //                           },
        //                         ),
        //                       ),
        //                       SizedBox(
        //                         height: SizeConfig.screenHeight * 0.02,
        //                       ),
        //                       SizedBox(
        //                         height: SizeConfig.screenHeight * 0.08,
        //                         width: SizeConfig.screenWidth * 0.55,
        //                         child: BasicButton(
        //                           buttonName: "تآكيد",
        //                           onPressedFunction: () async {
        //                             print(_verifyController.text.trim() + '-----' + _pref.getString('bookingId')!);
        //                             await BlocProvider.of<BookingCubit>(context)
        //                                 .verifyPayment(
        //                               _pref.getString('userToken')!,
        //                               _pref.getString('bookingId')!,
        //                               _verifyController.text.trim(),
        //                             )
        //                                 .then((value) {
        //                               print(value);
        //                               if (value == true) {
        //                                 Fluttertoast.showToast(
        //                                     msg: 'تم الحجز بنجاح',
        //                                     gravity: ToastGravity.TOP,
        //                                     toastLength: Toast.LENGTH_LONG,
        //                                     timeInSecForIosWeb: 5);
        //                                 Navigator.of(context).pop();
        //                               } else {
        //                                 Fluttertoast.showToast(
        //                                     msg: 'الرمز الذي ادخلته غير صحيح',
        //                                     gravity: ToastGravity.TOP,
        //                                     toastLength: Toast.LENGTH_LONG,
        //                                     timeInSecForIosWeb: 5);
        //                               }
        //                             });
        //                           },
        //                         ),
        //                       ),
        //                     ],
        //                   ),
        //                 ),
        //               )
        //             ],
        //           ),
        //         ),
        //       ),
        //     ),
        //   );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  lazy: false,
                  create: (context) => SubDepartmentsCubit(SubDepartmentsRepository(WebServices())),
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
                appointmentId: widget.times
                    .where((element) => element['day_date'] == _selectedDay)
                    .toList()[_selectedIndex!]['appointment_id'],
                appointmentDate: widget.days
                    .where((element) => element == _focusedDay.toString().replaceFirst(' 00:00:00.000Z', ''))
                    .toList()[_selectedIndex!]
                    .toString(),
                courtAnswer: widget.courtAnswer,
                lawyerId: widget.lawyer.id.toString(),
                lawyerName: widget.lawyer.name!,
                lawyerUrlImage: widget.lawyer.imageurl ?? '',
                pay: widget.pay,
                wayToCommunicate: wayToCommunication!,
                fromCourt: !widget.fromCourt,
                hasLawyers: widget.hasLawyers,
              ),
            ),
          ),
        );
      }
    });
  }

  @override
  void initState() {
    isChat = true;
    isVoice = false;
    isVedio = false;
    isSelected = false;
    isTimeSelected = false;
    _selectedIndex = 0;
    wayToCommunication = 'شات';
    Future.delayed(Duration(seconds: 0)).then((_) async {
      _pref = await SharedPreferences.getInstance();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Directionality(
                textDirection: TextDirection.ltr,
                child: Icon(
                  Icons.arrow_back,
                  color: Color(0xff03564C),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(
                      (widget.lawyer.imageurl == null) ? '' : widget.lawyer.imageurl!,
                    ),
                  ),
                  SizedBox(
                    width: SizeConfig.screenWidth * 0.1,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.lawyer.name!,
                        style: TextStyles.h3.copyWith(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: SizeConfig.screenHeight * 0.02,
                      ),
                      Text(
                        (widget.lawyer.bio == null) ? '' : widget.lawyer.bio!,
                        style: TextStyles.h3.copyWith(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
                ],
              ),
              Row(
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
            ],
          ),
          Divider(
            thickness: 1,
            indent: SizeConfig.screenWidth * 0.22,
            endIndent: SizeConfig.screenWidth * 0.22,
            color: Colors.grey[300],
          ),
          SizedBox(
            height: SizeConfig.screenHeight * 0.02,
          ),
          (widget.lawyer.specialists!.isEmpty)
              ? Container()
              : SizedBox(
                  height: SizeConfig.screenHeight * 0.02,
                ),
          (widget.lawyer.specialists!.isEmpty)
              ? Container()
              : Divider(
                  thickness: 1,
                  indent: 50,
                  endIndent: 50,
                  color: Colors.grey[300],
                ),
          SizedBox(
            height: SizeConfig.screenHeight * 0.02,
          ),
          SizedBox(
            width: SizeConfig.screenWidth * 0.55,
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
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
                    ],
                  ),
                  VerticalDivider(
                    color: Colors.grey[300],
                    thickness: 2,
                  ),
                  Column(
                    children: [
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
                    ],
                  ),
                  VerticalDivider(
                    color: Colors.grey[300],
                    thickness: 2,
                  ),
                  (widget.fromCourt)
                      ? Column(
                          children: [
                            Text(
                              'سعر الخدمة',
                              style: TextStyles.textFieldsLabels,
                            ),
                            Text(
                              (widget.lawyer.price == null) ? '' : widget.lawyer.price!.toString() + ' ريال سعودي',
                              style: TextStyles.h2.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Text(
                              'التكلفة',
                              style: TextStyles.textFieldsLabels,
                            ),
                            Text(
                              (widget.lawyer.subs!.isEmpty)
                                  ? ''
                                  : (widget.subDepartmentId != null)
                                      ? (widget.lawyer.subs!.where((element) => element.id == widget.subDepartmentId))
                                          .toList()[0]
                                          .pivot
                                          .price
                                          .toString()
                                      : '',
                              style: TextStyles.h2.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                  VerticalDivider(
                    color: Colors.grey[300],
                    thickness: 2,
                  ),
                  Column(
                    children: [
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
                    ],
                  ),
                  VerticalDivider(
                    color: Colors.grey[300],
                    thickness: 2,
                  ),
                  Column(
                    children: [
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
                ],
              ),
            ),
          ),
          Divider(
            thickness: 1,
            indent: SizeConfig.screenWidth * 0.22,
            endIndent: SizeConfig.screenWidth * 0.22,
            color: Colors.grey[300],
          ),
          SizedBox(
            height: SizeConfig.screenHeight * 0.02,
          ),
          Padding(
            padding: EdgeInsets.only(right: (SizeConfig.screenWidth * 0.1), left: (SizeConfig.screenWidth * 0.1)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'الأيام المتاحة',
                  style: TextStyles.h2Bold.copyWith(fontSize: 24),
                ),
              ],
            ),
          ),
          SizedBox(
            height: SizeConfig.screenHeight * 0.02,
          ),
          SizedBox(
            width: SizeConfig.screenWidth * 0.5,
            child: TableCalendar(
              focusedDay: _focusedDay,
              firstDay: DateTime.utc(2020, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              calendarFormat: CalendarFormat.week,
              headerStyle: HeaderStyle(formatButtonVisible: false, titleCentered: true),
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(color: Colors.teal, shape: BoxShape.circle),
                selectedTextStyle: TextStyles.h3.copyWith(color: Colors.white),
                isTodayHighlighted: false,
                // canMarkersOverflow: true,
                outsideDaysVisible: false,
              ),
              onDaySelected: _onDaySelected,
              selectedDayPredicate: (DateTime date) {
                return _selectedDays.contains(date);
              },
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, _) {
                  if (widget.ids.contains(day.weekday) &&
                      widget.days.contains(day.toString().replaceFirst(' 00:00:00.000Z', ''))) {
                    final text = intl.DateFormat.d().format(day);
                    return Center(
                      child: Text(
                        replaceArabicNumber(text),
                        style: TextStyles.h3.copyWith(fontSize: 14, color: Colors.orange),
                      ),
                    );
                  } else {
                    return Center(
                      child: Text(
                        replaceArabicNumber(intl.DateFormat.d().format(day)),
                        style: TextStyles.h3.copyWith(fontSize: 14, color: Colors.black),
                      ),
                    );
                  }
                },
                outsideBuilder: (context, day, _) {
                  if (widget.ids.contains(day.weekday) &&
                      widget.days.contains(day.toString().replaceFirst(' 00:00:00.000Z', ''))) {
                    final text = intl.DateFormat.d().format(day);
                    return Center(
                      child: Text(
                        replaceArabicNumber(text),
                        style: TextStyles.h3.copyWith(fontSize: 14, color: Colors.orange),
                      ),
                    );
                  } else {
                    return Center(
                      child: Text(
                        replaceArabicNumber(intl.DateFormat.d().format(day)),
                        style: TextStyles.h3.copyWith(fontSize: 14, color: Colors.black),
                      ),
                    );
                  }
                },
                headerTitleBuilder: (context, year) {
                  return Center(
                    child: Text(
                      replaceArabicMonths(intl.DateFormat.MMMM().format(year)) +
                          ' ' +
                          replaceArabicNumber(year.year.toString()),
                      style: TextStyles.h2Bold,
                    ),
                  );
                },
                selectedBuilder: (context, day, _) {
                  return Container(
                    decoration: BoxDecoration(color: Colors.teal, shape: BoxShape.circle),
                    margin: EdgeInsets.all(5),
                    child: Center(
                      child: Text(
                        replaceArabicNumber(intl.DateFormat.d().format(day)),
                        style: TextStyles.h3.copyWith(fontSize: 14, color: Colors.white),
                      ),
                    ),
                  );
                },
                dowBuilder: (context, day) {
                  return Center(
                    child: Text(
                      replaceArabicDays(day.weekday.toString()),
                      style: TextStyles.h3.copyWith(fontSize: 13, color: Colors.black),
                    ),
                  );
                },
              ),
            ),
          ),
          Divider(
            thickness: 1,
            indent: SizeConfig.screenWidth * 0.22,
            endIndent: SizeConfig.screenWidth * 0.22,
            color: Colors.grey[300],
          ),
          SizedBox(
            height: SizeConfig.screenHeight * 0.02,
          ),
          Padding(
            padding: EdgeInsets.only(right: (SizeConfig.screenWidth * 0.1), left: (SizeConfig.screenWidth * 0.1)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'الفترات المتاحة',
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
            child: (isSelected!)
                ? GridView.builder(
                    itemCount: widget.times.where((element) => element['day_date'] == _selectedDay).length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      // mainAxisSpacing: 4,
                      crossAxisSpacing: SizeConfig.screenWidth * 0.01,
                      childAspectRatio: 2,
                    ),
                    itemBuilder: (context, index) {
                      // if (_selectedIndex == index) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        color: (_selectedIndex == index) ? Colors.teal : Colors.white,
                        elevation: 10,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedIndex = index;
                              isTimeSelected = true;
                            });
                          },
                          focusColor: Colors.teal,
                          hoverColor: Colors.teal,
                          splashColor: Colors.teal,
                          highlightColor: Colors.teal,
                          borderRadius: BorderRadius.circular(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                replaceArabicNumber(
                                  intl.DateFormat('hh:mm')
                                      .format(DateTime(
                                          2021,
                                          10,
                                          26,
                                          convertStringToDate(widget.times
                                                  .where((element) => element['day_date'] == _selectedDay)
                                                  .toList()[index]['from'])
                                              .hour,
                                          convertStringToDate(widget.times
                                                  .where((element) => element['day_date'] == _selectedDay)
                                                  .toList()[index]['from'])
                                              .minute))
                                      .toString(),
                                ),
                                style: TextStyles.h3.copyWith(fontSize: 14),
                                textDirection: TextDirection.ltr,
                                // textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              FittedBox(
                                child: Text(
                                  replaceArabicNumber(
                                    intl.DateFormat('a')
                                        .format(DateTime(
                                            2021,
                                            10,
                                            26,
                                            convertStringToDate(widget.times
                                                    .where((element) => element['day_date'] == _selectedDay)
                                                    .toList()[index]['from'])
                                                .hour,
                                            convertStringToDate(widget.times
                                                    .where((element) => element['day_date'] == _selectedDay)
                                                    .toList()[index]['from'])
                                                .minute))
                                        .toString(),
                                  ),
                                  style: TextStyles.h3.copyWith(fontSize: 14),
                                  textDirection: TextDirection.rtl,
                                  // textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                      // } else {
                      //   return Container();
                      // }
                    },
                  )
                : Center(
                    child: Text(
                      'اختر اليوم المناسب ليتم ظهور الفترات المتاحة',
                      style: TextStyles.h2,
                    ),
                  ),
          ),
          Divider(
            thickness: 1,
            indent: SizeConfig.screenWidth * 0.22,
            endIndent: SizeConfig.screenWidth * 0.22,
            color: Colors.grey[300],
          ),
          (widget.chatArray[0]['chat'] == 0)
              ? Container()
              : Padding(
                  padding: EdgeInsets.only(right: (SizeConfig.screenWidth * 0.1), left: (SizeConfig.screenWidth * 0.1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'ترتيب حسب: ',
                        style: TextStyles.h2Bold.copyWith(fontSize: 24),
                        textDirection: TextDirection.rtl,
                      ),
                    ],
                  ),
                ),
          (widget.chatArray[0]['write'] == 0)
              ? Container()
              : SizedBox(
                  height: SizeConfig.screenHeight * 0.05,
                  width: SizeConfig.screenWidth * 0.55,
                  child: CheckboxListTile(
                    title: Text(
                      'شات فقط',
                      style: TextStyles.h4,
                    ),
                    value: isChat,
                    onChanged: (newValue) {
                      setState(() {
                        isChat = newValue;
                        isVoice = false;
                        isVedio = false;
                        wayToCommunication = 'شات';
                      });
                    },
                  ),
                ),
          (widget.chatArray[0]['voice'] == 0)
              ? Container()
              : SizedBox(
                  height: SizeConfig.screenHeight * 0.05,
                  width: SizeConfig.screenWidth * 0.55,
                  child: CheckboxListTile(
                    title: Text(
                      'مكالمة صوت',
                      style: TextStyles.h4,
                    ),
                    value: isVoice,
                    onChanged: (newValue) {
                      setState(() {
                        isChat = false;
                        isVoice = newValue;
                        isVedio = false;
                        wayToCommunication = 'مكالمة صوت';
                      });
                    },
                  ),
                ),
          (widget.chatArray[0]['seen'] == 0)
              ? Container()
              : SizedBox(
                  height: SizeConfig.screenHeight * 0.05,
                  width: SizeConfig.screenWidth * 0.55,
                  child: CheckboxListTile(
                    title: Text(
                      'مكالمة فيديو',
                      style: TextStyles.h4,
                    ),
                    value: isVedio,
                    onChanged: (newValue) {
                      setState(() {
                        isChat = false;
                        isVoice = false;
                        isVedio = newValue;
                        wayToCommunication = 'مكالمة فيديو';
                      });
                    },
                  ),
                ),
          SizedBox(
            height: SizeConfig.screenHeight * 0.04,
          ),
          Padding(
            padding: EdgeInsets.only(right: (SizeConfig.screenWidth * 0.1), left: (SizeConfig.screenWidth * 0.1)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "اراء العملاء عن المحامي..",
                  style: TextStyles.h2Bold.copyWith(fontSize: 24),
                ),
              ],
            ),
          ),
          SizedBox(
            height: SizeConfig.screenHeight * 0.02,
          ),
          Container(
            height: (widget.lawyer.rateList!.isEmpty) ? SizeConfig.screenHeight * 0.1 : SizeConfig.screenHeight * 0.5,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Wrap(
                runSpacing: 2,
                spacing: 2,
                alignment: WrapAlignment.center,
                direction: Axis.horizontal,
                children: List.generate(
                  widget.lawyer.rateList!.length,
                  (index) {
                    return (widget.lawyer.rateList![index]['comment'] == null)
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
                                      (widget.lawyer.rateList![index]['comment'] == null)
                                          ? ''
                                          : widget.lawyer.rateList![index]['comment'],
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
                                              (widget.lawyer.rateList![index]['user'] != null)
                                                  ? widget.lawyer.rateList![index]['user']['name']
                                                  : '',
                                              textAlign: TextAlign.right,
                                              style: TextStyles.h3.copyWith(fontSize: 16, color: Colors.teal),
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
                                          initialRating: widget.lawyer.rateList![index]['rate'],
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
            width: SizeConfig.screenWidth * 0.55,
            height: SizeConfig.screenHeight * 0.08,
            child: BasicButton(
              buttonName: 'حجز استشاره',
              onPressedFunction: () {
                if (_selectedIndex == null) {
                  return Fluttertoast.showToast(
                    msg: 'من فضلك اختر ميعاد لحجز الاستشارة',
                    gravity: ToastGravity.TOP,
                    toastLength: Toast.LENGTH_LONG,
                    timeInSecForIosWeb: 5,
                  );
                } else {
                  if (isSelected! && isTimeSelected!) {
                    timer();
                    (widget.fromCourt)
                        ? showDialog(
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
                                        height: SizeConfig.screenHeight * 0.18,
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
                                              Icons.check,
                                              color: Color(0xffE2C069),
                                              size: 40,
                                            ),
                                            SizedBox(
                                              height: SizeConfig.screenHeight * 0.02,
                                            ),
                                            Text(
                                              "تم الحجز بنجاح!",
                                              style: TextStyles.h2,
                                              textDirection: TextDirection.rtl,
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
                          )
                        : showDialog(
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
                                        height: SizeConfig.screenHeight * 0.28,
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
                                              "جاوب علي الآسئلة !",
                                              style: TextStyles.h2,
                                              textDirection: TextDirection.rtl,
                                            ),
                                            SizedBox(
                                              height: SizeConfig.screenHeight * 0.02,
                                            ),
                                            SizedBox(
                                              width: SizeConfig.screenWidth * 0.8,
                                              child: Text(
                                                'سوف يتم إعادة توجيهك لصفحة الأسئلة الخاصة بالخدمة، لذا ادخل البيانات و سوف يتم الحجز',
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
                  } else {
                    return Fluttertoast.showToast(
                      msg: 'من فضلك اختر ميعاد لحجز الاستشارة',
                      gravity: ToastGravity.TOP,
                      toastLength: Toast.LENGTH_LONG,
                      timeInSecForIosWeb: 5,
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
    );
  }
}
