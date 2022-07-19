class Notifications {
  int? id;
  int? userId;
  int? lawyerId;
  String? notification;
  String? createdAt;
  String? updatedAt;

  Notifications({this.id, this.userId, this.lawyerId, this.notification, this.createdAt, this.updatedAt});

  factory Notifications.fromJson(Map<String, dynamic> json) => Notifications(
        id: json['id'],
        userId: json['user_id'],
        lawyerId: json['lawyer_id'] ?? 0,
        notification: json['notification'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
      );

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['id'] = this.id;
  //   data['user_id'] = this.userId;
  //   data['lawyer_id'] = this.lawyerId;
  //   data['notification'] = this.notification;
  //   data['created_at'] = this.createdAt;
  //   data['updated_at'] = this.updatedAt;
  //   return data;
  // }
}
