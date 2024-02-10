class CategoriasModel {
  String? image;
  String? slug;
  String? name;
  String? id;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['slug'] = slug;
    data['name'] = name;
    data['id'] = id;

    return data;
  }

  CategoriasModel.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    slug = json['slug'];
    name = json['name'];
    id = json['id'];
  }
}
