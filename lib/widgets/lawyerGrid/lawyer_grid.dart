import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mannar_web/models/aboutUsModel.dart';
import 'package:mannar_web/models/filter_data.dart';
import 'package:mannar_web/models/lawyers.dart';
import '../../bloc/cities/cities_cubit.dart';
import '../../bloc/country/country_cubit.dart';

import '../../bloc/lawyer/lawyer_cubit.dart';
import '../../bloc/sub_departments/sub_departments_cubit.dart';
import '../../constants/size_config.dart';
import '../../constants/styles.dart';
import '../../repository/cities_repository.dart';
import '../../repository/countries_repository.dart';
import '../../repository/sub_departments_repository.dart';
import '../../repository/web_services.dart';
import '../../screens/lawyer/lawyer_profile.dart';

class LawyerGrid extends StatefulWidget {
  final bool? reservation;
  final int? subDepartmentId;
  final String? lawyerName;
  final List<dynamic>? lawyersList;
  final bool? fromCourt;
  final String? courtAnswer;
  final List? chatArray;
  final String? pay;

  final List<Lawyer> _lawyersList;
  final FilterData _filterData;
  final AboutUsModel _aboutUsModel;

  LawyerGrid(
    this._lawyersList,
    this._filterData,
    this._aboutUsModel, {
    this.reservation,
    this.subDepartmentId,
    this.lawyerName,
    this.lawyersList,
    this.fromCourt,
    this.courtAnswer,
    this.chatArray,
    this.pay,
  });

  @override
  State<LawyerGrid> createState() => _LawyerGridState();
}

class _LawyerGridState extends State<LawyerGrid> {
  List<dynamic> listItem = [];

  @override
  void initState() {
    Future.delayed(Duration(seconds: 0)).then((_) async {
      if (widget.reservation != false) {
        if (widget.fromCourt!) {
          listItem =
              await BlocProvider.of<LawyerCubit>(context).getSuggetionsLawyersListByCourts(widget.subDepartmentId!);
          print('fromCourts' + listItem.toString());
        } else {
          listItem = await BlocProvider.of<LawyerCubit>(context).getSuggetionsLawyersList(widget.subDepartmentId!);
          print(listItem.toString());
        }
      } else {
        listItem = await BlocProvider.of<LawyerCubit>(context).getLawyersList(widget.lawyerName!);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print('lawyer grid-------->' +
    //     widget.subDepartmentId.toString() +
    //     ',,,,' +
    //     widget.reservation!.toString() +
    //     '++++++' +
    //     widget.lawyersList!.toString() +
    //     '\\\\' +
    //     widget.fromCourt!.toString());
    // print(widget.reservation.toString());

    SizeConfig().init(context);
    return BlocBuilder<LawyerCubit, LawyerState>(
      builder: (context, state) {
        if (state is GetSuggetionsLawyersState) {
          if (state.suggetionLawyer.isEmpty) {
            return Text(
              'لا يوجد محاميين مقترحيين حالياً',
              style: TextStyles.h2Bold.copyWith(fontSize: 24),
              textAlign: TextAlign.center,
            );
          } else {
            return SizedBox(
              height: SizeConfig.screenHeight * 0.5,
              child: ListView.builder(
                  itemCount: listItem.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: InkWell(
                        focusColor: Colors.teal,
                        hoverColor: Colors.teal,
                        borderRadius: BorderRadius.circular(15),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => MultiBlocProvider(
                                providers: [
                                  BlocProvider(
                                    create: (context) => CountryCubit(
                                      CountriesRepository(
                                        WebServices(),
                                      ),
                                    ),
                                  ),
                                  BlocProvider(
                                    create: (context) => CitiesCubit(
                                      CitiesRepository(
                                        WebServices(),
                                      ),
                                    ),
                                  ),
                                  BlocProvider(
                                    create: (context) => SubDepartmentsCubit(
                                      SubDepartmentsRepository(
                                        WebServices(),
                                      ),
                                    ),
                                  ),
                                ],
                                child: LawyerProfile(
                                  widget.reservation!,
                                  widget.subDepartmentId!,
                                  listItem[index],
                                  widget.fromCourt!,
                                  widget.courtAnswer!,
                                  widget.pay!,
                                  widget.chatArray!,
                                  widget._lawyersList,
                                  widget._filterData,
                                  widget._aboutUsModel,
                                ),
                              ),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Padding(
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
                                        (listItem[index].rate == 0.0) ? '' : (listItem[index].rate!).toString(),
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
                                              listItem[index].name!,
                                              style: TextStyles.h3,
                                            ),
                                          ),
                                          Container(
                                            //alignment: Alignment.topRight,
                                            child: Text(
                                              listItem[index].type!,
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
                                          listItem[index].imageurl!,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            );
          }
        } else if (state is GetSuggetionsLawyersByCourtsState) {
          if (state.suggetionLawyer.isEmpty) {
            return Text(
              'لا يوجد محاميين مقترحيين حالياً',
              style: TextStyles.h2Bold,
              textAlign: TextAlign.center,
            );
          } else {
            print('----++++---->');
            return SizedBox(
              height: SizeConfig.screenHeight * 0.5,
              child: ListView.builder(
                  itemCount: listItem.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: InkWell(
                        focusColor: Colors.teal,
                        hoverColor: Colors.teal,
                        borderRadius: BorderRadius.circular(15),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => MultiBlocProvider(
                                providers: [
                                  BlocProvider(
                                    create: (context) => CountryCubit(
                                      CountriesRepository(
                                        WebServices(),
                                      ),
                                    ),
                                  ),
                                  BlocProvider(
                                    create: (context) => CitiesCubit(
                                      CitiesRepository(
                                        WebServices(),
                                      ),
                                    ),
                                  ),
                                  BlocProvider(
                                    create: (context) => SubDepartmentsCubit(
                                      SubDepartmentsRepository(
                                        WebServices(),
                                      ),
                                    ),
                                  ),
                                ],
                                child: LawyerProfile(
                                  widget.reservation!,
                                  widget.subDepartmentId!,
                                  listItem[index],
                                  widget.fromCourt!,
                                  widget.courtAnswer!,
                                  widget.pay!,
                                  widget.chatArray!,
                                  widget._lawyersList,
                                  widget._filterData,
                                  widget._aboutUsModel,
                                ),
                              ),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Padding(
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
                                        (listItem[index].rate == 0.0) ? '' : (listItem[index].rate!).toString(),
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
                                              listItem[index].name!,
                                              style: TextStyles.h3,
                                            ),
                                          ),
                                          Container(
                                            //alignment: Alignment.topRight,
                                            child: Text(
                                              listItem[index].type!,
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
                                          listItem[index].imageurl!,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            );
          }
        } else if (state is GetLawyersState) {
          return SizedBox(
            height: SizeConfig.screenHeight * 0.5,
            child: ListView.builder(
                itemCount: widget.lawyersList!.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: InkWell(
                      focusColor: Colors.teal,
                      hoverColor: Colors.teal,
                      borderRadius: BorderRadius.circular(15),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => MultiBlocProvider(
                              providers: [
                                BlocProvider(
                                  create: (context) => CountryCubit(
                                    CountriesRepository(
                                      WebServices(),
                                    ),
                                  ),
                                ),
                                BlocProvider(
                                  create: (context) => CitiesCubit(
                                    CitiesRepository(
                                      WebServices(),
                                    ),
                                  ),
                                ),
                              ],
                              child: LawyerProfile(
                                widget.reservation!,
                                (widget.subDepartmentId == null) ? 0 : widget.subDepartmentId!,
                                widget.lawyersList![index],
                                widget.fromCourt ?? false,
                                widget.courtAnswer ?? '',
                                widget.pay ?? '0',
                                [],
                                widget._lawyersList,
                                widget._filterData,
                                widget._aboutUsModel,
                              ),
                            ),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Padding(
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
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Text(
                                      (widget.lawyersList![index].rate == 0.0)
                                          ? ''
                                          : (widget.lawyersList![index].rate).toString(),
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
                                            widget.lawyersList![index].name!,
                                            style: TextStyles.h3,
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            widget.lawyersList![index].type!,
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
                                        widget.lawyersList![index].imageurl!,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
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
    );
  }
}
