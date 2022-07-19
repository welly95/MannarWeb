import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../constants/size_config.dart';
import '../../constants/styles.dart';
import '../../models/lawyers.dart';

class SearchForLawyer extends StatelessWidget {
  final Lawyer lawyerList;

  SearchForLawyer(this.lawyerList);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
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
                      (lawyerList.imageurl == null) ? '' : lawyerList.imageurl!,
                    ),
                  ),
                  SizedBox(
                    width: SizeConfig.screenWidth * 0.1,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        lawyerList.name!,
                        style: TextStyles.h3.copyWith(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: SizeConfig.screenHeight * 0.02,
                      ),
                      Text(
                        (lawyerList.bio == null) ? '' : lawyerList.bio!,
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
                    (lawyerList.rate == null) ? '' : (lawyerList.rate!).toString(),
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
          SizedBox(
            width: SizeConfig.screenWidth * 0.55,
            // height: SizeConfig.screenHeight * 0.1,
            child: GridView.builder(
                itemCount: lawyerList.specialists!.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: SizeConfig.screenWidth * 0.01,
                  childAspectRatio: 2,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    color: Colors.amberAccent,
                    child: Center(
                      child: Text(
                        lawyerList.specialists![index].name!,
                        style: TextStyles.h3.copyWith(color: Colors.white),
                      ),
                    ),
                  );
                }),
          ),
          SizedBox(
            height: SizeConfig.screenHeight * 0.02,
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
                        lawyerList.email!,
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
                        lawyerList.phone!,
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
                        'سنوات الخبرة',
                        style: TextStyles.textFieldsLabels,
                      ),
                      Text(
                        lawyerList.experience!,
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
                        lawyerList.licenseNum.toString(),
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
                        lawyerList.licenseDate!,
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
            height: SizeConfig.screenHeight * 0.5,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Wrap(
                runSpacing: 2,
                spacing: 2,
                alignment: WrapAlignment.center,
                direction: Axis.horizontal,
                children: List.generate(
                  lawyerList.rateList!.length,
                  (index) {
                    return (lawyerList.rateList![index]['comment'] == null)
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
                                      (lawyerList.rateList![index]['comment'] == null)
                                          ? ''
                                          : lawyerList.rateList![index]['comment'],
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
                                              (lawyerList.rateList![index]['user'] != null)
                                                  ? lawyerList.rateList![index]['user']['name']
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
                                          initialRating: lawyerList.rateList![index]['rate'],
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
        ],
      ),
    );
  }
}
