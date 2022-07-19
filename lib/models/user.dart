class User {
  String? imageUrl;
  String? name;
  String? email;
  String? phoneNumber;
  String? password;
  String? job;
  String? age;
  int? countryId;

  User({
    this.imageUrl,
    this.name,
    this.email,
    this.phoneNumber,
    this.password,
    this.job,
    this.age,
    this.countryId,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        imageUrl: json['image'],
        name: json['name'],
        email: json['email'],
        phoneNumber: json['phone'],
        password: json['password'],
        job: json['job'],
        age: json['age'],
        countryId: json['country_id'],
      );

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> json = Map<String, dynamic>();

  // json['image'] = imageUrl;
  // json['name'] = name;
  // json['email'] = email;
  // json['phone'] = phoneNumber;
  // json['password'] = password;
  //   return json;
  // }
}
