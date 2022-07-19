class SpecialistsModel {
  int? id;
  String? name;
  String? image;
  String? createdAt;
  String? updatedAt;
  String? imageurl;

  SpecialistsModel({this.id, this.name, this.image, this.createdAt, this.updatedAt, this.imageurl});

  factory SpecialistsModel.fromJson(Map<String, dynamic> json) => SpecialistsModel(
        id: json['id'],
        name: json['name'],
        image: json['image'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        imageurl: json['imageurl'],
      );
}
