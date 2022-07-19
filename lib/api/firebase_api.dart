import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/chat_user.dart';
import '../../models/message.dart';

import '../utils.dart';

class FirebaseApi {
  static Stream<List<User>> getChats(String idUser) => FirebaseFirestore.instance
      .collection('chats')
      .where('idUser', isEqualTo: idUser)
      .orderBy(UserField.lastMessageTime, descending: true)
      .snapshots()
      .transform(Utils.transformer(User.fromJson));

  static Stream<List<User>> getLawyerChats(String recieverId) => FirebaseFirestore.instance
      .collection('chats')
      .where('recieverId', isEqualTo: recieverId)
      .orderBy(UserField.lastMessageTime, descending: true)
      .snapshots()
      .transform(Utils.transformer(User.fromJson));

  static Future uploadMessage(String idUser, String recieverId, String name, String message, String title, String type,
      String lawyerName, String userToken, String lawyerToken) async {
    final refMessages = FirebaseFirestore.instance.collection('chats/chatRoom:-${idUser}_to_$recieverId/messages');

    final newMessage = Message(
      idUser: idUser,
      recieverId: recieverId,
      type: type,
      username: name,
      lawyerName: lawyerName,
      message: message,
      title: title,
      createdAt: DateTime.now(),
    );
    await refMessages.add(newMessage.toJson());

    final refChats = FirebaseFirestore.instance.collection('chats');
    await refChats.doc('chatRoom:-${idUser}_to_$recieverId').update({
      'lastMessageTime': DateTime.now(),
      'userToken': userToken,
      'lawyerToken': lawyerToken,
    });
  }

  static Future lawyerUploadMessage(String idUser, String recieverId, String name, String message, String type,
      String lawyerName, String userToken, String lawyerToken) async {
    final refMessages = FirebaseFirestore.instance.collection('chats/chatRoom:-${idUser}_to_$recieverId/messages');

    final newMessage = Message(
      idUser: recieverId,
      recieverId: idUser,
      type: type,
      username: name,
      lawyerName: lawyerName,
      message: message,
      createdAt: DateTime.now(),
    );
    await refMessages.add(newMessage.toJson());

    final refChats = FirebaseFirestore.instance.collection('chats');
    await refChats.doc('chatRoom:-${idUser}_to_$recieverId').update({
      'lastMessageTime': DateTime.now(),
      'userToken': userToken,
      'lawyerToken': lawyerToken,
    });
  }

  static Stream<List<Message>> getMessages(String chatRoomName) {
    return FirebaseFirestore.instance
        .collection('chats/$chatRoomName/messages')
        .orderBy(MessageField.createdAt, descending: true)
        .snapshots()
        .transform(Utils.transformer(Message.fromJson));
  }
}
