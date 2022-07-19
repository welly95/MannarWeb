class SubDepartments {
  int? id;
  String? name;
  String? image;
  int? departmentId;
  String? createdAt;
  String? updatedAt;
  List<dynamic>? questions;
  int? hasQuestion;
  int? hasExternal;

  SubDepartments({
    this.id,
    this.name,
    this.image,
    this.departmentId,
    this.createdAt,
    this.updatedAt,
    this.questions,
    this.hasQuestion,
    this.hasExternal,
  });

  factory SubDepartments.fromJson(Map<String, dynamic> json) {
    List<dynamic> questionsList;
    if (json['questions'] == null) {
      questionsList = [];
    } else {
      questionsList = json['questions'].map((questions) => Questions.fromJson(questions)).toList();
    }
    return SubDepartments(
      id: json['id'],
      name: json['name'],
      image: json['image'] ?? '',
      departmentId: json['department_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      questions: questionsList,
      hasQuestion: json['has_question'],
      hasExternal: json['has_external'],
    );
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['id'] = this.id;
  //   data['name'] = this.name;
  //   data['image'] = this.image;
  //   data['department_id'] = this.departmentId;
  //   data['created_at'] = this.createdAt;
  //   data['updated_at'] = this.updatedAt;
  //   if (this.questions != null) {
  //     data['questions'] = this.questions.map((v) => v.toJson()).toList();
  //   }
  //   return data;
  // }
}

class Questions {
  int? id;
  String? name;
  int? subId;
  String? createdAt;
  String? updatedAt;

  Questions({
    this.id,
    this.name,
    this.subId,
    this.createdAt,
    this.updatedAt,
  });

  factory Questions.fromJson(Map<String, dynamic> json) => Questions(
        id: json['id'],
        name: json['name'],
        subId: json['sub_id'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
      );

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['id'] = this.id;
  //   data['name'] = this.name;
  //   data['sub_id'] = this.subId;
  //   data['created_at'] = this.createdAt;
  //   data['updated_at'] = this.updatedAt;
  //   return data;
  // }
}
