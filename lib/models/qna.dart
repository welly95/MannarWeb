class QNA {
  int? id;
  String? question;
  String? answer;
  String? createdAt;
  String? updatedAt;

  QNA({this.id, this.question, this.answer, this.createdAt, this.updatedAt});

  factory QNA.fromJson(Map<String, dynamic> json) => QNA(
        id: json['id'],
        question: json['question'],
        answer: json['answer'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
      );
}
