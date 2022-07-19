import 'package:mannar_web/constants/size_config.dart';

import '../../constants/styles.dart';
import '../../models/chat_user.dart';

import 'package:flutter/material.dart';
import '../../screens/chat/lawyer_chat_page.dart';

class LawyerChatBodyWidget extends StatelessWidget {
  final List<User> users;
  // final String lawyerName;

  const LawyerChatBodyWidget({
    required this.users,
    // required this.lawyerName,
    Key? key,
  }) : super(key: key);

  Future<String> createChatRoomName(String idUser, String recieverId) async {
    return 'chatRoom:-${idUser}_to_$recieverId';
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Expanded(
      child: Material(
        elevation: 20,
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: SizeConfig.screenWidth * 0.04),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: buildChats(),
        ),
      ),
    );
  }

  Widget buildChats() => Directionality(
        textDirection: TextDirection.rtl,
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            final user = users[index];

            return SizedBox(
              height: 75,
              child: ListTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                onTap: () async {
                  await createChatRoomName(user.idUser!, user.recieverId).then((chatRoomName) {
                    return Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => LawyerChatPage(
                        user: user,
                        chatRoomName: chatRoomName,
                        lawyerName: user.lawyerName,
                      ),
                    ));
                  });
                },
                leading: CircleAvatar(
                  radius: 25,
                  // backgroundImage: NetworkImage(user.urlAvatar),
                ),
                title: Text(
                  user.name,
                  style: TextStyles.h1.copyWith(color: Colors.black),
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.right,
                ),
              ),
            );
          },
          itemCount: users.length,
        ),
      );
}
