import 'package:mannar_web/models/aboutUsModel.dart';
import 'package:mannar_web/models/filter_data.dart';
import 'package:mannar_web/models/lawyers.dart';

import '../../constants/styles.dart';
import '../../models/chat_user.dart';
import '../../screens/chat/chat_page.dart';

import 'package:flutter/material.dart';

class ChatBodyWidget extends StatelessWidget {
  final List<User> users;
  final AboutUsModel aboutUsModel;
  final FilterData filterData;
  final List<Lawyer> lawyersList;

  const ChatBodyWidget({
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
  Widget build(BuildContext context) => Expanded(
        child: Material(
          elevation: 20,
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
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

  Widget buildChats() => Directionality(
        textDirection: TextDirection.rtl,
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            final user = users[index];

            return SizedBox(
              height: 75,
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  focusColor: Colors.teal,
                  hoverColor: Colors.teal,
                  onTap: () async {
                    await createChatRoomName(user.idUser!, user.recieverId).then((chatRoomName) {
                      return Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ChatPage(
                          user: user,
                          chatRoomName: chatRoomName,
                          lawyerName: user.lawyerName,
                          lawyer: lawyersList.where((element) => element.id == int.parse(user.recieverId)).first,
                          aboutUsModel: aboutUsModel,
                          filterData: filterData,
                          lawyersList: lawyersList,
                        ),
                      ));
                    });
                  },
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.transparent,
                        backgroundImage: NetworkImage(user.urlAvatar),
                        // backgroundImage: AssetImage('assets/images/profile_icon.jpg'),
                      ),
                      title: Text(
                        user.lawyerName,
                        style: TextStyles.h1.copyWith(color: Colors.black),
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          itemCount: users.length,
        ),
      );
}
