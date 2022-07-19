import '../utils.dart';

class MessageField {
  static const String createdAt = 'createdAt';
}

class Message {
  final String idUser;
  final String recieverId;
  final String type;
  final String username;
  final String lawyerName;
  final String message;
  final String? title;
  final DateTime createdAt;

  const Message({
    required this.idUser,
    required this.recieverId,
    required this.type,
    required this.username,
    required this.lawyerName,
    required this.message,
    this.title,
    required this.createdAt,
  });

  static Message fromJson(Map<String, dynamic> json) => Message(
        idUser: json['idUser'],
        recieverId: json['recieverId'],
        type: json['type'],
        username: json['username'],
        lawyerName: json['lawyerName'],
        message: json['message'],
        title: json['title'],
        createdAt: Utils.toDateTime(json['createdAt']),
      );

  Map<String, dynamic> toJson() => {
        'idUser': idUser,
        'recieverId': recieverId,
        'type': type,
        'username': username,
        'lawyerName': lawyerName,
        'message': message,
        'title': title,
        'createdAt': Utils.fromDateTimeToJson(createdAt),
      };
}
