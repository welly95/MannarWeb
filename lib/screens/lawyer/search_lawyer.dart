import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mannar_web/bloc/country/country_cubit.dart';
import 'package:mannar_web/bloc/service_provider/service_provider_cubit.dart';
import 'package:mannar_web/bloc/services/services_cubit.dart';
import 'package:mannar_web/bloc/user/user_cubit.dart';
import 'package:mannar_web/models/aboutUsModel.dart';
import 'package:mannar_web/repository/countries_repository.dart';
import 'package:mannar_web/repository/service_provider_repository.dart';
import 'package:mannar_web/repository/services_repository.dart';
import 'package:mannar_web/repository/user_repository.dart';
import 'package:mannar_web/screens/aboutUs/about_us.dart';
import 'package:mannar_web/screens/chat/chats_page.dart';
import 'package:mannar_web/screens/contactUS/contact_us.dart';
import 'package:mannar_web/screens/home/home_screen.dart';
import 'package:mannar_web/screens/profile/profile_information.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../bloc/lawyer/lawyer_cubit.dart';
import '../../constants/size_config.dart';
import '../../constants/styles.dart';
import '../../models/filter_data.dart';
import '../../models/lawyers.dart';
import '../../repository/lawyer_repository.dart';
import '../../repository/web_services.dart';
import '../../widgets/buttons/basic_button.dart';
import '../../widgets/lawyerGrid/lawyer_grid.dart';

class SearchLawyer extends StatefulWidget {
  final FilterData _filterData;
  final List<Lawyer> lawyerList;
  final AboutUsModel _aboutUsModel;

  SearchLawyer(this._filterData, this.lawyerList, this._aboutUsModel);

  @override
  _SearchLawyerState createState() => _SearchLawyerState();
}

class _SearchLawyerState extends State<SearchLawyer> {
  TextEditingController nameController = TextEditingController();
  TextEditingController mainDepartmentController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController specialistController = TextEditingController();

  List<Lawyer> _lawyersList = [];
  List<dynamic> filteredCities = [];
  late List<Lawyer> _searchedLawyers;

  bool? _lawyer = true;
  bool? _representative = false;

  @override
  void initState() {
    Future.delayed(Duration(seconds: 0)).then((_) async {
      BlocProvider.of<LawyerCubit>(context);
      // _lawyersList = await BlocProvider.of<LawyerCubit>(context).getLawyersList(nameController.text);
    });
    _lawyersList = widget.lawyerList.where((element) => element.internalExternal == 'خارجي').toList();
    nameController.text = '';
    mainDepartmentController.text = '';
    cityController.text = '';
    typeController.text = 'محامي';
    specialistController.text = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          body: SingleChildScrollView(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
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
                                          false, widget._aboutUsModel, widget._filterData, _lawyersList),
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
                                      child: ContactUs(widget.lawyerList, widget._filterData, widget._aboutUsModel),
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
                                      child: AboutUs(widget.lawyerList, widget._filterData, widget._aboutUsModel),
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
                                        ChatsPage(widget._aboutUsModel, widget._filterData, widget.lawyerList),
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
                    child: BlocBuilder<LawyerCubit, LawyerState>(
                      builder: (context, state) {
                        if (_lawyersList != []) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: SizeConfig.screenHeight * 0.02,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    icon: Icon(
                                      Icons.arrow_back,
                                      color: Color(0xff03564C),
                                    ),
                                  ),
                                  Container(
                                    width: SizeConfig.screenWidth * 0.55,
                                    height: SizeConfig.screenHeight * 0.06,
                                    child: TextFormField(
                                      controller: nameController,
                                      autofocus: false,
                                      textAlignVertical: TextAlignVertical.center,
                                      textAlign: TextAlign.right,
                                      maxLines: 1,
                                      cursorColor: Colors.grey,
                                      keyboardType: TextInputType.text,
                                      onChanged: (value) {
                                        nameController.text = value.trim();
                                        nameController.selection = TextSelection.fromPosition(
                                            TextPosition(offset: nameController.text.length));
                                        _searchedLawyers = this
                                            ._lawyersList
                                            .where((lawyer) => lawyer.name!.startsWith(value.trim()))
                                            .toList();
                                        setState(() {});
                                      },
                                      style: GoogleFonts.elMessiri(color: Colors.black, fontSize: 16.0),
                                      decoration: InputDecoration(
                                        hintStyle:
                                            GoogleFonts.elMessiri(color: const Color(0xff03564C), fontSize: 13.0),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                          borderSide: BorderSide.none,
                                        ),
                                        fillColor: Colors.grey[200],
                                        filled: true,
                                        hintText: '..ابحث عن محامي',
                                        prefixIcon: InkWell(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              useRootNavigator: true,
                                              useSafeArea: false,
                                              builder: (_) => BlocProvider(
                                                lazy: false,
                                                create: (context) => LawyerCubit(LawyerRepository(WebServices())),
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
                                                            height: SizeConfig.screenHeight * 0.75,
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(15),
                                                                color: Colors.white),
                                                            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
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
                                                                SizedBox(
                                                                  height: SizeConfig.screenHeight * 0.02,
                                                                ),
                                                                Text(
                                                                  'فلتر بواسطة',
                                                                  style: TextStyles.h1.copyWith(
                                                                    color: Colors.black,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: SizeConfig.screenHeight * 0.07,
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
                                                                        setStateDialog(() {
                                                                          mainDepartmentController.text =
                                                                              value.toString();
                                                                        });
                                                                        setState(() {
                                                                          mainDepartmentController.text =
                                                                              value.toString();
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
                                                                              value: mainDepartments.id!,
                                                                            ),
                                                                          )
                                                                          .toList(),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: SizeConfig.screenHeight * 0.07,
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
                                                                        hintText: 'البلد',
                                                                        hintStyle: TextStyles.h4,
                                                                      ),
                                                                      onChanged: (value) async {
                                                                        setStateDialog(() {
                                                                          countryController.text = value.toString();
                                                                          print(countryController.text);
                                                                          filteredCities = widget._filterData.cities!
                                                                              .where((element) =>
                                                                                  element.countryId ==
                                                                                  int.parse(countryController.text))
                                                                              .toList();
                                                                          print(filteredCities);
                                                                        });
                                                                        setState(() {
                                                                          countryController.text = value.toString();
                                                                          filteredCities = widget._filterData.cities!
                                                                              .where((element) =>
                                                                                  element.countryId ==
                                                                                  int.parse(countryController.text))
                                                                              .toList();
                                                                        });
                                                                      },
                                                                      items: widget._filterData.countries!
                                                                          .map(
                                                                            (countries) => DropdownMenuItem(
                                                                              child: Text(
                                                                                countries.nationality!,
                                                                                style: TextStyles.h4,
                                                                                textAlign: TextAlign.center,
                                                                              ),
                                                                              value: countries.id!,
                                                                            ),
                                                                          )
                                                                          .toList(),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: SizeConfig.screenHeight * 0.06,
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
                                                                        hintText: 'المدينة',
                                                                        hintStyle: TextStyles.h4,
                                                                      ),
                                                                      onChanged: (value) {
                                                                        setStateDialog(() {
                                                                          cityController.text = value.toString();
                                                                        });
                                                                        setState(() {
                                                                          cityController.text = value.toString();
                                                                        });
                                                                      },
                                                                      items: filteredCities
                                                                          .map(
                                                                            (cities) => DropdownMenuItem(
                                                                              child: Text(
                                                                                cities.name!,
                                                                                style: TextStyles.h4,
                                                                                textAlign: TextAlign.center,
                                                                              ),
                                                                              value: cities.id!,
                                                                            ),
                                                                          )
                                                                          .toList(),
                                                                    ),
                                                                  ),
                                                                ),
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
                                                                  height: SizeConfig.screenHeight * 0.04,
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
                                                                        typeController.text = 'محامي';
                                                                      });
                                                                      setState(() {
                                                                        _lawyer = newValue;
                                                                        _representative = !newValue!;
                                                                        typeController.text = 'محامي';
                                                                      });
                                                                    },
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: SizeConfig.screenHeight * 0.04,
                                                                  child: CheckboxListTile(
                                                                    title: Text(
                                                                      'مترجم',
                                                                      style: TextStyles.h4,
                                                                    ),
                                                                    value: _representative,
                                                                    onChanged: (newValue) {
                                                                      setStateDialog(() {
                                                                        _representative = newValue;
                                                                        _lawyer = !newValue!;
                                                                        typeController.text = 'مترجم';
                                                                      });
                                                                      setState(() {
                                                                        _representative = newValue;
                                                                        _lawyer = !newValue!;
                                                                        typeController.text = 'مترجم';
                                                                      });
                                                                    },
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: SizeConfig.screenHeight * 0.02,
                                                                ),
                                                                SizedBox(
                                                                  width: SizeConfig.screenWidth * 0.55,
                                                                  // height: SizeConfig.screenHeight * 0.5,
                                                                  child: Center(
                                                                    child: GridView.builder(
                                                                      itemCount: widget._filterData.services!.length,
                                                                      shrinkWrap: true,
                                                                      physics: NeverScrollableScrollPhysics(),
                                                                      gridDelegate:
                                                                          SliverGridDelegateWithFixedCrossAxisCount(
                                                                        crossAxisCount: 4,
                                                                        crossAxisSpacing: SizeConfig.screenWidth * 0.01,
                                                                        childAspectRatio: 2,
                                                                        mainAxisSpacing: 2,
                                                                      ),
                                                                      itemBuilder: (BuildContext context, int index) {
                                                                        return InkWell(
                                                                          highlightColor: Colors.white,
                                                                          onTap: () {
                                                                            setStateDialog(() {});
                                                                          },
                                                                          child: Container(
                                                                            padding: EdgeInsets.all(4),
                                                                            decoration: BoxDecoration(
                                                                                color: Colors.amberAccent,
                                                                                border: Border.all(
                                                                                  color: Colors.amberAccent,
                                                                                ),
                                                                                borderRadius: BorderRadius.all(
                                                                                  Radius.circular(20),
                                                                                )),
                                                                            child: Center(
                                                                              child: Text(
                                                                                widget
                                                                                    ._filterData.services![index].name!,
                                                                                style: TextStyles.h3
                                                                                    .copyWith(color: Colors.white),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: SizeConfig.screenHeight * 0.03,
                                                                ),
                                                                SizedBox(
                                                                  width: SizeConfig.screenWidth * 0.35,
                                                                  height: SizeConfig.screenHeight * 0.07,
                                                                  child: BlocProvider(
                                                                    create: (context) =>
                                                                        LawyerCubit(LawyerRepository(WebServices())),
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        SizedBox(
                                                                          width: SizeConfig.screenWidth * 0.15,
                                                                          height: SizeConfig.screenHeight * 0.07,
                                                                          child: BasicButton(
                                                                            buttonName: 'فلتر',
                                                                            onPressedFunction: () async {
                                                                              await BlocProvider.of<LawyerCubit>(
                                                                                      context)
                                                                                  .getFilteredLawyersList(
                                                                                countryController.text,
                                                                                cityController.text,
                                                                                typeController.text,
                                                                                (mainDepartmentController.text == '')
                                                                                    ? []
                                                                                    : [
                                                                                        int.parse(
                                                                                            mainDepartmentController
                                                                                                .text),
                                                                                      ],
                                                                                [],
                                                                              ).then((value) async {
                                                                                if (nameController.text != '') {
                                                                                  await BlocProvider.of<LawyerCubit>(
                                                                                          context)
                                                                                      .getLawyersList('');
                                                                                  _searchedLawyers = value
                                                                                      .where((lawyers) => lawyers.name!
                                                                                          .startsWith(nameController
                                                                                              .text
                                                                                              .trim()))
                                                                                      .toList();
                                                                                  countryController.clear();
                                                                                  Navigator.of(context).pop();
                                                                                  setState(() {});
                                                                                } else {
                                                                                  await BlocProvider.of<LawyerCubit>(
                                                                                          context)
                                                                                      .getLawyersList('');
                                                                                  _lawyersList = value;
                                                                                  mainDepartmentController.clear();
                                                                                  countryController.clear();
                                                                                  cityController.clear();
                                                                                  Navigator.of(context).pop();
                                                                                  setState(() {});
                                                                                }
                                                                              });
                                                                            },
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width: SizeConfig.screenWidth * 0.02,
                                                                        ),
                                                                        SizedBox(
                                                                          width: SizeConfig.screenWidth * 0.15,
                                                                          height: SizeConfig.screenHeight * 0.07,
                                                                          child: BasicButton(
                                                                            buttonName: 'إلغاء الفلتر',
                                                                            onPressedFunction: () async {
                                                                              await BlocProvider.of<LawyerCubit>(
                                                                                      context)
                                                                                  .getFilteredLawyersList(
                                                                                '',
                                                                                '',
                                                                                '',
                                                                                [],
                                                                                [],
                                                                              ).then((value) async {
                                                                                if (nameController.text != '') {
                                                                                  await BlocProvider.of<LawyerCubit>(
                                                                                          context)
                                                                                      .getLawyersList('');
                                                                                  _searchedLawyers = value
                                                                                      .where((lawyers) => lawyers.name!
                                                                                          .startsWith(nameController
                                                                                              .text
                                                                                              .trim()))
                                                                                      .toList();
                                                                                  countryController.clear();
                                                                                  Navigator.of(context).pop();
                                                                                  setState(() {});
                                                                                } else {
                                                                                  await BlocProvider.of<LawyerCubit>(
                                                                                          context)
                                                                                      .getLawyersList('');
                                                                                  _lawyersList = value;
                                                                                  mainDepartmentController.clear();
                                                                                  countryController.clear();
                                                                                  cityController.clear();
                                                                                  Navigator.of(context).pop();
                                                                                  setState(() {});
                                                                                }
                                                                              });
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
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
                                          },
                                          child: Image.asset(
                                            'assets/images/filter.png',
                                            fit: BoxFit.scaleDown,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.arrow_back,
                                      color: Colors.transparent,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: SizeConfig.screenHeight * 0.04,
                              ),
                              Container(
                                // height: SizeConfig.screenHeight * 0.5,
                                width: SizeConfig.screenWidth * 0.55,
                                child: BlocProvider(
                                  create: (context) => LawyerCubit(
                                    LawyerRepository(
                                      WebServices(),
                                    ),
                                  ),
                                  child: LawyerGrid(
                                    widget.lawyerList,
                                    widget._filterData,
                                    widget._aboutUsModel,
                                    reservation: false,
                                    lawyerName: nameController.text,
                                    lawyersList: nameController.text != '' ? _searchedLawyers : _lawyersList,
                                    fromCourt: false,
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else if (state is GetFilteredLawyersState) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: SizeConfig.screenWidth * 0.55,
                                height: SizeConfig.screenHeight * 0.06,
                                child: TextFormField(
                                  controller: nameController,
                                  autofocus: false,
                                  textAlignVertical: TextAlignVertical.center,
                                  textAlign: TextAlign.right,
                                  maxLines: 1,
                                  cursorColor: Colors.grey,
                                  keyboardType: TextInputType.text,
                                  onChanged: (value) async {
                                    nameController.text = value.trim();
                                    _searchedLawyers = this
                                        ._lawyersList
                                        .where((lawyer) => lawyer.name!.startsWith(value.trim()))
                                        .toList();
                                    setState(() {});
                                  },
                                  style: GoogleFonts.elMessiri(color: Colors.black, fontSize: 16.0),
                                  decoration: new InputDecoration(
                                    hintStyle: GoogleFonts.elMessiri(color: const Color(0xff03564C), fontSize: 13.0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide.none,
                                    ),
                                    fillColor: Colors.grey[200],
                                    filled: true,
                                    hintText: '..ابحث عن محامي',
                                    prefixIcon: InkWell(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          useRootNavigator: true,
                                          useSafeArea: false,
                                          builder: (_) => BlocProvider(
                                            create: (context) => UserCubit(UserRepository(WebServices())),
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
                                                        width: SizeConfig.screenWidth * 0.40,
                                                        height: SizeConfig.screenHeight * 0.75,
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(15),
                                                            color: Colors.white),
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
                                                            SizedBox(
                                                              height: SizeConfig.screenHeight * 0.02,
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
                                                                    setStateDialog(() {
                                                                      mainDepartmentController.text = value.toString();
                                                                    });
                                                                    print(mainDepartmentController.text);
                                                                  },
                                                                  items: widget._filterData.main!
                                                                      .map(
                                                                        (mainDepartments) => DropdownMenuItem(
                                                                          child: Text(
                                                                            mainDepartments.name!,
                                                                            style: TextStyles.h4,
                                                                            textAlign: TextAlign.center,
                                                                          ),
                                                                          value: mainDepartments.id!,
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
                                                                    hintText: 'البلد',
                                                                    hintStyle: TextStyles.h4,
                                                                  ),
                                                                  onChanged: (value) async {
                                                                    setStateDialog(() {
                                                                      countryController.text = value.toString();
                                                                      print(countryController.text);
                                                                      filteredCities = widget._filterData.cities!
                                                                          .where((element) =>
                                                                              element.countryId ==
                                                                              int.parse(countryController.text))
                                                                          .toList();
                                                                      print(filteredCities);
                                                                    });
                                                                  },
                                                                  items: widget._filterData.countries!
                                                                      .map(
                                                                        (countries) => DropdownMenuItem(
                                                                          child: Text(
                                                                            countries.nationality!,
                                                                            style: TextStyles.h4,
                                                                            textAlign: TextAlign.center,
                                                                          ),
                                                                          value: countries.id!,
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
                                                                    hintText: 'المدينة',
                                                                    hintStyle: TextStyles.h4,
                                                                  ),
                                                                  onChanged: (value) {
                                                                    setStateDialog(() {
                                                                      cityController.text = value.toString();
                                                                    });
                                                                    print(cityController.text);
                                                                  },
                                                                  items: filteredCities
                                                                      .map(
                                                                        (cities) => DropdownMenuItem(
                                                                          child: Text(
                                                                            cities.name!,
                                                                            style: TextStyles.h4,
                                                                            textAlign: TextAlign.center,
                                                                          ),
                                                                          value: cities.id!,
                                                                        ),
                                                                      )
                                                                      .toList(),
                                                                ),
                                                              ),
                                                            ),
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
                                                                  setStateDialog(() {
                                                                    _lawyer = newValue;
                                                                    _representative = !newValue!;
                                                                    typeController.text = 'محامي';
                                                                    print(typeController.text);
                                                                  });
                                                                },
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: SizeConfig.screenHeight * 0.06,
                                                              child: CheckboxListTile(
                                                                title: Text(
                                                                  'مترجم',
                                                                  style: TextStyles.h4,
                                                                ),
                                                                value: _representative,
                                                                onChanged: (newValue) {
                                                                  setStateDialog(() {
                                                                    _representative = newValue;
                                                                    _lawyer = !newValue!;
                                                                    typeController.text = 'مترجم';
                                                                    print(typeController.text);
                                                                  });
                                                                },
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: SizeConfig.screenHeight * 0.06,
                                                            ),
                                                            SizedBox(
                                                              width: SizeConfig.screenWidth * 0.55,
                                                              // height: SizeConfig.screenHeight * 0.1,
                                                              child: Center(
                                                                child: GridView.builder(
                                                                  itemCount: widget._filterData.services!.length,
                                                                  shrinkWrap: true,
                                                                  physics: NeverScrollableScrollPhysics(),
                                                                  gridDelegate:
                                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                                    crossAxisCount: 3,
                                                                    crossAxisSpacing: SizeConfig.screenWidth * 0.01,
                                                                    childAspectRatio: 2.5,
                                                                  ),
                                                                  itemBuilder: (BuildContext context, int index) {
                                                                    return Container(
                                                                      padding: EdgeInsets.all(4),
                                                                      decoration: BoxDecoration(
                                                                        color: Colors.amberAccent,
                                                                        border: Border.all(
                                                                          color: Colors.amberAccent,
                                                                        ),
                                                                        borderRadius: BorderRadius.all(
                                                                          Radius.circular(20),
                                                                        ),
                                                                      ),
                                                                      child: Center(
                                                                        child: Text(
                                                                          widget._filterData.services![index].name!,
                                                                          style: TextStyles.h3
                                                                              .copyWith(color: Colors.white),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: SizeConfig.screenHeight * 0.02,
                                                            ),
                                                            SizedBox(
                                                              width: SizeConfig.screenWidth * 0.45,
                                                              height: SizeConfig.screenHeight * 0.08,
                                                              child: BlocProvider(
                                                                lazy: false,
                                                                create: (context) =>
                                                                    LawyerCubit(LawyerRepository(WebServices())),
                                                                child: BasicButton(
                                                                  buttonName: 'فلتر',
                                                                  onPressedFunction: () async {
                                                                    Navigator.of(context).pop();
                                                                    // Navigator.of(context).pop();

                                                                    await BlocProvider.of<LawyerCubit>(context)
                                                                        .getFilteredLawyersList(
                                                                      countryController.text,
                                                                      cityController.text,
                                                                      typeController.text,
                                                                      (mainDepartmentController.text == '')
                                                                          ? []
                                                                          : [
                                                                              int.parse(mainDepartmentController.text),
                                                                            ],
                                                                      [],
                                                                    ).then((value) async {
                                                                      if (nameController.text != '') {
                                                                        await BlocProvider.of<LawyerCubit>(context)
                                                                            .getLawyersList(nameController.text);
                                                                        _searchedLawyers = value
                                                                            .where((lawyers) => lawyers.name!
                                                                                .startsWith(nameController.text.trim()))
                                                                            .toList();
                                                                      } else {
                                                                        await BlocProvider.of<LawyerCubit>(context)
                                                                            .getLawyersList('');
                                                                        _lawyersList = value;
                                                                      }
                                                                    });
                                                                  },
                                                                ),
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
                                      },
                                      child: Image.asset(
                                        'assets/images/filter.png',
                                        fit: BoxFit.scaleDown,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: SizeConfig.screenHeight * 0.02,
                              ),
                              Container(
                                height: SizeConfig.screenHeight * 0.5,
                                width: SizeConfig.screenWidth * 0.55,
                                child: BlocProvider(
                                  create: (context) => LawyerCubit(
                                    LawyerRepository(
                                      WebServices(),
                                    ),
                                  ),
                                  child: LawyerGrid(
                                    widget.lawyerList,
                                    widget._filterData,
                                    widget._aboutUsModel,
                                    reservation: false,
                                    lawyerName: nameController.text,
                                    lawyersList: nameController.text != '' ? _searchedLawyers : _lawyersList,
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Container(
                            height: SizeConfig.screenHeight * 0.5,
                            child: Center(
                              child: Text(
                                'جاري البحث عن محاميين...',
                                style: TextStyles.h2Bold.copyWith(fontSize: 24),
                              ),
                            ),
                          );
                        }
                      },
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
                                            child:
                                                ContactUs(widget.lawyerList, widget._filterData, widget._aboutUsModel),
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
                                            child: AboutUs(widget.lawyerList, widget._filterData, widget._aboutUsModel),
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
                                              ChatsPage(widget._aboutUsModel, widget._filterData, widget.lawyerList),
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
        ),
      ),
    );
  }
}
