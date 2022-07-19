import '../utils.dart';

class UserField {
  static const String lastMessageTime = 'lastMessageTime';
}

class User {
  final String? idUser;
  final String recieverId;
  final String name;
  final String lawyerName;
  final String urlAvatar;
  final DateTime lastMessageTime;
  final String userToken;
  final String lawyerToken;

  User({
    this.idUser,
    required this.recieverId,
    required this.name,
    required this.lawyerName,
    required this.urlAvatar,
    required this.lastMessageTime,
    required this.userToken,
    required this.lawyerToken,
  });

  User copyWith({
    String? idUser,
    String? recieverId,
    String? name,
    String? lawyerName,
    String? urlAvatar,
    String? lastMessageTime,
    String? userToken,
    String? lawyerToken,
  }) =>
      User(
        idUser: idUser ?? this.idUser,
        recieverId: recieverId ?? this.recieverId,
        name: name ?? this.name,
        lawyerName: lawyerName ?? this.lawyerName,
        urlAvatar: urlAvatar ?? this.urlAvatar,
        lastMessageTime: (lastMessageTime == null) ? this.lastMessageTime : DateTime.parse(lastMessageTime),
        userToken: userToken ?? this.userToken,
        lawyerToken: lawyerToken ?? this.lawyerToken,
      );

  static User fromJson(Map<String, dynamic> json) => User(
        idUser: json['idUser'] ?? '',
        recieverId: json['recieverId'] ?? '',
        name: json['name'] ?? '',
        lawyerName: json['lawyerName'] ?? '',
        urlAvatar: json['urlAvatar'] ?? '',
        lastMessageTime: Utils.toDateTime(json['lastMessageTime']),
        userToken: json['userToken'] ?? '',
        lawyerToken: json['lawyerToken'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'idUser': idUser,
        'recieverId': recieverId,
        'name': name,
        'lawyerName': lawyerName,
        'urlAvatar': urlAvatar,
        'lastMessageTime': Utils.fromDateTimeToJson(lastMessageTime),
      };
}
