import '../../constants/size_config.dart';
import '../../constants/styles.dart';
import 'package:flutter/material.dart';

class NotificationGrid extends StatelessWidget {
  //final String? title;
  //final String? description;
  //final Function()? onPressedFunction;

  //EstersharaService({@required this.title, @required this.description});
  final listIitem = [
    {
      'serviceTitle': 'عنوان الاشعار',
      "serviceDescription": 'لوريم ايبسوم هو نموذج افتراضي يوضع في التالت على العميل ليتصور طريقه وضع النصوص'
    },
    {
      'serviceTitle': 'استشاره مرئيه',
      "serviceDescription":
          'تم انتهاء اللائحه المكتوبه اليك ويمكنك مشاهدتها من هنا خلال اللينك لينك لتصفح اللائحه الخاصه بك'
    },
    {
      'serviceTitle': 'عنوان الاشعار',
      "serviceDescription": 'لوريم ايبسوم هو نموذج افتراضي يوضع في التالت على العميل ليتصور طريقه وضع النصوص'
    },
    {
      'serviceTitle': 'عنوان الاشعار',
      "serviceDescription": 'لوريم ايبسوم هو نموذج افتراضي يوضع في التالت على العميل ليتصور طريقه وضع النصوص'
    },
  ];
  // child: Text("${listIitem[index]['serviceTitle']}"),
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return ListView.builder(
        itemCount: listIitem.length,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {},
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topRight,
                  width: 300,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                          child: Text(
                            "${listIitem[index]['serviceTitle']}",
                            textAlign: TextAlign.right,
                            style: TextStyles.h2.copyWith(fontSize: 17),
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.screenHeight * 0.01,
                        ),
                        SizedBox(
                          height: SizeConfig.screenHeight * 0.01,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 5.0, left: 2.0),
                          child: Text(
                            '${listIitem[index]['serviceDescription']}',
                            style: TextStyles.textFieldsLabels.copyWith(fontSize: 13),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.screenHeight * 0.02,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.screenHeight * 0.02,
                ),
              ],
            ),
          );
        });
  }
}
