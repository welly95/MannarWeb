class TechMessages {
  int? id;
  int? userId;
  String? message;
  int? toUserId;
  String? createdAt;
  String? updatedAt;

  TechMessages({this.id, this.userId, this.message, this.toUserId, this.createdAt, this.updatedAt});

  factory TechMessages.fromJson(Map<String, dynamic> json) => TechMessages(
        id: json['id'],
        userId: json['user_id'] ?? 0,
        message: json['message'],
        toUserId: json['to_user_id'] ?? 0,
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
      );

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['id'] = this.id;
  //   data['user_id'] = this.userId;
  //   data['message'] = this.message;
  //   data['to_user_id'] = this.toUserId;
  //   data['created_at'] = this.createdAt;
  //   data['updated_at'] = this.updatedAt;
  //   return data;
  // }
}
