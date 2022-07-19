class RateService {
  int? id;
  int? rate;
  int? lawyerId;
  int? userId;
  String? comment;
  String? service;
  String? application;
  String? createdAt;
  String? updatedAt;
  User? user;

  RateService(
      {this.id,
      this.rate,
      this.lawyerId,
      this.userId,
      this.comment,
      this.service,
      this.application,
      this.createdAt,
      this.updatedAt,
      this.user});

  factory RateService.fromJson(Map<String, dynamic> json) {
    return RateService(
      id: json['id'],
      rate: json['rate'],
      lawyerId: json['lawyer_id'],
      userId: json['user_id'],
      comment: json['comment'],
      service: json['service'],
      application: json['application'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      user: json['user'] != null
          ? User.fromJson(json['user'])
          : User(
              id: 0,
              name: '',
              email: '',
              phone: '',
              hashed: '',
              createdAt: '',
              updatedAt: '',
            ),
    );
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['id'] = this.id;
  //   data['rate'] = this.rate;
  //   data['lawyer_id'] = this.lawyerId;
  //   data['user_id'] = this.userId;
  //   data['comment'] = this.comment;
  //   data['service'] = this.service;
  //   data['application'] = this.application;
  //   data['created_at'] = this.createdAt;
  //   data['updated_at'] = this.updatedAt;
  //   if (this.user != null) {
  //     data['user'] = this.user!.toJson();
  //   }
  //   return data;
  // }
}

class User {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? hashed;
  String? createdAt;
  String? updatedAt;

  User({this.id, this.name, this.email, this.phone, this.hashed, this.createdAt, this.updatedAt});

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        phone: json['phone'],
        hashed: json['hashed'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
      );

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['id'] = this.id;
  //   data['name'] = this.name;
  //   data['email'] = this.email;
  //   data['phone'] = this.phone;
  //   data['hashed'] = this.hashed;
  //   data['created_at'] = this.createdAt;
  //   data['updated_at'] = this.updatedAt;
  //   return data;
  // }
}
