class FilterData {
  List<dynamic>? countries;
  List<dynamic>? cities;
  List<dynamic>? main;
  List<dynamic>? services;
  List<dynamic>? subs;

  FilterData({
    this.countries,
    this.cities,
    this.main,
    this.services,
    this.subs,
  });

  factory FilterData.fromJson(Map<String, dynamic> json) {
    List<dynamic> countriesList = json['countries'].map((country) => CountriesData.fromJson(country)).toList();
    List<dynamic> citiesList = json['cities'].map((city) => Cities.fromJson(city)).toList();
    List<dynamic> mainList = json['main'].map((main) => Main.fromJson(main)).toList();
    List<dynamic> servicesList = json['services'].map((service) => Services.fromJson(service)).toList();
    List<dynamic> subsList = json['subs'].map((service) => Services.fromJson(service)).toList();

    return FilterData(
      countries: countriesList,
      cities: citiesList,
      main: mainList,
      services: servicesList,
      subs: subsList,
    );
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   if (this.countries != null) {
  //     data['countries'] = this.countries.map((v) => v.toJson()).toList();
  //   }
  //   if (this.cities != null) {
  //     data['cities'] = this.cities.map((v) => v.toJson()).toList();
  //   }
  //   if (this.main != null) {
  //     data['main'] = this.main.map((v) => v.toJson()).toList();
  //   }
  //   if (this.services != null) {
  //     data['services'] = this.services.map((v) => v.toJson()).toList();
  //   }
  //   return data;
  // }
}

class CountriesData {
  int? id;
  String? name;
  String? image;
  String? currency;
  String? countryCode;
  String? nationality;
  String? createdAt;
  String? updatedAt;
  String? countryImg;

  CountriesData(
      {this.id,
      this.name,
      this.image,
      this.currency,
      this.countryCode,
      this.nationality,
      this.createdAt,
      this.updatedAt,
      this.countryImg});

  factory CountriesData.fromJson(Map<String, dynamic> json) => CountriesData(
        id: json['id'],
        name: json['name'],
        image: json['image'],
        currency: json['currency'],
        countryCode: json['country_code'],
        nationality: json['nationality'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        countryImg: json['countryImg'],
      );

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['id'] = this.id;
  //   data['name'] = this.name;
  //   data['image'] = this.image;
  //   data['currency'] = this.currency;
  //   data['country_code'] = this.countryCode;
  //   data['nationality'] = this.nationality;
  //   data['created_at'] = this.createdAt;
  //   data['updated_at'] = this.updatedAt;
  //   data['countryImg'] = this.countryImg;
  //   return data;
  // }
}

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

class Main {
  int? id;
  String? name;
  String? image;
  String? createdAt;
  String? updatedAt;
  String? imageurl;

  Main({
    this.id,
    this.name,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.imageurl,
  });

  factory Main.fromJson(Map<String, dynamic> json) => Main(
        id: json['id'],
        name: json['name'],
        image: json['image'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        imageurl: json['imageurl'],
      );

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['id'] = this.id;
  //   data['name'] = this.name;
  //   data['image'] = this.image;
  //   data['created_at'] = this.createdAt;
  //   data['updated_at'] = this.updatedAt;
  //   data['imageurl'] = this.imageurl;
  //   return data;
  // }
}

class Services {
  int? id;
  String? name;
  String? image;
  String? createdAt;
  String? updatedAt;
  String? imageurl;

  Services({
    this.id,
    this.name,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.imageurl,
  });

  factory Services.fromJson(Map<String, dynamic> json) => Services(
        id: json['id'],
        name: json['name'],
        image: json['image'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        imageurl: json['imageurl'],
      );

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['id'] = this.id;
  //   data['name'] = this.name;
  //   data['image'] = this.image;
  //   data['created_at'] = this.createdAt;
  //   data['updated_at'] = this.updatedAt;
  //   data['imageurl'] = this.imageurl;
  //   return data;
  // }
}

class Subs {
  int? id;
  String? name;
  int? departmentId;
  int? courtId;
  int? hasQuestion;
  int? hasExternal;
  String? createdAt;
  String? updatedAt;

  Subs(
      {this.id,
      this.name,
      this.departmentId,
      this.courtId,
      this.hasQuestion,
      this.hasExternal,
      this.createdAt,
      this.updatedAt});

  factory Subs.fromJson(Map<String, dynamic> json) => Subs(
        id: json['id'],
        name: json['name'],
        departmentId: json['department_id'],
        courtId: json['court_id'],
        hasQuestion: json['has_question'],
        hasExternal: json['has_external'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
      );

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['id'] = this.id;
  //   data['name'] = this.name;
  //   data['image'] = this.image;
  //   data['department_id'] = this.departmentId;
  //   data['court_id'] = this.courtId;
  //   data['has_question'] = this.hasQuestion;
  //   data['has_external'] = this.hasExternal;
  //   data['created_at'] = this.createdAt;
  //   data['updated_at'] = this.updatedAt;
  //   return data;
  // }
}
