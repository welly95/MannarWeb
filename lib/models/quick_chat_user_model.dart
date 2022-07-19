class QuickChatUserModel {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? image;
  String? createdAt;
  String? updatedAt;

  QuickChatUserModel({this.id, this.name, this.email, this.phone, this.image, this.createdAt, this.updatedAt});

  factory QuickChatUserModel.fromJson(Map<String, dynamic> json) => QuickChatUserModel(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        phone: json['phone'],
        image: json['image'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
      );

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['id'] = this.id;
  //   data['name'] = this.name;
  //   data['email'] = this.email;
  //   data['phone'] = this.phone;
  //   data['image'] = this.image;
  //   data['job'] = this.job;
  //   data['country_id'] = this.countryId;
  //   data['age'] = this.age;
  //   data['hashed'] = this.hashed;
  //   data['created_at'] = this.createdAt;
  //   data['updated_at'] = this.updatedAt;
  //   return data;
  // }
}
