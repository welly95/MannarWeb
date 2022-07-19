import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mannar_web/models/aboutUsModel.dart';
import 'package:mannar_web/models/filter_data.dart';
import 'package:mannar_web/models/lawyers.dart' as law;
import '../../bloc/booking/booking_cubit.dart';
import '../../bloc/services/services_cubit.dart';

import '../../constants/size_config.dart';
import '../../constants/styles.dart';
import '../../models/bookings.dart';
import '../../repository/booking_repository.dart';
import '../../repository/web_services.dart';
import '../../screens/RatingScreen/rating_screen.dart';
import '../../screens/chat/internal_lawyer_chat_messages_screen.dart';
import '../../screens/services/service_screen.dart';

class AllServicesGrid extends StatelessWidget {
  final List<Bookings> bookingsList;
  final AboutUsModel _aboutUsModel;
  final FilterData _filterData;
  final List<law.Lawyer> _lawyersList;
  final bool canEdit;

  AllServicesGrid(this.bookingsList, this._aboutUsModel, this._filterData, this._lawyersList, this.canEdit);

  final List<Color> colors = <Color>[
    Colors.yellow,
    Colors.red,
    Colors.teal,
  ];

  @override
  Widget build(BuildContext context) {
    print(bookingsList.length);
    SizeConfig().init(context);
    return ListView.builder(
      itemCount: bookingsList.length,
      //physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return Container(
          color: Colors.transparent,
          child: Card(
            color: Colors.white,
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              hoverColor: Colors.teal,
              highlightColor: Colors.teal,
              onTap: () {
                if (canEdit) {
                  if (bookingsList[index].status == 'مكتملة') {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => BlocProvider.of<ServicesCubit>(context),
                          child: RatingScreen(this._aboutUsModel, this._filterData, this._lawyersList,
                              lawyerId: bookingsList[index].lawyerId),
                        ),
                      ),
                    );
                  } else {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => BookingCubit(BookingRepository(WebServices())),
                          child: ServiceScreen(
                            bookingsList[index].id!,
                            bookingsList[index].appointment ?? Appointment(),
                            bookingsList[index].lawyer!,
                            (bookingsList[index].lawyerImageUrl == null) ? '' : bookingsList[index].lawyerImageUrl!,
                            bookingsList[index].price!.toString(),
                            (bookingsList[index].subService != null || bookingsList[index].subService!.id != 0)
                                ? bookingsList[index].subService!.name!
                                : bookingsList[index].main!.name!,
                            bookingsList[index].status!,
                            (bookingsList[index].status == 'ملغية')
                                ? colors[1]
                                : (bookingsList[index].status == 'جديدة')
                                    ? colors[0]
                                    : colors[2],
                            '',
                            // bookingsList[index].main!.name!,
                            bookingsList[index].wayToCommunicate ?? '',
                            (bookingsList[index].status == 'ملغية') ? bookingsList[index].reason! : '',
                            _aboutUsModel,
                            _filterData,
                            _lawyersList,
                          ),
                        ),
                      ),
                    );
                  }
                } else {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => BookingCubit(BookingRepository(WebServices())),
                        child: InternalLawyerChatMessagesScreen(
                            bookingsList[index].id!.toString(), _aboutUsModel, _filterData, _lawyersList),
                      ),
                    ),
                  );
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          bookingsList[index].status!,
                          style: TextStyles.h3.copyWith(
                            color: (bookingsList[index].status == 'جديدة') ? colors[0] : colors[2],
                          ),
                        ),
                        Text(
                          bookingsList[index].main!.name!,
                          textAlign: TextAlign.center,
                          style: TextStyles.h2Bold.copyWith(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  (canEdit)
                      ? Padding(
                          padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                          child: Text(
                            'تم حجز موعد يوم ${bookingsList[index].date} من الساعة (${(bookingsList[index].appointment!.from == '') ? '' : bookingsList[index].appointment!.from!.substring(0, 5)}) حتي الساعة (${(bookingsList[index].appointment!.to == '') ? '' : bookingsList[index].appointment!.to!.substring(0, 5)}) مع المحامي/ ${bookingsList[index].lawyer!.name}',
                            style: TextStyles.h2.copyWith(fontSize: 14),
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.rtl,
                          ),
                        )
                      : Container(),
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.01,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
