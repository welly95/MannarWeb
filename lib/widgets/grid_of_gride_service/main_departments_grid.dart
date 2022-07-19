import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mannar_web/models/aboutUsModel.dart';
import 'package:mannar_web/models/filter_data.dart';
import 'package:mannar_web/models/lawyers.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../bloc/booking/booking_cubit.dart';
import '../../bloc/user/user_cubit.dart';
import '../../repository/booking_repository.dart';
import '../../repository/user_repository.dart';
import '../../repository/web_services.dart';
import '../../screens/chat/quick_chat.dart';
import '../../screens/home/sub_departments_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/size_config.dart';
import '../../constants/styles.dart';
import '../../models/main_departments.dart';
import '../../bloc/main_departments/main_departments_cubit.dart';
import '../../screens/home/courts_screen.dart';
import '../buttons/basic_button.dart';
import '../textfields/number_textfield.dart';

class MainDepartmentsGrid extends StatefulWidget {
  final List<Lawyer> _lawyersList;
  final FilterData _filterData;
  final AboutUsModel _aboutUsModel;

  MainDepartmentsGrid(this._lawyersList, this._filterData, this._aboutUsModel);

  @override
  State<MainDepartmentsGrid> createState() => _MainDepartmentsGridState();
}

class _MainDepartmentsGridState extends State<MainDepartmentsGrid> {
  late SharedPreferences _pref;
  List<MainDepartments> listIitem = [];
  TextEditingController _verifyController = TextEditingController();

  @override
  void initState() {
    Future.delayed(Duration(seconds: 0)).then((_) async {
      _pref = await SharedPreferences.getInstance();
      listIitem = await BlocProvider.of<MainDepartmentsCubit>(context).getMainDepartmentsList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocBuilder<MainDepartmentsCubit, MainDepartmentsState>(
      builder: (context, state) {
        if (state is GetMainDepartmentsState) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: GridView.builder(
                  itemCount: listIitem.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: SizeConfig.screenWidth * 0.03,
                    // childAspectRatio:
                    //     (MediaQuery.of(context).size.width * 0.95) / (MediaQuery.of(context).size.height / 1.8),
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      highlightColor: Colors.white,
                      onTap: () async {
                        _pref.setInt('mainId', listIitem[index].id!);
                        // print('from SharedPref. --------->' + _pref.getInt('mainId').toString());
                        if (listIitem[index].hasCourts == 1) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CourtsScreen(
                                listIitem[index].id!,
                                listIitem[index].name!,
                                (listIitem[index].courtQuestion == 1) ? true : false,
                                listIitem[index].question!,
                                (listIitem[index].hasSubService == 1) ? true : false,
                                (listIitem[index].pickLawyer == 1 && listIitem[index].hasExternal == 1) ? true : false,
                                (listIitem[index].invitaionQuestion == 1) ? true : false,
                                [
                                  {
                                    'chat': listIitem[index].chat,
                                    'voice': listIitem[index].voice!,
                                    'write': listIitem[index].write!,
                                    'seen': listIitem[index].seen!,
                                  }
                                ],
                                listIitem[index].pay!.toString(),
                                listIitem[index].price!,
                                widget._lawyersList,
                                widget._filterData,
                                widget._aboutUsModel,
                              ),
                            ),
                          );
                        } else if (listIitem[index].hasCourts == 0 && listIitem[index].hasSubService == 1) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SubDepartmentsScreen(
                                listIitem[index].id!,
                                listIitem[index].name!,
                                0,
                                '',
                                false,
                                '',
                                [
                                  {
                                    'chat': listIitem[index].chat,
                                    'voice': listIitem[index].voice!,
                                    'write': listIitem[index].write!,
                                    'seen': listIitem[index].seen!,
                                  }
                                ],
                                (listIitem[index].pickLawyer == 1 && listIitem[index].hasExternal == 1) ? true : false,
                                (listIitem[index].invitaionQuestion == 1) ? true : false,
                                listIitem[index].pay!.toString(),
                                listIitem[index].price!,
                                widget._lawyersList,
                                widget._filterData,
                                widget._aboutUsModel,
                              ),
                            ),
                          );
                        } else if (listIitem[index].hasCourts == 0 &&
                            listIitem[index].hasSubService == 0 &&
                            listIitem[index].name == 'دردشة فورية') {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => MultiBlocProvider(
                                providers: [
                                  BlocProvider(
                                    create: (context) => BookingCubit(
                                      BookingRepository(
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
                                child: QuickChat(widget._aboutUsModel, widget._filterData, widget._lawyersList),
                              ),
                            ),
                          );
                        } else if (listIitem[index].hasCourts == 0 &&
                            listIitem[index].hasSubService == 0 &&
                            listIitem[index].name != 'دردشة فورية') {
                          if (listIitem[index].hasQuestion == 0) {
                            await BlocProvider.of<BookingCubit>(context).bookingServiceWithoutLawyers(
                              _pref.getString('userToken')!,
                              listIitem[index].id!.toString(),
                              '',
                              '',
                              '',
                              [],
                            ).then((value) {
                              if (value == 'success') {
                                Fluttertoast.showToast(
                                  msg: 'تم الحجز بنجاح',
                                  gravity: ToastGravity.TOP,
                                  toastLength: Toast.LENGTH_LONG,
                                  timeInSecForIosWeb: 5,
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
                            });
                          } else {}
                        }
                      },
                      child: Card(
                        color: Colors.white,
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                              child: Image.network(
                                listIitem[index].imageurl!,
                                fit: BoxFit.cover,
                                width: 1000,
                                // height: SizeConfig.screenHeight * 0.35,
                                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: (loadingProgress.expectedTotalBytes != null)
                                            ? loadingProgress.cumulativeBytesLoaded /
                                                loadingProgress.expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  }
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/images/mannar_logo.png',
                                    fit: BoxFit.cover,
                                    width: 1000,
                                    // height: SizeConfig.screenHeight * 0.35,
                                  );
                                },
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: SizeConfig.screenHeight * 0.05,
                                width: SizeConfig.screenWidth * 0.2,
                                decoration: BoxDecoration(
                                    color: Colors.black87,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                    )),
                                child: Text(
                                  listIitem[index].name!,
                                  style: TextStyles.h2.copyWith(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
