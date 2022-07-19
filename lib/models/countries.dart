class Countries {
  int? id;
  String? name;
  String? image;
  String? currency;
  String? countryCode;
  String? nationality;
  String? createdAt;
  String? updatedAt;
  String? imageurl;

  Countries({
    this.id,
    this.name,
    this.image,
    this.currency,
    this.countryCode,
    this.nationality,
    this.createdAt,
    this.updatedAt,
    this.imageurl,
  });

  factory Countries.fromJson(Map<String, dynamic> json) => Countries(
        id: json['id'],
        name: json['name'],
        image: json['image'],
        currency: json['currency'],
        countryCode: json['country_code'],
        nationality: json['nationality'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        imageurl: json['imageurl'],
      );

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['id'] = this.id;
  //   data['name'] = this.name;
  //   data['image'] = this.image;
  //   data['currency'] = this.currency;
  //   data['country_code'] = this.countryCode;
  //   data['created_at'] = this.createdAt;
  //   data['updated_at'] = this.updatedAt;
  //   data['imageurl'] = this.imageurl;
  //   return data;
  // }
}
