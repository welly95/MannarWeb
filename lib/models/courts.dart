class Courts {
  int? id;
  String? name;
  int? departmentId;
  String? createdAt;
  String? updatedAt;
  int? hasSubService;
  int? hasQuestion;
  int? hasExternal;

  Courts({
    this.id,
    this.name,
    this.departmentId,
    this.createdAt,
    this.updatedAt,
    this.hasSubService,
    this.hasQuestion,
    this.hasExternal,
  });

  factory Courts.fromJson(Map<String, dynamic> json) => Courts(
        id: json['id'],
        name: json['name'],
        departmentId: json['department_id'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        hasSubService: json['has_sub_service'],
        hasQuestion: json['has_question'],
        hasExternal: json['has_external'],
      );

  //"has_question": 0,
  //"has_sub_service": 1,
  //"has_external": 0,
  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['id'] = this.id;
  //   data['name'] = this.name;
  //   data['image'] = this.image;
  //   data['department_id'] = this.departmentId;
  //   data['created_at'] = this.createdAt;
  //   data['updated_at'] = this.updatedAt;
  //   return data;
  // }
}
