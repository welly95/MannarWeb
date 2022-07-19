import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../bloc/lawyer/lawyer_cubit.dart';
import '../../bloc/services/services_cubit.dart';
import '../../bloc/user/user_cubit.dart';
import '../../models/aboutUsModel.dart';
import '../../models/filter_data.dart';
import '../../bloc/booking/booking_cubit.dart';

import '../../constants/size_config.dart';
import '../../constants/styles.dart';
import '../../models/bookings.dart';
import '../../models/lawyers.dart' as law;
import '../../repository/lawyer_repository.dart';
import '../../repository/services_repository.dart';
import '../../repository/user_repository.dart';
import '../../repository/web_services.dart';
import '../../widgets/allServices/all_services_grid.dart';
import '../../widgets/buttons/basic_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../aboutUs/about_us.dart';
import '../chat/chats_page.dart';
import '../contactUS/contact_us.dart';
import '../home/home_screen.dart';
import '../lawyer/search_lawyer.dart';

class AllServicesWithLawyers extends StatefulWidget {
  final AboutUsModel _aboutUsModel;
  final FilterData _filterData;
  final List<law.Lawyer> _lawyersList;

  AllServicesWithLawyers(this._aboutUsModel, this._filterData, this._lawyersList);
  _AllServicesWithLawyers createState() => _AllServicesWithLawyers();
}

class _AllServicesWithLawyers extends State<AllServicesWithLawyers> {
  TextEditingController searchController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController mainDepartmentController = TextEditingController();
  TextEditingController statusController = TextEditingController();

  bool? _lawyer = true;
  bool? _representative = false;
  late SharedPreferences _pref;
  List<Bookings> bookingsList = [];
  List<Bookings> filteredBookingsList = [];
  bool noUser = false;
  bool filteredOn = false;
  List<String> statuses = ['ملغية', 'جديدة', 'مكتملة'];
  @override
  void initState() {
    Future.delayed(Duration(seconds: 0)).then((_) async {
      _pref = await SharedPreferences.getInstance();
      typeController.text = 'محامي';
      if (_pref.getString('userToken') != null) {
        print('++++++++>');
        bookingsList = await BlocProvider.of<BookingCubit>(context).getBookings(_pref.getString('userToken')!);
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
                      width: SizeConfig.screenWidth * 0.9,
                      height: SizeConfig.screenHeight * 0.07,
                      child: TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        textAlign: TextAlign.right,
                        maxLines: 1,
                        cursorColor: Color(0xffF2F2F2),
                        enabled: (bookingsList.isEmpty) ? false : true,
                        onFieldSubmitted: (value) {
                          searchController.text = value.trim();
                          setState(() {
                            filteredBookingsList = this
                                .bookingsList
                                .where((booking) => booking.subService!.name!.startsWith(value.trim()))
                                .toList();
                            filteredOn = true;
                          });
                          print(filteredBookingsList);
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
                              if (widget._filterData.main == null) {
                                return;
                              } else {
                                showModalBottomSheet(
                                  context: context,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30),
                                  )),
                                  builder: (ctx) {
                                    return StatefulBuilder(
                                      builder: (context2, setState2) {
                                        return Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: Container(
                                            margin: EdgeInsets.symmetric(horizontal: 20),
                                            height: SizeConfig.screenHeight * 0.95,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: SizeConfig.screenHeight * 0.02,
                                                ),
                                                Text(
                                                  'ترتيب حسب الخبرة',
                                                  style: TextStyles.h1.copyWith(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: SizeConfig.screenHeight * 0.06,
                                                  child: CheckboxListTile(
                                                    title: Text(
                                                      'محامي',
                                                      style: TextStyles.h4,
                                                    ),
                                                    value: _lawyer,
                                                    onChanged: (newValue) {
                                                      setState2(() {
                                                        _lawyer = newValue;
                                                        _representative = !newValue!;
                                                        typeController.text = 'محامي';
                                                      });
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: SizeConfig.screenHeight * 0.06,
                                                  child: CheckboxListTile(
                                                    title: Text(
                                                      'مندوب',
                                                      style: TextStyles.h4,
                                                    ),
                                                    value: _representative,
                                                    onChanged: (newValue) {
                                                      setState2(() {
                                                        _representative = newValue;
                                                        _lawyer = !newValue!;
                                                        typeController.text = 'مندوب';
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
                                                  height: SizeConfig.screenHeight * 0.08,
                                                  child: Directionality(
                                                    textDirection: TextDirection.rtl,
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
                                                        setState2(() {
                                                          mainDepartmentController.text = value.toString();
                                                        });
                                                      },
                                                      items: widget._filterData.main!
                                                          .map(
                                                            (mainDepartments) => DropdownMenuItem(
                                                              child: Text(
                                                                mainDepartments.name!,
                                                                style: TextStyles.h4,
                                                                textAlign: TextAlign.center,
                                                              ),
                                                              value: mainDepartments.name!,
                                                            ),
                                                          )
                                                          .toList(),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: SizeConfig.screenHeight * 0.08,
                                                  child: Directionality(
                                                    textDirection: TextDirection.rtl,
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
                                                        setState2(() {
                                                          statusController.text = value.toString();
                                                        });
                                                      },
                                                      items: statuses
                                                          .map(
                                                            (statues) => DropdownMenuItem(
                                                                child: Text(
                                                                  statues,
                                                                  style: TextStyles.h4,
                                                                  textAlign: TextAlign.center,
                                                                ),
                                                                value: statues),
                                                          )
                                                          .toList(),
                                                    ),
                                                  ),
                                                ),
                                                // SizedBox(
                                                //   height: SizeConfig.screenHeight * 0.15,
                                                // ),
                                                SizedBox(
                                                  width: SizeConfig.screenWidth * 0.85,
                                                  height: SizeConfig.screenHeight * 0.08,
                                                  child: BasicButton(
                                                    buttonName: 'فلتر',
                                                    onPressedFunction: () {
                                                      print(mainDepartmentController.text);
                                                      setState(() {
                                                        filteredBookingsList = bookingsList.where((element) {
                                                          if (mainDepartmentController.text.isNotEmpty &&
                                                              statusController.text.isEmpty) {
                                                            return element.main!.name == mainDepartmentController.text;
                                                          } else if (mainDepartmentController.text.isEmpty &&
                                                              statusController.text.isNotEmpty) {
                                                            return element.status == statusController.text;
                                                          } else {
                                                            return element.main!.name ==
                                                                    mainDepartmentController.text &&
                                                                element.status == statusController.text;
                                                          }
                                                        }).toList();
                                                        print(filteredBookingsList);
                                                        filteredOn = true;
                                                      });

                                                      Navigator.of(context).pop();
                                                      setState(() {
                                                        typeController.text = 'محامي';
                                                        mainDepartmentController.clear();
                                                        statusController.clear();
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                              }
                            },
                            child: Image.asset(
                              'assets/images/filter.png',
                            ),
                          ),
                        ),
                        //counterText: '0 characters',
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.02,
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
                                if (state is GetBookingsState) {
                                  return AllServicesGrid(
                                      (filteredOn)
                                          ? filteredBookingsList.reversed.toList()
                                          : bookingsList.reversed.toList(),
                                      widget._aboutUsModel,
                                      widget._filterData,
                                      widget._lawyersList,
                                      true);
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              },
                            ),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.02,
                    ),
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
