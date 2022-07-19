class Sliders {
  int? id;
  String? image;
  String? title;
  String? description;
  String? createdAt;
  String? updatedAt;
  String? imageurl;

  Sliders({this.id, this.image, this.title, this.description, this.createdAt, this.updatedAt, this.imageurl});

  factory Sliders.fromJson(Map<String, dynamic> json) => Sliders(
        id: json['id'],
        image: json['image'],
        title: json['title'],
        description: json['description'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        imageurl: json['imageurl'],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['title'] = this.title;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['imageurl'] = this.imageurl;
    return data;
  }
}
