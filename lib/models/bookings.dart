class Bookings {
  int? id;
  int? userId;
  int? lawyerId;
  int? appointmentId;
  int? subId;
  int? price;
  String? status;
  int? mainId;
  String? wayToCommunicate;
  String? reason;
  String? date;
  int? courtId;
  String? createdAt;
  String? updatedAt;
  String? lawyerImageUrl;
  Lawyer? lawyer;
  Appointment? appointment;
  Court? court;
  SubService? subService;
  Main? main;

  Bookings({
    this.id,
    this.userId,
    this.lawyerId,
    this.appointmentId,
    this.subId,
    this.price,
    this.status,
    this.mainId,
    this.wayToCommunicate,
    this.reason,
    this.date,
    this.courtId,
    this.createdAt,
    this.updatedAt,
    this.lawyerImageUrl,
    this.lawyer,
    this.appointment,
    this.court,
    this.subService,
    this.main,
  });

  factory Bookings.fromJson(Map<String, dynamic> json) {
    Lawyer lawyerList;
    if (json['lawyer'] == null) {
      lawyerList = Lawyer(
        id: 0,
        name: '',
        phone: '',
        email: '',
        countryId: 0,
        type: '',
        token: '',
        cityId: 0,
        bio: '',
        image: '',
        internalExternal: '',
        rate: 0,
        details: '',
        experience: '',
        licenseNum: 0,
        licenseDate: '',
        createdAt: '',
        updatedAt: '',
      );
    } else {
      lawyerList = Lawyer.fromJson(json['lawyer']);
    }

    Appointment appointmentList;
    if (json['appointment'] == null) {
      appointmentList = Appointment(
        id: 0,
        day: '',
        from: '',
        to: '',
        lawyerId: 0,
        createdAt: '',
        updatedAt: '',
        dayDate: '',
        dayId: 0,
      );
    } else {
      appointmentList = Appointment.fromJson(json['appointment']);
    }

    Main mainList;
    if (json['service'] == null) {
      mainList = Main(
        id: 0,
        name: '',
        image: '',
        hasCourts: 0,
        hasSubService: 0,
        hasQuestion: 0,
        hasExternal: 0,
        courtType: 0,
        invitaionType: 0,
        invitaionQuestion: 0,
        courtQuestion: 0,
        files: 0,
        pickLawyer: 0,
        hasInternal: 0,
        chat: 0,
        pay: 0,
        voice: 0,
        write: 0,
        question: '',
        seen: 0,
        createdAt: '',
        updatedAt: '',
      );
    } else {
      mainList = Main.fromJson(json['service']);
    }

    SubService subServiceList;
    if (json['sub_service'] == null) {
      subServiceList = SubService(
        id: 0,
        image: '',
        name: '',
        createdAt: '',
        departmentId: 0,
        updatedAt: '',
      );
    } else {
      subServiceList = SubService.fromJson(json['sub_service']);
    }

    Court courtList;
    if (json['court'] == null) {
      courtList = Court(
          id: 0,
          name: '',
          image: '',
          departmentId: 0,
          hasQuestion: 0,
          hasSubService: 0,
          hasExternal: 0,
          createdAt: '',
          updatedAt: '');
    } else {
      courtList = Court.fromJson(json['court']);
    }

    return Bookings(
      id: json['id'],
      userId: json['user_id'],
      lawyerId: json['lawyer_id'],
      appointmentId: json['appointment_id'],
      subId: json['sub_id'],
      price: (json['price'] != null) ? json['price'] : 0,
      status: json['status'],
      mainId: json['main_id'],
      wayToCommunicate: json['way_to_communicate'],
      reason: json['reason'] ?? '',
      date: json['date'],
      courtId: json['court_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      lawyerImageUrl: json['lawyerImageUrl'],
      lawyer: lawyerList,
      appointment: appointmentList,
      court: courtList,
      subService: subServiceList,
      main: mainList,
    );
  }
}

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
  double? rate;
  String? details;
  String? experience;
  int? licenseNum;
  String? licenseDate;
  String? createdAt;
  String? updatedAt;

  Lawyer(
      {this.id,
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
      this.rate,
      this.details,
      this.experience,
      this.licenseNum,
      this.licenseDate,
      this.createdAt,
      this.updatedAt});

  Lawyer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    countryId = json['country_id'];
    type = json['type'];
    token = json['token'];
    cityId = json['city_id'];
    bio = json['bio'];
    image = json['image'];
    internalExternal = json['internal_external'];
    rate = json['average_rate'].toDouble();
    details = json['details'];
    experience = json['experience'];
    licenseNum = json['license_num'];
    licenseDate = json['license_date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['id'] = this.id;
  //   data['name'] = this.name;
  //   data['phone'] = this.phone;
  //   data['email'] = this.email;
  //   data['country_id'] = this.countryId;
  //   data['type'] = this.type;
  //   data['token'] = this.token;
  //   data['city_id'] = this.cityId;
  //   data['bio'] = this.bio;
  //   data['image'] = this.image;
  //   data['internal_external'] = this.internalExternal;
  //   data['rate'] = this.rate;
  //   data['details'] = this.details;
  //   data['experience'] = this.experience;
  //   data['license_num'] = this.licenseNum;
  //   data['license_date'] = this.licenseDate;
  //   data['created_at'] = this.createdAt;
  //   data['updated_at'] = this.updatedAt;
  //   return data;
  // }
}

class Appointment {
  int? id;
  String? day;
  String? from;
  String? to;
  int? lawyerId;
  String? createdAt;
  String? updatedAt;
  String? dayDate;
  int? dayId;

  Appointment(
      {this.id, this.day, this.from, this.to, this.lawyerId, this.createdAt, this.updatedAt, this.dayDate, this.dayId});

  Appointment.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    day = json['day'] ?? '';
    from = json['from'] ?? '';
    to = json['to'] ?? '';
    lawyerId = json['lawyer_id'] ?? 0;
    createdAt = json['created_at'] ?? '';
    updatedAt = json['updated_at'] ?? '';
    dayDate = json['day_date'] ?? '';
    dayId = json['day_id'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['day'] = this.day;
    data['from'] = this.from;
    data['to'] = this.to;
    data['lawyer_id'] = this.lawyerId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class SubService {
  int? id;
  String? name;
  String? image;
  int? departmentId;
  String? createdAt;
  String? updatedAt;

  SubService({this.id, this.name, this.image, this.departmentId, this.createdAt, this.updatedAt});

  SubService.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'] ?? '';
    departmentId = json['department_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['department_id'] = this.departmentId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Main {
  int? id;
  String? name;
  String? image;
  int? hasCourts;
  int? hasSubService;
  int? hasQuestion;
  int? hasExternal;
  int? courtType;
  int? invitaionType;
  int? invitaionQuestion;
  int? courtQuestion;
  int? files;
  int? pickLawyer;
  int? hasInternal;
  int? chat;
  int? pay;
  int? voice;
  int? write;
  String? question;
  int? seen;
  String? createdAt;
  String? updatedAt;

  Main(
      {this.id,
      this.name,
      this.image,
      this.hasCourts,
      this.hasSubService,
      this.hasQuestion,
      this.hasExternal,
      this.courtType,
      this.invitaionType,
      this.invitaionQuestion,
      this.courtQuestion,
      this.files,
      this.pickLawyer,
      this.hasInternal,
      this.chat,
      this.pay,
      this.voice,
      this.write,
      this.question,
      this.seen,
      this.createdAt,
      this.updatedAt});

  Main.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    hasCourts = json['has_courts'];
    hasSubService = json['has_sub_service'];
    hasQuestion = json['has_question'];
    hasExternal = json['has_external'];
    courtType = json['court_type'];
    invitaionType = json['invitaion_type'];
    invitaionQuestion = json['invitaion_question'];
    courtQuestion = json['court_question'];
    files = json['files'];
    pickLawyer = json['pick_lawyer'];
    hasInternal = json['has_internal'];
    chat = json['chat'];
    pay = json['pay'];
    voice = json['voice'];
    write = json['write'];
    question = json['question'];
    seen = json['seen'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['has_courts'] = this.hasCourts;
    data['has_sub_service'] = this.hasSubService;
    data['has_question'] = this.hasQuestion;
    data['has_external'] = this.hasExternal;
    data['court_type'] = this.courtType;
    data['invitaion_type'] = this.invitaionType;
    data['invitaion_question'] = this.invitaionQuestion;
    data['court_question'] = this.courtQuestion;
    data['files'] = this.files;
    data['pick_lawyer'] = this.pickLawyer;
    data['has_internal'] = this.hasInternal;
    data['chat'] = this.chat;
    data['pay'] = this.pay;
    data['voice'] = this.voice;
    data['write'] = this.write;
    data['question'] = this.question;
    data['seen'] = this.seen;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Court {
  int? id;
  String? name;
  String? image;
  int? departmentId;
  int? hasQuestion;
  int? hasSubService;
  int? hasExternal;
  String? createdAt;
  String? updatedAt;

  Court(
      {this.id,
      this.name,
      this.image,
      this.departmentId,
      this.hasQuestion,
      this.hasSubService,
      this.hasExternal,
      this.createdAt,
      this.updatedAt});

  factory Court.fromJson(Map<String, dynamic> json) => Court(
        id: json['id'],
        name: json['name'],
        image: json['image'],
        departmentId: json['department_id'],
        hasQuestion: json['has_question'],
        hasSubService: json['has_sub_service'],
        hasExternal: json['has_external'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['department_id'] = this.departmentId;
    data['has_question'] = this.hasQuestion;
    data['has_sub_service'] = this.hasSubService;
    data['has_external'] = this.hasExternal;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
