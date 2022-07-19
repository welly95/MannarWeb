class ServiceProvider {
  int? id;
  String? name;
  String? phone;
  String? email;
  int? countryId;
  String? type;
  String? token;
  int? cityId;
  String? bio;
  String? image;
  String? internalExternal;
  String? details;
  String? experience;
  int? licenseNum;
  String? licenseDate;
  String? lawyerType;
  String? createdAt;
  String? updatedAt;
  String? imageurl;
  int? averageRate;

  ServiceProvider({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.countryId,
    this.type,
    this.token,
    this.cityId,
    this.bio,
    this.image,
    this.internalExternal,
    this.details,
    this.experience,
    this.licenseNum,
    this.licenseDate,
    this.lawyerType,
    this.createdAt,
    this.updatedAt,
    this.imageurl,
    this.averageRate,
  });

  factory ServiceProvider.fromJson(Map<String, dynamic> json) => ServiceProvider(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        phone: json['phone'] ?? '',
        email: json['email'] ?? '',
        countryId: json['country_id'] ?? '',
        type: json['type'] ?? '',
        token: json['token'] ?? '',
        cityId: json['city_id'] ?? '',
        bio: json['bio'] ?? '',
        image: json['image'] ?? '',
        internalExternal: json['internal_external'] ?? '',
        details: json['details'] ?? '',
        experience: json['experience'] ?? '',
        licenseNum: json['license_num'] ?? '',
        licenseDate: json['license_date'] ?? '',
        lawyerType: json['ServiceProvider_type'] ?? '',
        createdAt: json['created_at'] ?? '',
        updatedAt: json['updated_at'] ?? '',
        imageurl: json['imageurl'] ?? '',
        averageRate: json['average_rate'] ?? '',
      );
}
