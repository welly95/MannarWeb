class MainDepartments {
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
  int? price;
  String? createdAt;
  String? updatedAt;
  String? imageurl;

  MainDepartments({
    this.id,
    this.name,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.imageurl,
    this.hasCourts,
    this.hasSubService,
    this.hasQuestion,
    this.hasExternal,
    this.courtType,
    this.invitaionType,
    this.invitaionQuestion,
    this.courtQuestion,
    this.pickLawyer,
    this.files,
    this.hasInternal,
    this.chat,
    this.pay,
    this.voice,
    this.write,
    this.seen,
    this.price,
    this.question,
  });

  factory MainDepartments.fromJson(Map<String, dynamic> json) => MainDepartments(
        id: json['id'],
        name: json['name'],
        image: json['image'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        imageurl: json['imageurl'],
        hasCourts: json['has_courts'],
        hasSubService: json['has_sub_service'],
        hasQuestion: json['has_question'],
        hasExternal: json['has_external'],
        courtType: json["court_type"],
        invitaionType: json["invitaion_type"],
        invitaionQuestion: json["invitaion_question"],
        courtQuestion: json["court_question"],
        files: json["files"],
        pickLawyer: json["pick_lawyer"],
        hasInternal: json["has_internal"],
        chat: json["chat"],
        pay: json["pay"],
        voice: json["voice"],
        write: json["write"],
        question: json["question"] ?? '',
        seen: json["seen"],
        price: json['price'] ?? 0,
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
