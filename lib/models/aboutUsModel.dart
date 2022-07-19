class AboutUsModel {
  int? id;
  String? about;
  String? email;
  String? phone;
  String? whatsapp;
  String? facebook;
  String? twitter;
  String? linkedIn;
  String? createdAt;
  String? updatedAt;
  String? vision;
  String? using;

  AboutUsModel({
    this.id,
    this.about,
    this.email,
    this.phone,
    this.whatsapp,
    this.facebook,
    this.twitter,
    this.linkedIn,
    this.createdAt,
    this.updatedAt,
    this.vision,
    this.using,
  });

  factory AboutUsModel.fromJson(Map<String, dynamic> json) => AboutUsModel(
        id: json['id'],
        about: json['about'],
        email: json['email'],
        phone: json['phone'],
        whatsapp: json['whatsapp'],
        facebook: json['facebook'],
        twitter: json['twitter'],
        linkedIn: json['linkedin'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        vision: json['vision'],
        using: json['using'],
      );
}
