import 'package:mannar_web/models/aboutUsModel.dart';
import 'package:mannar_web/models/filter_data.dart';
import 'package:mannar_web/models/lawyers.dart';

import '../../constants/size_config.dart';
import '../../constants/styles.dart';
import '../../models/chat_user.dart';

import 'package:flutter/material.dart';
import '../../screens/chat/chat_page.dart';

class ChatHeaderWidget extends StatelessWidget {
  final List<User> users;
  final AboutUsModel aboutUsModel;
  final FilterData filterData;
  final List<Lawyer> lawyersList;

  const ChatHeaderWidget({
    required this.users,
    required this.aboutUsModel,
    required this.filterData,
    required this.lawyersList,
    Key? key,
  }) : super(key: key);

  Future<String> createChatRoomName(String idUser, String recieverId) async {
    return 'chatRoom:-${idUser}_to_$recieverId';
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12,
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  color: Colors.teal,
                ),
              ),
              Text(
                'الدردشــــات',
                style: TextStyles.h2Bold.copyWith(fontSize: 24),
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.screenHeight * 0.02,
          ),
          SizedBox(
            height: 80,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];

                  return Container(
                    margin: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () async {
                        await createChatRoomName(users[index].idUser!, users[index].recieverId).then(
                          (chatRoomName) => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ChatPage(
                                user: users[index],
                                chatRoomName: chatRoomName,
                                lawyerName: user.lawyerName,
                                lawyer: lawyersList
                                    .where((element) => element.id == int.parse(users[index].recieverId))
                                    .first,
                                aboutUsModel: aboutUsModel,
                                filterData: filterData,
                                lawyersList: lawyersList,
                              ),
                            ),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.transparent,
                            backgroundImage: NetworkImage(user.urlAvatar),
                            // backgroundImage: AssetImage('assets/images/profile_icon.jpg'),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            user.lawyerName,
                            style: TextStyles.h3.copyWith(color: Colors.black),
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.ltr,
                          ),
                        ],
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
        ],
      ),
    );
  }
}
