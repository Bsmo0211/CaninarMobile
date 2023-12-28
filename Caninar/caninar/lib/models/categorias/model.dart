class CategoriasModel {
  String? image;
  String? slug;
  String? name;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['slug'] = slug;
    data['name'] = name;

    return data;
  }

  CategoriasModel.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    slug = json['slug'];
    name = json['name'];
  }
}
