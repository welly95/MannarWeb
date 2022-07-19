import '../../models/message.dart';

import '../../api/firebase_api.dart';
import 'package:flutter/material.dart';

import 'message_widget.dart';

class LawyerMessagesWidget extends StatelessWidget {
  final String idUser;
  final String recieverId;
  final String chatRoomName;

  const LawyerMessagesWidget({
    required this.idUser,
    required this.recieverId,
    required this.chatRoomName,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('from messages widget ====>' + chatRoomName);
    return StreamBuilder<List<Message>>(
      stream: FirebaseApi.getMessages(chatRoomName),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          default:
            if (snapshot.hasError) {
              print(snapshot.toString());
              return buildText('Something Went Wrong Try later');
            } else {
              final messages = snapshot.data;

              return messages!.isEmpty
                  ? buildText('Say Hi..')
                  : ListView.builder(
                      physics: BouncingScrollPhysics(),
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];

                        return MessageWidget(
                          message: message,
                          isMe: message.recieverId == recieverId,
                        );
                      },
                    );
            }
        }
      },
    );
  }

  Widget buildText(String text) => Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 24),
        ),
      );
}
