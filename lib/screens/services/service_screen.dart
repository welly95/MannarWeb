import 'dart:collection';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart' as intl;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mannar_web/bloc/booking/booking_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../constants/size_config.dart';
import '../../constants/styles.dart';
import '../../models/bookings.dart';
import '../../models/lawyers.dart' as law;
import '../../widgets/buttons/basic_button.dart';
import 'package:mannar_web/bloc/country/country_cubit.dart';
import 'package:mannar_web/bloc/lawyer/lawyer_cubit.dart';
import 'package:mannar_web/bloc/service_provider/service_provider_cubit.dart';
import 'package:mannar_web/bloc/services/services_cubit.dart';
import 'package:mannar_web/bloc/user/user_cubit.dart';
import 'package:mannar_web/models/aboutUsModel.dart';
import 'package:mannar_web/models/filter_data.dart';
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

class ServiceScreen extends StatefulWidget {
  final int appointmentId;
  final Appointment appointment;
  final Lawyer lawyer;
  final String lawyerImageUrl;
  final String price;
  final String caseName;
  final String caseStatus;
  final Color colorStatus;
  final String description;
  final String wayToCommunicate;
  final cancelReason;
  final AboutUsModel _aboutUsModel;
  final FilterData _filterData;
  final List<law.Lawyer> _lawyersList;

  ServiceScreen(
    this.appointmentId,
    this.appointment,
    this.lawyer,
    this.lawyerImageUrl,
    this.price,
    this.caseName,
    this.caseStatus,
    this.colorStatus,
    this.description,
    this.wayToCommunicate,
    this.cancelReason,
    this._aboutUsModel,
    this._filterData,
    this._lawyersList,
  );

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  late SharedPreferences _pref;
  DateTime _focusedDay = DateTime.now();
  List<int> appointmentIds = [];
  List<String> appointmentDays = [];
  List appointmentTimes = [];
  List<String> appointments = [];
  int? _selectedIndex;
  String? _selectedDay;
  bool? isSelected;

  final Set<DateTime> _selectedDays = LinkedHashSet<DateTime>(
    equals: isSameDay,
    // hashCode: getHashCode,
  );

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (appointmentIds.contains(selectedDay.weekday) &&
        appointmentDays.contains(selectedDay.toString().replaceFirst(' 00:00:00.000Z', ''))) {
      setState(() {
        _focusedDay = focusedDay;
        // Update values in a Set
        _selectedDays.clear();
        _selectedDays.add(selectedDay);
        _selectedDay = selectedDay.toString().replaceFirst(' 00:00:00.000Z', '');
        _selectedIndex = appointmentDays.indexOf(selectedDay.toString().replaceFirst(' 00:00:00.000Z', ''));
        isSelected = true;
        print(_selectedDays);
        print(appointmentTimes.where((element) => element['day_date'] == _selectedDay));
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
      'صباحاً',
      'مساءاً',
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

  @override
  void initState() {
    _selectedIndex = 0;
    isSelected = false;
    Future.delayed(Duration(seconds: 0)).then((value) async {
      _pref = await SharedPreferences.getInstance();

      print('Appointment is : ' + widget.appointment.dayDate.toString());
      setState(() {
        if (_pref.getString('userToken') != '' || _pref.getString('userToken') != null) {}
        _focusedDay = DateTime.parse(widget.appointment.dayDate!);
      });
      await BlocProvider.of<LawyerCubit>(context).getLawyersList('').then((value) {
        for (int i = 0;
            i < value.where((element) => element.id == widget.lawyer.id).toList()[0].appointments!.length;
            i++) {
          setState(() {
            appointments.add(
              value.where((element) => element.id == widget.lawyer.id).toList()[0].appointments![i]['id'].toString(),
            );
            appointmentIds.add(
              value.where((element) => element.id == widget.lawyer.id).toList()[0].appointments![i]['day_id'],
            );

            appointmentDays.add(
              value.where((element) => element.id == widget.lawyer.id).toList()[0].appointments![i]['day_date'],
            );
            appointmentTimes.add({
              'appointment_id': value
                  .where((element) => element.id == widget.lawyer.id)
                  .toList()[0]
                  .appointments![i]['id']
                  .toString(),
              'day_date': value.where((element) => element.id == widget.lawyer.id).toList()[0].appointments![i]
                  ['day_date'],
              'from': value.where((element) => element.id == widget.lawyer.id).toList()[0].appointments![i]['from'],
              'to': value.where((element) => element.id == widget.lawyer.id).toList()[0].appointments![i]['to']
            });
          });
        }
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      top: false,
      child: Scaffold(
        // endDrawer: AppDrawer(),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: Color(0xff03564C),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.3),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.caseStatus,
                            style: TextStyles.h3.copyWith(
                              color: widget.colorStatus,
                            ),
                          ),
                          Text(
                            widget.caseName,
                            textAlign: TextAlign.center,
                            style: TextStyles.h2.copyWith(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.3),
                      child: Text(
                        widget.description,
                        style: TextStyles.textFieldsLabels.copyWith(fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.02,
                    ),
                    Container(
                      width: SizeConfig.screenWidth * 0.55,
                      color: Colors.transparent,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1,
                          ),
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
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
                                  widget.lawyer.rate!.toStringAsFixed(1),
                                  style: TextStyles.h4.copyWith(
                                    color: Color(0xffF7CC19),
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        alignment: Alignment.topRight,
                                        child: Text(
                                          widget.lawyer.name!,
                                          style: TextStyles.h3,
                                        ),
                                      ),
                                      Container(
                                        //alignment: Alignment.topRight,
                                        child: Text(
                                          widget.lawyer.type!,
                                          style: TextStyles.h3,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: SizeConfig.screenWidth * 0.02,
                                  ),
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Colors.transparent,
                                    backgroundImage: NetworkImage(widget.lawyerImageUrl),
                                  ),
                                ],
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
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'التكلفة',
                          style: TextStyles.textFieldsLabels,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          widget.price,
                          style: TextStyles.h2.copyWith(fontSize: 13),
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.02,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'نوع التواصل',
                          style: TextStyles.textFieldsLabels,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          widget.wayToCommunicate,
                          style: TextStyles.h2.copyWith(fontSize: 13),
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.02,
                    ),
                    SizedBox(
                      width: SizeConfig.screenWidth * 0.5,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
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
                          // rangeStartDay: _focusedDay,
                          onDaySelected: _onDaySelected,
                          selectedDayPredicate: (DateTime date) {
                            return _selectedDays.contains(date);
                          },
                          calendarBuilders: CalendarBuilders(
                            defaultBuilder: (context, day, _) {
                              if (appointmentIds.contains(day.weekday) &&
                                  appointmentDays.contains(day.toString().replaceFirst(' 00:00:00.000Z', ''))) {
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
                            outsideBuilder: (context, day, _) {
                              return Container(
                                margin: EdgeInsets.all(5),
                                child: Center(
                                  child: Text(
                                    replaceArabicNumber(intl.DateFormat.d().format(day)),
                                    style: TextStyles.h3.copyWith(fontSize: 14, color: Colors.black),
                                  ),
                                ),
                              );
                            },
                            rangeStartBuilder: (context, day, _) {
                              return Container(
                                decoration: BoxDecoration(color: Colors.blueGrey, shape: BoxShape.circle),
                                margin: EdgeInsets.all(5),
                                child: Center(
                                  child: Text(
                                    replaceArabicNumber(intl.DateFormat.d().format(day)),
                                    style: TextStyles.h3.copyWith(fontSize: 14, color: Colors.white),
                                  ),
                                ),
                              );
                            },
                          ),
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
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: SizedBox(
                        width: SizeConfig.screenWidth * 0.55,
                        child: (isSelected!)
                            ? Directionality(
                                textDirection: TextDirection.rtl,
                                child: GridView.builder(
                                  itemCount:
                                      appointmentTimes.where((element) => element['day_date'] == _selectedDay).length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    mainAxisSpacing: 4,
                                    crossAxisSpacing: SizeConfig.screenWidth * 0.01,
                                    childAspectRatio: 2.5,
                                  ),
                                  itemBuilder: (context, index) {
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
                                          });
                                        },
                                        focusColor: Colors.teal,
                                        hoverColor: Colors.teal,
                                        splashColor: Colors.teal,
                                        highlightColor: Colors.teal,
                                        borderRadius: BorderRadius.circular(15),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              replaceArabicNumber(
                                                intl.DateFormat('hh:mm')
                                                    .format(DateTime(
                                                        2021,
                                                        10,
                                                        26,
                                                        convertStringToDate(appointmentTimes
                                                                .where((element) => element['day_date'] == _selectedDay)
                                                                .toList()[index]['from'])
                                                            .hour,
                                                        convertStringToDate(appointmentTimes
                                                                .where((element) => element['day_date'] == _selectedDay)
                                                                .toList()[index]['from'])
                                                            .minute))
                                                    .toString(),
                                              ),
                                              style: TextStyles.h3.copyWith(fontSize: 14),
                                              textDirection: TextDirection.ltr,
                                            ),
                                            SizedBox(
                                              width: 2,
                                            ),
                                            Text(
                                              replaceArabicNumber(
                                                intl.DateFormat('a')
                                                    .format(DateTime(
                                                        2021,
                                                        10,
                                                        26,
                                                        convertStringToDate(appointmentTimes
                                                                .where((element) => element['day_date'] == _selectedDay)
                                                                .toList()[index]['from'])
                                                            .hour,
                                                        convertStringToDate(appointmentTimes
                                                                .where((element) => element['day_date'] == _selectedDay)
                                                                .toList()[index]['from'])
                                                            .minute))
                                                    .toString(),
                                              ),
                                              style: TextStyles.h3.copyWith(fontSize: 14),
                                              textDirection: TextDirection.rtl,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : Center(
                                child: Text(
                                  'اختر اليوم المناسب ليتم ظهور الفترات المتاحة',
                                  style: TextStyles.h2,
                                ),
                              ),
                      ),
                    ),
                    Divider(
                      thickness: 1,
                      indent: SizeConfig.screenWidth * 0.22,
                      endIndent: SizeConfig.screenWidth * 0.22,
                      color: Colors.grey[300],
                    ),
                    (widget.cancelReason != '')
                        ? Column(
                            children: [
                              SizedBox(
                                height: SizeConfig.screenHeight * 0.02,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    'السبب',
                                    style: TextStyles.textFieldsLabels,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    widget.cancelReason,
                                    style: TextStyles.h2.copyWith(fontSize: 13),
                                    textDirection: TextDirection.rtl,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Container(),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.02,
                    ),
                    SizedBox(
                      width: SizeConfig.screenWidth * 0.55,
                      height: SizeConfig.screenHeight * 0.08,
                      child: BasicButton(
                        buttonName: 'تعديل',
                        onPressedFunction: () async {
                          if (isSelected!) {
                            await BlocProvider.of<BookingCubit>(context)
                                .updateBookingService(
                              _pref.getString('userToken')!,
                              widget.appointmentId.toString(),
                              widget.appointment.id!.toString(),
                              appointmentDays
                                  .where(
                                      (element) => element == _focusedDay.toString().replaceFirst(' 00:00:00.000Z', ''))
                                  .toList()[_selectedIndex!]
                                  .toString(),
                              widget.lawyer.id!.toString(),
                              widget.wayToCommunicate,
                            )
                                .then((value) {
                              if (value == 'success') {
                                Navigator.of(context).pop();
                                Fluttertoast.showToast(
                                  msg: 'تم تعديل الميعاد بنجاح',
                                  gravity: ToastGravity.TOP,
                                  toastLength: Toast.LENGTH_LONG,
                                  timeInSecForIosWeb: 5,
                                );
                              } else {
                                return;
                              }
                            });
                          } else {
                            Fluttertoast.showToast(
                                msg: 'هنالك مشكلة في تعديل ميعاد الحجز، برجاء المحاولة مرة أخري في وقت لاحق!',
                                gravity: ToastGravity.TOP,
                                toastLength: Toast.LENGTH_LONG);
                            return;
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
