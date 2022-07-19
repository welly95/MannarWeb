class ChatWithAttachments {
  int? id;
  int? serviceBookingId;
  String? attachment;
  String? message;
  String? createdAt;
  String? updatedAt;

  ChatWithAttachments({this.id, this.serviceBookingId, this.attachment, this.message, this.createdAt, this.updatedAt});

  factory ChatWithAttachments.fromJson(Map<String, dynamic> json) => ChatWithAttachments(
        id: json['id'],
        serviceBookingId: json['service_booking_id'],
        attachment: json['attachment'],
        message: json['message'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
      );

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['id'] = this.id;
  //   data['service_booking_id'] = this.serviceBookingId;
  //   data['attachment'] = this.attachment;
  //   data['message'] = this.message;
  //   data['created_at'] = this.createdAt;
  //   data['updated_at'] = this.updatedAt;
  //   return data;
  // }
}
