class QuickChatModel {
  int? id;
  int? userId;
  int? lawyerId;
  String? from;
  String? message;
  int? read;
  String? createdAt;
  String? updatedAt;

  QuickChatModel(
      {this.id, this.userId, this.lawyerId, this.from, this.message, this.read, this.createdAt, this.updatedAt});

  factory QuickChatModel.fromJson(Map<String, dynamic> json) => QuickChatModel(
        id: json['id'],
        userId: json['user_id'],
        lawyerId: json['lawyer_id'],
        from: json['from'],
        message: json['message'],
        read: json['read'],
      );

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['id'] = this.id;
  //   data['user_id'] = this.userId;
  //   data['lawyer_id'] = this.lawyerId;
  //   data['from'] = this.from;
  //   data['message'] = this.message;
  //   data['read'] = this.read;
  //   data['created_at'] = this.createdAt;
  //   data['updated_at'] = this.updatedAt;
  //   return data;
  // }
}
