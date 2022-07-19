class Lawyer {
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
  double? rate;
  int? price;
  List<dynamic>? rateList;
  String? experience;
  int? licenseNum;
  String? licenseDate;
  String? createdAt;
  String? updatedAt;
  String? imageurl;
  List<dynamic>? appointments;
  List<dynamic>? subs;
  List<dynamic>? main;
  List<dynamic>? specialists;

  Lawyer({
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
    this.rate,
    this.price,
    this.rateList,
    this.experience,
    this.licenseNum,
    this.licenseDate,
    this.createdAt,
    this.updatedAt,
    this.imageurl,
    this.appointments,
    this.subs,
    this.main,
    this.specialists,
  });

  factory Lawyer.fromJson(Map<String, dynamic> json) {
    // List<dynamic> rateList = json['rate'].map((rate) => Rate.fromJson(rate)).toList();
    List<dynamic> appointmentsList =
        json['appointments'] ?? [].map((appointments) => Appointments.fromJson(appointments)).toList();
    List<dynamic> subsList = (json['subs'] == null) ? [] : json['subs'].map((subs) => Subs.fromJson(subs)).toList();
    List<dynamic> mainList = (json['main'] == null) ? [] : json['main'].map((main) => Main.fromJson(main)).toList();
    List<dynamic> specialistsList = (json['specialists'] == null)
        ? []
        : json['specialists'].map((specialist) => Specialists.fromJson(specialist)).toList();

    return Lawyer(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      countryId: json['country_id'],
      type: json['type'],
      token: json['token'] ?? '',
      cityId: json['city_id'],
      bio: json['bio'] ?? '',
      image: json['image'],
      internalExternal: json['internal_external'],
      details: json['details'] ?? '',
      rate: (json['average_rate'] == null) ? json['rate'].toDouble() : json['average_rate'].toDouble(),
      price: json['foreign_price'] ?? 0,
      rateList: (json['rate'] is List) ? json['rate'] : [json['rate']],
      experience: json['experience'],
      licenseNum: json['license_num'],
      licenseDate: json['license_date'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      imageurl: json['imageurl'],
      appointments: appointmentsList,
      subs: subsList,
      main: mainList,
      specialists: specialistsList,
    );
  }
}

class Rate {
  int? id;
  int? rate;
  int? lawyerId;
  int? userId;
  String? comment;
  String? createdAt;
  String? updatedAt;

  Rate({
    this.id,
    this.rate,
    this.lawyerId,
    this.userId,
    this.comment,
    this.createdAt,
    this.updatedAt,
  });

  factory Rate.fromJson(Map<String, dynamic> json) => Rate(
        id: json['id'],
        rate: json['rate'],
        lawyerId: json['lawyer_id'],
        userId: json['user_id'],
        comment: json['comment'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
      );
}

class Appointments {
  int? id;
  String? day;
  String? from;
  String? to;
  int? lawyerId;
  String? createdAt;
  String? updatedAt;

  Appointments({
    this.id,
    this.day,
    this.from,
    this.to,
    this.lawyerId,
    this.createdAt,
    this.updatedAt,
  });

  Appointments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    day = json['day'];
    from = json['from'];
    to = json['to'];
    lawyerId = json['lawyer_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}

class Subs {
  int? id;
  String? name;
  String? image;
  int? departmentId;
  String? createdAt;
  String? updatedAt;
  Pivot? pivot;

  Subs({this.id, this.name, this.image, this.departmentId, this.createdAt, this.updatedAt, this.pivot});

  Subs.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    departmentId = json['department_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    pivot = json['pivot'] != null ? Pivot.fromJson(json['pivot']) : null;
  }
}

class Pivot {
  int? lawyerId;
  int? subId;
  int? price;

  Pivot({this.lawyerId, this.subId, this.price});

  Pivot.fromJson(Map<String, dynamic> json) {
    lawyerId = json['lawyer_id'];
    subId = json['sub_id'];
    price = json['price'];
  }
}

class Main {
  int? id;
  String? name;
  String? image;
  String? createdAt;
  String? updatedAt;
  Pivot? pivot;

  Main({this.id, this.name, this.image, this.createdAt, this.updatedAt, this.pivot});

  Main.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    pivot = json['pivot'] != null ? new Pivot.fromJson(json['pivot']) : null;
  }
}

class Specialists {
  int? id;
  String? name;
  String? image;
  String? createdAt;
  String? updatedAt;
  Pivot? pivot;

  Specialists({this.id, this.name, this.image, this.createdAt, this.updatedAt, this.pivot});

  Specialists.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    pivot = json['pivot'] != null ? new Pivot.fromJson(json['pivot']) : null;
  }
}
