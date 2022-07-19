import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mannar_web/bloc/lawyer/lawyer_cubit.dart';
import 'package:mannar_web/bloc/services/services_cubit.dart';
import 'package:mannar_web/bloc/user/user_cubit.dart';
import 'package:mannar_web/models/aboutUsModel.dart';
import 'package:mannar_web/models/filter_data.dart';
import 'package:mannar_web/models/lawyers.dart' as law;
import 'package:mannar_web/repository/lawyer_repository.dart';
import 'package:mannar_web/repository/services_repository.dart';
import 'package:mannar_web/repository/user_repository.dart';
import 'package:mannar_web/repository/web_services.dart';
import 'package:mannar_web/screens/aboutUs/about_us.dart';
import 'package:mannar_web/screens/chat/chats_page.dart';
import 'package:mannar_web/screens/contactUS/contact_us.dart';
import 'package:mannar_web/screens/home/home_screen.dart';
import 'package:mannar_web/screens/lawyer/search_lawyer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../bloc/booking/booking_cubit.dart';

import '../../constants/size_config.dart';
import '../../constants/styles.dart';
import '../../models/bookings.dart';
import '../../repository/booking_repository.dart';
import '../../widgets/allServices/all_services_grid.dart';
import '../../widgets/buttons/basic_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'all_services_with_lawyers.dart';

class AllServicesScreen extends StatefulWidget {
  final AboutUsModel _aboutUsModel;
  final FilterData _filterData;
  final List<law.Lawyer> _lawyersList;

  AllServicesScreen(this._aboutUsModel, this._filterData, this._lawyersList);

  _AllServicesScreen createState() => _AllServicesScreen();
}

class _AllServicesScreen extends State<AllServicesScreen> {
  TextEditingController searchController = TextEditingController();
  TextEditingController subServiceController = TextEditingController();
  TextEditingController statusController = TextEditingController();

  List statuses = [
    {
      'id': 0,
      'name': 'جديدة',
    },
    {
      'id': 1,
      'name': 'ملغية',
    },
    {
      'id': 2,
      'name': 'مكتملة',
    },
  ];

  bool? _activateFilter = false;
  bool? _lawyer = true;
  bool noUser = false;
  bool? _representative = false;
  late SharedPreferences _pref;
  List<Bookings> bookingsList = [];
  List<Bookings> filterList = [];
  List<Bookings> searchInFilterList = [];
  @override
  void initState() {
    Future.delayed(Duration(seconds: 0)).then((_) async {
      _pref = await SharedPreferences.getInstance();
      subServiceController.text = 'محامي';
      if (_pref.getString('userToken') != null) {
        print('++++++++>');
        bookingsList =
            await BlocProvider.of<BookingCubit>(context).getBookingsWithoutLawyers(_pref.getString('userToken')!);
        setState(() {});
      } else {
        setState(() {
          noUser = true;
          bookingsList = [];
        });
      }
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
                          onTap: null,
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
              Padding(
                padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.teal,
                      ),
                    ),
                    Text(
                      "خدماتـــي",
                      style: TextStyles.h2Bold.copyWith(fontSize: 24),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.04),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: SizeConfig.screenWidth * 0.55,
                      height: SizeConfig.screenHeight * 0.07,
                      child: TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        textAlign: TextAlign.right,
                        controller: searchController,
                        maxLines: 1,
                        // cursorColor: Color(0xffF2F2F2),
                        style: GoogleFonts.elMessiri(color: Colors.black, fontSize: 16.0),
                        onChanged: (val) {
                          searchController.text = val.trim();
                          searchController.selection =
                              TextSelection.fromPosition(TextPosition(offset: searchController.text.length));
                          if (_activateFilter!) {
                            filterList = searchInFilterList
                                .where((booking) => booking.subService!.name!.startsWith(val.trim()))
                                .toList();
                          } else {
                            filterList = this
                                .bookingsList
                                .where((booking) => booking.subService!.name!.startsWith(val.trim()))
                                .toList();
                          }
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xffF2F2F2),
                          hintStyle: GoogleFonts.elMessiri(fontSize: 13.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintText: '..ابحث عن خدمه',
                          prefixIcon: InkWell(
                            onTap: () {
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
                                            width: SizeConfig.screenWidth * 0.35,
                                            height: SizeConfig.screenHeight * 0.55,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(15), color: Colors.white),
                                            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    IconButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      icon: Icon(Icons.cancel),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  'ترتيب حسب الخبرة',
                                                  style: TextStyles.h1.copyWith(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 25,
                                                  child: CheckboxListTile(
                                                    title: Text(
                                                      'محامي',
                                                      style: TextStyles.h4,
                                                    ),
                                                    value: _lawyer,
                                                    onChanged: (newValue) {
                                                      setStateDialog(() {
                                                        _lawyer = newValue;
                                                        _representative = !newValue!;
                                                      });
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 25,
                                                  child: CheckboxListTile(
                                                    title: Text(
                                                      'متدرب',
                                                      style: TextStyles.h4,
                                                    ),
                                                    value: _representative,
                                                    onChanged: (newValue) {
                                                      setStateDialog(() {
                                                        _representative = newValue;
                                                        _lawyer = !newValue!;
                                                      });
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: SizeConfig.screenHeight * 0.04,
                                                ),
                                                Text(
                                                  'فلتر بواسطة',
                                                  style: TextStyles.h1.copyWith(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: SizeConfig.screenHeight * 0.02,
                                                ),
                                                SizedBox(
                                                  height: SizeConfig.screenHeight * 0.07,
                                                  child: DropdownButtonFormField(
                                                    decoration: InputDecoration(
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide.none,
                                                        // borderRadius: BorderRadius.circular(10),
                                                      ),
                                                      disabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide.none,
                                                      ),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide.none,
                                                      ),
                                                      fillColor: Colors.transparent,
                                                      filled: true,
                                                      hintText: 'الخدمة',
                                                      hintStyle: TextStyles.h4,
                                                    ),
                                                    onChanged: (value) {
                                                      setStateDialog(() {
                                                        subServiceController.text = value.toString();
                                                      });
                                                    },
                                                    items: widget._filterData.subs!
                                                        .map(
                                                          (service) => DropdownMenuItem(
                                                            child: Text(
                                                              service.name!,
                                                              style: TextStyles.h4,
                                                              textAlign: TextAlign.center,
                                                            ),
                                                            value: service.name!,
                                                          ),
                                                        )
                                                        .toList(),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: SizeConfig.screenHeight * 0.07,
                                                  child: DropdownButtonFormField(
                                                    decoration: InputDecoration(
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide.none,
                                                        // borderRadius: BorderRadius.circular(10),
                                                      ),
                                                      disabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide.none,
                                                      ),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide.none,
                                                      ),
                                                      fillColor: Colors.transparent,
                                                      filled: true,
                                                      hintText: 'الحالة',
                                                      hintStyle: TextStyles.h4,
                                                    ),
                                                    onChanged: (value) {
                                                      setStateDialog(() {
                                                        statusController.text =
                                                            statuses[int.parse(value.toString())]['name'];
                                                      });
                                                    },
                                                    items: statuses
                                                        .map(
                                                          (status) => DropdownMenuItem(
                                                            child: Text(
                                                              status['name']!,
                                                              style: TextStyles.h4,
                                                              textAlign: TextAlign.center,
                                                            ),
                                                            value: status['id']!,
                                                          ),
                                                        )
                                                        .toList(),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: SizeConfig.screenWidth * 0.35,
                                                  height: SizeConfig.screenHeight * 0.08,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      SizedBox(
                                                        width: SizeConfig.screenWidth * 0.15,
                                                        height: SizeConfig.screenHeight * 0.08,
                                                        child: BasicButton(
                                                          buttonName: 'فلتر',
                                                          onPressedFunction: () {
                                                            Navigator.of(context).pop();
                                                            if (statusController.text != '') {
                                                              if (subServiceController.text == '') {
                                                                filterList = this
                                                                    .bookingsList
                                                                    .where((booking) =>
                                                                        booking.status == statusController.text)
                                                                    .where((booking) {
                                                                  if (_lawyer!) {
                                                                    return booking.lawyer!.type == 'lawyer';
                                                                  } else {
                                                                    return booking.lawyer!.type == 'training';
                                                                  }
                                                                }).toList();
                                                              } else {
                                                                filterList = this
                                                                    .bookingsList
                                                                    .where((booking) =>
                                                                        booking.status == statusController.text)
                                                                    .where((booking) =>
                                                                        booking.subService!.name ==
                                                                        subServiceController.text)
                                                                    .where((booking) {
                                                                  if (_lawyer!) {
                                                                    return booking.lawyer!.type == 'lawyer';
                                                                  } else {
                                                                    return booking.lawyer!.type == 'training';
                                                                  }
                                                                }).toList();
                                                              }
                                                            } else {
                                                              if (subServiceController.text != '') {
                                                                filterList = this
                                                                    .bookingsList
                                                                    .where((booking) =>
                                                                        booking.subService!.name ==
                                                                        subServiceController.text)
                                                                    .where((booking) {
                                                                  if (_lawyer!) {
                                                                    return booking.lawyer!.type == 'lawyer';
                                                                  } else {
                                                                    return booking.lawyer!.type == 'training';
                                                                  }
                                                                }).toList();
                                                              } else {
                                                                filterList = this.bookingsList.where((booking) {
                                                                  if (_lawyer!) {
                                                                    return booking.lawyer!.type == 'lawyer';
                                                                  } else {
                                                                    return booking.lawyer!.type == 'training';
                                                                  }
                                                                }).toList();
                                                              }
                                                            }
                                                            setState(() {
                                                              _activateFilter = true;
                                                              searchInFilterList = filterList;
                                                              statusController.text = '';
                                                              subServiceController.text = '';
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: SizeConfig.screenWidth * 0.15,
                                                        height: SizeConfig.screenHeight * 0.08,
                                                        child: BasicButton(
                                                          buttonName: 'إلغاء الفلتر',
                                                          onPressedFunction: () {
                                                            Navigator.of(context).pop();
                                                            setState(() {
                                                              _activateFilter = false;
                                                              _lawyer = true;
                                                              searchController.text = '';
                                                              statusController.text = '';
                                                              subServiceController.text = '';
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ],
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
                              );
                            },
                            child: Image.asset(
                              'assets/images/filter.png',
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.02,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (context) => BookingCubit(BookingRepository(WebServices())),
                              child: AllServicesWithLawyers(
                                widget._aboutUsModel,
                                widget._filterData,
                                widget._lawyersList,
                              ),
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'لتعديل مواعيد الحجز الخاصة بالمحاميين٬ إضغط هنا',
                        style: TextStyles.h3.copyWith(
                          color: Colors.teal,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.04,
                    ),
                    SizedBox(
                        height: SizeConfig.screenHeight * 0.5,
                        width: SizeConfig.screenWidth * 0.55,
                        child: (noUser)
                            ? Center(
                                child: Text(
                                  'قم بتسجيل الدخول ليتم ظهور خدماتك المحجوزة\n يمكنك تسجيل الدخول من القائمة الجانبية',
                                  style: TextStyles.h2Bold,
                                  textAlign: TextAlign.center,
                                  textDirection: TextDirection.rtl,
                                ),
                              )
                            : BlocBuilder<BookingCubit, BookingState>(
                                builder: (context, state) {
                                  if (state is GetBookingsWithoutLawyersState) {
                                    return AllServicesGrid(
                                      (_activateFilter!)
                                          ? filterList
                                          : (searchController.text == '')
                                              ? bookingsList
                                              : filterList,
                                      widget._aboutUsModel,
                                      widget._filterData,
                                      widget._lawyersList,
                                      false,
                                    );
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                },
                              )),
                  ],
                ),
              ),
              SizedBox(
                height: SizeConfig.screenHeight * 0.04,
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
