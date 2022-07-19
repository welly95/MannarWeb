import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mannar_web/models/aboutUsModel.dart';
import 'package:mannar_web/models/filter_data.dart';
import 'package:mannar_web/models/lawyers.dart';
import '../../bloc/booking/booking_cubit.dart';
import '../../repository/booking_repository.dart';
import '../../repository/web_services.dart';
import '../../screens/Reservation/court_question.dart';
import '../../screens/home/sub_departments_screen.dart';
import '../../screens/lawyer/lawyer_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../bloc/courts/courts_cubit.dart';
import '../../constants/size_config.dart';
import '../../constants/styles.dart';
import '../../models/courts.dart';

class CourtsWidget extends StatefulWidget {
  final int mainId;
  final mainDepartmentName;
  final bool hasQuestion;
  final String question;
  final bool hasSubServices;
  final bool hasLawyers;
  final bool hasSubQuestions;
  final List chatArray;
  final String pay;
  final int price;
  final List<Lawyer> _lawyersList;
  final FilterData _filterData;
  final AboutUsModel _aboutUsModel;

  CourtsWidget(
    this.mainId,
    this.mainDepartmentName,
    this.hasQuestion,
    this.question,
    this.hasSubServices,
    this.hasLawyers,
    this.hasSubQuestions,
    this.chatArray,
    this.pay,
    this.price,
    this._lawyersList,
    this._filterData,
    this._aboutUsModel,
  );

  @override
  State<CourtsWidget> createState() => _CourtsWidgetState();
}

class _CourtsWidgetState extends State<CourtsWidget> {
  List<Courts> listItem = [];
  late SharedPreferences _pref;

  @override
  void initState() {
    Future.delayed(Duration(seconds: 0)).then((_) async {
      _pref = await SharedPreferences.getInstance();
      listItem = await BlocProvider.of<CourtsCubit>(context).getCourtsList(widget.mainId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocBuilder<CourtsCubit, CourtsState>(
      builder: (context, state) {
        if (state is GetCourtsState) {
          return Container(
            // height: (listItem.length > 0 && listItem.length <= 4)
            //     ? SizeConfig.screenHeight * 0.15
            //     : (listItem.length > 4)
            //         ? SizeConfig.screenHeight * 0.3
            //         : SizeConfig.screenHeight * 0.45,
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
                            _pref.setInt('index', index);
                            _pref.setInt('courtId', listItem[index].id!);
                            print('=====>' + widget.hasLawyers.toString());
                            if (widget.hasSubServices && !widget.hasQuestion) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => SubDepartmentsScreen(
                                    widget.mainId,
                                    widget.mainDepartmentName,
                                    listItem[index].id!,
                                    listItem[index].name!,
                                    true,
                                    '',
                                    widget.chatArray,
                                    widget.hasLawyers,
                                    widget.hasSubQuestions,
                                    widget.pay,
                                    widget.price,
                                    widget._lawyersList,
                                    widget._filterData,
                                    widget._aboutUsModel,
                                  ),
                                ),
                              );
                            } else if (widget.hasSubServices && widget.hasQuestion) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                    create: (context) => BookingCubit(
                                      BookingRepository(
                                        WebServices(),
                                      ),
                                    ),
                                    child: CourtQuestion(
                                      widget.question,
                                      widget.mainId,
                                      widget.mainDepartmentName,
                                      listItem[index].name!,
                                      listItem[index].id!,
                                      true,
                                      widget.hasLawyers,
                                      widget.hasSubQuestions,
                                      widget.chatArray,
                                      widget.pay,
                                      widget.price,
                                      widget._lawyersList,
                                      widget._filterData,
                                      widget._aboutUsModel,
                                    ),
                                  ),
                                ),
                              );
                            } else if (!widget.hasSubServices && widget.hasQuestion) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                    create: (context) => BookingCubit(
                                      BookingRepository(
                                        WebServices(),
                                      ),
                                    ),
                                    child: CourtQuestion(
                                      widget.question,
                                      widget.mainId,
                                      widget.mainDepartmentName,
                                      listItem[index].name!,
                                      listItem[index].id!,
                                      false,
                                      widget.hasLawyers,
                                      widget.hasSubQuestions,
                                      widget.chatArray,
                                      widget.pay,
                                      widget.price,
                                      widget._lawyersList,
                                      widget._filterData,
                                      widget._aboutUsModel,
                                    ),
                                  ),
                                ),
                              );
                            } else if (widget.hasLawyers && !widget.hasSubServices && !widget.hasQuestion) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => LawyerScreen(
                                    true,
                                    widget.mainId,
                                    widget.mainDepartmentName,
                                    listItem[index].name!,
                                    listItem[index].id!,
                                    0,
                                    '',
                                    true,
                                    '',
                                    widget.chatArray,
                                    widget.pay,
                                    widget._lawyersList,
                                    widget._filterData,
                                    widget._aboutUsModel,
                                  ),
                                ),
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
