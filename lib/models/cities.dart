class Cities {
  int? id;
  String? name;
  int? countryId;
  String? createdAt;
  String? updatedAt;

  Cities({
    this.id,
    this.name,
    this.countryId,
    this.createdAt,
    this.updatedAt,
  });

  factory Cities.fromJson(Map<String, dynamic> json) => Cities(
        id: json['id'],
        name: json['name'],
        countryId: json['country_id'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
      );

  static Map<String, dynamic> toMap(Cities cities) => {
        'id': cities.id,
        'name': cities.name,
        'country_id': cities.countryId,
      };

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['id'] = this.id;
  //   data['name'] = this.name;
  //   data['country_id'] = this.countryId;
  //   data['created_at'] = this.createdAt;
  //   data['updated_at'] = this.updatedAt;
  //   return data;
  // }
}
